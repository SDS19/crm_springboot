package com.crm.workbench.controller;

import com.crm.exceptions.DaoException;
import com.crm.settings.domain.User;
import com.crm.utils.DateTimeUtil;
import com.crm.utils.UUIDUtil;
import com.crm.vo.Pagination;
import com.crm.workbench.domain.Customer;
import com.crm.workbench.service.CustomerService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/customer")
public class CustomerController {

    @Resource
    private CustomerService customerService;

    @GetMapping
    public Pagination<Customer> list(Integer pageNo, Integer pageSize, Customer customer) {
        customer.setPageCount((pageNo-1)*pageSize);
        try {
            return customerService.customerList(customer);
        } catch (DaoException e) {
            e.printStackTrace();
            return null;
        }
    }

    @PostMapping
    public String create(HttpServletRequest request,Customer customer){
        customer.setId(UUIDUtil.getUUID());
        customer.setCreateTime(DateTimeUtil.getSysTime());
        customer.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        try {
            customerService.create(customer);
            return "1";
        } catch (DaoException e) {
            e.printStackTrace();
            return "0";
        }
    }


}
