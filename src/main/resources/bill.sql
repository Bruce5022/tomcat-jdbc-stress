-- --------------------------------------------------------
-- ---               编码规则(只用来管单据号的数字部分)         -------
-- --------------------------------------------------------
DROP TABLE IF EXISTS bill_code_rule;
create table bill_code_rule
(
	`id` VARCHAR(64) PRIMARY KEY,
	`busi_code` VARCHAR(16) UNSIGNED COMMENT '功能编码: 票据定义:DF 票据:BL 模板映射:TP 批次表:BT 票据发放:PO 机构入库:ON 机构出库:OT 用户入库:UN 用户出库:UT 票据退回:BK',
  `current_val` INT(16) COMMENT '当前值',
  `pattern` VARCHAR(64) COMMENT '默认格式:yyyyMMdd',
  `busidate` VARCHAR(64) COMMENT '19990704',
  `num_len` INT(2) COMMENT '数字部分长度,默认为4'
) COMMENT '票据信息定义表';

-- --------------------------------------------------------
-- ---               票据定义表（票据通用的定义信息）         -------
-- --------------------------------------------------------
DROP TABLE IF EXISTS bill_define;
create table bill_define
(
	`id` VARCHAR(64) PRIMARY KEY,
	`org_id` INT(11) NOT NULL COMMENT '机构ID',
	`name` VARCHAR(64) COMMENT '票据名称',
	`bill_type` INT(1) UNSIGNED COMMENT '票据业务类型: 0:门诊收费 1:住院收费 3:商城收费',
	`max_code` VARCHAR(64) NOT NULL DEFAULT '' COMMENT '最大票据号，自动生成才赋值',
	`is_auto_generate` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '票据号是否自动生成 0：手动输入 1：自动生成',
	`prefix` VARCHAR(5) NOT NULL DEFAULT '' COMMENT '票据号前缀，5长度，大小写字母、整数',
	`suffix` VARCHAR(5) NOT NULL DEFAULT '' COMMENT '票据号后缀，5长度，大小写字母、整数',
	`is_show_prefix` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否显示前缀 0：否 1：是',
	`is_show_suffix` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否显示后缀 0：否 1：是',
	`is_invoice` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否是发票 0：否 1：是',
	`is_allow_express` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否允许邮寄发票 0：不允许 1：允许',
	`is_allow_print_again` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否允许重新打印 0：不允许 1：允许',
	`is_allow_print_new` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否允许补打印 0：不允许 1：允许',
	`is_allow_multi_template` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否支持多种打印模板 0：不允许 1：允许',
	`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
	`create_by` VARCHAR(64) DEFAULT NULL COMMENT '创建人',
	`update_time` DATETIME COMMENT '修改时间',
	`update_by` VARCHAR(64) DEFAULT NULL COMMENT '修改人',
	`is_delete` TINYINT(1) UNSIGNED DEFAULT 0 COMMENT '0:正常 1:删除',
	`remark`  VARCHAR(200) DEFAULT NULL COMMENT '备注'
) COMMENT '票据信息定义表';





-- --------------------------------------------------------
-- ---               票据表（票据记录表）         -------
-- --------------------------------------------------------
DROP TABLE IF EXISTS bill;
create table bill
(
	`id` VARCHAR(64) PRIMARY KEY COMMENT '主键ID',
	`define_id` VARCHAR(64) NOT NULL COMMENT '票据定义ID',
	`code` VARCHAR(64) NOT NULL COMMENT '票据编码',
	`source_id` INT(1) NOT NULL COMMENT '使用单据id',
	`print_status` INT(1) NOT NULL DEFAULT 0 COMMENT '打印状态：0 打印  1 重打 2 补打',
	`bill_type` INT(1) NOT NULL DEFAULT 0 COMMENT '票据类型：0 正票  1 废票',
	`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
	`create_by` VARCHAR(64) DEFAULT NULL COMMENT '创建人',
	`update_time` DATETIME COMMENT '修改时间',
	`update_by` VARCHAR(64) DEFAULT NULL COMMENT '修改人',
	`is_delete` TINYINT(1) UNSIGNED DEFAULT 0 COMMENT '0 正常 1删除',
	`remark`  VARCHAR(200) DEFAULT NULL COMMENT '备注'
) COMMENT '票据信息定义表';


-- --------------------------------------------------------
-- ---              票据可打印模板映射表               -------
-- --------------------------------------------------------
DROP TABLE IF EXISTS bill_template;
create table bill_template
(
	`id` VARCHAR(64) PRIMARY KEY,
	`code` VARCHAR(64) NOT NULL COMMENT '编码',
	`define_id` VARCHAR(64) NOT NULL COMMENT '票据种类id',
	`business_id` VARCHAR(64) NOT NULL unique COMMENT '业务id',
	`template_id` VARCHAR(64) NOT NULL unique COMMENT '打印模板id',
	`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
	`create_by` VARCHAR(64) DEFAULT NULL COMMENT '创建人'
) COMMENT '票据可打印模板映射表';


-- --------------------------------------------------------
-- ---                   机构票据入库批次表            -------
-- ---         																			-------
-- --------------------------------------------------------
DROP TABLE IF EXISTS bill_batch;
create table bill_batch
(
	`id` VARCHAR(64) PRIMARY KEY,
	`code` INT UNSIGNED NOT NULL COMMENT '批次号',
	`qty` INT(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '本批次入库数量',
	`create_by` VARCHAR(64) NOT NULL COMMENT '发放人id',
	`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '机构票据入库记录表';


-- ----------------------------------------------------------------------
-- ---               票据快速发放记录表（按渠道来源划分）     			    -------
-- ---          （同等级的还有：采购表、退回表、通用入库表等）           -------
-- ----------------------------------------------------------------------
DROP TABLE IF EXISTS bill_org_provide;
create table bill_org_provide
(
	`id` VARCHAR(64) PRIMARY KEY,
	`code` VARCHAR(64) NOT NULL COMMENT '编码',
	`define_id` VARCHAR(64) NOT NULL COMMENT '票据种类id',
	`org_id` INT(11) NOT NULL COMMENT '医疗机构ID',
	`useable_qty` INT(10) default 0 comment '可分配库存数量快照',
	`hope_provide_qty` INT(10) default 0 comment '希望发放数量',
	`real_provide_qty` INT(10) default 0 comment '实际发放数量 = 希望发放数量 - 可分配库存数量快照',
	`start_num` VARCHAR(64) DEFAULT '' COMMENT '票号范围起',
	`end_num` VARCHAR(64) DEFAULT '' COMMENT '票号范围止',
	`apply_user_id` VARCHAR(64) NOT NULL COMMENT '申领人id',
	`create_by` VARCHAR(64) DEFAULT NULL COMMENT '创建人',
	`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'

) COMMENT '票据快速发放记录表';


-- ------------------------------------------------------------------------------
-- ---                      	  机构票据入库记录表                	          -------
-- ---          （票据采购、发放、退票、通用入库等多渠道来源生成）                -------
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS bill_org_in_record;
create table bill_org_in_record
(
	`id` VARCHAR(64) PRIMARY KEY,
	`code` VARCHAR(64) NOT NULL COMMENT '编码',
	`org_id` INT(11) NOT NULL COMMENT '机构ID',
	`bill_id` VARCHAR(64) NOT NULL COMMENT '票据id',
	`batch_id` VARCHAR(64) NOT NULL COMMENT '批次id',
	`source_id` VARCHAR(64) NOT NULL COMMENT '票据来源表记录id',
	`come_from` INT(1) NOT NULL DEFAULT 0 COMMENT '数据来源：0：采购进货 1:发放新增  2：领用退回 3：通用入库',
	`create_by` VARCHAR(64) NOT NULL COMMENT '发放人id',
	`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '机构票据入库记录表';


-- ------------------------------------------------------------------------
-- ---                      		机构票据实际库存表                			-------
-- ---                         （源自：票据入库表）   				          -------
-- ------------------------------------------------------------------------
DROP TABLE IF EXISTS bill_org_real_store;
create table bill_org_real_store
(
	`id` VARCHAR(64) PRIMARY KEY,
	`org_id` INT(11) NOT NULL COMMENT '机构ID',
	`bill_id` VARCHAR(64) NOT NULL COMMENT '票据id',
	`batch_id` VARCHAR(64) NOT NULL COMMENT '批次id',
	`source_id` VARCHAR(64) NOT NULL COMMENT '入库记录id',
	`create_by` VARCHAR(64) NOT NULL COMMENT '发放人id',
	`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '机构票据实际库存表';



-- ------------------------------------------------------------------------
-- ---                      		机构票据出库记录表                			-------
-- ---                         （源自：实际库存表）   				          -------
-- ------------------------------------------------------------------------
DROP TABLE IF EXISTS bill_org_out_record;
create table bill_org_out_record
(
	`id` VARCHAR(64) PRIMARY KEY,
	`code` VARCHAR(64) NOT NULL COMMENT '编码',
	`org_id` INT(11) NOT NULL COMMENT '机构ID',
	`bill_id` VARCHAR(64) NOT NULL COMMENT '票据id',
	`batch_id` VARCHAR(64) NOT NULL COMMENT '批次id',
	`source_id` VARCHAR(64) NOT NULL COMMENT '源单id',
	`owner_id` VARCHAR(64) NOT NULL COMMENT '拥有人id',
	`come_from` INT(1) NOT NULL DEFAULT 0 COMMENT '数据来源：0：采购退货 1:票据发放  2：领用申请 3：通用出库',
	`create_by` VARCHAR(64) NOT NULL COMMENT '发放人id',
	`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '机构票据出库记录表';







-- -------------------------------------------------------------------------
-- ---                      		用户票据入库记录表                			 -------
-- ---                          源自：实际库存表）   				           -------
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS bill_user_in_record;
create table bill_user_in_record
(
	`id` VARCHAR(64) PRIMARY KEY,
	`code` VARCHAR(64) NOT NULL COMMENT '编码',
	`org_id` INT(11) NOT NULL COMMENT '机构ID',
	`bill_id` VARCHAR(64) NOT NULL COMMENT '票据id',
	`batch_id` VARCHAR(64) NOT NULL COMMENT '批次id',
	`source_id` VARCHAR(64) NOT NULL COMMENT '源单id',
	`owner_id` VARCHAR(64) NOT NULL COMMENT '申领人id',
	`come_from` INT(1) NOT NULL DEFAULT 0 COMMENT '数据来源：0:发放到货  1：领用到货 2：通用入库',
	`create_by` VARCHAR(64)  NOT NULL COMMENT '发放人id',
	`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '用户票据入库记录表';





-- -------------------------------------------------------------------
-- ---                      		用户票据实际库存表                -------
-- ---                         （源自：票据入库表）   				     -------
-- -------------------------------------------------------------------
DROP TABLE IF EXISTS bill_user_real_store;
create table bill_user_real_store
(
	`id` VARCHAR(64) PRIMARY KEY,
	`org_id` INT(11) NOT NULL COMMENT '机构ID',
	`bill_id` VARCHAR(64) NOT NULL COMMENT '票据id',
	`batch_id` VARCHAR(64) NOT NULL COMMENT '批次id',
	`source_id` VARCHAR(64) NOT NULL COMMENT '入库记录id',
	`owner_id` VARCHAR(64) NOT NULL COMMENT '申领人id',
	`create_by` VARCHAR(64) NOT NULL COMMENT '发放人id',
	`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '用户票据实际库存表';



-- -------------------------------------------------------------------
-- ---                      		用户票据消耗表                		 -------
-- ---                         （源自：票据入库表）   				     -------
-- -------------------------------------------------------------------
DROP TABLE IF EXISTS bill_user_out_record;
create table bill_user_out_record
(
	`id` VARCHAR(64) PRIMARY KEY,
	`org_id` INT(11) NOT NULL COMMENT '机构ID',
	`bill_id` VARCHAR(64) NOT NULL COMMENT '票据id',
	`batch_id` VARCHAR(64) NOT NULL COMMENT '批次id',
	`source_id` VARCHAR(64) NOT NULL COMMENT '库存表id',
	`user_id` VARCHAR(64) NOT NULL COMMENT '使用人id',
	`business_id` VARCHAR(64) NOT NULL COMMENT '请求业务（结算单）id',
	`request_type` INT(1) NOT NULL DEFAULT 0 COMMENT '请求类型：0 打印  1 重打 2 补打 3 作废 4 退票',
	`come_from` INT(1) NOT NULL DEFAULT 0 COMMENT '数据来源：0 门诊发票 1 住院发票 3 商城发票',
	`create_by` VARCHAR(64) NOT NULL COMMENT '创建（请求）人id',
	`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建（请求）时间'
) COMMENT '用户票据消耗表';




-- -------------------------------------------------------------------
-- ---                      		票据退回表                		   -------
-- ---                         （源自：用户票据使用表）   				 -------
-- -------------------------------------------------------------------
DROP TABLE IF EXISTS bill_give_back;
create table bill_give_back
(
	`id` VARCHAR(64) PRIMARY KEY,
	`org_id` INT(11) NOT NULL COMMENT '机构ID',
	`bill_id` VARCHAR(64) NOT NULL COMMENT '票据id',
	`batch_id` VARCHAR(64) NOT NULL COMMENT '批次id',
	`source_id` VARCHAR(64) NOT NULL COMMENT '源单id',
	`come_from` INT(1) NOT NULL DEFAULT 0 COMMENT '数据来源：0 领用退回 1 住院发票',
	`owner_id` VARCHAR(64) NOT NULL COMMENT '退回人id',
	`create_by` VARCHAR(64) NOT NULL COMMENT '创建（退票）人id',
	`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建（退票）时间'
) COMMENT '用户票据退回表';