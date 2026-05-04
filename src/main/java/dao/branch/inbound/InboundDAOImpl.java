package dao.branch.inbound;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.branch.inbound.InboundProcessingDTO;

public class InboundDAOImpl implements InboundDao {
	
	private static final String MAPPER_NAMESPACE = "mapper.branch.inboundMapper.";

	@Override
	public List<InboundProcessingDTO> findInboundList(SqlSession sqlSession) {
		return sqlSession.selectList(MAPPER_NAMESPACE+"selectInboundsToProcess");
	}

}
