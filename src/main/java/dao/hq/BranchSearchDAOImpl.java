package dao.hq;

import dto.HqBranchSearchDTO;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BranchSearchDAOImpl implements BranchSearchDAO {

    @Override
    public List<HqBranchSearchDTO> searchBranches(String region, String keyword) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("region", "전체".equals(region) ? null : region);
            params.put("keyword", keyword);
            return sqlSession.selectList("mapper.hq.BranchSearchMapper.searchBranches", params);
        }
    }

    // [추가]
    @Override
    public Integer getMaxBranchCode(String regionCode) throws Exception {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return sqlSession.selectOne("mapper.hq.BranchSearchMapper.getMaxBranchCode", regionCode);
        }
    }

    @Override
    public void createBranch(HqBranchSearchDTO branchDTO) throws Exception {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            sqlSession.insert("mapper.hq.BranchSearchMapper.createBranch", branchDTO);
            sqlSession.commit();
        }
    }

    // 기존 메서드 아래에 추가
    @Override
    public void updateBranch(HqBranchSearchDTO branchDTO) throws Exception {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            sqlSession.update("mapper.hq.BranchSearchMapper.updateBranch", branchDTO);
            sqlSession.commit();
        }
    }

    @Override
    public void deleteBranch(String id) throws Exception {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            sqlSession.delete("mapper.hq.BranchSearchMapper.deleteBranch", id);
            sqlSession.commit();
        }
    }

}