package service.branch.inbound;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import dao.branch.inbound.InboundHistoryDao;
import dao.branch.inbound.InboundHistoryDaoImpl;
import dto.branch.inbound.InboundHistoryDTO;
import util.MyBatisSqlSessionFactory;

public class InboundHistoryServiceImpl implements InboundHistoryService {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private final InboundHistoryDao inboundHistoryDao = new InboundHistoryDaoImpl();

    @Override
    public List<InboundHistoryDTO> getInboundHistoryList(int branchCode, String startDate, String endDate) {
        Map<String, Object> params = new HashMap<>();
        params.put("branchCode", branchCode);
        params.put("startDate", normalizeStartDate(startDate));
        params.put("endDate", normalizeEndDate(endDate));

        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            List<InboundHistoryDTO> historyList = inboundHistoryDao.selectInboundHistoryList(sqlSession, params);
            return historyList == null ? Collections.emptyList() : historyList;
        }
    }

    @Override
    public InboundHistoryDTO getInboundHistoryDetail(int branchCode, String poNo) {
        if (poNo == null || poNo.isBlank()) {
            throw new IllegalArgumentException("발주 번호가 필요합니다.");
        }

        Map<String, Object> params = new HashMap<>();
        params.put("branchCode", branchCode);
        params.put("poNo", poNo);

        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            InboundHistoryDTO history = inboundHistoryDao.selectInboundHistoryHeader(sqlSession, params);
            if (history == null) {
                return null;
            }
            history.setItems(inboundHistoryDao.selectInboundHistoryItems(sqlSession, params));
            return history;
        }
    }

    private String normalizeStartDate(String startDate) {
        if (startDate != null && !startDate.isBlank()) {
            return startDate;
        }
        return LocalDate.now().withDayOfMonth(1).format(DATE_FORMATTER);
    }

    private String normalizeEndDate(String endDate) {
        if (endDate != null && !endDate.isBlank()) {
            return endDate;
        }
        LocalDate today = LocalDate.now();
        return today.withDayOfMonth(today.lengthOfMonth()).format(DATE_FORMATTER);
    }
}