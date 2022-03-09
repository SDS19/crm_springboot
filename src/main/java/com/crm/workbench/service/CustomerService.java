package com.crm.workbench.service;

import com.crm.exceptions.DaoException;
import com.crm.vo.Pagination;
import com.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {

    Pagination<Customer> customerList(Customer customer) throws DaoException;

    List<String> autoComplete(String name);

    void create(Customer customer) throws DaoException;

    Map<String, Object> edit(String id);

    void update(Customer customer) throws DaoException;
}
