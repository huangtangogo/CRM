package com.huangliutan.crm.workbench.service.impl;

import com.huangliutan.crm.workbench.domain.ContactsRemark;
import com.huangliutan.crm.workbench.mapper.ContactsRemarkMapper;
import com.huangliutan.crm.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("contactsRemarkService")
public class ContactsRemarkServiceImpl implements ContactsRemarkService {
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Override
    public List<ContactsRemark> queryContactsRemarkByContactsId(String contactsId) {
        return contactsRemarkMapper.selectContactsRemarkByContactsId(contactsId);
    }

    @Override
    public int saveCreateContactsRemark(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.insertContactsRemark(contactsRemark);
    }

    @Override
    public int deleteContactsRemarkById(String id) {
        return contactsRemarkMapper.deleteContactsRemarkById(id);
    }

    @Override
    public int saveEditContactsRemark(ContactsRemark remark) {
        return contactsRemarkMapper.updateContactsRemark(remark);
    }
}
