package service.hq.place_order;

import java.util.List;

import dto.hq.place_order.OrderQuantityLimitDTO;

public interface OrderQuantityLimitService {
	List<OrderQuantityLimitDTO> selectLimits(String categoryName, String itemName) throws Exception;
	int updateLimit(String materialCode, java.math.BigDecimal minQty, java.math.BigDecimal maxQty) throws Exception;

}
