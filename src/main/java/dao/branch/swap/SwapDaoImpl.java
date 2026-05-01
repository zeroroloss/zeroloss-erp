package dao.branch.swap;

import dto.branch.BranchLocationDto;
import dto.branch.swap.MaterialDto;
import dto.branch.swap.MaterialGroupDto;
import dto.branch.swap.SwapRequestDto;
import dto.branch.swap.SwapStockSearchResultDto;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import util.MyBatisSqlSessionFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SwapDaoImpl implements SwapDao {

    private final SqlSessionFactory sqlSessionFactory;

    public SwapDaoImpl() {
        this.sqlSessionFactory = MyBatisSqlSessionFactory.getSqlSessionFactory();
    }

    @Override
    public List<SwapStockSearchResultDto> findNearbyBranchStocks(int currentBranchCode, String materialCode, int requiredQty, int distance, double currentLat, double currentLng) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("currentBranchCode", currentBranchCode);
            params.put("materialCode", materialCode);
            params.put("requiredQty", requiredQty);
            params.put("distance", distance);
            params.put("currentLat", currentLat);
            params.put("currentLng", currentLng);
            return session.selectList("mapper.branch.SwapMapper.findNearbyBranchStocks", params);
        }
    }

    @Override
    public BranchLocationDto findBranchLocation(int branchCode) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectOne("mapper.branch.SwapMapper.findBranchLocation", branchCode);
        }
    }

    @Override
    public List<MaterialGroupDto> getMaterialGroups() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.branch.SwapMapper.getMaterialGroups");
        }
    }

    @Override
    public List<MaterialDto> getMaterialsByGroup(int materialGroupId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.branch.SwapMapper.getMaterialsByGroup", materialGroupId);
        }
    }

    @Override
    public int createSwapRequest(int reqBranchCode, int resBranchCode, String materialCode, double qty) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            Map<String, Object> params = new HashMap<>();
            params.put("reqBranchCode", reqBranchCode);
            params.put("resBranchCode", resBranchCode);
            params.put("materialCode", materialCode);
            params.put("qty", qty);
            return session.insert("mapper.branch.SwapMapper.createSwapRequest", params);
        }
    }

    @Override
    public List<SwapRequestDto> getSentRequests(int branchCode) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.branch.SwapMapper.getSentRequests", branchCode);
        }
    }

    @Override
    public List<SwapRequestDto> getReceivedRequests(int branchCode) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.branch.SwapMapper.getReceivedRequests", branchCode);
        }
    }

    @Override
    public List<SwapRequestDto> getSwapHistory(int branchCode) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("mapper.branch.SwapMapper.getSwapHistory", branchCode);
        }
    }

    @Override
    public int approveSwapRequest(int swapId, int currentBranchCode) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            Map<String, Object> params = new HashMap<>();
            params.put("swapId", swapId);
            params.put("currentBranchCode", currentBranchCode);
            return session.update("mapper.branch.SwapMapper.approveSwapRequest", params);
        }
    }

    @Override
    public int rejectSwapRequest(int swapId) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            return session.update("mapper.branch.SwapMapper.rejectSwapRequest", swapId);
        }
    }

    @Override
    public int cancelSwapRequest(int swapId) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            return session.update("mapper.branch.SwapMapper.cancelSwapRequest", swapId);
        }
    }

    @Override
    public SwapRequestDto getSwapRequestDetail(int swapId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectOne("mapper.branch.SwapMapper.getSwapRequestDetail", swapId);
        }
    }

    @Override
    public int decreaseStock(int branchCode, String materialCode, double qty) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            Map<String, Object> params = new HashMap<>();
            params.put("branchCode", branchCode);
            params.put("materialCode", materialCode);
            params.put("qty", qty);
            return session.update("mapper.branch.SwapMapper.decreaseStock", params);
        }
    }

    @Override
    public int increaseStock(int branchCode, String materialCode, double qty) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            Map<String, Object> params = new HashMap<>();
            params.put("branchCode", branchCode);
            params.put("materialCode", materialCode);
            params.put("qty", qty);
            return session.update("mapper.branch.SwapMapper.increaseStock", params);
        }
    }

    @Override
    public int recordStockChange(String branchStockCode, double changeAmount, String changeType, double afterQty) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            Map<String, Object> params = new HashMap<>();
            params.put("branchStockCode", branchStockCode);
            params.put("changeAmount", changeAmount);
            params.put("changeType", changeType);
            params.put("afterQty", afterQty);
            return session.insert("mapper.branch.SwapMapper.recordStockChange", params);
        }
    }

    @Override
    public String getBranchStockCode(int branchCode, String materialCode) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("branchCode", branchCode);
            params.put("materialCode", materialCode);
            return session.selectOne("mapper.branch.SwapMapper.getBranchStockCode", params);
        }
    }
}
