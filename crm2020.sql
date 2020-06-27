/*
Navicat MySQL Data Transfer

Source Server         : mysql
Source Server Version : 50536
Source Host           : localhost:3306
Source Database       : crm2020

Target Server Type    : MYSQL
Target Server Version : 50536
File Encoding         : 65001

Date: 2020-06-18 01:27:50
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `tbl_activity`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_activity`;
CREATE TABLE `tbl_activity` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `start_date` char(10) DEFAULT NULL,
  `end_date` char(10) DEFAULT NULL,
  `cost` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_activity
-- ----------------------------
INSERT INTO `tbl_activity` VALUES ('1bfaf07f5a8d4445b47ee084f1d4f4e4', '40f6cdea0bd34aceb77492a1656d9fb3', '市场活动02', '2020-06-19', '2020-07-16', '9999', '描述测试01', '2020-06-17 23:15:33', '06f5fc056eac41558a964f96daa7f27c', null, null);
INSERT INTO `tbl_activity` VALUES ('a68b56dbcffc4b9dbfbb1829a14ee1c7', '06f5fc056eac41558a964f96daa7f27c', '市场活动01', '2020-06-09', '2020-06-25', '888', '市场活动描述01', '2020-06-17 23:05:07', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:06:13', '06f5fc056eac41558a964f96daa7f27c');

-- ----------------------------
-- Table structure for `tbl_activity_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_activity_remark`;
CREATE TABLE `tbl_activity_remark` (
  `id` char(32) NOT NULL,
  `note_content` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_flag` char(1) DEFAULT NULL COMMENT '0��ʾδ�޸ģ�1��ʾ���޸�',
  `activity_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_activity_remark
-- ----------------------------
INSERT INTO `tbl_activity_remark` VALUES ('5dce2d62c9734ce080d5f7d183567234', '哈哈', '2020-06-17 23:05:24', '06f5fc056eac41558a964f96daa7f27c', null, null, '0', 'a68b56dbcffc4b9dbfbb1829a14ee1c7');
INSERT INTO `tbl_activity_remark` VALUES ('cdd13aa1495f4f7c8cc02f1376d04027', '可以可以', '2020-06-17 23:06:01', '06f5fc056eac41558a964f96daa7f27c', null, null, '0', 'a68b56dbcffc4b9dbfbb1829a14ee1c7');

-- ----------------------------
-- Table structure for `tbl_clue`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue`;
CREATE TABLE `tbl_clue` (
  `id` char(32) NOT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `appellation` varchar(255) DEFAULT NULL,
  `owner` char(32) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `mphone` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contact_summary` varchar(255) DEFAULT NULL,
  `next_contact_time` char(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue
-- ----------------------------
INSERT INTO `tbl_clue` VALUES ('44fa450538764dcba232c4cef1b070a6', '黄坦', '31539e7ed8c848fc913e1c2c93d76fd1', '06f5fc056eac41558a964f96daa7f27c', 'java开发语言研究院', '实验室主管', '152345@qq.com', '0315-8888888', 'http://666.com', '15266666666', '1e0bd307e6ee425599327447f8387285', '72f13af8f5d34134b5b3f42c5d477510', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:09:09', null, null, '线索描述测试01', '联系纪要测试01', '2020-06-18', '详细地址测试01');

-- ----------------------------
-- Table structure for `tbl_clue_activity_relation`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue_activity_relation`;
CREATE TABLE `tbl_clue_activity_relation` (
  `id` char(32) NOT NULL,
  `clue_id` char(32) DEFAULT NULL,
  `activity_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue_activity_relation
-- ----------------------------
INSERT INTO `tbl_clue_activity_relation` VALUES ('5f5eb7f0f1c84c19b2ea66c046901244', '44fa450538764dcba232c4cef1b070a6', 'a68b56dbcffc4b9dbfbb1829a14ee1c7');

-- ----------------------------
-- Table structure for `tbl_clue_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue_remark`;
CREATE TABLE `tbl_clue_remark` (
  `id` char(32) NOT NULL,
  `note_content` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_flag` char(1) DEFAULT NULL,
  `clue_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue_remark
-- ----------------------------
INSERT INTO `tbl_clue_remark` VALUES ('409d4069decf4ec69c3d7f4a85af279d', '可以的老黄', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:09:28', null, null, '0', '44fa450538764dcba232c4cef1b070a6');
INSERT INTO `tbl_clue_remark` VALUES ('c512e9f176a648c4810c1a428711e6c1', '哈哈', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:09:17', null, null, '0', '44fa450538764dcba232c4cef1b070a6');

-- ----------------------------
-- Table structure for `tbl_contacts`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts`;
CREATE TABLE `tbl_contacts` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `customer_id` char(32) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `appellation` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mphone` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `birth` char(10) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contact_summary` varchar(255) DEFAULT NULL,
  `next_contact_time` char(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts
-- ----------------------------
INSERT INTO `tbl_contacts` VALUES ('631f4cb6b95947f591ed0bedf3824a47', '06f5fc056eac41558a964f96daa7f27c', 'fb65d7fdb9c6483db02713e6bc05dd19', 'e548873389f74067a40ba60e87195e2e', '小姐姐', 'e5f383d2622b4fc0959f4fe131dafc80', '12531253@qq.com', '15266333625', '助理工程师', '2020-06-16', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:13:05', null, null, '描述测试01', '联系纪要01', '2020-06-10', '深圳南山');

-- ----------------------------
-- Table structure for `tbl_contacts_activity_relation`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts_activity_relation`;
CREATE TABLE `tbl_contacts_activity_relation` (
  `id` char(32) NOT NULL,
  `contacts_id` char(32) DEFAULT NULL,
  `activity_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts_activity_relation
-- ----------------------------
INSERT INTO `tbl_contacts_activity_relation` VALUES ('67da98167d624d2897d2ab85c83fabc7', '631f4cb6b95947f591ed0bedf3824a47', '1bfaf07f5a8d4445b47ee084f1d4f4e4');

-- ----------------------------
-- Table structure for `tbl_contacts_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts_remark`;
CREATE TABLE `tbl_contacts_remark` (
  `id` char(32) NOT NULL,
  `note_content` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_flag` char(1) DEFAULT NULL,
  `contacts_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts_remark
-- ----------------------------
INSERT INTO `tbl_contacts_remark` VALUES ('1f6178bc0ad4405e87bc91ee68c8d77d', '哎呀', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:14:54', null, null, '0', '631f4cb6b95947f591ed0bedf3824a47');
INSERT INTO `tbl_contacts_remark` VALUES ('faeb5eb888964c50bf6a6e77804578b9', '开心', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:14:59', null, null, '0', '631f4cb6b95947f591ed0bedf3824a47');

-- ----------------------------
-- Table structure for `tbl_customer`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_customer`;
CREATE TABLE `tbl_customer` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `contact_summary` varchar(255) DEFAULT NULL,
  `next_contact_time` char(10) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_customer
-- ----------------------------
INSERT INTO `tbl_customer` VALUES ('4c86756f47bf4b2e8927258de330933a', '06f5fc056eac41558a964f96daa7f27c', '晶准生物医学', 'http://www.baidu.com', '321-0231666', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:31:01', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:48:39', '藐视', '2020-06-10', '藐视', '广西');
INSERT INTO `tbl_customer` VALUES ('e548873389f74067a40ba60e87195e2e', '06f5fc056eac41558a964f96daa7f27c', 'java开发国际合作中心', 'http://www.baidu.com', '0315-66666666', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:11:36', null, null, '联系纪要测试01', '2020-06-20', '描述测试01', '广西河池都安');

-- ----------------------------
-- Table structure for `tbl_customer_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_customer_remark`;
CREATE TABLE `tbl_customer_remark` (
  `id` char(32) NOT NULL,
  `note_content` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_flag` char(1) DEFAULT NULL,
  `customer_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_customer_remark
-- ----------------------------
INSERT INTO `tbl_customer_remark` VALUES ('437f089f0fb34cf797e221f172b22c8c', '可以的，好好搬砖，老黄', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:11:51', null, null, '0', 'e548873389f74067a40ba60e87195e2e');
INSERT INTO `tbl_customer_remark` VALUES ('66f48e21c0e84e85b58473feff1eb971', '这里也可惜可惜', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:32:15', null, null, '0', '4c86756f47bf4b2e8927258de330933a');
INSERT INTO `tbl_customer_remark` VALUES ('7f8f77bab67f421abbee2ed1610160df', '真棒', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:48:52', null, null, '0', '4c86756f47bf4b2e8927258de330933a');

-- ----------------------------
-- Table structure for `tbl_dic_type`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_type`;
CREATE TABLE `tbl_dic_type` (
  `code` varchar(255) NOT NULL COMMENT '����������������Ϊ�գ����ܺ������ġ�',
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_dic_type
-- ----------------------------
INSERT INTO `tbl_dic_type` VALUES ('appellation', '称呼', '');
INSERT INTO `tbl_dic_type` VALUES ('clueState', '线索状态', '');
INSERT INTO `tbl_dic_type` VALUES ('returnPriority', '回访优先级', '');
INSERT INTO `tbl_dic_type` VALUES ('returnState', '回访状态', '');
INSERT INTO `tbl_dic_type` VALUES ('source', '来源', '');
INSERT INTO `tbl_dic_type` VALUES ('stage', '阶段', '');
INSERT INTO `tbl_dic_type` VALUES ('transactionType', '交易类型', '');

-- ----------------------------
-- Table structure for `tbl_dic_value`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_value`;
CREATE TABLE `tbl_dic_value` (
  `id` char(32) NOT NULL COMMENT '����������UUID',
  `value` varchar(255) DEFAULT NULL COMMENT '����Ϊ�գ�����Ҫ��ͬһ���ֵ��������ֵ�ֵ�����ظ�������Ψһ�ԡ�',
  `text` varchar(255) DEFAULT NULL COMMENT '����Ϊ��',
  `order_no` varchar(255) DEFAULT NULL COMMENT '����Ϊ�գ�����Ϊ�յ�ʱ��Ҫ�������������',
  `type_code` varchar(255) DEFAULT NULL COMMENT '���',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_dic_value
-- ----------------------------
INSERT INTO `tbl_dic_value` VALUES ('06e3cbdf10a44eca8511dddfc6896c55', '虚假线索', '虚假线索', '4', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('0fe33840c6d84bf78df55d49b169a894', '销售邮件', '销售邮件', '8', 'source');
INSERT INTO `tbl_dic_value` VALUES ('12302fd42bd349c1bb768b19600e6b20', '交易会', '交易会', '11', 'source');
INSERT INTO `tbl_dic_value` VALUES ('1615f0bb3e604552a86cde9a2ad45bea', '最高', '最高', '2', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('176039d2a90e4b1a81c5ab8707268636', '教授', '教授', '5', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('1e0bd307e6ee425599327447f8387285', '将来联系', '将来联系', '2', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2173663b40b949ce928db92607b5fe57', '丢失线索', '丢失线索', '5', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2876690b7e744333b7f1867102f91153', '未启动', '未启动', '1', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('29805c804dd94974b568cfc9017b2e4c', '07成交', '07成交', '7', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('310e6a49bd8a4962b3f95a1d92eb76f4', '试图联系', '试图联系', '1', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('31539e7ed8c848fc913e1c2c93d76fd1', '博士', '博士', '4', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('37ef211719134b009e10b7108194cf46', '01资质审查', '01资质审查', '1', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('391807b5324d4f16bd58c882750ee632', '08丢失的线索', '08丢失的线索', '8', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('3a39605d67da48f2a3ef52e19d243953', '聊天', '聊天', '14', 'source');
INSERT INTO `tbl_dic_value` VALUES ('474ab93e2e114816abf3ffc596b19131', '低', '低', '3', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('48512bfed26145d4a38d3616e2d2cf79', '广告', '广告', '1', 'source');
INSERT INTO `tbl_dic_value` VALUES ('4d03a42898684135809d380597ed3268', '合作伙伴研讨会', '合作伙伴研讨会', '9', 'source');
INSERT INTO `tbl_dic_value` VALUES ('59795c49896947e1ab61b7312bd0597c', '先生', '先生', '1', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('5c6e9e10ca414bd499c07b886f86202a', '高', '高', '1', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('67165c27076e4c8599f42de57850e39c', '夫人', '夫人', '2', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('68a1b1e814d5497a999b8f1298ace62b', '09因竞争丢失关闭', '09因竞争丢失关闭', '9', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('6b86f215e69f4dbd8a2daa22efccf0cf', 'web调研', 'web调研', '13', 'source');
INSERT INTO `tbl_dic_value` VALUES ('72f13af8f5d34134b5b3f42c5d477510', '合作伙伴', '合作伙伴', '6', 'source');
INSERT INTO `tbl_dic_value` VALUES ('7c07db3146794c60bf975749952176df', '未联系', '未联系', '6', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('86c56aca9eef49058145ec20d5466c17', '内部研讨会', '内部研讨会', '10', 'source');
INSERT INTO `tbl_dic_value` VALUES ('9095bda1f9c34f098d5b92fb870eba17', '进行中', '进行中', '3', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('954b410341e7433faa468d3c4f7cf0d2', '已有业务', '已有业务', '1', 'transactionType');
INSERT INTO `tbl_dic_value` VALUES ('966170ead6fa481284b7d21f90364984', '已联系', '已联系', '3', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('96b03f65dec748caa3f0b6284b19ef2f', '推迟', '推迟', '2', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('97d1128f70294f0aac49e996ced28c8a', '新业务', '新业务', '2', 'transactionType');
INSERT INTO `tbl_dic_value` VALUES ('9ca96290352c40688de6596596565c12', '完成', '完成', '4', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('9e6d6e15232549af853e22e703f3e015', '需要条件', '需要条件', '7', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('9ff57750fac04f15b10ce1bbb5bb8bab', '02需求分析', '02需求分析', '2', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('a70dc4b4523040c696f4421462be8b2f', '等待某人', '等待某人', '5', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('a83e75ced129421dbf11fab1f05cf8b4', '推销电话', '推销电话', '2', 'source');
INSERT INTO `tbl_dic_value` VALUES ('ab8472aab5de4ae9b388b2f1409441c1', '常规', '常规', '5', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('ab8c2a3dc05f4e3dbc7a0405f721b040', '05提案/报价', '05提案/报价', '5', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('b924d911426f4bc5ae3876038bc7e0ad', 'web下载', 'web下载', '12', 'source');
INSERT INTO `tbl_dic_value` VALUES ('c13ad8f9e2f74d5aa84697bb243be3bb', '03价值建议', '03价值建议', '3', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('c83c0be184bc40708fd7b361b6f36345', '最低', '最低', '4', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('db867ea866bc44678ac20c8a4a8bfefb', '员工介绍', '员工介绍', '3', 'source');
INSERT INTO `tbl_dic_value` VALUES ('e44be1d99158476e8e44778ed36f4355', '04确定决策者', '04确定决策者', '4', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('e5f383d2622b4fc0959f4fe131dafc80', '女士', '女士', '3', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('e81577d9458f4e4192a44650a3a3692b', '06谈判/复审', '06谈判/复审', '6', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('fb65d7fdb9c6483db02713e6bc05dd19', '在线商场', '在线商场', '5', 'source');
INSERT INTO `tbl_dic_value` VALUES ('fd677cc3b5d047d994e16f6ece4d3d45', '公开媒介', '公开媒介', '7', 'source');
INSERT INTO `tbl_dic_value` VALUES ('ff802a03ccea4ded8731427055681d48', '外部介绍', '外部介绍', '4', 'source');

-- ----------------------------
-- Table structure for `tbl_tran`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran`;
CREATE TABLE `tbl_tran` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `expected_date` char(10) DEFAULT NULL,
  `customer_id` char(32) DEFAULT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `possibility` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `activity_id` char(32) DEFAULT NULL,
  `contacts_id` char(32) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contact_summary` varchar(255) DEFAULT NULL,
  `next_contact_time` char(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran
-- ----------------------------
INSERT INTO `tbl_tran` VALUES ('67bbf08187ef4721828a01fdfe0f1a55', '06f5fc056eac41558a964f96daa7f27c', '8888', '好大的交易哦', '2020-11-10', 'e548873389f74067a40ba60e87195e2e', 'ab8c2a3dc05f4e3dbc7a0405f721b040', '70', '97d1128f70294f0aac49e996ced28c8a', 'fd677cc3b5d047d994e16f6ece4d3d45', 'a68b56dbcffc4b9dbfbb1829a14ee1c7', '631f4cb6b95947f591ed0bedf3824a47', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:14:18', null, null, '描述01', '联系纪要01', '2020-06-18');
INSERT INTO `tbl_tran` VALUES ('e0d2be29eb0540e9917875b11173efaa', '06f5fc056eac41558a964f96daa7f27c', '5888966', 'CTC100', '2020-07-15', '4c86756f47bf4b2e8927258de330933a', '391807b5324d4f16bd58c882750ee632', '0', '97d1128f70294f0aac49e996ced28c8a', 'db867ea866bc44678ac20c8a4a8bfefb', '', '', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:31:01', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:31:25', '描述01', '联系纪要01', '2020-06-19');

-- ----------------------------
-- Table structure for `tbl_tran_history`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran_history`;
CREATE TABLE `tbl_tran_history` (
  `id` char(32) NOT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL,
  `expected_date` char(10) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `tran_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran_history
-- ----------------------------
INSERT INTO `tbl_tran_history` VALUES ('53277635aba140b1aae49ce2f4989fe9', '391807b5324d4f16bd58c882750ee632', '5888966', '2020-07-15', '2020-06-17 23:31:25', '06f5fc056eac41558a964f96daa7f27c', 'e0d2be29eb0540e9917875b11173efaa');
INSERT INTO `tbl_tran_history` VALUES ('86cdb436e63d46a19d96c5fa509f3063', 'ab8c2a3dc05f4e3dbc7a0405f721b040', '5888966', '2020-07-15', '2020-06-17 23:31:01', '06f5fc056eac41558a964f96daa7f27c', 'e0d2be29eb0540e9917875b11173efaa');
INSERT INTO `tbl_tran_history` VALUES ('c91633e5fbba41bd97b71975e48a07b2', 'ab8c2a3dc05f4e3dbc7a0405f721b040', '8888', '2020-11-10', '2020-06-17 23:14:18', '06f5fc056eac41558a964f96daa7f27c', '67bbf08187ef4721828a01fdfe0f1a55');

-- ----------------------------
-- Table structure for `tbl_tran_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran_remark`;
CREATE TABLE `tbl_tran_remark` (
  `id` char(32) NOT NULL,
  `note_content` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_flag` char(1) DEFAULT NULL,
  `tran_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran_remark
-- ----------------------------
INSERT INTO `tbl_tran_remark` VALUES ('359babbb48f0437c91d6efb561f47608', '咔咔', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:31:14', null, null, '0', 'e0d2be29eb0540e9917875b11173efaa');
INSERT INTO `tbl_tran_remark` VALUES ('56def0af37084bfd8aa6c4fe21fd4188', '可以的', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:14:32', null, null, '0', '67bbf08187ef4721828a01fdfe0f1a55');
INSERT INTO `tbl_tran_remark` VALUES ('9793b932388d4a8db347e8febe13df05', '可惜可惜', '06f5fc056eac41558a964f96daa7f27c', '2020-06-17 23:31:38', null, null, '0', 'e0d2be29eb0540e9917875b11173efaa');

-- ----------------------------
-- Table structure for `tbl_user`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_user`;
CREATE TABLE `tbl_user` (
  `id` char(32) NOT NULL COMMENT 'uuid\r\n            ',
  `login_act` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `login_pwd` varchar(255) DEFAULT NULL COMMENT '���벻�ܲ������Ĵ洢���������ģ�MD5����֮�������',
  `email` varchar(255) DEFAULT NULL,
  `expire_time` char(19) DEFAULT NULL COMMENT 'ʧЧʱ��Ϊ�յ�ʱ���ʾ����ʧЧ��ʧЧʱ��Ϊ2018-10-10 10:10:10�����ʾ�ڸ�ʱ��֮ǰ���˻����á�',
  `lock_state` char(1) DEFAULT NULL COMMENT '����״̬Ϊ��ʱ��ʾ���ã�Ϊ0ʱ��ʾ������Ϊ1ʱ��ʾ���á�',
  `dept_no` char(4) DEFAULT NULL,
  `allow_ips` varchar(255) DEFAULT NULL COMMENT '������ʵ�IPΪ��ʱ��ʾIP��ַ�������ޣ�������ʵ�IP������һ����Ҳ�����Ƕ���������IP��ַ��ʱ�򣬲��ð�Ƕ��ŷָ������IP��192.168.100.2����ʾ���û�ֻ����IP��ַΪ192.168.100.2�Ļ�����ʹ�á�',
  `create_time` char(19) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_user
-- ----------------------------
INSERT INTO `tbl_user` VALUES ('06f5fc056eac41558a964f96daa7f27c', 'hlt', '黄流坦', '666', 'hlt@163.com', '2020-11-27 21:50:05', '1', 'A001', '192.168.1.1,0:0:0:0:0:0:0:1', '2018-11-22 12:11:40', '李四', null, null);
INSERT INTO `tbl_user` VALUES ('40f6cdea0bd34aceb77492a1656d9fb3', 'hfh', '黄飞鸿', '666', 'hfh@qq.com', '2020-11-30 23:50:55', '1', 'A001', '192.168.1.1,0:0:0:0:0:0:0:1', '2018-11-22 11:37:34', '张三', null, null);
