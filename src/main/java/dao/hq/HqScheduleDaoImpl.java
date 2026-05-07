package dao.hq;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.hq.hr.EmployeeDTO;
import dto.hq.hr.HqScheduleDTO;
import util.MyBatisSqlSessionFactory;

public class HqScheduleDaoImpl implements HqScheduleDao {

	@Override
	public void insertSchedule(HqScheduleDTO schedule) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.insert("mapper.hq.schedule.insertSchedule", schedule);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public HqScheduleDTO selectSchedule(Integer scheduleId) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		HqScheduleDTO schedule = null;
		try {
			schedule = sqlSession.selectOne("mapper.hq.schedule.selectSchedule", scheduleId);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return schedule;
	}

	@Override
	public List<HqScheduleDTO> selectScheduleList(HqScheduleDTO schedule) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		List<HqScheduleDTO> scd = null;
		try {
			scd = sqlSession.selectList("mapper.hq.schedule.selectScheduleList", schedule);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return scd;
	}

	@Override
	public Integer duplicateScdCnt(HqScheduleDTO schedule) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.hq.schedule.duplicateScdCnt", schedule);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}

	@Override
	public Integer duplicateScdCntForUpdate(HqScheduleDTO schedule) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.hq.schedule.duplicateScdCntForUpdate", schedule);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}

	@Override
	public void updateSchedule(HqScheduleDTO schedule) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.update("mapper.hq.schedule.updateSchedule", schedule);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public List<EmployeeDTO> selectHqEmployee() throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		List<EmployeeDTO> empList = null;
		try {
			empList = sqlSession.selectList("mapper.hq.schedule.selectHqEmployee");
		} catch(Exception e) {
			throw e;
		} finally {
			sqlSession.close();
		}
		return empList;
	}

	@Override
	public void deleteSchedule(Integer scheduleId) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.delete("mapper.hq.schedule.deleteSchedule", scheduleId);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}
}
