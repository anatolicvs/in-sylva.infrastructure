'use strict'

db.createUser(
    {
        user: "insylva_mongoc",
        pwd: "v2kGBDUaGjXK2VuPyf5R64VS",
        roles: [
            {
                role: "readWrite",
                db: "insylva_mongodb"
            }
        ]
    }
);