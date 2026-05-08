package dao.branch.stock;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.NotificationDTO;
import util.MyBatisSqlSessionFactory;

public class BranchNotificationDaoImpl implements BranchNotificationDao {

	@Override
	public void insertNotification(NotificationDTO notification) throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			sqlSession.insert("mapper.branch.stock.alert.insertNotification", notification);
			sqlSession.commit();
		} catch (Exception e) {
			throw e;
		}

	}

	@Override
	public void insertNotificationReceiver(NotificationDTO notification) throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			sqlSession.insert("mapper.branch.stock.alert.insertNotificationReceiver", notification);
			sqlSession.commit();
		} catch (Exception e) {
			throw e;
		}

	}

	@Override
	public boolean existsTodayNotification(NotificationDTO notification) throws Exception {
		Integer cnt = 0;
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			cnt = sqlSession.selectOne("mapper.branch.stock.alert.existsTodayNotification", notification);
		} catch (Exception e) {
			throw e;
		}
		return cnt != null && cnt > 0;
	}

	@Override
	public List<Integer> selectBranchAccountIds(int branchCode) throws Exception {
	    List<Integer> list = null;
	    try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
	        list = sqlSession.selectList(
	            "mapper.branch.stock.alert.selectBranchAccountIds",
	            branchCode
	        );
	    } catch (Exception e) {
	        throw e;
	    }
	    return list;
	}

}
