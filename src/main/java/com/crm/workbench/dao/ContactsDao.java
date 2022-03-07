package com.crm.workbench.dao;

import com.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    int total(Contacts contact);

    List<Contacts> contactsList(Contacts contact);

    int insert(Contacts contact);

}
