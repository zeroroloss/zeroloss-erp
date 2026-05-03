package dao.hq.warehouse;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.hq.warehouse.WarehouseOutboundDTO;
import dto.hq.warehouse.WarehouseOutboundDetailDTO;
import dto.hq.warehouse.WarehouseOutboundItemDTO;

public class WarehouseOutboundDaoImpl implements WarehouseOutboundDao {
    private static final String NAME_SPACE = "mapper.hq.warehouse.outbound.";

    @Override
    public List<String> findAllBranchNames(SqlSession sqlSession) {
        return sqlSession.selectList(NAME_SPACE + "selectAllBranchNames");
    }

    @Override
    public List<WarehouseOutboundDTO> findOutbounds(SqlSession sqlSession, Map<String, String> params) {
        return sqlSession.selectList(NAME_SPACE + "selectOutbounds", params);
    }

    @Override
    public WarehouseOutboundDetailDTO findDetailByOutboundNo(SqlSession sqlSession, int outboundNo) {
        return sqlSession.selectOne(NAME_SPACE + "selectOutboundDetail", outboundNo);
    }

    @Override
    public List<WarehouseOutboundItemDTO> findDetailItemsByOutboundNo(SqlSession sqlSession, int outboundNo) {
        return sqlSession.selectList(NAME_SPACE + "selectOutboundItems", outboundNo);
    }

}
