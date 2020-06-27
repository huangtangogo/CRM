package com.huangliutan.crm.workbench.service;

import com.huangliutan.crm.workbench.domain.FunnelVo;
import com.huangliutan.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranService {
    List<Tran> queryTranForDetailByCustomerId(String customerId);

    int deleteTranById(String id);

    int saveCreateTran(Map<String,Object> map);

    List<Tran> queryTranForPageByCondition(Map<String,Object> map);

    long queryCountOfTranByCondition(Map<String,Object> map);

    Tran queryTranForDetailById(String id);

    int deleteTranByIds(String[] ids);

    List<FunnelVo> queryCountOfTranGroupByStage();

    Tran queryTranById(String id);

    int saveEditTran(Map<String,Object> map);

    List<Tran> queryTranOfContactsByContactsId(String contactsId);
}
