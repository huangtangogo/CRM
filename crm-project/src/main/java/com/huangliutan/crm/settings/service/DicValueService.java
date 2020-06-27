package com.huangliutan.crm.settings.service;

import com.huangliutan.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueService {
    List<DicValue> queryAllDicValues();

    int saveCreateDicValue(DicValue dicValue);

    int deleteDicValueByIds(String[] id);

    DicValue queryDicValueById(String id);

    int saveEditDicValue(DicValue dicValue);

    List<DicValue> queryAllDicValueByTypeCode(String typeCode);

}
