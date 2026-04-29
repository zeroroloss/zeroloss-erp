package dao.hq.sales; // (Service는 package service.hq.sales;)

import dto.hq.sales.SalesRankingDto;
import java.util.List;

public interface SalesRankingDao { // (Service는 interface SalesRankingService)
    // 🟢 시작일과 종료일을 파라미터로 추가
    List<SalesRankingDto> getSalesRanking(String startDate, String endDate);
    List<SalesRankingDto> getSalesQuantityRanking(String startDate, String endDate);
}