--liquibase formatted sql
SELECT ID INTO @usr.sysadmin from iam_user where USER_NAME = 'SysAdmin' LIMIT 1;

INSERT INTO iam_large_entity (ID, ENTITY_NAME, STR_ENTITY, BIN_ENTITY, CREATED_BY, CREATED_ON, LAST_UPDATED_BY, LAST_UPDATED_ON, VERSION_NUMBER) VALUES (default, 'HEADER', null, '{
  "headerTabs": [
    {
      "displayName": "Home",
      "icon":"<i class=''fa fa-home''></i>",
      "applicationTitle": "My Tasks",
      "url": "/home",
      "httpLinkGroups": [
        {
          "groupTitle": null,
          "columnCount": 0
        }
      ]
    },
    {
      "displayName": "Servicing",
      "icon": "<i class=''fa fa-key''></i>",
      "applicationTitle": "Loan Servicing",
      "url": "",
      "httpLinkGroups": [
        {
          "groupTitle": "Servicing Processes",
          "columnCount": 4,
          "httpLinks": [
            {
              "displayName": "Tax",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Insurance",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Escrow",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Mortgage Insurance",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Credit Reporting",
              "url": "/cr",
              "permission": "UI.CreditReporting.Read"
            },
            {
              "displayName": "ARM Review",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Investor Relations",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Investor Reporting",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Cashiering",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Collateral",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Payoff",
              "url": "",
              "permission": "UI.Servicing.Reade"
            },
            {
              "displayName": "Collections",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Compliance",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Contracts",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Research",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "End of Year",
              "url": "",
              "permission": "UI.Servicing.Read"
            }
          ]
        },
        {
          "groupTitle": "Servicing Functions",
          "columnCount": 4,
          "httpLinks": [
            {
              "displayName": "Payables",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Receivables",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Borrowers Account",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Billing",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Calculators",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Core Entities",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Compliance",
              "url": "",
              "permission": "UI.Servicing.Read"
            },
            {
              "displayName": "Statements",
              "url": "",
              "permission": "UI.Servicing.Read"
            }
          ]
        }
      ]
    },
    {
      "displayName": "Investors",
      "icon": "<i class=''fa fa-rebel''></i>",
      "applicationTitle": "Loan Boarding",
      "url": "",
      "httpLinkGroups": [
        {
          "groupTitle": "Loan Boarding",
          "columnCount": 1,
          "httpLinks": [
            {
              "displayName": "Deals",
              "url": "/deal-setup-client/#/deals",
              "permission": "UI.LoanBoarding.Read"
            },
            {
              "displayName": "Tasks",
              "url": "/deal-setup-client/#/tasks",
              "permission": "UI.LoanBoarding.Read"
            }
          ]
        }
      ]
    },
    {
      "displayName": "Documents",
      "icon": "<i class=''fa fa-file-text''></i>",
      "applicationTitle": "REALDoc",
      "url": "",
      "httpLinkGroups": [
        {
          "groupTitle": "Document Center",
          "columnCount": 1,
          "httpLinks": [
            {
			  "displayName": "Dashboard",
			  "url": "#/dashboard",
			  "permission": "UI.Doc.Dashboard.Read"
			},
            {
              "displayName": "Vault",
			  "url": "#/vault",
			  "permission": "UI.Doc.Vault.Read"
            },
            {
              "displayName": "Correspondence",
              "url": "",
              "permission": "UI.Documents.Read"
            },
            {
              "displayName": "Capture",
			  "url": "#/capture",
			  "permission": "UI.Doc.Capture.Read"
            },
            {
              "displayName": "Configuration",
              "url": "",
              "permission": "UI.Documents.Read"
            },
            {
              "displayName": "Templates",
			  "url": "#/templates/list",
			  "permission": "UI.Doc.Templates.Read"
            },
            {
              "displayName": "Fields",
			  "url": "#/fields",
			  "permission": "UI.Doc.Fields.Read"
            },
            {
              "displayName": "Requests",
              "url": "#/requests",
              "permission": "UI.Doc.Requests.Read"
            }
          ]
        }
      ]
    },
    {
      "displayName": "Orders",
      "icon": "<i class=''fa fa-files-o''></i>",
      "applicationTitle": "Vendor Portal",
      "url": "",
      "httpLinkGroups": [
        {
          "groupTitle": "Transactions",
          "columnCount": 1,
          "httpLinks": [
            {
              "displayName": "Requester",
              "url": "",
              "permission": "UI.Orders.Read"
            },
            {
              "displayName": "Facilitator",
              "url": "",
              "permission": "UI.Orders.Read"
            },
            {
              "displayName": "Vendor",
              "url": "",
              "permission": "UI.Orders.Read"
            }
          ]
        },
        {
          "groupTitle": "Invoices",
          "columnCount": 1,
          "httpLinks": [
            {
              "displayName": "Submit",
              "url": "",
              "permission": "UI.Orders.Read"
            },
            {
              "displayName": "Approve",
              "url": "",
              "permission": "UI.Orders.Read"
            },
            {
              "displayName": "Manage",
              "url": "",
              "permission": "UI.Orders.Read"
            }
          ]
        }
      ]
    },
    {
      "displayName": "Default",
      "icon": "<i class=''fa fa-gavel''></i>",
      "applicationTitle": "Default Management",
      "url": "",
      "httpLinkGroups": [
        {
          "groupTitle": "Default Management",
          "columnCount": 1,
          "httpLinks": [
            {
              "displayName": "Modification",
              "url": "",
              "permission": "UI.Default.Read"
            },
            {
              "displayName": "Short Sale",
              "url": "",
              "permission": "UI.Default.Read"
            },
            {
              "displayName": "Deed-in-Lieu",
              "url": "",
              "permission": "UI.Default.Read"
            },
            {
              "displayName": "Foreclosure",
              "url": "",
              "permission": "UI.Default.Read"
            },
            {
              "displayName": "Bankruptcy",
              "url": "",
              "permission": "UI.Default.Read"
            }
          ]
        }
      ]
    },
    {
      "displayName": "REO",
      "icon": "<i class=''fa fa-building''></i>",
      "applicationTitle": "Real Estate Owned",
      "url": "",
      "httpLinkGroups": [
        {
          "groupTitle": "Real Estate Owned",
          "columnCount": 1,
          "httpLinks": [
            {
              "displayName": "Menu item 1",
              "url": "",
              "permission": "UI.REO.Read"
            },
            {
              "displayName": "Menu item 2",
              "url": "",
              "permission": "UI.REO.Read"
            },
            {
              "displayName": "Menu item 3",
              "url": "",
              "permission": "UI.REO.Read"
            }
          ]
        }
      ]
    },
    {
      "displayName": "Reports",
      "icon": "<i class=''fa fa-bar-chart-o''></i>",
      "applicationTitle": "Reporting Dashboard",
      "url": "",
      "httpLinkGroups": [
        {
          "groupTitle": "Reporting and Analytics",
          "httpLinks": [
            {
              "displayName": "List Reports",
              "url": "/realreports/#/reports",
              "permission": "UI.Reports.Read"
            }
          ]
        }
      ]
    },
    {
      "displayName": "ADMIN",
      "icon": "<i class=''fa fa-user''></i>",
      "applicationTitle": "Administration",
      "url": "",
      "httpLinkGroups": [
        {
          "groupTitle": "Administrative Consoles",
          "columnCount": 3,
          "httpLinks": [
            {
              "displayName": "User Management",
              "url": "/iam",
              "permission": "UI.IAM.Read"
            },
            {
              "displayName": "Investors",
              "url": "",
              "permission": "UI.Administration.Read"
            },
            {
              "displayName": "Tenant Management",
              "url": "/tenant",
              "permission": "UI.TenantMgmt.Read"
            },
            {
              "displayName": "Rules Management",
              "url": "/rules-mgmt",
              "permission": "UI.RuleMgmt.Read"
            },
            {
              "displayName": "Reports Administration",
              "url": "/realreports/#/reports-administration",
              "permission": "UI.ReportsAdmin.Read"
            },
            {
              "displayName": "Workflows",
              "url": "",
              "permission": "UI.RuleMgmt.Read"
            },
            {
              "displayName": "Search",
              "url": "",
              "permission": "UI.Administration.Read"
            },
            {
              "displayName": "Loan Boarding",
              "url": "",
              "permission": "UI.LoanBoarding.Read"
            },
            {
              "displayName": "Loan Deboarding",
              "url": "",
              "permission": "UI.LoanDeboarding.Read"
            },
            {
              "displayName": "IAM Configurations",
              "url": "/iam/#/configurations",
              "permission": "UI.Configurations.Read"
            },
            {
              "displayName": "Configurations",
              "url": "#/administration/configuration",
              "permission": "UI.Doc.Admin.Config.Read"
            },
            {
              "displayName": "Audit",
              "url": "/iam/#/audit",
              "permission": "UI.Audit.Read"
            },
            {
              "displayName": "Usage",
              "url": "#/administration/usage",
              "permission": "UI.Doc.Admin.Usage.Read"
            }
          ]
        }
      ]
    }
  ]
}', @usr.sysadmin, UNIX_TIMESTAMP()*1000, @usr.sysadmin, UNIX_TIMESTAMP()*1000, 1);
