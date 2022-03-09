package com.crm.workbench.dao;

import com.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {

    int total(Customer customer);

    List<Customer> customerList(Customer customer);

    Customer select(String name);

    Customer edit(String id);

    int insert(Customer customer);

    int update(Customer customer);

    List<String> selectName(String name);


}
