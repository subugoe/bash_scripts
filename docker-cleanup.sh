#!/bin/bash

### BEGIN INIT INFO
# Provides:          os_update
# Required-Start:    $local_fs $remote_fs
# Required-Stop:     $local_fs $remote_fs
# Default-Start:     5
# Default-Stop:      0 1 6
# Short-Description: automatic update and cleanup of the system
### END INIT INFO

LOG_FILE=/tmp/docker_cleanup.log
# Time function
function current {
    if [ -n $LOG_TIME ]
    then
        unset $LOG_TIME
    fi
    LOG_TIME=`date '+%Y%M%d-%H:%M'`
}
# Creating the Log-File
if [ ! -f $LOG_FILE ]
then
    touch $LOG_FILE
fi
sudo chmod 777 $LOG_FILE
# Starting
echo "** $LOG_TIME ** Starting the Cleanup..."
LOG_TIME=`date '+%Y%M%d-%H:%M'`
echo "** $LOG_TIME **"  2>&1 | tee --append $LOG_FILE
echo "********************************"  2>&1 | tee --append $LOG_FILE
echo "** Cleaning unused containers **"  2>&1 | tee --append $LOG_FILE
echo "********************************"  2>&1 | tee --append $LOG_FILE
if [ '$(docker ps -qa -f "dangling=true")' ]
then
    sudo docker rm $(docker ps -qa -f "dangling=true") 2>&1 | tee --append $LOG_FILE
fi
echo "********************************"  2>&1 | tee --append $LOG_FILE
echo "** Cleaning unsed images      **"  2>&1 | tee --append $LOG_FILE
echo "********************************"  2>&1 | tee --append $LOG_FILE
if [ '$(docker images -q -f "dangling=true")' ]
then
    sudo docker rmi $(docker images -q -f "dangling=true") 2>&1 | tee --append $LOG_FILE
fi
echo "********************************"  2>&1 | tee --append $LOG_FILE
echo "** Cleaning unsed volumes     **"  2>&1 | tee --append $LOG_FILE
echo "********************************"  2>&1 | tee --append $LOG_FILE
if [ '$(docker volume ls -qf "dangling=true")' ]
then
    docker volume rm $(docker volume ls -qf "dangling=true")
fi
LOG_TIME=`date '+%Y%M%d-%H:%M'`
echo "** $LOG_TIME ** Cleanup finished..."
