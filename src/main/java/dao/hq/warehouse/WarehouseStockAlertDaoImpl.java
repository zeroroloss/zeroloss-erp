package dao.hq.warehouse;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.NotificationDTO;
import dto.WarehouseStockDTO;
import util.MyBatisSqlSessionFactory;

public class WarehouseStockAlertDaoImpl implements WarehouseStockAlertDao {

	@Override
	public List<WarehouseStockDTO> selectExpiredStock() throws Exception {
		List<WarehouseStockDTO> expiredList = null;
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			expiredList = sqlSession.selectList("mapper.hq.warehouse.alert.selectExpiredStock");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return expiredList;
	}

	@Override
	public List<WarehouseStockDTO> selectUrgentStock() throws Exception {
		List<WarehouseStockDTO> urgentList = null;
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			urgentList = sqlSession.selectList("mapper.hq.warehouse.alert.selectUrgentStock");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return urgentList;
	}

	@Override
	public List<WarehouseStockDTO> selectWarningStock() throws Exception {
		List<WarehouseStockDTO> warningList = null;
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			warningList = sqlSession.selectList("mapper.hq.warehouse.alert.selectWarningStock");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return warningList;
	}

	@Override
	public void insertNotification(NotificationDTO notification) throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			sqlSession.insert("mapper.hq.warehouse.alert.insertNotification", notification);
			sqlSession.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public void insertNotificationReceiver(NotificationDTO notification) throws Exception {
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			sqlSession.insert("mapper.hq.warehouse.alert.insertNotificationReceiver", notification);
			sqlSession.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public boolean existsTodayNotification(NotificationDTO notification) throws Exception {
		Integer cnt = 0;
		try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
			cnt = sqlSession.selectOne("mapper.hq.warehouse.alert.existsTodayNotification", notification);
		}
		return cnt != null && cnt > 0;
	}

}
