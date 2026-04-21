package dao;

import dto.DemoDto;

import java.util.List;

public class DemoDao {

    public List<DemoDto> findAll() {
        return List.of(
                new DemoDto(1L, "Hello from DAO"),
                new DemoDto(2L, "This is JSP/Servlet demo data")
        );
    }
}

