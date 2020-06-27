package com.huangliutan.crm.workbench.service.impl;

import com.huangliutan.crm.commons.utils.DateUtils;
import com.huangliutan.crm.commons.utils.UUIDUtils;
import com.huangliutan.crm.settings.domain.User;
import com.huangliutan.crm.workbench.domain.Contacts;
import com.huangliutan.crm.workbench.domain.ContactsActivityRelation;
import com.huangliutan.crm.workbench.domain.ContactsRemark;
import com.huangliutan.crm.workbench.domain.Customer;
import com.huangliutan.crm.workbench.mapper.ContactsActivityRelationMapper;
import com.huangliutan.crm.workbench.mapper.ContactsMapper;
import com.huangliutan.crm.workbench.mapper.ContactsRemarkMapper;
import com.huangliutan.crm.workbench.mapper.CustomerMapper;
import com.huangliutan.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("contactsService")
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Override
    public void saveCreateContact(Map<String,Object> map) {//一个事务,不需要返回值，通过判断异常即可
        //因为事务是添加在service层的，所以为了保证事务一致性，在这里完成客户的添加功能,调用其他的对象mapper最合理
        //根据异常来判断最合理，返回条数不起作用
        //获取contacts对象
        Contacts contacts = (Contacts) map.get("contacts");
        User user = (User) map.get("sessionUser");
        String customerName = (String) map.get("customerName");

        //获取customerId
        String customerId = contacts.getCustomerId();

        //判断customerId是否存在,这里不一样，customerName也需要判断是不是为空
        if(customerName!=null||customerName!=""){
            if(customerId == null || customerId.trim().length()==0){//标准判断写法
                //封装Customer对象
                Customer customer = new Customer();
                customer.setOwner(user.getId());
                customer.setName(customerName);
                customer.setCreateBy(user.getId());
                customer.setCreateTime(DateUtils.formatDateTime(new Date()));
                customer.setId(UUIDUtils.getUUID());

                //保存客户
                customerMapper.insertCustomer(customer);
                //并且还有需要把客户的id告诉给联系人
                contacts.setCustomerId(customer.getId());
            }
        }

       //保存联系人
        contactsMapper.insertContacts(contacts);
    }

    @Override
    public List<Contacts> queryContactsForDetailByCustomerId(String customerId) {
        return contactsMapper.selectContactsForDetailByCustomerId(customerId);
    }

    @Override
    public int deleteContactsById(String id) {
        //删除联系人备注
        contactsRemarkMapper.deleteContactsRemarkById(id);
        //删除联系人关联市场活动
        contactsActivityRelationMapper.deleteContactsActivityRelationByContactsId(id);
        //删除联系人
        return contactsMapper.deleteContactsById(id);
    }

    @Override
    public List<Contacts> queryContactsForDetailByName(String name) {
        return contactsMapper.selectContactsForDetailByFullName(name);
    }

    @Override
    public List<Contacts> queryContactsForPageByCondition(Map<String, Object> map) {
        return contactsMapper.selectContactsForPageByCondition(map);
    }

    @Override
    public long queryCountOfContactsByCondition(Map<String, Object> map) {
        return contactsMapper.selectCountOfContactsByCondition(map);
    }

    @Override
    public Contacts queryContactsForDetailById(String id) {
        return contactsMapper.selectContactsForDetailById(id);
    }

    @Override
    public int deleteContactsByIds(String[] id) {
        //删除联系人备注
        contactsRemarkMapper.deleteContactsRemarkByContactsIds(id);
        //删除联系人关联市场活动
        contactsActivityRelationMapper.deleteContactsActivityRelationByContactsIds(id);
        //删除联系人
        return contactsMapper.deleteContactsByIds(id);
    }

    @Override
    public Contacts queryContactsById(String id) {
        return contactsMapper.selectContactsById(id);
    }

    @Override
    public int saveEditContacts(Map<String, Object> map) {
        //获取Contacts对象
        Contacts contacts = (Contacts) map.get("contacts");
        //获取user对象
        User user = (User) map.get("sessionUser");
        //获取customerName
        String customerName = (String) map.get("customerName");
        String customerId = contacts.getCustomerId();

        //判断customerId是否为空,标准写法
        //这里不一样，customerName也需要判断是不是为空
        if(customerName!=null||customerName!="") {
            if (customerId == null && customerId.trim().length() == 0) {
                //说明客户不存在，创建客户
                Customer customer = new Customer();
                customer.setCreateTime(DateUtils.formatDateTime(new Date()));
                customer.setId(UUIDUtils.getUUID());
                customer.setCreateBy(user.getId());
                customer.setName(customerName);
                customer.setOwner(user.getId());
                //保存客户
                customerMapper.insertCustomer(customer);

                //将客户的id赋值给联系人
                contacts.setCustomerId(customer.getId());
            }
        }
        //更改联系人信息
        contactsMapper.updateContacts(contacts);
        return 0;
    }
}
