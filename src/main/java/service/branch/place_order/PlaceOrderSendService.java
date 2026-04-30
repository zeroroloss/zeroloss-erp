package service.branch.place_order;

public interface PlaceOrderSendService {
	
	// branchCode 지점의 InProgress 상태의 임시 발주서(draft)를 기반으로
	// 발주서를 생성한다. 그 후 임시 발주서 데이터를 정리한다.
	// 반환) 발주 전송 성공 시 true
    boolean sendDraft(int branchCode);
}
