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

sudo apt update
sudo apt install awscli

aws s3 \
cp /var/tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3bucket}/${myname}-httpd-logs-${timestamp}.tar


