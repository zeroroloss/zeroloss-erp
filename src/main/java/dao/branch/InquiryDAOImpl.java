package dao.branch;

import dto.InquiryDTO;
import dto.InquiryReplyDTO;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import java.util.List;
import java.util.Map;

public class InquiryDAOImpl implements InquiryDAO {

    @Override
    public List<InquiryDTO> selectInquiries(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return sqlSession.selectList("mapper.branch.InquiryMapper.selectInquiries", params);
        }
    }

    @Override
    public InquiryDTO selectInquiryById(int inquiryId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return sqlSession.selectOne("mapper.branch.InquiryMapper.selectInquiryById", inquiryId);
        }
    }

    @Override
    public int createInquiry(InquiryDTO inquiry) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            int result = sqlSession.insert("mapper.branch.InquiryMapper.createInquiry", inquiry);
            sqlSession.commit();
            return result;
        }
    }

    @Override
    public int updateInquiry(InquiryDTO inquiry) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            int result = sqlSession.update("mapper.branch.InquiryMapper.updateInquiry", inquiry);
            sqlSession.commit();
            return result;
        }
    }

    @Override
    public int deleteInquiry(int inquiryId) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            int result = sqlSession.delete("mapper.branch.InquiryMapper.deleteInquiry", inquiryId);
            sqlSession.commit();
            return result;
        }
    }

    @Override
    public int createReply(InquiryReplyDTO reply) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            int result = sqlSession.insert("mapper.branch.InquiryMapper.createReply", reply);
            sqlSession.commit();
            return result;
        }
    }
    
    @Override
    public int updateInquiryStatus(Map<String, Object> params) {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            int result = sqlSession.update("mapper.branch.InquiryMapper.updateInquiryStatus", params);
            sqlSession.commit();
            return result;
        }
    }
}