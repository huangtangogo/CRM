package com.huangliutan.crm.settings.service.impl;

import com.huangliutan.crm.settings.domain.User;
import com.huangliutan.crm.settings.mapper.UserMapper;
import com.huangliutan.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("userService")
public class UserServiceImpl implements UserService {
    /**
     * 使用框架ioc技术提供的注解Autowired赋值
     */
    @Autowired
    private UserMapper userMapper;

    /**
     * 该方法是调用mapper层方法查询用户
     * @param map map参数
     * @return 返回用户对象
     */
    @Override
    public User queryUserByLoginActAndPwd(Map<String, Object> map) {
        return userMapper.selectUserByLoginActAndPwd(map);
    }

    @Override
    public List<User> queryAllUsers() {
        return userMapper.selectAllUsers();
    }
}
