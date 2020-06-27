package com.huangliutan.crm.settings.service.impl;

import com.huangliutan.crm.settings.domain.DicValue;
import com.huangliutan.crm.settings.mapper.DicValueMapper;
import com.huangliutan.crm.settings.service.DicValueService;
import com.huangliutan.crm.workbench.domain.Activity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("dicValueService")
public class DicValueServiceImpl implements DicValueService {
    @Autowired
    private DicValueMapper dicValueMapper;
    @Override
    public List<DicValue> queryAllDicValues() {
        return dicValueMapper.selectAllDicValues();
    }

    @Override
    public int saveCreateDicValue(DicValue dicValue) {
        return dicValueMapper.insertDicValue(dicValue);
    }

    @Override
    public int deleteDicValueByIds(String[] id) {
        return dicValueMapper.deleteDicValueByIds(id);
    }

    @Override
    public DicValue queryDicValueById(String id) {
        return dicValueMapper.selectDicValueById(id);
    }

    @Override
    public int saveEditDicValue(DicValue dicValue) {
        return dicValueMapper.updateDicValue(dicValue);
    }

    @Override
    public List<DicValue> queryAllDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectAllDicValueByTypeCode(typeCode);
    }
}
