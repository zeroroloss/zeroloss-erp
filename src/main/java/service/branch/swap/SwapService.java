package service.branch.swap;

import dto.branch.swap.MaterialDto;
import dto.branch.swap.MaterialGroupDto;
import dto.branch.swap.SwapRequestDto;
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

    /**
     * 재고 교환 요청을 생성합니다.
     * @param reqBranchCode 요청한 지점 코드
     * @param resBranchCode 응답 지점 코드
     * @param materialCode 품목 코드
     * @param qty 수량
     * @return 성공 여부
     */
    boolean createSwapRequest(int reqBranchCode, int resBranchCode, String materialCode, double qty);

    /**
     * 보낸 요청 목록을 조회합니다.
     * @param branchCode 지점 코드
     * @return 요청 목록
     */
    List<SwapRequestDto> getSentRequests(int branchCode);

    /**
     * 받은 요청 목록을 조회합니다.
     * @param branchCode 지점 코드
     * @return 요청 목록
     */
    List<SwapRequestDto> getReceivedRequests(int branchCode);

    /**
     * 완료된 교환 내역을 조회합니다.
     * @param branchCode 지점 코드
     * @return 교환 내역 목록
     */
    List<SwapRequestDto> getSwapHistory(int branchCode);

    /**
     * 재고 교환 요청을 수락합니다.
     * @param swapId 요청 ID
     * @return 성공 여부
     */
    boolean approveSwapRequest(int swapId);

    /**
     * 재고 교환 요청을 거절합니다.
     * @param swapId 요청 ID
     * @return 성공 여부
     */
    boolean rejectSwapRequest(int swapId);

    /**
     * 보낸 요청을 취소합니다.
     * @param swapId 요청 ID
     * @return 성공 여부
     */
    boolean cancelSwapRequest(int swapId);
}
