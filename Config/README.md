## Rsyslog server (192.168.169.135) 

Gồm 2 file:

    10-input-nmap.conf
    51-output-kafka-nmap.conf

Đặt ở `/etc/logstash/conf.d`

## Logstash-indexer

3 file:

    10-input-kafka.conf
    37-filter-nmap.conf
    51-output-elasticsearch.conf

Đặt ở `/etc/logstash/conf.d`

File `extra_patterns` đặt ở `/etc/logstash/`
