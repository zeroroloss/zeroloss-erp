package dao.branch.swap;

import dto.branch.BranchLocationDto;
import dto.branch.swap.MaterialDto;
import dto.branch.swap.MaterialGroupDto;
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
}
