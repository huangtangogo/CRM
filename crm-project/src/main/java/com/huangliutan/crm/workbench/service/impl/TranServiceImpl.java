package com.huangliutan.crm.workbench.service.impl;

import com.huangliutan.crm.commons.utils.DateUtils;
import com.huangliutan.crm.commons.utils.UUIDUtils;
import com.huangliutan.crm.settings.domain.User;
import com.huangliutan.crm.workbench.domain.*;
import com.huangliutan.crm.workbench.mapper.CustomerMapper;
import com.huangliutan.crm.workbench.mapper.TranHistoryMapper;
import com.huangliutan.crm.workbench.mapper.TranMapper;
import com.huangliutan.crm.workbench.mapper.TranRemarkMapper;
import com.huangliutan.crm.workbench.service.TranService;
import org.apache.poi.ss.usermodel.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("tranService")
public class TranServiceImpl implements TranService {
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;
    @Autowired
    private TranRemarkMapper tranRemarkMapper;


    @Override
    public List<Tran> queryTranForDetailByCustomerId(String customerId) {
        return tranMapper.selectTranForDetailByCustomerId(customerId);
    }

    @Override
    public int deleteTranById(String id) {
        //删除交易备注
        tranRemarkMapper.deleteTranRemarkByTranId(id);
        //删除交易历史
        tranHistoryMapper.deleteTranHistoryByTranId(id);
        return tranMapper.deleteTranById(id);
    }

    @Override
    public int saveCreateTran(Map<String, Object> map) {
        //获取Tran对象
        Tran tran = (Tran) map.get("tran");
        //获取customerId
        String customerId = tran.getCustomerId();
        //获取客户名字
        String customerName = (String) map.get("customerName");
        //过去User
        User user = (User) map.get("sessionUser");

        //判断客户是否存在,不存在则新建
        if(customerId ==null || customerId.trim().length()==0){//标准的判断
            Customer customer = new Customer();
            //封装参数
            customer.setId(UUIDUtils.getUUID());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customer.setCreateBy(user.getId());
            customer.setName(customerName);
            customer.setOwner(user.getId());
            //保存客户信息
            customerMapper.insertCustomer(customer);

            //将customerId赋值给交易对象
            tran.setCustomerId(customer.getId());

        }
        //保存交易
        tranMapper.insertTran(tran);

        //创建交易历史对象
        TranHistory tranHistory = new TranHistory();
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranId(tran.getId());
        //保存交易对象
        tranHistoryMapper.insertTranHistory(tranHistory);

        return 0;
    }

    @Override
    public List<Tran> queryTranForPageByCondition(Map<String, Object> map) {
        return tranMapper.selectTranForPageByCondition(map);
    }

    @Override
    public long queryCountOfTranByCondition(Map<String, Object> map) {
        return tranMapper.selectCountOfTranByCondition(map);
    }

    @Override
    public Tran queryTranForDetailById(String id) {

        return tranMapper.selectTranForDetailById(id);
    }

    @Override
    public int deleteTranByIds(String[] ids) {
        //删除交易备注
        tranRemarkMapper.deleteTranRemarkByTranIds(ids);
        //删除交易历史
        tranHistoryMapper.deleteTranHistoryByTranIds(ids);
        //删除交易
        tranMapper.deleteTranByIds(ids);
        return 0;
    }

    @Override
    public List<FunnelVo> queryCountOfTranGroupByStage() {
        return tranMapper.selectCountOfTranGroupByStage();
    }

    @Override
    public Tran queryTranById(String id) {
        return tranMapper.selectTranById(id);
    }

    @Override
    public int saveEditTran(Map<String,Object> map) {
        //获取Tran
        Tran tran = (Tran) map.get("tran");
        //获取User
        User user = (User) map.get("sessionUser");

        //创建交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranId(tran.getId());
        tranHistory.setMoney(tran.getMoney());
        //保存交易历史
        tranHistoryMapper.insertTranHistory(tranHistory);

        //更新交易
        tranMapper.updateTran(tran);
        return 0;
    }

    @Override
    public List<Tran> queryTranOfContactsByContactsId(String contactsId) {
        return tranMapper.selectTranOfContactsByContactsId(contactsId);
    }
}
