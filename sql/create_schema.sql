show con_name;
show pdbs;
alter session set container = XEPDB1;

CREATE USER localsrc IDENTIFIED BY test_password1;
GRANT CREATE TABLE TO localsrc;
SELECT username, account_status FROM dba_users
WHERE username = 'LOCALSRC';
alter user localsrc quota unlimited on users;

CREATE USER localdest IDENTIFIED BY test_password2;
GRANT CREATE TABLE TO localdest;
SELECT username, account_status FROM dba_users
WHERE username = 'LOCALDEST';
alter user localdest quota unlimited on users;

commit;