package service.hq;

import dao.hq.RecipeDao;
import dao.hq.RecipeDaoImpl;
import dto.*;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
                int totalCost = 0;
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
                        if (price != null) {
                            totalCost += price * ingredient.getQuantity();
                        }
                    }
                }
                recipe.setCost(totalCost);
            }
            return recipe;
        }
    }

    @Override
    public boolean saveRecipe(RecipeViewDTO dto) {
        SqlSession session = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false);
        try {
            // 1. 원가 계산
            int totalCost = 0;
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
                    if (price != null) {
                        totalCost += price * ingredient.getQuantity();
                    }
                }
            }
            dto.setCost(totalCost);

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
            recipeDao.deleteRecipeDetails(session, id); // BOM 먼저 삭제
            recipeDao.deleteRecipe(session, id);
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
}
