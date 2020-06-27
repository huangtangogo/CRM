package com.huangliutan.crm.workbench.service.impl;

import com.huangliutan.crm.commons.utils.DateUtils;
import com.huangliutan.crm.commons.utils.UUIDUtils;
import com.huangliutan.crm.settings.domain.User;
import com.huangliutan.crm.workbench.domain.*;
import com.huangliutan.crm.workbench.mapper.*;
import com.huangliutan.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("clueService")
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private TranRemarkMapper tranRemarkMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueForPageByCondition(Map<String, Object> map) {
        return clueMapper.selectClueForPageByCondition(map);
    }

    @Override
    public long queryCountForPageByCondition(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByCondition(map);
    }

    @Override
    public int deleteClueByIds(String[] id) {
        //删除所有的备注
        clueRemarkMapper.deleteClueRemarkClueIds(id);
        //删除所有的关联市场活动
        clueActivityRelationMapper.deleteClueActivityRelationByClueIds(id);
        return clueMapper.deleteClueByIds(id);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public int saveEditClue(Clue clue) {
        return clueMapper.updateClue(clue);
    }

    @Override
    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueForDetailById(id);
    }

    @Override
    public void saveConvert(Map<String, Object> map) {//在一个service方法里面增删改，保证事务一致性
        //根据clueId查询线索中所有的信息
        String clueId = (String) map.get("clueId");
        User user = (User) map.get("user");
        Clue clue = clueMapper.selectClueForConvertById(clueId);

        //把线索中的公司信息保存到客户表中
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        customer.setAddress(clue.getAddress());
        customer.setContactSummary(clue.getContactSummary());
        customer.setCreateBy(user.getId());
        customer.setDescription(clue.getDescription());
        customer.setName(clue.getCompany());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setOwner(user.getId());
        customer.setPhone(clue.getPhone());
        customer.setWebsite(clue.getWebsite());
        customerMapper.insertCustomer(customer);

        //把线索中的个人信息保存到联系人表中
        Contacts contacts = new Contacts();
        contacts.setCustomerId(customer.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));
        contacts.setCreateBy(user.getId());
        contacts.setAddress(clue.getAddress());
        contacts.setAppellation(clue.getAppellation());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setDescription(clue.getDescription());
        contacts.setEmail(clue.getEmail());
        contacts.setFullName(clue.getFullName());
        contacts.setId(UUIDUtils.getUUID());
        contacts.setJob(clue.getJob());
        contacts.setMphone(clue.getMphone());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contactsMapper.insertContacts(contacts);

        //根据clueId查询线索中所有的备注
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkForConvertByClueId(clueId);
        List<CustomerRemark> customerRemarkList = new ArrayList<>();
        List<ContactsRemark> contactsRemarkList = new ArrayList<>();

        CustomerRemark customerRemark = null;
        ContactsRemark contactsRemark = null;
        if (clueRemarkList != null && clueRemarkList.size() > 0) {//集合判断的必须写法，避免空指针，顺序也不能弄反
            //遍历集合
            for (ClueRemark clueRemark : clueRemarkList) {
                //给客户一份线索的所有备注
                customerRemark = new CustomerRemark();
                customerRemark.setCreateBy(clueRemark.getCreateBy());
                customerRemark.setCreateTime(clueRemark.getCreateTime());
                customerRemark.setCustomerId(customer.getId());
                customerRemark.setEditBy(clueRemark.getEditBy());
                customerRemark.setEditFlag(clueRemark.getEditFlag());
                customerRemark.setEditTime(clueRemark.getEditTime());
                customerRemark.setId(UUIDUtils.getUUID());
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemarkList.add(customerRemark);

                //给联系人一份线索的所有备注
                contactsRemark = new ContactsRemark();
                contactsRemark.setContactsId(contacts.getId());
                contactsRemark.setCreateBy(clueRemark.getCreateBy());
                contactsRemark.setCreateTime(clueRemark.getCreateTime());
                contactsRemark.setEditBy(clueRemark.getEditBy());
                contactsRemark.setEditFlag(clueRemark.getEditFlag());
                contactsRemark.setEditTime(clueRemark.getEditTime());
                contactsRemark.setId(UUIDUtils.getUUID());
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemarkList.add(contactsRemark);
            }
            //批量保存客户备注
            customerRemarkMapper.insertCustomerRemarkByList(customerRemarkList);
            //批量保存联系人备注
            contactsRemarkMapper.insertContactsRemarkByList(contactsRemarkList);
        }

        //根据clueId查询所有的线索关联市场活动
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectClueActivityRelationByClueId(clueId);
        if (clueActivityRelationList != null && clueActivityRelationList.size() > 0) {
            ContactsActivityRelation contactsActivityRelation = null;
            List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();

            //遍历集合
            for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
                //给联系人一份线索关联的市场活动
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelation.setId(UUIDUtils.getUUID());
                contactsActivityRelationList.add(contactsActivityRelation);
            }
            //批量保存联系人关联市场活动
            contactsActivityRelationMapper.insertContactsActivityRelationByList(contactsActivityRelationList);
        }
        //判断是否创建交易
        String isCreateTran = (String) map.get("isCreateTran");
        if ("true".equals(isCreateTran)) {
            //接收所有的数据
            String money = (String) map.get("money");
            String name = (String) map.get("name");
            String expectedDate = (String) map.get("expectedDate");
            String stage = (String) map.get("stage");
            String activityId = (String) map.get("activityId");

            //创建交易对象
            Tran tran = new Tran();
            tran.setActivityId(activityId);
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtils.formatDateTime(new Date()));
            tran.setCustomerId(customer.getId());
            tran.setExpectedDate(expectedDate);
            tran.setId(UUIDUtils.getUUID());
            tran.setMoney(money);
            tran.setName(name);
            tran.setOwner(user.getId());
            tran.setStage(stage);
            //保存交易
            tranMapper.insertTran(tran);
            //clueId查询线索中所有的备注，将线索所有的备注转换到交易备注表中一份
            if (clueRemarkList != null && clueRemarkList.size() > 0) {
                List<TranRemark> tranRemarkList = new ArrayList<>();
                TranRemark tranRemark = null;
                //遍历线索备注
                for (ClueRemark clueRemark : clueRemarkList) {
                    //给交易一份备注
                    tranRemark = new TranRemark();
                    tranRemark.setCreateBy(clueRemark.getId());
                    tranRemark.setCreateTime(clueRemark.getCreateTime());
                    tranRemark.setEditBy(clueRemark.getEditBy());
                    tranRemark.setEditFlag(clueRemark.getEditFlag());
                    tranRemark.setEditTime(clueRemark.getEditTime());
                    tranRemark.setId(UUIDUtils.getUUID());
                    tranRemark.setNoteContent(clueRemark.getNoteContent());
                    tranRemark.setTranId(tran.getId());
                    tranRemarkList.add(tranRemark);
                }
                //保存交易备注
                tranRemarkMapper.insertTranRemarkByList(tranRemarkList);
            }
            //创建交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setTranId(tran.getId());
            tranHistory.setStage(tran.getStage());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setId(UUIDUtils.getUUID());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
            tranHistory.setCreateBy(user.getId());
            //保存交易历史
            tranHistoryMapper.insertTranHistory(tranHistory);
        }
        //删除线索所有的备注，先删子表
        clueRemarkMapper.deleteClueRemarkByClueId(clueId);
        //删除线索中关联的市场活动
        clueActivityRelationMapper.deleteClueActivityRelationByClueId(clueId);
        //删除线索
        clueMapper.deleteClueById(clueId);
    }

}
