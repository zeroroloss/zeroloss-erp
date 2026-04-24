package service.hq;

import dto.NoticeDTO;
import java.util.List;

public interface NoticeService {
    List<NoticeDTO> getNotices();
    void createNotice(NoticeDTO noticeDTO) throws Exception;
    void updateNotice(NoticeDTO noticeDTO) throws Exception;
    void deleteNotice(int noticeId) throws Exception;
    void incrementViewCount(int noticeId) throws Exception;
}