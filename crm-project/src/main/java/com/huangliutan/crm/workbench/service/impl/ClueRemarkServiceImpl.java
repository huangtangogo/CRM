package com.huangliutan.crm.workbench.service.impl;

import com.huangliutan.crm.workbench.domain.ClueRemark;
import com.huangliutan.crm.workbench.mapper.ClueRemarkMapper;
import com.huangliutan.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("clueRemarkService")
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Override
    public List<ClueRemark> queryClueRemarkByClueId(String clueId) {
        return clueRemarkMapper.selectClueRemarkByClueId(clueId);
    }

    @Override
    public int saveCreateClueRemark(ClueRemark remark) {
        return clueRemarkMapper.insertClueRemark(remark);
    }

    @Override
    public int deleteClueRemarkById(String id) {
        return clueRemarkMapper.deleteClueRemarkById(id);
    }

    @Override
    public int saveEditClueRemark(ClueRemark remark) {
        return clueRemarkMapper.updateClueRemark(remark);
    }
}
