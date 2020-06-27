package com.huangliutan.crm.workbench.service;

import com.huangliutan.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {
    int saveCreateClueActivityRelationByList(List<ClueActivityRelation> relationList);

    int deleteClueActivityRelationByClueIdActivityId(ClueActivityRelation clueActivityRelation);
}
