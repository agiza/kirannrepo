//  to run: sudo $MONGO_HOME/bin/mongo localhost:27017/realdoc --quiet demoData.js
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Loan Servicing/00877.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Loan Servicing/00878.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Bankruptcy/00880.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Collateral/00001.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Collateral/00002.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Collection an Delinquency/00658.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Collection an Delinquency/00656.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Correspondence/00486.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Correspondence/00487.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Foreclosure/00801.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Foreclosure/00802.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/HAMP/01061.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/HAMP/01060.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Insurance/00655.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Invoices/01073.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Invoices/01072.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Loss Mitigation Documents/009550.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Loss Mitigation Documents/00949.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Origination and Closing/00215.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Origination and Closing/00214.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Originations and Searches/00370.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Originations and Searches/00369.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Property Reports/00528.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Property Reports/00529.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Workouts/00882.tif"})
db.real_file.files.insert({"_id":"file:///media/files/7090340014/Workouts/00881.tif"})

db.real_folder.insert({ "_id" : "7090340014", "_class" : "realdoc.api.domain.document.RealFolder", "name" : "7090340014", "createdDateMillis" : NumberLong("1343401848085"), "parentId" : "50607afd8fa8d25a3f22e12b",
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    },  "Attorneys" : {
      "__EDIT_DOC" : "DENY",
      "savePageOrder" : "DENY",
      "savePageRotate" : "DENY",
      "__ADMIN" : "GRANT",
      "moveDoc" : "GRANT",
      "__DELETE_DOC" : "GRANT",
      "__READ_DOC" : "GRANT",
      "chgDocAnnotations" : "GRANT",
      "downloadDocs" : "GRANT",
      "__CREATE_DOC" : "GRANT"
    }
  } })

db.real_folder.insert({
  "_id" : ObjectId("50607afd8fa8d25a3f22e12b"),
  "_class" : "realdoc.api.domain.document.RealFolder",
  "childIds" : ["7090340014"],
  "name" : "____ROOT",
  "createdDateMillis" : NumberLong("1348500221252"),
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__EDIT_DOC" : "GRANT",
      "savePageOrder" : "GRANT",
      "savePageRotate" : "GRANT",
      "__ADMIN" : "GRANT",
      "moveDoc" : "GRANT",
      "__DELETE_DOC" : "GRANT",
      "__READ_DOC" : "GRANT",
      "chgDocAnnotations" : "GRANT",
      "downloadDocs" : "GRANT",
      "__CREATE_DOC" : "GRANT"
    }
  }
} )

db.real_fileset.insert({"_id":ObjectId("1012ee37602ea71188d1cbda"),"_class" : "realdoc.api.domain.document.RealFileSet", "createdDateMillis" : NumberLong("1343052604778"), "childIds":["file:///media/files/7090340014/Loan Servicing/00877.tif","file:///media/files/7090340014/Loan Servicing/00878.tif"]})
db.real_fileset.insert({"_id":ObjectId("2012ee37602ea71188d1cbda"),"_class" : "realdoc.api.domain.document.RealFileSet", "createdDateMillis" : NumberLong("1343052604778"), "childIds":["file:///media/files/7090340014/Collateral/00001.tif","file:///media/files/7090340014/Collateral/00002.tif"]})
db.real_fileset.insert({"_id":ObjectId("3012ee37602ea71188d1cbda"),"_class" : "realdoc.api.domain.document.RealFileSet", "createdDateMillis" : NumberLong("1343052604778"), "childIds":["file:///media/files/7090340014/HAMP/01060.tif","file:///media/files/7090340014/HAMP/01061.tif"]})
db.real_fileset.insert({"_id":ObjectId("4012ee37602ea71188d1cbda"),"_class" : "realdoc.api.domain.document.RealFileSet", "createdDateMillis" : NumberLong("1343052604778"), "childIds":["file:///media/files/7090340014/Origination and Closing/00214.tif","file:///media/files/7090340014/Origination and Closing/00215.tif"]})
db.real_fileset.insert({"_id":ObjectId("6012ee37602ea71188d1cbda"),"_class" : "realdoc.api.domain.document.RealFileSet", "createdDateMillis" : NumberLong("1343052604778"), "childIds":["file:///media/files/7090340014/Originations and Searches/00369.tif","file:///media/files/7090340014/Originations and Searches/00370.tif"]})
db.real_fileset.insert({"_id":ObjectId("7012ee37602ea71188d1cbda"),"_class" : "realdoc.api.domain.document.RealFileSet", "createdDateMillis" : NumberLong("1343052604778"), "childIds":["file:///media/files/7090340014/Property Reports/00528.tif","file:///media/files/7090340014/Property Reports/00529.tif"]})

db.real_document.insert({"name":"CIS Legacy 3", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Bankruptcy", "loan" : "Loan", "type" : "Motions", "parent":"7090340014", "__fileName" : "00880.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Bankruptcy/00880.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Bankruptcy/00880.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"CIS Legacy 6", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Collection and Delinquency", "loan" : "Loan", "type" : "Financial Income/Expense Statement", "parent":"7090340014", "__fileName" : "00658.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Collection an Delinquency/00658.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Collection an Delinquency/00658.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"CIS Legacy 7", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Collection and Delinquency", "loan" : "Loan", "type" : "Financial Income/Expense Statement", "parent":"7090340014", "__fileName" : "00656.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Collection an Delinquency/00656.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Collection an Delinquency/00656.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"CIS Legacy 8", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Correspondence", "loan" : "Loan", "type" : "Miscellaneous", "parent":"7090340014", "__fileName" : "00486.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Correspondence/00486.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Correspondence/00486.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"CIS Legacy 9", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Correspondence", "loan" : "Loan", "type" : "Miscellaneous", "parent":"7090340014", "__fileName" : "00487.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Correspondence/00487.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Correspondence/00487.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"CIS Legacy 10", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Foreclosure", "loan" : "Loan", "type" : "Affidavits Review", "parent":"7090340014", "__fileName" : "00801.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Foreclosure/00801.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Foreclosure/00801.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"CIS Legacy 11", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Foreclosure", "loan" : "Loan", "type" : "Affidavits Review", "parent":"7090340014", "__fileName" : "00802.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Foreclosure/00802.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Foreclosure/00802.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"CIS Legacy 14", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Insurance", "loan" : "Loan", "type" : "Cancellations", "parent":"7090340014", "__fileName" : "00655.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Insurance/00655.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Insurance/00655.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"CIS Legacy 15", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Admin", "loan" : "Loan", "type" : "Invoices", "parent":"7090340014", "__fileName" : "01073.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Invoices/01073.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Invoices/01073.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"CIS Legacy 16", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Admin", "loan" : "Loan", "type" : "Invoices", "parent":"7090340014", "__fileName" : "01072.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Invoices/01072.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Invoices/01072.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"CIS Legacy 17", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Loss Mitigation Documents from TBW", "loan" : "Loan", "type" : "No Title", "parent":"7090340014", "__fileName" : "00950.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Loss Mitigation Documents/00950.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Loss Mitigation Documents/00950.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"CIS Legacy 18", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Loss Mitigation Documents from Sparta", "loan" : "Loan", "type" : "No Title", "parent":"7090340014", "__fileName" : "00949.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Loss Mitigation Documents/00949.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Loss Mitigation Documents/00949.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"CIS Legacy 25", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Workout", "loan" : "Loan", "type" : "Financial", "parent":"7090340014", "__fileName" : "00882.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Workouts/00882.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Workouts/00882.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"CIS Legacy 26", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Workout", "loan" : "Loan", "type" : "Financial", "parent":"7090340014", "__fileName" : "00881.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Workouts/00881.tif", "createdDateMillis" : NumberLong("1343052604776"), "createdBy":"CIS User", "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Workouts/00881.tif" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})


db.real_document.insert({"name":"CIS Legacy Fileset", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Loan Servicing", "loan" : "Loan", "type" : "Miscellaneous", "parent":"7090340014", "__fileName" : "realfile1"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"1012ee37602ea71188d1cbda", "createdDateMillis" : NumberLong("1343052604778"), "parentId" : "7090340014", "versionIds" : ["1012ee37602ea71188d1cbda" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"Washington Mutual", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Collateral", "loan" : "Loan", "type" : "Agreements", "parent":"7090340014", "__fileName" : "00002.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"2012ee37602ea71188d1cbda", "createdDateMillis" : NumberLong("1343052604778"), "parentId" : "7090340014", "versionIds" : ["2012ee37602ea71188d1cbda" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"HAMP", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "HAMP", "loan" : "Loan", "type" : "Final Modification", "parent":"7090340014", "__fileName" : "01061.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"3012ee37602ea71188d1cbda", "createdDateMillis" : NumberLong("1343052604778"), "parentId" : "7090340014", "versionIds" : ["3012ee37602ea71188d1cbda" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"Washington Mutual Fax", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Origination and Closing", "loan" : "Loan", "type" : "Miscellaneous", "parent":"7090340014", "__fileName" : "00215.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"4012ee37602ea71188d1cbda", "createdDateMillis" : NumberLong("1343052604778"), "parentId" : "7090340014", "versionIds" : ["4012ee37602ea71188d1cbda" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"Litton", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Servicing", "loan" : "Loan", "type" : "Miscellaneous", "parent":"7090340014", "__fileName" : "00370.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"6012ee37602ea71188d1cbda", "createdDateMillis" : NumberLong("1343052604778"), "parentId" : "7090340014", "versionIds" : ["6012ee37602ea71188d1cbda" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})
db.real_document.insert({"name":"Photos", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Title", "loan" : "Loan", "type" : "Reports", "parent":"7090340014", "__fileName" : "title"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"7012ee37602ea71188d1cbda", "createdDateMillis" : NumberLong("1343052604778"), "parentId" : "7090340014", "versionIds" : ["7012ee37602ea71188d1cbda" ],
  "groupAuthorizations" : {
    "__GROUP_FOR_SUPER_USERS" : {
      "__ALL" : "GRANT"
    }
  }})


//db.real_document.insert({"name":"CIS Legacy 19", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Origination and Closing", "loan" : "Loan", "type" : "Miscellaneous", "parent":"7090340014", "__fileName" : "00215.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Origination and Closing/00215.tif", "createdDateMillis" : NumberLong("1343052604776"), "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Origination and Closing/00215.tif" ]})
//db.real_document.insert({"name":"CIS Legacy 20", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Origination and Closing", "loan" : "Loan", "type" : "Miscellaneous", "parent":"7090340014", "__fileName" : "00214.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Origination and Closing/00214.tif", "createdDateMillis" : NumberLong("1343052604776"), "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Origination and Closing/00214.tif" ]})
//db.real_document.insert({"name":"CIS Legacy 21", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Servicing", "loan" : "Loan", "type" : "Miscellaneous", "parent":"7090340014", "__fileName" : "00370.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Originations and Searches/00370.tif", "createdDateMillis" : NumberLong("1343052604776"), "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Originations and Searches/00370.tif" ]})
//db.real_document.insert({"name":"CIS Legacy 22", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Servicing", "loan" : "Loan", "type" : "Miscellaneous", "parent":"7090340014", "__fileName" : "00369.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Originations and Searches/00369.tif", "createdDateMillis" : NumberLong("1343052604776"), "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Originations and Searches/00369.tif" ]})
//db.real_document.insert({"name":"CIS Legacy 23", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Title", "loan" : "Loan", "type" : "Reports", "parent":"7090340014", "__fileName" : "00528.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Property Reports/00528.tif", "createdDateMillis" : NumberLong("1343052604776"), "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Property Reports/00528.tif" ]})
//db.real_document.insert({"name":"CIS Legacy 24", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Title", "loan" : "Loan", "type" : "Reports", "parent":"7090340014", "__fileName" : "00529.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Property Reports/00529.tif", "createdDateMillis" : NumberLong("1343052604776"), "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Property Reports/00529.tif" ]})
//db.real_document.insert({"name":"CIS Legacy 12", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "HAMP", "loan" : "Loan", "type" : "Final Modification", "parent":"7090340014", "__fileName" : "01061.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/HAMP/01061.tif", "createdDateMillis" : NumberLong("1343052604776"), "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/HAMP/01061.tif" ]})
//db.real_document.insert({"name":"CIS Legacy 13", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "HAMP", "loan" : "Loan", "type" : "Final Modification", "parent":"7090340014", "__fileName" : "01060.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/HAMP/01060.tif", "createdDateMillis" : NumberLong("1343052604776"), "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/HAMP/01060.tif" ]})
//db.real_document.insert({"name":"CIS Legacy 4", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Collateral", "loan" : "Loan", "type" : "Agreements", "parent":"7090340014", "__fileName" : "00001.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Collateral/00001.tif", "createdDateMillis" : NumberLong("1343052604776"), "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Collateral/00001.tif" ]})
//db.real_document.insert({"name":"CIS Legacy 5", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Collateral", "loan" : "Loan", "type" : "Agreements", "parent":"7090340014", "__fileName" : "00002.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Collateral/00002.tif", "createdDateMillis" : NumberLong("1343052604776"), "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Collateral/00002.tif" ]})
//db.real_document.insert({"name":"CIS Legacy 1", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Loan Servicing", "loan" : "Loan", "type" : "Miscellaneous", "parent":"7090340014", "__fileName" : "00878.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Loan Servicing/00878.tif", "createdDateMillis" : NumberLong("1343052604776"), "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Loan Servicing/00878.tif" ]})
//db.real_document.insert({"name":"CIS Legacy 2", "metadata" : { "__author" : "correspondence", "__owner" : "correspondence","category" : "Loan Servicing", "loan" : "Loan", "type" : "Miscellaneous", "parent":"7090340014", "__fileName" : "00877.tif"},"metadataClass" : "class realdoc.api.domain.document.RealDocumentMetadata","activeVersion":"file:///media/files/7090340014/Loan Servicing/00877.tif", "createdDateMillis" : NumberLong("1343052604777"), "parentId" : "7090340014", "versionIds" : ["file:///media/files/7090340014/Loan Servicing/00877.tif" ]})
