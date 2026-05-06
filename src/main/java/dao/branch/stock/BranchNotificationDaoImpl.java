package dao.branch.stock;

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
			e.printStackTrace();
		}

	}

	@Override
	public void insertNotificationReceiver(NotificationDTO notification) throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			sqlSession.insert("mapper.branch.stock.alert.insertNotificationReceiver", notification);
			sqlSession.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public boolean existsTodayNotification(NotificationDTO notification) throws Exception {
		Integer cnt = 0;
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			cnt = sqlSession.selectOne("mapper.branch.stock.alert.existsTodayNotification", notification);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return cnt != null && cnt > 0;
	}

}
