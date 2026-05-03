package service.hq.delivery;

import dto.hq.delivery.DispatchCreationDto;
import dto.hq.delivery.PlaceOrderDetailDto;

import java.util.List;
import java.util.Map;

public interface DispatchService {
    Map<String, Object> getDispatchPageData();
    List<PlaceOrderDetailDto> getOrderDetails(String poNo);
    Map<String, Object> getDispatchModalData(String regionCode);
    void createDispatch(DispatchCreationDto dispatchCreationDto);
}
