package com.huangliutan.crm.settings.service;

import com.huangliutan.crm.settings.domain.DicType;

import java.util.List;

public interface DicTypeService {
    List<DicType> queryAllDicTypes();

    DicType queryDicTypeByCode(String code);

    int saveCreateDicType(DicType dicType);

    int deleteDicTypeByCodes(String[] code);

    int saveEditDicType(DicType dicType);

}
