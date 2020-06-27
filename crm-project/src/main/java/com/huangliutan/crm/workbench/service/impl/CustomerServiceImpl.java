package com.huangliutan.crm.workbench.service.impl;

import com.huangliutan.crm.workbench.domain.Contacts;
import com.huangliutan.crm.workbench.domain.Customer;
import com.huangliutan.crm.workbench.domain.TranRemark;
import com.huangliutan.crm.workbench.mapper.*;
import com.huangliutan.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("customerService")
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private TranRemarkMapper tranRemarkMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;


    @Override
    public int saveCreateCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }

    @Override
    public List<Customer> queryCustomerForPageByCondition(Map<String, Object> map) {
        return customerMapper.selectCustomerForPageByCondition(map);
    }

    @Override
    public long queryCountOfCustomerByCondition(Map<String, Object> map) {
        return customerMapper.selectCountOfCustomerByCondition(map);
    }

    @Override
    public int deleteCustomerByIds(String[] id) {
        //为了保证事务的一致性，涉及多个事务需要放在同一一个事务中进行，因为删除客户涉及到交易和联系人，所以需要先删除子表，避免失去外键导致垃圾数据过多
        //1.删除客户对应的所有的备注
        customerRemarkMapper.deleteCustomerRemarkByCustomerIds(id);

        //2.查询客户对应的所有的tranId
        String[] tranIds = tranMapper.selectTranIdsByCustomerIds(id);
        //System.out.println("tranId数组的长度："+tranIds.length);
        //删除之前必须先判断数组是否null和是否有值
        if(tranIds!=null && tranIds.length>0){
            //3.根据tranId删除所有对应的交易的备注
            tranRemarkMapper.deleteTranRemarkByTranIds(tranIds);
            //4.根据tranId删除所有对应的阶段历史
            tranHistoryMapper.deleteTranHistoryByTranIds(tranIds);
        }

        //5.查询客户对应的所有的contactsId
        String[] contactsIds = contactsMapper.selectContactsIdsByCustomerIds(id);
        //System.out.println("contactsIds数组的长度："+contactsIds.length);
        //删除之前必须先判断数组是否null和是否有值
        if(contactsIds!=null&&contactsIds.length>0){
            //6.根据contactsId删除对应的联系人备注
            contactsRemarkMapper.deleteContactsRemarkByContactsIds(contactsIds);
            //7.根据contactsId删除对应的联系人关联市场活动
            contactsActivityRelationMapper.deleteContactsActivityRelationByContactsIds(contactsIds);
        }

        //8.删除客户对应的联系人
        contactsMapper.deleteContactsByCustomerId(id);
        //8.删除客户对应的交易
        tranMapper.deleteTranByCustomerIds(id);

        return customerMapper.deleteCustomerByIds(id);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }

    @Override
    public int saveEditCustomer(Customer customer) {
        return customerMapper.updateCustomer(customer);
    }

    @Override
    public List<Customer> queryCustomerForDetailByName(String name) {
        return customerMapper.selectCustomerForDetailByName(name);
    }

    @Override
    public Customer queryCustomerForDetailById(String id) {
        return customerMapper.selectCustomerForDetailById(id);
    }
}
