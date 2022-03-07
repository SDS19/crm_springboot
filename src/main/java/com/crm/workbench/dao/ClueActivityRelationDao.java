package com.crm.workbench.dao;

import com.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {

    int delete(String id);

    int deleteByClue(String[] clueIds);

    int bind(List<ClueActivityRelation> list);

    List<ClueActivityRelation> getActiviesByclueId(String clueId);


}
