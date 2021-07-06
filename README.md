### Purpose

The main purpose of this repo is to provide an Apache NiFi flow template, `oracle_upsert.xml` which continually fetches data from a source oracle db and conditionally inserts or updates the records in a target oracle db, i.e. mimic an upsert operation.  

### Setup 

Lets look at the local setup on macOS Big Sur 11.4:

1. Install docker desktop for mac.
2. Follow the steps here to install oracle express: https://blogs.oracle.com/oraclemagazine/deliver-oracle-database-18c-express-edition-in-containers
3. Pull nifi image: `docker pull apache/nifi` ref: https://hub.docker.com/r/apache/nifi
4. Installed jdk on Mac: https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html
5. Installed sql developer: https://www.oracle.com/tools/downloads/sqldev-downloads.html
6. Followed https://community.oracle.com/tech/developers/discussion/4477413/sql-developer-on-macos-11-big-sur to launch SQL Developer	
    ```bash
    cd /Applications/SQLDeveloper.app/Contents/resources/sqldeveloper
    zsh sqldeveloper.sh
    ```
7. Connect xe to sqldev: https://www.oracle.com/au/database/technologies/howto-connect-xe.html
8. Changed to pluggable db instead of container db, look at the `create_schema.sql`. Ref: https://stackoverflow.com/questions/33330968/error-ora-65096-invalid-common-user-or-role-name-in-oracle
9. Created local schemas called `LOCALSRC` and `LOCALDEST`, use `create_schema.sql`. Ref: https://docs.oracle.com/en/cloud/paas/exadata-express-cloud/csdbp/create-database-schemas.html 
10. Created a sample db `ORDERS` in both the schemas, use `create_table.sql`. Ref: https://www.oracletutorial.com/getting-started/oracle-sample-database/
11. Loaded data in the source table (use `initial_data.sql`). Ref: https://www.oracletutorial.com/getting-started/oracle-sample-database/ and goto __Download Oracle Sample Database__

### Let it flow

Next was to build the NiFi flow and run it.

1. Created the flow in NiFi, which can be imported via `oracle_upsert.xml` (all the controller services will need to be enabled).
2. Started all the components and performed the first run. This copied all the (105) records from the source `LOCALSRC.ORDERS` table to the target `LOCALDEST.ORDERS` table.
3. Performed some updates to the source `LOCALSRC.ORDERS` table, using `update_data.sql`. This update edited 5 existing rows and inserted 5 new rows in the `LOCALSRC.ORDERS` table.
4. As the flow is scheduled to run every 60 seconds, the next run would pick up the changes from source and load them into the target, inserting the 5 new rows and updating the 5 edited rows.


