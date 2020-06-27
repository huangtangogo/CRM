package com.huangliutan.crm.workbench.service;

import com.huangliutan.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {
    void saveCreateContact(Map<String,Object> map) throws Exception;

    List<Contacts> queryContactsForDetailByCustomerId(String customerId);

    int deleteContactsById(String id);

    List<Contacts> queryContactsForDetailByName(String name);

    List<Contacts> queryContactsForPageByCondition(Map<String,Object> map);

    long queryCountOfContactsByCondition(Map<String,Object> map);

    Contacts queryContactsForDetailById(String id);

    int deleteContactsByIds(String[] id);

    Contacts queryContactsById(String id);

    int saveEditContacts(Map<String,Object> map);

}
