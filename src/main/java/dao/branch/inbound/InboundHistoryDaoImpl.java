package dao.branch.inbound;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.branch.inbound.InboundHistoryDTO;
import dto.branch.inbound.InboundHistoryItemDTO;

public class InboundHistoryDaoImpl implements InboundHistoryDao {

    private static final String MAPPER_NAMESPACE = "mapper.branch.InboundHistoryMapper.";

    @Override
    public List<InboundHistoryDTO> selectInboundHistoryList(SqlSession sqlSession, Map<String, Object> params) {
        return sqlSession.selectList(MAPPER_NAMESPACE + "selectInboundHistoryList", params);
    }

    @Override
    public InboundHistoryDTO selectInboundHistoryHeader(SqlSession sqlSession, Map<String, Object> params) {
        return sqlSession.selectOne(MAPPER_NAMESPACE + "selectInboundHistoryHeader", params);
    }

    @Override
    public List<InboundHistoryItemDTO> selectInboundHistoryItems(SqlSession sqlSession, Map<String, Object> params) {
        return sqlSession.selectList(MAPPER_NAMESPACE + "selectInboundHistoryItems", params);
    }
}