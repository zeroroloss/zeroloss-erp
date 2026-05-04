package dao.branch.inbound;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.branch.inbound.InboundProcessingDTO;

public interface InboundDao {

	List<InboundProcessingDTO> findInboundList(SqlSession sqlSession);

}
