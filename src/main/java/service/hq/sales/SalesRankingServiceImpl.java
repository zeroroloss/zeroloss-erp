package service.hq.sales;

import dao.hq.sales.SalesRankingDao;
import dao.hq.sales.SalesRankingDaoImpl;
import dto.hq.sales.SalesRankingDto;

import java.util.List;

public class SalesRankingServiceImpl implements SalesRankingService {

    private SalesRankingDao salesRankingDao;

    public SalesRankingServiceImpl() {
        this.salesRankingDao = new SalesRankingDaoImpl();
    }

    @Override
    public List<SalesRankingDto> getSalesRanking(String startDate, String endDate) {
        return salesRankingDao.getSalesRanking(startDate, endDate); // 🟢 파라미터 전달
    }

    @Override
    public List<SalesRankingDto> getSalesQuantityRanking(String startDate, String endDate) {
        return salesRankingDao.getSalesQuantityRanking(startDate, endDate); // 🟢 파라미터 전달
    }
}