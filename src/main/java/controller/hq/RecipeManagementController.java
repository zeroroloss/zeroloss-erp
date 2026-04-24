package controller.hq;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import dto.RecipeViewDTO;
import service.hq.RecipeService;
import service.hq.RecipeServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Type;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet("/RecipeManagementController")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 15   // 15MB
)
public class RecipeManagementController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final RecipeService recipeService = new RecipeServiceImpl();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        String action = request.getParameter("action");
        Object result = null;

        try {
            if ("categories".equals(action)) {
                result = recipeService.getMainCategories();
            } else if ("subcategories".equals(action)) {
                Integer mainId = Integer.parseInt(request.getParameter("mainCategoryId"));
                result = recipeService.getSubCategories(mainId);
            } else if ("materials".equals(action)) {
                result = recipeService.getMaterials();
            } else if ("list".equals(action)) {
                result = recipeService.getRecipeList();
            } else if ("detail".equals(action)) {
                result = recipeService.getRecipeDetail(request.getParameter("id"));
            }
            response.getWriter().write(gson.toJson(result));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 오류가 발생했습니다.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        String action = request.getParameter("action");
        Map<String, Object> result = new HashMap<>();

        try {
            if ("save".equals(action)) {
                result = saveRecipeAction(request);
            } else if ("delete".equals(action)) {
                boolean success = recipeService.deleteRecipe(request.getParameter("id"));
                result.put("success", success);
            }
            response.getWriter().write(gson.toJson(result));
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "요청 처리 중 오류가 발생했습니다: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(result));
        }
    }

    private Map<String, Object> saveRecipeAction(HttpServletRequest request) throws IOException, ServletException {
        Map<String, Object> result = new HashMap<>();
        RecipeViewDTO dto = new RecipeViewDTO();

        // 1. 텍스트 데이터 파싱
        dto.setId(request.getParameter("id"));
        dto.setName(request.getParameter("name"));
        dto.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        dto.setSubCategoryCode(request.getParameter("subCategoryCode"));
        dto.setPrice(Integer.parseInt(request.getParameter("price")));
        dto.setInstructions(request.getParameter("instructions"));
        dto.setIsActive(Boolean.parseBoolean(request.getParameter("isActive")));

        // 2. 이미지 파일 처리
        Part imagePart = request.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            String uploadPath = getServletContext().getRealPath("") + "uploads" + File.separator + "recipe_images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String fileName = UUID.randomUUID().toString() + "_" + Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            imagePart.write(uploadPath + File.separator + fileName);
            dto.setImage("uploads/recipe_images/" + fileName);
        }
        // [수정] imagePath 파라미터를 받는 부분 제거

        // 3. 재료(BOM) 데이터 파싱
        String ingredientsJson = request.getParameter("ingredients");
        Type type = new TypeToken<List<RecipeViewDTO.RecipeIngredientDTO>>() {}.getType();
        List<RecipeViewDTO.RecipeIngredientDTO> ingredients = gson.fromJson(ingredientsJson, type);
        dto.setIngredients(ingredients);

        // 4. 서비스 호출
        boolean success = recipeService.saveRecipe(dto);
        result.put("success", success);
        if (!success) {
            result.put("message", "레시피 저장에 실패했습니다.");
        }

        return result;
    }
}

