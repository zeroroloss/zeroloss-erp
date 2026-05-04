package service.branch.inbound;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dao.branch.inbound.InboundDAOImpl;
import dao.branch.inbound.InboundDao;
import dto.branch.inbound.InboundProcessingDTO;
import util.MyBatisSqlSessionFactory;

public class InboundServiceImpl implements InboundService {
	
	private final InboundDao dao = new InboundDAOImpl();

	@Override
	public List<InboundProcessingDTO> findInboundsToProcess() {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			return dao.findInboundList(sqlSession);
		} catch(Exception e) {
			throw new RuntimeException(e);
		}
	}

}
