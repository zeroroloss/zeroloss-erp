package service.branch.swap;

import dto.branch.swap.MaterialDto;
import dto.branch.swap.MaterialGroupDto;
import dto.branch.swap.SwapStockSearchRequestDto;
import dto.branch.swap.SwapStockSearchResultDto;

import java.util.List;

public interface SwapService {
    /**
     * 주변 지점의 재고를 검색합니다.
     *
     * @param searchDto 검색 조건 DTO
     * @return 검색 결과 리스트
     */
    List<SwapStockSearchResultDto> findNearbyBranchStocks(SwapStockSearchRequestDto searchDto);

    /**
     * 모든 재료 그룹 목록을 조회합니다.
     * @return 재료 그룹 목록
     */
    List<MaterialGroupDto> getMaterialGroups();

    /**
     * 특정 재료 그룹에 속하는 재료 목록을 조회합니다.
     * @param materialGroupId 재료 그룹 ID
     * @return 재료 목록
     */
    List<MaterialDto> getMaterialsByGroup(int materialGroupId);
}
