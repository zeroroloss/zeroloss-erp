package dao.branch.swap;

import dto.branch.BranchLocationDto;
import dto.branch.swap.MaterialDto;
import dto.branch.swap.MaterialGroupDto;
import dto.branch.swap.SwapRequestDto;
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

    // 추가 메서드
    int createSwapRequest(@Param("reqBranchCode") int reqBranchCode,
                         @Param("resBranchCode") int resBranchCode,
                         @Param("materialCode") String materialCode,
                         @Param("qty") double qty);

    List<SwapRequestDto> getSentRequests(@Param("branchCode") int branchCode);

    List<SwapRequestDto> getReceivedRequests(@Param("branchCode") int branchCode);

    List<SwapRequestDto> getSwapHistory(@Param("branchCode") int branchCode);

    int approveSwapRequest(@Param("swapId") int swapId, @Param("currentBranchCode") int currentBranchCode);

    int rejectSwapRequest(@Param("swapId") int swapId);

    int cancelSwapRequest(@Param("swapId") int swapId);

    // 재고 이동 관련 메서드
    SwapRequestDto getSwapRequestDetail(@Param("swapId") int swapId);

    int decreaseStock(@Param("branchCode") int branchCode, @Param("materialCode") String materialCode, @Param("qty") double qty);

    int increaseStock(@Param("branchCode") int branchCode, @Param("materialCode") String materialCode, @Param("qty") double qty);

    int recordStockChange(@Param("branchStockCode") String branchStockCode, @Param("changeAmount") double changeAmount,
                          @Param("changeType") String changeType, @Param("afterQty") double afterQty);

    String getBranchStockCode(@Param("branchCode") int branchCode, @Param("materialCode") String materialCode);
}
