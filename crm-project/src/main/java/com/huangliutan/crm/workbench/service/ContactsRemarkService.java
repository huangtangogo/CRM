package com.huangliutan.crm.workbench.service;

import com.huangliutan.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkService {
    List<ContactsRemark> queryContactsRemarkByContactsId(String contactsId);

    int saveCreateContactsRemark(ContactsRemark contactsRemark);

    int deleteContactsRemarkById(String id);

    int saveEditContactsRemark(ContactsRemark remark);
}
