package service.hq;

import dao.hq.NoticeDAO;
import dao.hq.NoticeDAOImpl;
import dto.NoticeDTO;

import java.util.List;

public class NoticeServiceImpl implements NoticeService {

    private final NoticeDAO noticeDAO = new NoticeDAOImpl();

    @Override
    public List<NoticeDTO> getNotices() {
        return noticeDAO.selectNotices();
    }

    @Override
    public void createNotice(NoticeDTO noticeDTO) throws Exception {
        noticeDAO.createNotice(noticeDTO);
    }

    @Override
    public void updateNotice(NoticeDTO noticeDTO) throws Exception {
        noticeDAO.updateNotice(noticeDTO);
    }

    @Override
    public void deleteNotice(int noticeId) throws Exception {
        noticeDAO.deleteNotice(noticeId);
    }

    @Override
    public void incrementViewCount(int noticeId) throws Exception {
        noticeDAO.incrementViewCount(noticeId);
    }
}
