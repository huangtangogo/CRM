package com.huangliutan.crm.workbench.service;

import com.huangliutan.crm.workbench.domain.Contacts;
import com.huangliutan.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    int saveCreateCustomer(Customer customer);

    List<Customer> queryCustomerForPageByCondition(Map<String,Object> map);

    long queryCountOfCustomerByCondition(Map<String,Object> map);

    int deleteCustomerByIds(String[] id);

    Customer queryCustomerById(String id);

    int saveEditCustomer(Customer customer);

    List<Customer> queryCustomerForDetailByName(String name);

    Customer queryCustomerForDetailById(String id);

}
