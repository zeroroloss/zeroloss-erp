package dao.hq;

import dto.*;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;

public interface RecipeDao {
    // 기초 데이터 및 채번
    List<MainCategoryDTO> selectMainCategories(SqlSession session);
    List<Map<String, Object>> selectSubCategories(SqlSession session, Integer mainCategoryId);
    List<MaterialDTO> selectMaterials(SqlSession session);
    String selectMaxRecipeCode(SqlSession session, Integer categoryId);
    List<MaterialDTO> findMaterialsByCodes(SqlSession session, List<String> materialCodes); // 추가

    // 레시피 조회
    List<RecipeViewDTO> selectRecipeList(SqlSession session);
    RecipeViewDTO selectRecipeDetail(SqlSession session, String id);

    // 레시피 CUD
    int insertRecipe(SqlSession session, RecipeViewDTO dto);
    int updateRecipe(SqlSession session, RecipeViewDTO dto);
    int deleteRecipe(SqlSession session, String id);

    // 레시피 상세(BOM) CUD
    int deleteRecipeDetails(SqlSession session, String id);
    int insertRecipeDetails(SqlSession session, Map<String, Object> paramMap);
}
