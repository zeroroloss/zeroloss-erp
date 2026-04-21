//package util;
//
//import java.io.InputStream;
//
//import org.apache.ibatis.io.Resources;
//import org.apache.ibatis.session.SqlSessionFactory;
//import org.apache.ibatis.session.SqlSessionFactoryBuilder;
//
//// 역할:
//// - 애플리케이션 전역에서 사용할 SqlSessionFactory를 1번만 생성하고 공유하는 클래스
//// - MyBatis 설정 파일을 읽어서 SqlSessionFactory를 초기화하는 책임
//public class MyBatisSqlSessionFactory {
//
//    // SqlSessionFactory는 여러 요청에서 공유해야 하므로 static으로 선언 (싱글톤처럼 사용)
//    private static SqlSessionFactory sqlSessionFactory;
//
//    // static 초기화 블록 → 클래스가 처음 로딩될 때 딱 1번만 실행됨
//    static {
//        try {
//            // MyBatis 설정 파일 경로
//            String resource = "resource/mybatis-config.xml";
//
//            // 설정 파일을 InputStream으로 읽어옴
//            InputStream inputStream = Resources.getResourceAsStream(resource);
//
//            // SqlSessionFactory를 생성해주는 빌더 객체
//            SqlSessionFactoryBuilder builder = new SqlSessionFactoryBuilder();
//
//            // 설정 파일을 기반으로 SqlSessionFactory 생성
//            // 내부적으로 Configuration, Mapper, SQL 등을 모두 파싱하여 준비
//            sqlSessionFactory = builder.build(inputStream);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//
//    // 외부에서 SqlSessionFactory를 꺼내 쓰기 위한 메서드
//    public static SqlSessionFactory getSqlSessionFactory() {
//        return sqlSessionFactory;
//    }
//}