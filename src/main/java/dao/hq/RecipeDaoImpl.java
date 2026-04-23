package dao.hq;

import dto.*;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;

public class RecipeDaoImpl implements RecipeDao {

    // Mapper XML에 설정한 namespace와 동일하게 맞춥니다.
    private static final String NS = "dao.hq.RecipeDao.";

    @Override
    public List<MainCategoryDTO> selectMainCategories(SqlSession session) {
        return session.selectList(NS + "selectMainCategories");
    }

    @Override
    public List<Map<String, Object>> selectSubCategories(SqlSession session, Integer mainCategoryId) {
        return session.selectList(NS + "selectSubCategories", mainCategoryId);
    }

    @Override
    public List<MaterialDTO> selectMaterials(SqlSession session) {
        return session.selectList(NS + "selectMaterials");
    }

    @Override
    public String selectMaxRecipeCode(SqlSession session, Integer categoryId) {
        return session.selectOne(NS + "selectMaxRecipeCode", categoryId);
    }

    @Override
    public List<MaterialDTO> findMaterialsByCodes(SqlSession session, List<String> materialCodes) {
        return session.selectList(NS + "findMaterialsByCodes", materialCodes);
    }

    @Override
    public List<RecipeViewDTO> selectRecipeList(SqlSession session) {
        return session.selectList(NS + "selectRecipeList");
    }

    @Override
    public RecipeViewDTO selectRecipeDetail(SqlSession session, String id) {
        return session.selectOne(NS + "selectRecipeDetail", id);
    }

    @Override
    public int insertRecipe(SqlSession session, RecipeViewDTO dto) {
        return session.insert(NS + "insertRecipe", dto);
    }

    @Override
    public int updateRecipe(SqlSession session, RecipeViewDTO dto) {
        return session.update(NS + "updateRecipe", dto);
    }

    @Override
    public int deleteRecipe(SqlSession session, String id) {
        return session.delete(NS + "deleteRecipe", id);
    }

    @Override
    public int deleteRecipeDetails(SqlSession session, String id) {
        return session.delete(NS + "deleteRecipeDetails", id);
    }

    @Override
    public int insertRecipeDetails(SqlSession session, Map<String, Object> paramMap) {
        return session.insert(NS + "insertRecipeDetails", paramMap);
    }
}
