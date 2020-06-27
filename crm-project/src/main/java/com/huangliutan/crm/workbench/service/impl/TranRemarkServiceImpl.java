package com.huangliutan.crm.workbench.service.impl;

import com.huangliutan.crm.workbench.domain.TranRemark;
import com.huangliutan.crm.workbench.mapper.TranRemarkMapper;
import com.huangliutan.crm.workbench.service.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("tranRemarkService")
public class TranRemarkServiceImpl implements TranRemarkService {
    @Autowired
    private TranRemarkMapper tranRemarkMapper;
    @Override
    public List<TranRemark> queryTranRemarkForDetailByTranId(String tranId) {
        return tranRemarkMapper.selectTranRemarkForDetail(tranId);
    }

    @Override
    public int saveCreateTranRemark(TranRemark tranRemark) {
        return tranRemarkMapper.insertTranRemark(tranRemark);
    }

    @Override
    public int deleteTranRemarkById(String id) {
        return tranRemarkMapper.deleteTranRemarkById(id);
    }

    @Override
    public int saveEditTranRemark(TranRemark tranRemark) {
        return tranRemarkMapper.updateTranRemark(tranRemark);
    }
}
