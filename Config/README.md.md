## Rsyslog server (192.168.169.135) 
Gồm 2 file:
```
10-input-nmap.conf.txt
51-output-kafka-nmap.conf.txt
```
Đặt ở `/etc/logstash/conf.d`

## Logstash-indexer
3 file:
```
10-input-kafka.conf.txt
37-filter-nmap.conf.txt
51-output-elasticsearch.conf.txt
```
Đặt ở `/etc/logstash/conf.d`

File `extra_patterns.txt` đặt ở `/etc/logstash/`
