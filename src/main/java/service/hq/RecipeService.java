package service.hq;

import dto.*;
import java.util.List;
import java.util.Map;

public interface RecipeService {
    List<MainCategoryDTO> getMainCategories();
    List<Map<String, Object>> getSubCategories(Integer mainCategoryId);
    List<MaterialDTO> getMaterials();
    List<RecipeViewDTO> getRecipeList();
    RecipeViewDTO getRecipeDetail(String id);
    boolean saveRecipe(RecipeViewDTO dto);
    boolean deleteRecipe(String id);
}