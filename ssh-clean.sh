#/bin/bash
# Remove old keys
hostaddr=''
portnr=''

while read dataline
do
    if [[ $dataline == *"HostName"* ]]
    then
        hostaddr=`echo $dataline | sed -r '/HostName/ s/[ ]+/_/g' | cut -d '_' -f2`
    elif [[ $dataline == *"Port"* ]]
    then
        portnr=`echo $dataline | sed -r '/Port/ s/[ ]+/_/g' | cut -d '_' -f2`
    fi

    if [ "$hostaddr" ] && [ "$portnr" ]
    then
        echo $hostaddr:$portnr
        ssh-keygen -f ~/.ssh/known_hosts -R $hostaddr
        ssh-keygen -f ~/.ssh/known_hosts -R \[$hostaddr\]:$portnr
        unset hostaddr portnr
    fi
done <~/.ssh/config

exit 0
