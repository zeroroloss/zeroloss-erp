package util;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import java.sql.Connection;

/**
 * MyBatis와 MariaDB 연결 테스트 클래스
 */
public class DbConnectionTest {

    public static void main(String[] args) {
        System.out.println("========================================");
        System.out.println("   DB 연결 테스트 시작");
        System.out.println("========================================\n");

        boolean success = false;

        try {
            // 1. SqlSessionFactory 생성 테스트
            System.out.println("[1단계] SqlSessionFactory 생성 중...");
            SqlSessionFactory factory = MyBatisSqlSessionFactory.getSqlSessionFactory();

            if (factory == null) {
                System.out.println("❌ SqlSessionFactory가 null입니다.");
                return;
            }
            System.out.println("✅ SqlSessionFactory 생성 성공!\n");

            // 2. SqlSession 생성 및 연결 테스트
            System.out.println("[2단계] SqlSession 생성 및 DB 연결 중...");
            SqlSession session = factory.openSession();

            if (session == null) {
                System.out.println("❌ SqlSession이 null입니다.");
                return;
            }
            System.out.println("✅ SqlSession 생성 성공!\n");

            // 3. 실제 연결 확인 (JDBC Connection 획득)
            System.out.println("[3단계] 실제 DB 연결 확인 중...");
            Connection connection = session.getConnection();

            if (connection == null) {
                System.out.println("❌ DB Connection이 null입니다.");
                return;
            }

            // 4. DB 메타데이터 확인
            System.out.println("✅ DB 연결 성공!\n");
            System.out.println("[4단계] DB 정보");
            System.out.println("- 데이터베이스 드라이버: " + connection.getMetaData().getDriverName());
            System.out.println("- 데이터베이스 URL: " + connection.getMetaData().getURL());
            System.out.println("- 데이터베이스 버전: " + connection.getMetaData().getDatabaseProductVersion());
            System.out.println("- 연결 상태: " + (connection.isClosed() ? "접속 종료됨" : "정상 연결됨"));
            System.out.println();

            session.close();
            System.out.println("✅ SqlSession 종료 완료\n");
            success = true;

        } catch (Exception e) {
            System.out.println("❌ DB 연결 테스트 실패!");
            System.out.println("\n에러 메시지:");
            System.out.println(e.getClass().getSimpleName() + ": " + e.getMessage());
            System.out.println("\n자세한 스택 트레이스:");
            e.printStackTrace();
        }

        System.out.println("\n========================================");
        if (success) {
            System.out.println("✅ DB 연결 테스트 성공!");
        } else {
            System.out.println("❌ DB 연결 테스트 실패!");
        }
        System.out.println("========================================\n");
    }
}

