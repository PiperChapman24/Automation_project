sudo apt update -y

servstat=$(service apache2 status)

if [[ $servstat == *"active (running)"* ]]; 
then
         echo "process is running"
else 
        echo "process is not running"
        sudo apt install apache2
        sudo /etc/init.d/apache2 start
fi

myname="Tanvi"
timestamp=$(date '+%d%m%Y-%H%M%S')
s3bucket="upgradtanvi"


cd /var/tmp
tar -cvf ${myname}-httpd-logs-${timestamp}.tar /var/log/apache2
cd

#sudo apt update
sudo apt install awscli

aws s3 \
cp /var/tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3bucket}/${myname}-httpd-logs-${timestamp}.tar

if [[ $(test -f /var/www/html/inventory.html) > 0 ]];
then
        echo "file is not present"
        cd /var/www/html
        touch inventory.html
        echo -e "LogType\tTimeCreated\tType\tSize">>inventory.html

fi
if [[ $(test -f /var/www/html/inventory.html) -eq "0" ]];
then
        echo "file is  present"
        filesize=$(du -h /var/tmp/${myname}-httpd-logs-${timestamp}.tar | awk '{print $1}')
         echo -e "httpd-logs\t${timestamp}\ttar\t${filesize}">>/var/www/html/inventory.html
fi


if [[ $(test -f /etc/cron.d/automation) > 0 ]];
then
        echo "0 10 * * * bash root/Automation_Project/automation.sh">> /etc/cron.d/automation
fi

