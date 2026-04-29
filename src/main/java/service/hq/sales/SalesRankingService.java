package service.hq.sales;

import dto.hq.sales.SalesRankingDto;
import java.util.List;

public interface SalesRankingService{
    List<SalesRankingDto> getSalesRanking(String startDate, String endDate);
    List<SalesRankingDto> getSalesQuantityRanking(String startDate, String endDate);
}