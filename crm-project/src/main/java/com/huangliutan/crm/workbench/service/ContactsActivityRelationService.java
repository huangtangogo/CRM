package com.huangliutan.crm.workbench.service;

import com.huangliutan.crm.workbench.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationService {
    int saveCreateContactsActivityRelationByList(List<ContactsActivityRelation> list);

    int deleteContactsActivityRelationByContactsIdAndActivityId(ContactsActivityRelation contactsActivityRelation);
}
