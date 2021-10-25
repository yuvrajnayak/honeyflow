#!/bin/bash

# call recycling script on all four containers. 
# script will not run if a user is currently logged on.
/honeyflow/mongoRecycling.sh m1 mongoTemplate
/honeyflow/mongoRecycling.sh m2 mongoTemplate
/honeyflow/sqlRecycling.sh s1 mysqlTemplate
/honeyflow/sqlRecycling.sh s2 mysqlTemplate

# call networking for all four containers
/honeyflow/networking.sh
