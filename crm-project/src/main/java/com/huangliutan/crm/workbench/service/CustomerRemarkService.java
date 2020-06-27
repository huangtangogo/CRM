package com.huangliutan.crm.workbench.service;

import com.huangliutan.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkService {
    List<CustomerRemark> queryCustomerRemarkForDetailByCustomerId(String customerId);

    int saveCreateCustomerRemark(CustomerRemark customerRemark);

    int deleteCustomerRemarkById(String id);

    int updateCustomerRemark(CustomerRemark customerRemark);
}
