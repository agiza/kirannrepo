//  to run: sudo $MONGO_HOME/bin/mongo localhost:27017/realdoc --quiet addIndexes.js
db.getCollection("real_document").ensureIndex({"name":1});
db.getCollection("real_file.files").ensureIndex({"name":1});
db.getCollection("real_folder").ensureIndex({"name":1});
db.getCollection("real_permission").ensureIndex({"partyId":1});
db.getCollection("real_permission").ensureIndex({"realDocId":1});
