package dao.branch;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import dto.branch.hr.BranchScheduleDTO;
import dto.branch.hr.EmployeeDTO;
import util.MyBatisSqlSessionFactory;

public class BranchScheduleDaoImpl implements BranchScheduleDao {

	@Override
	public void insertSchedule(BranchScheduleDTO schedule) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.insert("mapper.branch.schedule.insertSchedule", schedule);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public List<EmployeeDTO> selectBranchEmployee(Integer branchCode) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		List<EmployeeDTO> empList = null;
		try {
			empList = sqlSession.selectList("mapper.branch.schedule.selectBranchEmployee", branchCode);
		} catch(Exception e) {
			throw e;
		} finally {
			sqlSession.close();
		}
		return empList;
	}

	@Override
	public List<BranchScheduleDTO> selectBranchScheduleList(BranchScheduleDTO schedule) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		List<BranchScheduleDTO> scd = null;
		try {
			scd = sqlSession.selectList("mapper.branch.schedule.selectBranchScheduleList", schedule);
		} catch(Exception e) {
			throw e;
		} finally {
			sqlSession.close();
		}
		return scd;
	}

	@Override
	public Integer duplicateScdCnt(BranchScheduleDTO schedule) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.branch.schedule.duplicateScdCnt", schedule);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}

	@Override
	public Integer duplicateScdCntForUpdate(BranchScheduleDTO schedule) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		Integer cnt = null;
		try {
			cnt = sqlSession.selectOne("mapper.branch.schedule.duplicateScdCntForUpdate", schedule);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return cnt;
	}

	@Override
	public void updateSchedule(BranchScheduleDTO schedule) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.update("mapper.branch.schedule.updateSchedule", schedule);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public void deleteSchedule(Integer scheduleId) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.delete("mapper.branch.schedule.deleteSchedule", scheduleId);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public void deleteRepeatSchedule(String repeatGroupId) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.delete("mapper.branch.schedule.deleteRepeatSchedule", repeatGroupId);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}

	@Override
	public BranchScheduleDTO selectSchedule(Integer scheduleId) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		BranchScheduleDTO schedule = null;
		try {
			schedule = sqlSession.selectOne("mapper.branch.schedule.selectSchedule", scheduleId);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			sqlSession.close();
		}
		return schedule;
	}

	@Override
	public void updateRepeatSchedule(BranchScheduleDTO schedule) throws Exception {
		SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession();
		try {
			sqlSession.update("mapper.branch.schedule.updateRepeatSchedule", schedule);
			sqlSession.commit();
		} catch(Exception e) {
			sqlSession.rollback();
			throw e;
		} finally {
			sqlSession.close();
		}
	}

}
