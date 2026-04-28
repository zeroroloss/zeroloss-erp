package service.branch;

import java.util.List;

import dao.branch.EmployeeDao;
import dao.branch.EmployeeDaoImpl;
import dto.branch.hr.EmployeeDTO;

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
	public Integer selectHqEmpCnt() throws Exception {
		Integer cnt = employeeDao.selectHqEmpCnt();
		return cnt;
	}

	@Override
	public Integer selectPTMCnt() throws Exception {
		Integer cnt = employeeDao.selectPTMCnt();
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
	public EmployeeDTO selectEmployee(Integer empNo) throws Exception {
		return employeeDao.selectEmployee(empNo);
	}

	@Override
	public EmployeeDTO selectEmployeeByPhone(EmployeeDTO employee) throws Exception {
		return employeeDao.selectEmployeeByPhone(employee);
	}

	@Override
	public void modifyEmployee(EmployeeDTO employee) throws Exception {
		employeeDao.updateEmployee(employee);
	}
}
