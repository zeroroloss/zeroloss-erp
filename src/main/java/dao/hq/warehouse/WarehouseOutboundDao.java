package dao.hq.warehouse;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dto.hq.warehouse.WarehouseOutboundDTO;
import dto.hq.warehouse.WarehouseOutboundDetailDTO;
import dto.hq.warehouse.WarehouseOutboundItemDTO;

public interface WarehouseOutboundDao {

    List<String> findAllBranchNames(SqlSession sqlSession);

    List<WarehouseOutboundDTO> findOutbounds(SqlSession sqlSession, Map<String, String> params);

    WarehouseOutboundDetailDTO findDetailByOutboundNo(SqlSession sqlSession, int outboundNo);

    List<WarehouseOutboundItemDTO> findDetailItemsByOutboundNo(SqlSession sqlSession, int outboundNo);

}
