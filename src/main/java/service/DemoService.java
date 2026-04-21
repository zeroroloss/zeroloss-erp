package service;

import dao.DemoDao;
import dto.DemoDto;

import java.util.List;

public class DemoService {
    private final DemoDao demoDao = new DemoDao();

    public List<DemoDto> getDemoList() {
        return demoDao.findAll();
    }
}

