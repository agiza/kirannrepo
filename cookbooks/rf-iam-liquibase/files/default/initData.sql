--liquibase formatted sql

--changeset author:iam

-- Users
INSERT INTO `iam_user` (`ID`, `USER_NAME`, `USER_TYPE`, `MANAGED`, `FIRST_NAME`, `LAST_NAME`, `PRIMARY_PHONE`, `EMAIL`, `SECRET_QUESTION_1`, `SECRET_ANSWER_1`, `SECRET_QUESTION_2`, `SECRET_ANSWER_2`)
VALUES
    (1, 'SysAdmin', 'Admin', 1, 'Seed', 'User', NULL, 'admin@realsuite.com', NULL, NULL, NULL, NULL);

-- Tenants
INSERT INTO `iam_tenant` (`ID`, `NAME`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES
    (1, 'System', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (2, 'Ocwen', 1, 1, 1412633598720, 1, 1412633598720, 1);

-- Roles
INSERT INTO `iam_role` (`ID`, `TENANT_ID`, `ROLE_NAME`, `ROLE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES
    (1, 1, 'UI User', 'UI User', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (2, 1, 'UI Admin', 'UI Admin', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (3, 1, 'ROLE_IAM_USER', 'ROLE_IAM_USER', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (4, 1, 'ROLE_IAM_ADMIN', 'ROLE_IAM_ADMIN', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (5, 1, 'Rules User', 'Rules User', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (6, 1, 'Rules Admin', 'Rules Admin', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (7, 1, 'Servicer_View', 'Servicer_View', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (8, 1, 'Admin_View', 'Admin_View', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (9, 1, 'Vendor_View', 'Vendor_View', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (10, 1, 'Facilitator_View', 'Facilitator_View', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (11, 1, 'Investor_View', 'Investor_View', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (12, 1, 'Barrower_View', 'Barrower_View', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (13, 1, 'Partner_View', 'Partner_View', 1, 1, 1412633598720, 1, 1412633598720, 1);

-- Ref Codes
INSERT INTO `iam_ref_code` (`ID`, `REF_CODE`,`REF_DESC`, `REF_TYPE`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES
    (1, 'Admin', 'Admin', 'UTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (2, 'Vendor', 'Vendor', 'UTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (3, 'Servicer', 'Servicer', 'UTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (4, 'Borrower', 'Borrower', 'UTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (5, 'Partner', 'Partner', 'UTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (6, 'Investor', 'Investor', 'UTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (7, 'Internal', 'Internal', 'UTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (8, 'Create', 'Create', 'PTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (9, 'Read', 'Read', 'PTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (10, 'Update', 'Update', 'PTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (11, 'Delete', 'Delete', 'PTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (12, 'Report', 'Report', 'PTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (13, 'Upload', 'Upload', 'PTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (14, 'Download', 'Download', 'PTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (15, 'Assign', 'Assign', 'PTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (16, 'Claim', 'Claim', 'PTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (17, 'Disable', 'Disable', 'PTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (18, 'Relate', 'Relate', 'PTYPE', 1, 1, 1412633598720, 1, 1412633598720, 1);

-- Products
INSERT INTO `iam_product` (`ID`, `PRODUCT_NAME`, `PRODUCT_DESC`, DEFAULT_ROLE_ID, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES
    (1, 'UI', 'Real Foundation UI', 1, 1, 1, 1412633598720, 1, 1412633598720, 1),
    (2, 'IAM', 'Identity Access Management', 3, 1, 1, 1412633598720, 1, 1412633598720, 1),
    (3, 'Rules Management', 'Rules Management', 5, 1, 1, 1412633598720, 1, 1412633598720, 1);

-- Resources
INSERT INTO `iam_resource` (`ID`, `PRODUCT_ID`, `RESOURCE_NAME`, `RESOURCE_DESC`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES
    (1, 1, 'Home', 'Controls Visibility of Home tab in the NavBar', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (2, 1, 'Servicing', 'Controls Visibility of Servicing tab in the NavBar', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (3, 1, 'Documents', 'Controls Visibility of Documents tab in the NavBar', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (4, 1, 'Orders', 'Controls Visibility of Orders tab in the NavBar', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (5, 1, 'Default', 'Controls Visibility of Default tab in the NavBar', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (6, 1, 'REO', 'Controls Visibility of REO tab in the NavBar', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (7, 1, 'Reports', 'Controls Visibility of Reports tab in the NavBar', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (8, 1, 'Administration', 'Controls Visibility of Administration tab in the NavBar', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (9, 1, 'UserMgmt', 'Controls Visibility of UserMgmt in Admin tab', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (10, 1, 'RuleMgmt', 'Controls Visibility of RuleMgmt in Admin tab', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (11, 1, 'TenantMgmt', 'Controls Visibility of TenantMgmt in Admin tab', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (12, 1, 'InvestorMgmt', 'Controls Visibility of InvestorMgmt in Admin tab', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (13, 1, 'LoanBoarding', 'Controls Visibility of LoanBoarding in Admin tab', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (14, 1, 'LoanDeboarding', 'Controls Visibility of LoanDeboarding in Admin tab', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (15, 1, 'UsageBilling', 'Controls Visibility of UsageBilling in Admin tab', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (16, 1, 'SystemConfig', 'Controls Visibility of SystemConfig in Admin tab', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (17, 1, 'Audit', 'Controls Visibility of Audit in Admin tab', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (18, 1, 'CreditReporting', 'Controls Visibility of CreditReporting in Servicing tab', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (19, 1, 'Configurations', 'Controls Visibility of Configurations in Admin tab', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (20, 2, 'Resource', 'Controls CRUD to resources and relation to role', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (21, 2, 'Role', 'Controls CRUD to roles and relation to group', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (22, 2, 'Group', 'Controls CRUD to groups and relation to users', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (23, 2, 'Product', 'Controls CRUD to product', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (24, 2, 'User', 'Controls CRUD to users and relation to role', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (25, 2, 'Tenant', 'Controls CRUD to tenant configuration and mgmt.', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (26, 3, 'Rule Set', 'Controls CRUD to rule sets and relation to publish', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (27, 3, 'Rules', 'Controls CRUD to rules', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (28, 3, 'Tests', 'Controls CRUD to tests', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (29, 3, 'FactModels', 'Controls CRUD to fact model(s)', 1, 1, 1412633598720, 1, 1412633598720, 1);

-- Permissions
INSERT INTO `iam_permission` (`ID`, `RESOURCE_ID`, `OPERATION`, `ACTIVE`, `CREATED_BY`, `CREATED_ON`, `LAST_UPDATED_BY`, `LAST_UPDATED_ON`, `VERSION_NUMBER`)
VALUES
    (1, 1, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (2, 2, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (3, 3, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (4, 4, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (5, 5, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (6, 6, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (7, 7, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (8, 8, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (9, 9, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (10, 10, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (11, 11, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (12, 12, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (13, 13, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (14, 14, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (15, 15, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (16, 16, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (17, 17, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (18, 18, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (19, 19, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (20, 20, 'Create', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (21, 20, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (22, 20, 'Update', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (23, 20, 'Disable', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (24, 20, 'Relate', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (25, 20, 'Upload', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (26, 21, 'Create', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (27, 21, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (28, 21, 'Update', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (29, 21, 'Disable', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (30, 21, 'Relate', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (31, 22, 'Create', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (32, 22, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (33, 22, 'Update', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (34, 22, 'Disable', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (35, 22, 'Relate', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (36, 23, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (37, 23, 'Relate', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (38, 24, 'Create', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (39, 24, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (40, 24, 'Update', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (41, 24, 'Disable', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (42, 24, 'Relate', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (43, 24, 'Upload', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (44, 24, 'Download', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (45, 25, 'Create', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (46, 25, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (47, 25, 'Update', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (48, 25, 'Disable', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (49, 25, 'Relate', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (50, 26, 'Create', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (51, 26, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (52, 26, 'Update', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (53, 26, 'Disable', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (54, 26, 'Relate', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (55, 26, 'Upload', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (56, 26, 'Download', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (57, 27, 'Create', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (58, 27, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (59, 27, 'Update', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (60, 27, 'Disable', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (61, 27, 'Upload', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (62, 27, 'Download', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (63, 28, 'Create', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (64, 28, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (65, 28, 'Update', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (66, 28, 'Disable', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (67, 28, 'Upload', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (68, 28, 'Download', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (69, 29, 'Create', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (70, 29, 'Read', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (71, 29, 'Update', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (72, 29, 'Disable', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (73, 29, 'Upload', 1, 1, 1412633598720, 1, 1412633598720, 1),
    (74, 29, 'Download', 1, 1, 1412633598720, 1, 1412633598720, 1);

-- Roles and Permissions
INSERT INTO `iam_role_permission` (`ROLE_ID`, `PERMISSION_ID`)
VALUES
    (1, 1),
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 4),
    (2, 5),
    (2, 6),
    (2, 7),
    (2, 8),
    (2, 9),
    (2, 10),
    (2, 11),
    (2, 12),
    (2, 13),
    (2, 14),
    (2, 15),
    (2, 16),
    (2, 17),
    (2, 18),
    (2, 19),
    (3, 21),
    (3, 27),
    (3, 32),
    (3, 36),
    (3, 39),
    (3, 46),
    (3, 8),
    (3, 17),
    (3, 19),
    (3, 1),
    (3, 11),
    (3, 9),
    (4, 20),
    (4, 21),
    (4, 22),
    (4, 23),
    (4, 24),
    (4, 25),
    (4, 26),
    (4, 27),
    (4, 28),
    (4, 29),
    (4, 30),
    (4, 31),
    (4, 32),
    (4, 33),
    (4, 34),
    (4, 35),
    (4, 38),
    (4, 39),
    (4, 40),
    (4, 41),
    (4, 42),
    (4, 43),
    (4, 44),
    (4, 8),
    (4, 17),
    (4, 19),
    (4, 1),
    (4, 11),
    (4, 9),
    (5, 51),
    (5, 58),
    (5, 64),
    (5, 70),
    (5, 10),
    (5, 8),
    (5, 1),
    (6, 50),
    (6, 51),
    (6, 52),
    (6, 53),
    (6, 54),
    (6, 55),
    (6, 56),
    (6, 57),
    (6, 58),
    (6, 59),
    (6, 60),
    (6, 61),
    (6, 62),
    (6, 63),
    (6, 64),
    (6, 65),
    (6, 66),
    (6, 67),
    (6, 68),
    (6, 69),
    (6, 70),
    (6, 71),
    (6, 72),
    (6, 73),
    (6, 74),
    (6, 10),
    (6, 8),
    (6, 1),
    (7, 1),
    (8, 1),
    (9, 1),
    (10, 1),
    (11, 1),
    (12, 1),
    (13, 1);

-- TenantProduct
INSERT INTO `iam_tenant_product` (`TENANT_ID`, `PRODUCT_ID`)
VALUES
    (1, 1),
    (1, 2),
    (2, 1),
    (2, 2),
    (2, 3);

-- User Role
INSERT INTO `iam_user_role` (`USER_ID`, `ROLE_ID`)
VALUES
    (1, 4),
    (1, 1),
    (1, 2),
    (1, 3);

-- User Tenant
INSERT INTO `iam_tenant_user` (`TENANT_ID`, `USER_ID`)
VALUES
  (1, 1);

