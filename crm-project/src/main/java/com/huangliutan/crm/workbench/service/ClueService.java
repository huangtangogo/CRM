package com.huangliutan.crm.workbench.service;

import com.huangliutan.crm.workbench.domain.Clue;
import com.huangliutan.crm.workbench.domain.ClueRemark;
import com.huangliutan.crm.workbench.web.controller.ClueController;

import java.util.List;
import java.util.Map;

public interface ClueService {
    int saveCreateClue(Clue clue);

    List<Clue> queryClueForPageByCondition(Map<String,Object> map);

    long queryCountForPageByCondition(Map<String,Object> map);

    int deleteClueByIds(String[] id);

    Clue queryClueById(String id);

    int saveEditClue(Clue clue);

    Clue queryClueForDetailById(String id);

    void saveConvert(Map<String,Object> map);

}
