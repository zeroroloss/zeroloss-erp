package service.branch.swap;

import dao.branch.swap.SwapDao;
import dao.branch.swap.SwapDaoImpl;
import dto.branch.BranchLocationDto;
import dto.branch.swap.MaterialDto;
import dto.branch.swap.MaterialGroupDto;
import dto.branch.swap.SwapStockSearchRequestDto;
import dto.branch.swap.SwapStockSearchResultDto;

import java.util.Collections;
import java.util.List;

public class SwapServiceImpl implements SwapService {

    private final SwapDao swapDao;

    public SwapServiceImpl() {
        this.swapDao = new SwapDaoImpl();
    }

    @Override
    public List<SwapStockSearchResultDto> findNearbyBranchStocks(SwapStockSearchRequestDto searchDto) {
        BranchLocationDto currentLocation = swapDao.findBranchLocation(searchDto.getCurrentBranchCode());
        if (currentLocation == null) {
            return Collections.emptyList();
        }

        return swapDao.findNearbyBranchStocks(
                searchDto.getCurrentBranchCode(),
                searchDto.getMaterialCode(),
                searchDto.getRequiredQty(),
                searchDto.getDistance(),
                currentLocation.getLat(),
                currentLocation.getLng()
        );
    }

    @Override
    public List<MaterialGroupDto> getMaterialGroups() {
        return swapDao.getMaterialGroups();
    }

    @Override
    public List<MaterialDto> getMaterialsByGroup(int materialGroupId) {
        return swapDao.getMaterialsByGroup(materialGroupId);
    }
}
