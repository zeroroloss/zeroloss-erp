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
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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

        int swapId = swapDao.createSwapRequest(reqBranchCode, resBranchCode, materialCode, qty);
        boolean success = swapId > 0;
        if (success) {
            // 요청을 받는 지점(resBranchCode)에 알림 전송
        	String materialName = swapDao.findMaterialName(materialCode);
        	insertSwapNotification("[재고 교환 요청]",
        			materialName +"(재료번호:" + materialCode + ") "+ qty + "개 재고 교환 요청이 접수되었습니다.",
        	        resBranchCode,
        	        swapId
        	    );
        }
        return success;
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
            boolean updateSuccess = swapDao.approveSwapRequest(swapId, 0) > 0;

            // 승인되면 요청 지점(reqBranchCode)에 알림 전송
            if (updateSuccess) {
            	insertSwapNotification("[재고 교환 승인]", 
            			swap.getMaterialName() +"(재료번호:" + swap.getMaterialCode() + ") " + swap.getQty() + "개 재고 교환 요청이 승인되었습니다.", 
            	        swap.getReqBranchCode(),
            	        swapId
            	    );
            }

            return updateSuccess;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean rejectSwapRequest(int swapId) {
        // 거절 전에 요청 정보 조회
        SwapRequestDto swap = swapDao.getSwapRequestDetail(swapId);
        boolean success = swapDao.rejectSwapRequest(swapId) > 0;
        
        // 거절되면 요청 지점(reqBranchCode)에 알림 전송
        if (success && swap != null) {
        	insertSwapNotification("[재고 교환 거절]",
        	        swap.getMaterialName() +"(재료번호:" + swap.getMaterialCode() + ") " + swap.getQty() + "개 재고 교환 요청이 거절되었습니다.",
        	        swap.getReqBranchCode(),
        	        swapId
        	    );
        }

        return success;
    }

    /**
     * 스왑 관련 알림을 특정 지점의 모든 계정에 전송
     */
    private void insertSwapNotification(String title, String message, int targetBranchCode, int targetId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession(false)) {
            Connection conn = sqlSession.getConnection();

            // 1. notification 테이블에 알림 본문 삽입
            String notifSql = "INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
            try (PreparedStatement ps = conn.prepareStatement(notifSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, "SWAP");
                ps.setString(2, title);
                ps.setString(3, message);
                ps.setString(4, "SWAP");
                ps.setInt(5, targetId);
                ps.executeUpdate();

                // 2. 생성된 notification_id로 notification_receiver에 수신자 추가
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        int notifId = keys.getInt(1);
                        String recvSql = "INSERT INTO notification_receiver (notification_id, account_id, is_read) SELECT ?, account_id, FALSE FROM account WHERE branch_code = ?";
                        try (PreparedStatement ps2 = conn.prepareStatement(recvSql)) {
                            ps2.setInt(1, notifId);
                            ps2.setInt(2, targetBranchCode);
                            ps2.executeUpdate();
                        }
                    }
                }
                sqlSession.commit();
            }
        } catch (SQLException sqle) {
            // 알림 생성 실패는 로그만 남기고 스왑 처리는 계속 진행
            sqle.printStackTrace();
        }
    }

    @Override
    public boolean cancelSwapRequest(int swapId) {
        return swapDao.cancelSwapRequest(swapId) > 0;
    }
}
