## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

#!/bin/bash
sudo bash -c "mv /tmp/db1.sql /home/oracle/ && chmod 777 /home/oracle/db1.sql"
sudo su - oracle -c "export ORACLE_SID=aTFdb && export ORAENV_ASK=NO && . /usr/local/bin/oraenv && exit | sqlplus / as sysdba @/home/oracle/db1.sql"