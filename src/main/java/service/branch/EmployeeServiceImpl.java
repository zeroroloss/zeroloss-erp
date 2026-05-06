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
	public Integer selectEmpCnt(Integer branchCode) throws Exception {
		return employeeDao.selectEmpCnt(branchCode);
	}

	@Override
	public Integer selectHqEmpCnt(Integer branchCode) throws Exception {
		return employeeDao.selectHqEmpCnt(branchCode);
	}

	@Override
	public Integer selectPTMCnt(Integer branchCode) throws Exception {
		return employeeDao.selectPTMCnt(branchCode);
	}

	@Override
	public List<EmployeeDTO> searchEmployeeList(Integer branchCode) throws Exception {
		return employeeDao.selectEmployeeList(branchCode);
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

	@Override
	public Integer selectTodayEmpCnt(Integer branchCode) throws Exception {
		return employeeDao.selectTodayEmpCnt(branchCode);
	}
}
