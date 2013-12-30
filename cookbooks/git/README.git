12/30/2013 - see DEVOPS-96 DEVOPS-270 DEVOPS-277 DEVOPS-269 and DEVOPS-264

* We can not use the community cookbooks for "git" or "java".  When either one is added as dependencies to another cookbooks metatadata.rb - we are seeing a strange hang on chef-client runs on nodes that forces the chef-server to spike CPU that never goes away and the client times out unable to reach the app behind chef's nginx proxy.

* It may be something related to "bookshelf".  One *possible* solution may be moving to "berkshelf".  Ran across various comments researching the problems that lead me to believe berkshelf is better than bookshelf for Chef (but not supported by default).  Needs more research....

Questions?   Try: scott.mcdonald@altisource.com
