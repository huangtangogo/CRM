package com.huangliutan.crm.workbench.service.impl;

import com.huangliutan.crm.workbench.domain.Activity;
import com.huangliutan.crm.workbench.mapper.ActivityMapper;
import com.huangliutan.crm.workbench.mapper.ActivityRemarkMapper;
import com.huangliutan.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("activityService")
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;
    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    @Override
    public int saveCreateActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryActivityForPageByCondition(Map<String, Object> map) {
        return activityMapper.selectActivityForPageByCondition(map);
    }

    @Override
    public long queryCountOfActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public int saveEditActivity(Activity activity) {
        return activityMapper.updateActivity(activity);
    }

    @Override
    public int deleteActivityByIds(String[] id) {
        //事务一致性，在同一个事物中进行删除市场活动备注,只要出现异常全部回滚
        activityRemarkMapper.deleteActivityRemarkByActivityId(id);
        return activityMapper.deleteActivityByIds(id);
    }

    @Override
    public List<Activity> queryAllActivityForDetail() {
        return activityMapper.selectAllActivityForDetail();
    }

    @Override
    public List<Activity> queryActivityForDetailByIds(String[] ids) {
        return activityMapper.selectActivityForDetailByIds(ids);
    }

    @Override
    public int saveCreateActivityByList(List<Activity> activityList) {
        return activityMapper.insertActivityByList(activityList);
    }

    @Override
    public Activity queryActivityForDetailById(String id) {
        return activityMapper.selectActivityForDetailById(id);
    }

    @Override
    public List<Activity> queryAllRelationActivityByClueId(String clueId) {
        return activityMapper.selectAllRelationActivityByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityForDetailByNameClueId(Map<String, Object> map) {
        return activityMapper.selectActivityForDetailByNameClueId(map);
    }

    @Override
    public List<Activity> queryActivityForDetailByName(String name) {
        return activityMapper.selectActivityForDetailByName(name);
    }

    @Override
    public List<Activity> queryContactsActivityRelationByContactsId(String contactsId) {
        return activityMapper.selectContactsActivityRelationByContactsId(contactsId);
    }

    @Override
    public List<Activity> queryActivityForDetailByNameAndContactsId(Map<String, Object> map) {
        return activityMapper.selectActivityForDetailByNameAndContactsId(map);
    }
}
