package dao.branch.swap;

import dto.branch.BranchLocationDto;
import dto.branch.swap.MaterialDto;
import dto.branch.swap.MaterialGroupDto;
import dto.branch.swap.SwapStockSearchResultDto;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SwapDao {
    List<SwapStockSearchResultDto> findNearbyBranchStocks(
            @Param("currentBranchCode") int currentBranchCode,
            @Param("materialCode") String materialCode,
            @Param("requiredQty") int requiredQty,
            @Param("distance") int distance,
            @Param("currentLat") double currentLat,
            @Param("currentLng") double currentLng
    );

    BranchLocationDto findBranchLocation(@Param("branchCode") int branchCode);

    List<MaterialGroupDto> getMaterialGroups();

    List<MaterialDto> getMaterialsByGroup(@Param("materialGroupId") int materialGroupId);
}
