package service.hq;

import java.util.List;

import dao.hq.EmployeeDao;
import dao.hq.EmployeeDaoImpl;
import dto.hq.hr.EmployeeDTO;

public class EmployeeServiceImpl implements EmployeeService {
	private EmployeeDao employeeDao;

	public EmployeeServiceImpl() {
		employeeDao = new EmployeeDaoImpl();
	}

	@Override
	public Integer selectEmpCnt() throws Exception {
		Integer cnt = employeeDao.selectEmpCnt();
		return cnt;
	}

	@Override
	public Integer selectBranchCnt() throws Exception {
		Integer cnt = employeeDao.selectBranchCnt();
		return cnt;
	}

	@Override
	public Integer selectNewEmpCnt() throws Exception {
		Integer cnt = employeeDao.selectNewEmpCnt();
		return cnt;
	}

	@Override
	public List<EmployeeDTO> searchEmployeeList(EmployeeDTO employee) throws Exception {
		List<EmployeeDTO> emp = employeeDao.selectEmployeeList(employee);
		return emp;
	}

	@Override
	public void addEmployee(EmployeeDTO employee) throws Exception {
		employeeDao.insertEmployee(employee);
	}

	@Override
	public void modifyEmployee(EmployeeDTO employee) throws Exception {
		employeeDao.updateEmployee(employee);
	}

}
