package com.huangliutan.crm.workbench.mapper;

import com.huangliutan.crm.workbench.domain.Contacts;
import com.huangliutan.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Thu Jun 04 09:31:40 CST 2020
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Thu Jun 04 09:31:40 CST 2020
     */
    int insert(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Thu Jun 04 09:31:40 CST 2020
     */
    int insertSelective(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Thu Jun 04 09:31:40 CST 2020
     */
    Customer selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Thu Jun 04 09:31:40 CST 2020
     */
    int updateByPrimaryKeySelective(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Thu Jun 04 09:31:40 CST 2020
     */
    int updateByPrimaryKey(Customer record);

    /**
     * 保存客户
     */
    int insertCustomer(Customer customer);

    /**
     * 根据条件，分页查询所有的客户
     */
    List<Customer> selectCustomerForPageByCondition(Map<String,Object> map);

    /**
     * 根据条件，查询所有的记录条数
     */
    long selectCountOfCustomerByCondition(Map<String,Object> map);

    /**
     * 批量删除客户信息
     */
    int deleteCustomerByIds(String[] id);

    /**
     * 根据id查询客户信息
     */
    Customer selectCustomerById(String id);

    /**
     * 修改客户信息
     */
    int updateCustomer(Customer customer);

    /**
     * 根据name模糊查询客户
     */
    List<Customer> selectCustomerForDetailByName(String name);

    /**
     * 根据id查询客户明细
     */
    Customer selectCustomerForDetailById(String id);

}