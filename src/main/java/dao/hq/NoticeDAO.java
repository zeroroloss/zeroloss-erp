package dao.hq;

import dto.NoticeDTO;
import java.util.List;

public interface NoticeDAO {
    List<NoticeDTO> selectNotices();
    void createNotice(NoticeDTO noticeDTO) throws Exception;
    void updateNotice(NoticeDTO noticeDTO) throws Exception;
    void deleteNotice(int noticeId) throws Exception;
    void incrementViewCount(int noticeId) throws Exception;
}