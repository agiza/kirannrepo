--liquibase formatted sql

--changeset author:iam

-- Aliases used for ID stroage
-- Users=usr; Tenant=tnt; Roles=rl; RefCode=rf; Product=prd; Resources=rs; Permissions=pm;
-- RolePermission=rp; TenantProduct=tp; UserRole=ur; UserProduct=up;

-- Users
INSERT INTO `iam_user` (`ID`, `USER_NAME`, `USER_TYPE`, `MANAGED`, `FIRST_NAME`, `LAST_NAME`, `PRIMARY_PHONE`, `EMAIL`, `SECRET_QUESTION_1`, `SECRET_ANSWER_1`, `SECRET_QUESTION_2`, `SECRET_ANSWER_2`, `CREATED_ON`, `LAST_UPDATED_ON`)
VALUES (default, 'SysAdmin', 'Admin', 1, 'Seed', 'User', NULL, 'admin@realsuite.com', NULL, NULL, NULL, NULL, UNIX_TIMESTAMP()*1000, UNIX_TIMESTAMP()*1000);
SET @usr.sysadmin = LAST_INSERT_ID();

-- Tenants
INSERT INTO `iam_tenant` (`ID`, `NAME`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, 'System', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @tnt.system = LAST_INSERT_ID();

INSERT INTO `iam_tenant` (`ID`, `NAME`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, 'Ocwen', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @tnt.ocwen = LAST_INSERT_ID();

-- Roles
INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @tnt.system, 'UI User', 'UI User', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rl.01uu = LAST_INSERT_ID();

INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @tnt.system, 'UI Admin', 'UI Admin', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rl.02ua = LAST_INSERT_ID();

INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @tnt.system, 'ROLE_IAM_USER', 'ROLE_IAM_USER', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rl.03iu = LAST_INSERT_ID();

INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @tnt.system, 'ROLE_IAM_ADMIN', 'ROLE_IAM_ADMIN', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rl.04ia = LAST_INSERT_ID();

INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @tnt.system, 'Rules User', 'Rules User', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rl.05ru = LAST_INSERT_ID();

INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @tnt.system, 'Rules Admin', 'Rules Admin', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rl.06ra = LAST_INSERT_ID();

INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @tnt.system, 'Servicer_View', 'Servicer_View', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rl.07sv = LAST_INSERT_ID();

INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @tnt.system, 'Admin_View', 'Admin_View', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rl.08av = LAST_INSERT_ID();

INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @tnt.system, 'Vendor_View', 'Vendor_View', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rl.09vv = LAST_INSERT_ID();

INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @tnt.system, 'Facilitator_View', 'Facilitator_View', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rl.10fv = LAST_INSERT_ID();

INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @tnt.system, 'Investor_View', 'Investor_View', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rl.11iv = LAST_INSERT_ID();

INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @tnt.system, 'Borrower_View', 'Borrower_View', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rl.12bv = LAST_INSERT_ID();

INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @tnt.system, 'Partner_View', 'Partner_View', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rl.13pv = LAST_INSERT_ID();

-- Ref Codes
INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Admin', 'Admin', 'UTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.01ad = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Vendor', 'Vendor', 'UTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.02ve = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Servicer', 'Servicer', 'UTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.03se = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Borrower', 'Borrower', 'UTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.04bo = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Partner', 'Partner', 'UTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.05pa = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Investor', 'Investor', 'UTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.06iv = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Internal', 'Internal', 'UTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.07it = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Create', 'Create', 'PTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.08cr = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Read', 'Read', 'PTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.09re = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Update', 'Update', 'PTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.10up = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Delete', 'Delete', 'PTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.11de = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Report', 'Report', 'PTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.12re = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Upload', 'Upload', 'PTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.13up = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, 'Download', 'Download', 'PTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.14do = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Assign', 'Assign', 'PTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.15as = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Claim', 'Claim', 'PTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.16cl = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, 'Disable', 'Disable', 'PTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.17di = LAST_INSERT_ID();

INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Relate', 'Relate', 'PTYPE', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rf.18re = LAST_INSERT_ID();

-- Products
INSERT INTO `iam_product` (`ID`, `PRODUCT_NAME`, `PRODUCT_DESC`, DEFAULT_ROLE_ID, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'UI', 'Real Foundation UI', @rl.01uu, 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @prd.01ui = LAST_INSERT_ID();

INSERT INTO `iam_product` (`ID`, `PRODUCT_NAME`, `PRODUCT_DESC`, DEFAULT_ROLE_ID, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'IAM', 'Identity Access Management', @rl.03iu, 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @prd.02iam = LAST_INSERT_ID();

INSERT INTO `iam_product` (`ID`, `PRODUCT_NAME`, `PRODUCT_DESC`, DEFAULT_ROLE_ID, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, 'Rules Management', 'Rules Management', @rl.05ru, 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @prd.03ru = LAST_INSERT_ID();

-- Resources
INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'Home', 'Controls Visibility of Home tab in the NavBar', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.01nb = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'Servicing', 'Controls Visibility of Servicing tab in the NavBar', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.02nb = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'Documents', 'Controls Visibility of Documents tab in the NavBar', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.03nb = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'Orders', 'Controls Visibility of Orders tab in the NavBar', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.04nb = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'Default', 'Controls Visibility of Default tab in the NavBar', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.05nb = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'REO', 'Controls Visibility of REO tab in the NavBar', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.06nb = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'Reports', 'Controls Visibility of Reports tab in the NavBar', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.07nb = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'Administration', 'Controls Visibility of Administration tab in the NavBar', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.08nb = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'UserMgmt', 'Controls Visibility of UserMgmt in Admin tab', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.09at = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'RuleMgmt', 'Controls Visibility of RuleMgmt in Admin tab', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.10at = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'TenantMgmt', 'Controls Visibility of TenantMgmt in Admin tab', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.11at = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'InvestorMgmt', 'Controls Visibility of InvestorMgmt in Admin tab', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.12at = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'LoanBoarding', 'Controls Visibility of LoanBoarding in Admin tab', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.13at = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'LoanDeboarding', 'Controls Visibility of LoanDeboarding in Admin tab', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.14at = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'UsageBilling', 'Controls Visibility of UsageBilling in Admin tab', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.15at = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'SystemConfig', 'Controls Visibility of SystemConfig in Admin tab', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.16at = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'Audit', 'Controls Visibility of Audit in Admin tab', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.17at = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'CreditReporting', 'Controls Visibility of CreditReporting in Servicing tab', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.18at = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.01ui, 'Configurations', 'Controls Visibility of Configurations in Admin tab', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.19at = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.02iam, 'Resource', 'Controls CRUD to resources and relation to role', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.20crud = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.02iam, 'Role', 'Controls CRUD to roles and relation to group', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.21crud = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.02iam, 'Group', 'Controls CRUD to groups and relation to users', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.22crud = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.02iam, 'Product', 'Controls CRUD to product', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.23crud = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.02iam, 'User', 'Controls CRUD to users and relation to role', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.24crud = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.02iam, 'Tenant', 'Controls CRUD to tenant configuration and mgmt.', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.25crud = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.03ru, 'Rule Set', 'Controls CRUD to rule sets and relation to publish', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.26crud = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.03ru, 'Rules', 'Controls CRUD to rules', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.27crud = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.03ru, 'Tests', 'Controls CRUD to tests', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.28crud = LAST_INSERT_ID();

INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @prd.03ru, 'FactModels', 'Controls CRUD to fact model(s)', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @rs.29crud = LAST_INSERT_ID();

-- Permissions
INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES(default, @rs.01nb, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.01 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.02nb, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.02 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.03nb, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.03 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.04nb, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.04 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.05nb, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.05 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.06nb, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.06 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.07nb, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.07 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.08nb, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.08 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.09at, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.09 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.10at, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.10 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.11at, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.11 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.12at, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.12 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.13at, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.13 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.14at, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.14 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.15at, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.15 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.16at, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.16 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.17at, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.17 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.18at, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.18 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.19at, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.19 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.20crud, 'Create', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.20 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.20crud, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.21 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.20crud, 'Update', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.22 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.20crud, 'Disable', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.23 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.20crud, 'Relate', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.24 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.20crud, 'Upload', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.25 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.21crud, 'Create', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.26 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.21crud, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.27 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.21crud, 'Update', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.28 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.21crud, 'Disable', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.29 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.21crud, 'Relate', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.30 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.22crud, 'Create', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.31 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.22crud, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.32 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.22crud, 'Update', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.33 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.22crud, 'Disable', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.34 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.22crud, 'Relate', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.35 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.23crud, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.36 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.23crud, 'Relate', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.37 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.24crud, 'Create', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.38 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.24crud, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.39 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.24crud, 'Update', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.40 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.24crud, 'Disable', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.41 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.24crud, 'Relate', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.42 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.24crud, 'Upload', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.43 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.24crud, 'Download', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.44 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.25crud, 'Create', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.45 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.25crud, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.46 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.25crud, 'Update', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.47 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.25crud, 'Disable', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.48 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.25crud, 'Relate', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.49 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.26crud, 'Create', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.50 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.26crud, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.51 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.26crud, 'Update', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.52 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.26crud, 'Disable', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.53 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.26crud, 'Relate', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.54 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.26crud, 'Upload', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.55 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.26crud, 'Download', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.56 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.27crud, 'Create', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.57 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.27crud, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.58 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.27crud, 'Update', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.59 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.27crud, 'Disable', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.60 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.27crud, 'Upload', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.61 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.27crud, 'Download', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.62 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.28crud, 'Create', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.63 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.28crud, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.64 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.28crud, 'Update', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.65 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.28crud, 'Disable', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.66 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.28crud, 'Upload', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.67 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.28crud, 'Download', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.68 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.29crud, 'Create', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.69 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.29crud, 'Read', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.70 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.29crud, 'Update', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.71 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.29crud, 'Disable', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.72 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.29crud, 'Upload', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.73 = LAST_INSERT_ID();

INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES (default, @rs.29crud, 'Download', 1, @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
SET @pm.74 = LAST_INSERT_ID();

-- Roles Permissions
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.01uu, @pm.01);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.01);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.02);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.03);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.04);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.05);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.06);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.07);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.08);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.09);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.10);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.11);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.12);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.13);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.14);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.15);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.16);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.17);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.18);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.02ua, @pm.19);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.03iu, @pm.21);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.03iu, @pm.27);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.03iu, @pm.32);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.03iu, @pm.36);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.03iu, @pm.39);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.03iu, @pm.46);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.03iu, @pm.08);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.03iu, @pm.17);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.03iu, @pm.19);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.03iu, @pm.01);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.03iu, @pm.11);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.03iu, @pm.09);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.20);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.21);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.22);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.23);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.24);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.25);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.26);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.27);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.28);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.29);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.30);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.31);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.32);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.33);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.34);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.35);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.38);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.39);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.40);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.41);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.42);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.43);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.44);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.08);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.17);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.19);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.01);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.11);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.04ia, @pm.09);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.05ru, @pm.51);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.05ru, @pm.58);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.05ru, @pm.64);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.05ru, @pm.70);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.05ru, @pm.10);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.05ru, @pm.08);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.05ru, @pm.01);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.50);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.51);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.52);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.53);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.54);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.55);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.56);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.57);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.58);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.59);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.60);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.61);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.62);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.63);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.64);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.65);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.66);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.67);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.68);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.69);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.70);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.71);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.72);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.73);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.74);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.10);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.08);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.06ra, @pm.01);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.07sv, @pm.01);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.08av, @pm.01);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.09vv, @pm.01);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.10fv, @pm.01);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.11iv, @pm.01);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.12bv, @pm.01);
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`) VALUES (@rl.13pv, @pm.01);


-- Tenant Product
INSERT INTO `iam_tenant_product` (`TENANT_ID`, `PRODUCT_ID`) VALUES (@tnt.system, @prd.01ui);
INSERT INTO `iam_tenant_product` (`TENANT_ID`, `PRODUCT_ID`) VALUES (@tnt.system, @prd.02iam);
INSERT INTO `iam_tenant_product` (`TENANT_ID`, `PRODUCT_ID`) VALUES (@tnt.ocwen, @prd.01ui);
INSERT INTO `iam_tenant_product` (`TENANT_ID`, `PRODUCT_ID`) VALUES (@tnt.ocwen, @prd.02iam);
INSERT INTO `iam_tenant_product` (`TENANT_ID`, `PRODUCT_ID`) VALUES (@tnt.ocwen, @prd.03ru);

-- User Role
INSERT INTO `iam_user_role` (`USER_ID`, `ROLE_ID`) VALUES (@usr.sysadmin, @rl.01uu);
INSERT INTO `iam_user_role` (`USER_ID`, `ROLE_ID`) VALUES (@usr.sysadmin, @rl.02ua);
INSERT INTO `iam_user_role` (`USER_ID`, `ROLE_ID`) VALUES (@usr.sysadmin, @rl.03iu);
INSERT INTO `iam_user_role` (`USER_ID`, `ROLE_ID`) VALUES (@usr.sysadmin, @rl.04ia);

-- User Tenant
INSERT INTO `iam_tenant_user` (`TENANT_ID`, `USER_ID`) VALUES(@tnt.system, @usr.sysadmin);