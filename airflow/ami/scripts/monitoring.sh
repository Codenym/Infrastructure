#!/usr/bin/env bash
apt-get install -y unzip
apt-get install -y libwww-perl libdatetime-perl
curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O

unzip CloudWatchMonitoringScripts-1.2.2.zip -d /opt
rm CloudWatchMonitoringScripts-1.2.2.zip

# Setup cron entries to monitoring disk metrics and memory metrics every 5 minutes
crontab -l | { cat; echo "*/5 * * * * /opt/aws-scripts-mon/mon-put-instance-data.pl --from-cron --disk-space-used --disk-space-util --disk-space-avail --disk-path=/"; } | crontab -
crontab -l | { cat; echo "*/5 * * * * /opt/aws-scripts-mon/mon-put-instance-data.pl --from-cron --disk-space-used --disk-space-util --disk-space-avail --disk-path=/run"; } | crontab -
crontab -l | { cat; echo "*/5 * * * * /opt/aws-scripts-mon/mon-put-instance-data.pl --from-cron --disk-space-used --disk-space-util --disk-space-avail --disk-path=/dev"; } | crontab -
crontab -l | { cat; echo "*/5 * * * * /opt/aws-scripts-mon/mon-put-instance-data.pl --from-cron --disk-space-used --disk-space-util --disk-space-avail --disk-path=/sys/fs/cgroup"; } | crontab -
crontab -l | { cat; echo "*/5 * * * * /opt/aws-scripts-mon/mon-put-instance-data.pl --from-cron --mem-util --mem-used --mem-used-incl-cache-buff --mem-avail --swap-util --swap-used --verify --verbose"; } | crontab -