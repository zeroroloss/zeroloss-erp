package service.branch.swap;

import dao.branch.swap.SwapDao;
import dao.branch.swap.SwapDaoImpl;
import dto.branch.BranchLocationDto;
import dto.branch.swap.MaterialDto;
import dto.branch.swap.MaterialGroupDto;
import dto.branch.swap.SwapRequestDto;
import dto.branch.swap.SwapStockSearchRequestDto;
import dto.branch.swap.SwapStockSearchResultDto;

import java.util.Collections;
import java.util.List;

public class SwapServiceImpl implements SwapService {

    private final SwapDao swapDao;

    public SwapServiceImpl() {
        this.swapDao = new SwapDaoImpl();
    }

    @Override
    public List<SwapStockSearchResultDto> findNearbyBranchStocks(SwapStockSearchRequestDto searchDto) {
        BranchLocationDto currentLocation = swapDao.findBranchLocation(searchDto.getCurrentBranchCode());
        if (currentLocation == null) {
            return Collections.emptyList();
        }

        return swapDao.findNearbyBranchStocks(
                searchDto.getCurrentBranchCode(),
                searchDto.getMaterialCode(),
                searchDto.getRequiredQty(),
                searchDto.getDistance(),
                currentLocation.getLat(),
                currentLocation.getLng()
        );
    }

    @Override
    public List<MaterialGroupDto> getMaterialGroups() {
        return swapDao.getMaterialGroups();
    }

    @Override
    public List<MaterialDto> getMaterialsByGroup(int materialGroupId) {
        return swapDao.getMaterialsByGroup(materialGroupId);
    }

    @Override
    public boolean createSwapRequest(int reqBranchCode, int resBranchCode, String materialCode, double qty) {
        return swapDao.createSwapRequest(reqBranchCode, resBranchCode, materialCode, qty) > 0;
    }

    @Override
    public List<SwapRequestDto> getSentRequests(int branchCode) {
        return swapDao.getSentRequests(branchCode);
    }

    @Override
    public List<SwapRequestDto> getReceivedRequests(int branchCode) {
        return swapDao.getReceivedRequests(branchCode);
    }

    @Override
    public List<SwapRequestDto> getSwapHistory(int branchCode) {
        return swapDao.getSwapHistory(branchCode);
    }

    @Override
    public boolean approveSwapRequest(int swapId) {
        try {
            // 스왑 요청 정보 조회
            SwapRequestDto swap = swapDao.getSwapRequestDetail(swapId);
            if (swap == null) {
                return false;
            }

            // 응답 지점의 재고 감소
            int decreaseResult = swapDao.decreaseStock(swap.getResBranchCode(), swap.getMaterialCode(), swap.getQty());
            if (decreaseResult == 0) {
                return false; // 재고 부족
            }

            // 요청 지점의 재고 증가
            int increaseResult = swapDao.increaseStock(swap.getReqBranchCode(), swap.getMaterialCode(), swap.getQty());
            if (increaseResult == 0) {
                return false;
            }

            // 응답 지점의 재고 변동 이력 기록
            String resStockCode = swapDao.getBranchStockCode(swap.getResBranchCode(), swap.getMaterialCode());
            if (resStockCode != null) {
                swapDao.recordStockChange(resStockCode, swap.getQty(), "EXCHANGEOUT", 0);
            }

            // 요청 지점의 재고 변동 이력 기록
            String reqStockCode = swapDao.getBranchStockCode(swap.getReqBranchCode(), swap.getMaterialCode());
            if (reqStockCode != null) {
                swapDao.recordStockChange(reqStockCode, swap.getQty(), "EXCHANGEIN", 0);
            }

            // 상태 업데이트
            return swapDao.approveSwapRequest(swapId, 0) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean rejectSwapRequest(int swapId) {
        return swapDao.rejectSwapRequest(swapId) > 0;
    }

    @Override
    public boolean cancelSwapRequest(int swapId) {
        return swapDao.cancelSwapRequest(swapId) > 0;
    }
}
