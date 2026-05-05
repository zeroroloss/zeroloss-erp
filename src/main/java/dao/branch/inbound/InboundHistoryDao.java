package dao.branch.inbound;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.branch.inbound.InboundHistoryDTO;
import dto.branch.inbound.InboundHistoryItemDTO;

public interface InboundHistoryDao {

    List<InboundHistoryDTO> selectInboundHistoryList(SqlSession sqlSession, Map<String, Object> params);

    InboundHistoryDTO selectInboundHistoryHeader(SqlSession sqlSession, Map<String, Object> params);

    List<InboundHistoryItemDTO> selectInboundHistoryItems(SqlSession sqlSession, Map<String, Object> params);
}