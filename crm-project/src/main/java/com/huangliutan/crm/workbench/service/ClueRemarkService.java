package com.huangliutan.crm.workbench.service;

import com.huangliutan.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {

    List<ClueRemark> queryClueRemarkByClueId(String clueId);

    int saveCreateClueRemark(ClueRemark remark);

    int deleteClueRemarkById(String id);

    int saveEditClueRemark(ClueRemark remark);
}
