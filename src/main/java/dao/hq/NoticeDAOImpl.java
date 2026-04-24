package dao.hq;

import dto.NoticeDTO;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisSqlSessionFactory;

import java.util.List;

public class NoticeDAOImpl implements NoticeDAO {

    @Override
    public List<NoticeDTO> selectNotices() {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            return sqlSession.selectList("mapper.hq.NoticeMapper.selectNotices");
        }
    }

    @Override
    public void createNotice(NoticeDTO noticeDTO) throws Exception {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            sqlSession.insert("mapper.hq.NoticeMapper.createNotice", noticeDTO);
            sqlSession.commit();
        }
    }

    @Override
    public void updateNotice(NoticeDTO noticeDTO) throws Exception {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            sqlSession.update("mapper.hq.NoticeMapper.updateNotice", noticeDTO);
            sqlSession.commit();
        }
    }

    @Override
    public void deleteNotice(int noticeId) throws Exception {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            sqlSession.delete("mapper.hq.NoticeMapper.deleteNotice", noticeId);
            sqlSession.commit();
        }
    }

    @Override
    public void incrementViewCount(int noticeId) throws Exception {
        try (SqlSession sqlSession = MyBatisSqlSessionFactory.getSqlSessionFactory().openSession()) {
            sqlSession.update("mapper.hq.NoticeMapper.incrementViewCount", noticeId);
            sqlSession.commit();
        }
    }
}
