package com.huangliutan.crm.settings.service.impl;

import com.huangliutan.crm.settings.domain.DicType;
import com.huangliutan.crm.settings.mapper.DicTypeMapper;
import com.huangliutan.crm.settings.mapper.DicValueMapper;
import com.huangliutan.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("dicTypeService")
public class DicTypeServiceImpl implements DicTypeService {
    @Autowired
    private DicTypeMapper dicTypeMapper;

    @Autowired
    private DicValueMapper dicValueMapper;
    @Override
    public List<DicType> queryAllDicTypes() {
        return dicTypeMapper.selectAllDicTypes();
    }

    @Override
    public DicType queryDicTypeByCode(String code) {
        return dicTypeMapper.selectDicTypeByCode(code);
    }

    @Override
    public int saveCreateDicType(DicType dicType) {
        return dicTypeMapper.insertDicType(dicType);
    }

    @Override
    public int deleteDicTypeByCodes(String[] code) {
        //先删除子表中记录，后删除父表中记录
        dicValueMapper.deleteDicValueByTypeCodes(code);
        return dicTypeMapper.deleteDicTypeByCodes(code);
    }

    @Override
    public int saveEditDicType(DicType dicType) {
        return dicTypeMapper.updateDicType(dicType);
    }
}
