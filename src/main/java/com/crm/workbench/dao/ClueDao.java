package com.crm.workbench.dao;

import com.crm.workbench.domain.Clue;

import java.util.List;

public interface ClueDao {

	int total(Clue clue);

	List<Clue> clueList(Clue clue);

	int insert(Clue clue);

	Clue detail(String id);

	Clue edit(String id);

	int update(Clue clue);

	int delete(String[] id);

	Clue getClueById(String id);






}
