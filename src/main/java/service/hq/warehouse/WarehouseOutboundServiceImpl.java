package service.hq.warehouse;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dao.hq.warehouse.WarehouseOutboundDao;
import dao.hq.warehouse.WarehouseOutboundDaoImpl;
import dto.hq.warehouse.WarehouseOutboundDTO;
import dto.hq.warehouse.WarehouseOutboundDetailDTO;
import util.MyBatisSqlSessionFactory;

public class WarehouseOutboundServiceImpl implements WarehouseOutboundService {

    private final WarehouseOutboundDao dao = new WarehouseOutboundDaoImpl();

    @Override
    public List<String> findAllBranchNames() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return dao.findAllBranchNames(sqlSession);
        }
    }

    @Override
    public List<WarehouseOutboundDTO> findOutbounds(Map<String, String> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return dao.findOutbounds(sqlSession, params);
        }
    }

    @Override
    public WarehouseOutboundDetailDTO findDetailByOutboundNo(int outboundNo) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            WarehouseOutboundDetailDTO detail = dao.findDetailByOutboundNo(sqlSession, outboundNo);
            if (detail == null) throw new RuntimeException("출고 정보 없음: " + outboundNo);
            detail.setItems(dao.findDetailItemsByOutboundNo(sqlSession, outboundNo));
            return detail;
        }
    }

}
