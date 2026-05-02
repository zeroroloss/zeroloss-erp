package service.hq.place_order;

import java.util.List;
import java.util.Map;

import dto.hq.place_order.PlaceOrderOverviewDTO;
import dto.hq.place_order.PlaceOrderOverviewDetailDTO;

public interface PlaceOrderOverviewService {

	List<String> findAllBranchNames();

	List<PlaceOrderOverviewDTO> findPlaceOrders(Map<String, String> params);

	PlaceOrderOverviewDetailDTO findDetailByPoId(int poId);

}
