##############################################
# Simple bash script to curl node-exporter
# service at port 9100 and grep for the 
# metrics (CPU, Memory, Disk usage)
# Redirecting the output to the log file with 
# timestamp in the filename
##############################################

#!/bin/sh
mkdir exporter-logs
cd exporter-logs && curl -s http://one2n-lab1-prometheus-node-exporter.one2n.svc.cluster.local:9100/metrics | egrep '^node_filesystem_size_bytes|^node_cpu_seconds_total|^node_memory_Mem' > metrics_file_$(date +"%Y%m%d_%H%M%S").log