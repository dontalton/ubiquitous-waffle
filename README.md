Quick and dirty fluentd setup for docker hosts.  
  
To use:  
On AWS, launch an Ubuntu 16.04 image, I used t2.medium.  
sudo to root  
clone this repo  
./setup.sh  
Wait  
  
That's it.  
  
Docker's logging is configured to use fluentd. Fluentd allows us to get away from managing conventional logs, and rather lets us handle log data as streams. App server containers should log directly to stdout and stderr. Fluentd captures the data and places it into mongodb for later analysis. Logs are also stored locally, in /var/log/fluentd/archive, and remotely in a s3 bucket of your choosing. The appserver is running a simple Flask app that returns 'Hello World'.  
  
To verify messages are getting into mongo:  
mongo  
use fluentd  
db.flask.find()  
  
This isn't an enterprise solution. In the real world, each Docker node would run fluentd as a forwarder to a central HA fluentd deployment, that would then leverage a production mongodb cluster. Buffer output files could be archived onto an EFS for short-term local storage, then push to s3 and placed under bucket lifecycle management for a long-term solution.  
