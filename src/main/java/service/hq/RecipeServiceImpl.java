package service.hq;

import dao.hq.RecipeDao;
import dao.hq.RecipeDaoImpl;
import dto.*;
import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import java.sql.SQLIntegrityConstraintViolationException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RecipeServiceImpl implements RecipeService {

    private final RecipeDao recipeDao = new RecipeDaoImpl();

    @Override
    public List<MainCategoryDTO> getMainCategories() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return recipeDao.selectMainCategories(session);
        }
    }

    @Override
    public List<Map<String, Object>> getSubCategories(Integer mainCategoryId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return recipeDao.selectSubCategories(session, mainCategoryId);
        }
    }

    @Override
    public List<MaterialDTO> getMaterials() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return recipeDao.selectMaterials(session);
        }
    }

    @Override
    public List<RecipeViewDTO> getRecipeList() {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return recipeDao.selectRecipeList(session);
        }
    }

    @Override
    public RecipeViewDTO getRecipeDetail(String id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            RecipeViewDTO recipe = recipeDao.selectRecipeDetail(session, id);
            if (recipe != null) {
                // 원가 재계산 로직 추가
                double totalCost = 0.0;
                List<RecipeViewDTO.RecipeIngredientDTO> ingredients = recipe.getIngredients();
                if (ingredients != null && !ingredients.isEmpty()) {
                    // 재료 코드 목록 추출
                    List<String> materialCodes = ingredients.stream()
                                                            .map(RecipeViewDTO.RecipeIngredientDTO::getMaterialCode)
                                                            .collect(Collectors.toList());
                    
                    // DB에서 최신 재료 가격 정보 조회
                    List<MaterialDTO> materials = recipeDao.findMaterialsByCodes(session, materialCodes);
                    Map<String, Integer> materialPriceMap = materials.stream()
                            .collect(Collectors.toMap(MaterialDTO::getMaterialCode, MaterialDTO::getMaterialPrice));

                    for (RecipeViewDTO.RecipeIngredientDTO ingredient : ingredients) {
                        Integer price = materialPriceMap.get(ingredient.getMaterialCode());
                        if (price != null && ingredient.getQuantity() != null) {
                            totalCost += price * ingredient.getQuantity();
                        }
                    }
                }
                recipe.setCost((int)Math.round(totalCost));
            }
            return recipe;
        }
    }

    @Override
    public boolean saveRecipe(RecipeViewDTO dto) {
        SqlSession session = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);
        try {
            boolean isNew = (dto.getId() == null || dto.getId().trim().isEmpty());
            // 1. 원가 계산
            double totalCost = 0.0;
            List<RecipeViewDTO.RecipeIngredientDTO> ingredients = dto.getIngredients();
            if (ingredients != null && !ingredients.isEmpty()) {
                List<String> materialCodes = ingredients.stream()
                        .map(RecipeViewDTO.RecipeIngredientDTO::getMaterialCode)
                        .collect(Collectors.toList());

                List<MaterialDTO> materials = recipeDao.findMaterialsByCodes(session, materialCodes);
                Map<String, Integer> materialPriceMap = materials.stream()
                        .collect(Collectors.toMap(MaterialDTO::getMaterialCode, MaterialDTO::getMaterialPrice));

                for (RecipeViewDTO.RecipeIngredientDTO ingredient : ingredients) {
                    Integer price = materialPriceMap.get(ingredient.getMaterialCode());
                    if (price != null && ingredient.getQuantity() != null) {
                        totalCost += price * ingredient.getQuantity();
                    }
                }
            }
            dto.setCost((int)Math.round(totalCost));

            // 2. 레시피 저장 (INSERT or UPDATE)
            if (dto.getId() == null || dto.getId().trim().isEmpty()) {
                String maxCode = recipeDao.selectMaxRecipeCode(session, dto.getCategoryId());
                if (maxCode == null || maxCode.isEmpty()) {
                    dto.setId(dto.getCategoryId() + "001");
                } else {
                    dto.setId(String.valueOf(Integer.parseInt(maxCode) + 1));
                }
                recipeDao.insertRecipe(session, dto);
            } else {
                recipeDao.updateRecipe(session, dto);
                recipeDao.deleteRecipeDetails(session, dto.getId());
            }

            // 3. BOM(재료) 저장
            if (ingredients != null && !ingredients.isEmpty()) {
                Map<String, Object> paramMap = new HashMap<>();
                paramMap.put("id", dto.getId());
                paramMap.put("ingredients", ingredients);
                recipeDao.insertRecipeDetails(session, paramMap);
            }

            // 4. 알림 생성 (본사 제외 모든 지점 계정 대상으로)
            try {
                Connection conn = session.getConnection();
                // 4.1 notification 본문 삽입
                String notifSql = "INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
                try (PreparedStatement ps = conn.prepareStatement(notifSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    String actionTitle = isNew ? "레시피 등록" : "레시피 수정";
                    String title = actionTitle + ": " + dto.getName();
                    String message = dto.getName() + "(코드: " + dto.getId() + ") 레시피가 " + (isNew ? "등록" : "수정") + "되었습니다.";
                    ps.setString(1, "SYSTEM"); // category
                    ps.setString(2, title);
                    ps.setString(3, message);
                    ps.setString(4, "RECIPE");
                    // target_id는 notification.target_id가 INT이므로
                    // 레시피 id가 정수 문자열이면 저장하고, 아니면 NULL로 둡니다.
                    Integer targetIdInt = null;
                    try {
                        if (dto.getId() != null) targetIdInt = Integer.parseInt(dto.getId());
                    } catch (NumberFormatException nfe) {
                        // 숫자가 아닐 경우 NULL로 둠
                    }
                    if (targetIdInt != null) ps.setInt(5, targetIdInt); else ps.setNull(5, java.sql.Types.INTEGER);
                    ps.executeUpdate();

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (keys.next()) {
                            int notifId = keys.getInt(1);
                            // 4.2 notification_receiver에 수신자 추가 (branch_code <> 1)
                            String recvSql = "INSERT INTO notification_receiver (notification_id, account_id, is_read) SELECT ?, account_id, FALSE FROM account WHERE branch_code <> 1";
                            try (PreparedStatement ps2 = conn.prepareStatement(recvSql)) {
                                ps2.setInt(1, notifId);
                                ps2.executeUpdate();
                            }
                        }
                    }
                }
            } catch (SQLException sqle) {
                // 알림 실패는 레시피 저장 전체 실패로 처리
                session.rollback();
                sqle.printStackTrace();
                return false;
            }

            session.commit();
            return true;
        } catch (Exception e) {
            session.rollback();
            e.printStackTrace();
            return false;
        } finally {
            session.close();
        }
    }

    @Override
    public boolean deleteRecipe(String id) {
        SqlSession session = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);
        try {
            // (선택) 삭제 전에 레시피명 조회
            RecipeViewDTO recipe = recipeDao.selectRecipeDetail(session, id);

            recipeDao.deleteRecipeDetails(session, id); // BOM 먼저 삭제
            recipeDao.deleteRecipe(session, id);

            // 알림 생성 (본사 제외 모든 지점)
            try {
                Connection conn = session.getConnection();
                String notifSql = "INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
                try (PreparedStatement ps = conn.prepareStatement(notifSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    String title = "레시피 삭제: " + (recipe != null ? recipe.getName() : id);
                    String message = (recipe != null ? recipe.getName() : id) + "(코드: " + id + ") 레시피가 삭제되었습니다.";
                    ps.setString(1, "SYSTEM");
                    ps.setString(2, title);
                    ps.setString(3, message);
                    ps.setString(4, "RECIPE");
                    Integer targetIdInt = null;
                    try {
                        if (id != null) targetIdInt = Integer.parseInt(id);
                    } catch (NumberFormatException nfe) {
                        // ignore
                    }
                    if (targetIdInt != null) ps.setInt(5, targetIdInt); else ps.setNull(5, java.sql.Types.INTEGER);
                    ps.executeUpdate();

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (keys.next()) {
                            int notifId = keys.getInt(1);
                            String recvSql = "INSERT INTO notification_receiver (notification_id, account_id, is_read) SELECT ?, account_id, FALSE FROM account WHERE branch_code <> 1";
                            try (PreparedStatement ps2 = conn.prepareStatement(recvSql)) {
                                ps2.setInt(1, notifId);
                                ps2.executeUpdate();
                            }
                        }
                    }
                }
            } catch (SQLException sqle) {
                session.rollback();
                sqle.printStackTrace();
                return false;
            }

            session.commit();
            return true;
        } catch (PersistenceException e) {
            session.rollback();
            // 원인 예외를 확인하여 SQLIntegrityConstraintViolationException인지 확인
            Throwable cause = e.getCause();
            if (cause instanceof SQLIntegrityConstraintViolationException) {
                // 이 예외는 "판매 중인 레시피"와 관련이 있을 가능성이 높음
                throw new RuntimeException("판매 내역이 존재하는 레시피는 삭제할 수 없습니다.");
            }
            // 그 외 다른 DB 관련 예외
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            session.rollback();
            e.printStackTrace();
            return false;
        } finally {
            session.close();
        }
    }
}
