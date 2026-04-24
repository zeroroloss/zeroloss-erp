package service.hq;

import dao.hq.BranchSearchDAO;
import dao.hq.BranchSearchDAOImpl;
import dto.HqBranchSearchDTO;

import java.util.List;

public class BranchSearchServiceImpl implements BranchSearchService {

    private final BranchSearchDAO branchSearchDAO = new BranchSearchDAOImpl();

    @Override
    public List<HqBranchSearchDTO> searchBranches(String region, String keyword) {
        return branchSearchDAO.searchBranches(region, keyword);
    }

    @Override
    public void createBranch(HqBranchSearchDTO branchDTO) throws Exception {
        // 1. 해당 지역(regionCode)의 가장 큰 지점 번호 조회
        Integer maxCode = branchSearchDAO.getMaxBranchCode(branchDTO.getRegionCode());
        int newBranchCode;

        // 2. 만약 해당 지역에 지점이 하나도 없다면 최초 번호 생성 규칙 적용
        if (maxCode == null) {
            String rc = branchDTO.getRegionCode(); // 예: "02" 또는 "031"
            if (rc.startsWith("0")) rc = rc.substring(1); // "2" 또는 "31"

            if (rc.length() == 1) {
                // 두 자리 지역번호 (02) -> 2001
                newBranchCode = Integer.parseInt(rc) * 1000 + 1;
            } else {
                // 세 자리 지역번호 (031) -> 3101
                newBranchCode = Integer.parseInt(rc) * 100 + 1;
            }
        } else {
            // 3. 기존 지점이 있다면 가장 큰 번호 + 1
            newBranchCode = maxCode + 1;
        }

        // 4. 생성된 번호를 DTO의 id(branch_code)에 세팅
        branchDTO.setId(String.valueOf(newBranchCode));

        // 5. DB Insert 실행
        branchSearchDAO.createBranch(branchDTO);
    }

    // 기존 메서드 아래에 추가
    @Override
    public void updateBranch(HqBranchSearchDTO branchDTO) throws Exception {
        branchSearchDAO.updateBranch(branchDTO);
    }

    @Override
    public void deleteBranch(String id) throws Exception {
        branchSearchDAO.deleteBranch(id);
    }

}