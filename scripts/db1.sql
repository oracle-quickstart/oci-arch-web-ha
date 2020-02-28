/*Copyright © 2020, Oracle and/or its affiliates. 
 All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
 */
 
alter session set "_ORACLE_SCRIPT"=true; 

CREATE USER dbfirst IDENTIFIED BY "DevOps_123#"
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users; 

GRANT CONNECT, DBA to dbfirst;

GRANT create table, create sequence to dbfirst;

GRANT all privileges to dbfirst;

CREATE TABLE "DBFIRST"."DEPT" (
  given_name  VARCHAR2(100) NOT NULL
);


INSERT INTO "DBFIRST"."DEPT"
VALUES ('Welcome to Oracle Cloud Infrastructure. Your application is up and running.');

commit;