package com.huangliutan.crm.workbench.service;

import com.huangliutan.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkService {
    List<TranRemark> queryTranRemarkForDetailByTranId(String tranId);

    int saveCreateTranRemark(TranRemark tranRemark);

    int deleteTranRemarkById(String id);

    int saveEditTranRemark(TranRemark tranRemark);
}
