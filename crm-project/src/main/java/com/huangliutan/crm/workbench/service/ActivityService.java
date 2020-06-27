package com.huangliutan.crm.workbench.service;

import com.huangliutan.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    int saveCreateActivity(Activity activity);

    List<Activity> queryActivityForPageByCondition(Map<String,Object> map);

    long queryCountOfActivityByCondition(Map<String,Object> map);

    Activity queryActivityById(String id);

    int saveEditActivity(Activity activity);

    int deleteActivityByIds(String[] id);

    List<Activity> queryAllActivityForDetail();

    List<Activity> queryActivityForDetailByIds(String[] ids);

    int saveCreateActivityByList(List<Activity> activityList);

    Activity queryActivityForDetailById(String id);

    List<Activity> queryAllRelationActivityByClueId(String clueId);

    List<Activity> queryActivityForDetailByNameClueId(Map<String,Object> map);

    List<Activity> queryActivityForDetailByName(String name);

    List<Activity> queryContactsActivityRelationByContactsId(String contactsId);

    List<Activity> queryActivityForDetailByNameAndContactsId(Map<String,Object> map);
}
