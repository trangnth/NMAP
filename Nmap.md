#  NMAP (Network Mapper)

1. [Overview](#overview)

2. [Deployment](#deployment)

3. [Use cases](#usecases)

4. [Research](#research)


<a name="overview"></a>
## 1. Overview

Nmap (Network Mapper) là một công cụ quét, theo dõi và đánh giá bảo mật một hệ thống mạng được phát triển bởi Gordon Lyon (hay còn được biết đến với tên gọi Fyodor Vaskovich).

Nmap được công bố lần đầu tiên vào tháng 9 năm 1997.

Nmap là phần mềm mã nguồn mở miễn phí, ban đầu chỉ được phát triển trên nền tảng Linux sau đó được phát triển trên nhiều nền tảng khác nhau như Windows, Solari, Mac OS… và phát triển thêm phiên bản giao diện người dùng (zenmap).

Các chức năng của nmap:

- Phát hiện host trong mạng.
- Liệt kê các port đang mở trên một host.
- Xác định các dịch vụ chạy trên các port đang mở cùng với phần mềm và phiên bản đang dùng.
- Xác đinh hệ điều hành của thiết bị.
- Chạy các script đặc biệt.

<a name="deployment"></a>
## 2. Deployment

### 1.1. Manual

#### Requirements

    Ubuntu 14.04
    Rsyslog-v8
    Nmap v7.12


#### Installation

Mặc định ubuntu 14.04 sẽ cài nmap 6.40 và rsyslog 7

- Install rsyslog 8.25

      add-apt-repository ppa:adiscon/v8-stable -y
      apt-get update
      apt-get -y install rsyslog
      rm /etc/apt/sources.list.d/adiscon-v8-stable-trusty.list
      apt-get update

Sau khi cài đặt thì restart service: `service rsyslog restart`

Gõ `rsyslogd -v` để kiểm tra 

- Install nmap 7.12

      add-apt-repository ppa:pi-rho/security -y
      apt-get update
      apt-get -y install nmap
      rm -rf /etc/apt/sources.list.d/pi-rho-security-trusty.list
      apt-get update

gõ `nmap -V` để kiểm tra version

Quét thử TCP: `nmap -sT 192.168.169.192 -oG /var/log/nmap.results.log`

file kết quả quét được lưu trong đường dẫn `/var/log/nmap.results.log`

- Config đẩy log tới rsyslog server

Add thêm file `/etc/rsyslog.d/nmap.conf` có nội dung:

      module(load="imfile" PollingInterval="10") 
      input(type="imfile"
        File="/var/log/nmap.results.log"
        Tag="nmap"
        Severity="info"
        Facility="local3"
      )
      local3.* @192.168.169.135:514

`@192.168.169.135:514` là rsyslog server nhận log theo UDP từ cổng 514

### 1.2. Script
[Scripts](Script/README.md)

Auto scan nmap

### 1.3. Configuration
Thêm một số cấu hình vào hệ thống syslog để phân tích log

[File Config](Config)


      192.168.169.135 => rsyslog server
      192.168.169.159 => kafka
      192.168.169.160 => logstash indexer
      192.168.169.136 => elasticsearch
      192.168.169.161 => kibana


Chạy logstash: `/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/ --config.reload.automatic`

Kiểm tra topics kafka: `bin/kafka-topics.sh --list --zookeeper localhost:2181`


### 1.4. Report

[Report-nmap](Report-nmap.md)



<a name="usecases"></a>
## 3. Một vài lưu ý

Việc scan port sẽ rất tốn thời gian và quét UDP sẽ lâu hơn TCP, do TCP có cơ chế bắt tay ba bước, truyền tin tin cậy nên sẽ nhanh hơn UDP

Quét nmap sẽ ảnh hưởng tới hiệu năng mạng, nên để 1 giờ quét 1 lần hoặc 1 ngày 

Nếu muốn quét TCP một dải ip từ 192.168.169.100 tới 192.168.169.109 và lưu kết quả ra file text.txt theo dạng grepable

    nmap -sT -T4 192.168.169.100-109 -oG test.txt

Sử dụng `-T4` để quét nhanh, –F (Fast scan) để quét 100 port phổ biến nhất thay vì mặc định 1000 port.

file output có dạng: 

<img src = "https://github.com/trangnth/NMAP/blob/master/img/nmap-output.png">


<a name="research"></a>
## 4. Research
### Scan với Nmap

`nmap [ <Scan Type> ...] [ <Options> ] { <target specification> }`

Bắt đầu với các lệch cơ bản:

- Quét 1 IP:	`nmap 192.168.1.1`
- Quét 1 dải IP:	`nmap 192.168.1.1/24`
- Quét 1 domain:	`nmap google.com`
- Quét 1 danh sách các mục tiêu từ 1 file với tùy chọn -iL:	`nmap -iL list.txt`

Kết quả của nmap là một danh sách các targets được scan, chủ yếu các thông tin đó là interesting ports table, nó liệt kê các port number, protocol, tên các service và state.

Có 6 port states:

- `open`: có nghĩa là một ứng dụng trên các máy target đang lắng nghe các kết nối, gói dữ liệu trên port đó.
- `close`: không có ứng dụng nào đang lắng nghe trên port, mặc dù nó có thể mở bất cứ lúc nào.
- `filtered`: có nghĩa là một filewall, filter hoặc network obstacle khác đang chặn cổng để nmap không thể nói cho dù nó có là open hay close.
- `unfiltered`: port được phân loại này khi nó đáp ứng các đầu dò nmap, nhưng không thể xác định xem nó đang open hay close
- `open|filtered`: nmap đặt cổng ở trạng thái này khi nó không thể xác định một port được open hoặc filtered. Điều này xảy ra với nhiều loại quét các port open không có phản ứng. Việc thiếu phản ứng cũng có thể nghĩa là một bộ lọc gói giảm đầu dò hoặc bất kỳ phản ứng nó gợi ra. Vì vậy, Nmap không biết chắc chắn liệu các cổng được mở hoặc được lọc. Các giao thức UDP, IP, FIN, NULL, và Xmas quét phân loại cổng theo cách này.
- `closed|filtered`: Trạng thái này được sử dụng khi Nmap không thể xác định một port close hay filtered. Nó chỉ được sử dụng cho các IP ID quét nhàn rỗi.

Target Specification

- `-iL <inputfilename>` (Đầu vào từ danh sách)
- `-iR <num hosts>` (Chọn mục tiêu ngẫu nhiên)
- `--exclude <host1>[,<host2>[,...]]` (Loại trừ host / mạng)
- `--excludefile <exclude_file>` (Danh sách loại trừ từ tập tin)



Phát hiện các host trong mạng (host discovery)

- TCP SYN Ping:`–PS`
- TCP ACK Ping: `–PA`
- UDP Ping: `–PU`
- ARP Ping (sử dụng trong mạng LAN): `-PR`
- ICMP type 8 (echo request): `-PE`
- ICMP type 13 (timestamp request): `-PP`
- ICMP type 17(Address mask request): `-PA`

Khi gửi các gói tin trên tới 1 port của mục tiêu nếu nmap nhận được phản hồi (có thể là SYN-ACK, RST, các gói tin ICMP) thì nmap sẽ coi host đó tồn tại trong mạng, không quan tâm đến trạng thái của port. Nếu không nhận được gói tin phản hồi thì nmap sẽ coi là host không tồn tại. Mặc đinh nmap sử dụng gói tin ICMP echo request, ICMP timespam request, TCP SYN to port 443, TCP ACK to port 80, tương đương với 

 `–PE –PP –PS443 –PA80`

Một vài tùy chọn:

- No port scan `-sn` sử dụng tùy chọn này để thực hiện quá trình discovery (nmap sẽ dừng lại sau khi xác định các host đang chạy và không thực hiện việc quét port). 
- Tùy chọn `Pn` để bỏ qua host discovery và chuyển qua quá trình quét port.
- Tùy chon `–F` (Fast scan): nmap quét 100 port phổ biến nhất thay vì mặc định 1000 port.
- Tùy chọn `–top-ports` : quét n port phổ biến nhất.
- Tùy chọn `–r`: thứ tự quét các port từ thấp lên cao thay vì mặc định là ngẫu nhiên.
- `-sL` scan danh sách
- `-Pn` không ping
- `-PS` <port list> (TCP SYN Ping)
- `-PA` <port list> (TCP ACK Ping)
- `-PU` <port list> (UDP Ping)
- `-PY` <port list> (SCTP INIT Ping)
- `-PO` <protocol list>` (IP Protocol Ping)
- `-PR` (ARP Ping)
- `--disable-arp-ping` (No ARP or ND Ping)
- `-R` phân giải DNS tất cả các tagets
- `-sS` (TCP SYN scan)
- `-sT` (Kết nối TCP scan)
- `-sU` (UDP scan)
- `-sA` (TCP ACK scan)
- `-sW` (TCP Window scan)
- `-sO` (IP protocol scan)


**Read more:**
 
https://svn.nmap.org/nmap/docs/nmap.usage.txt

https://nmap.org/book/man-host-discovery.html

## Một số lệnh phổ biến

Quét hệ điều hành của server: 
  
    nmap -O remote_host

Sử dụng "-" hoặc "/24" để quét nhiều host / server cùng lúc 

    nmap -PN xxx.xxx.xxx.xxx-yyy

Quét một mạng rộng hơn 

    nmap -sP network_address_range

Quét mà không tra cứu DNS (Điều này sẽ giúp bạn quét nhanh hơn) 

    nmap -n remote_host

Quét một port cụ thể hoặc 1 dải thay vì quét chung các port thông dụng

    nmap -p port_number remote_host
    nmap -p <port ranges>

Quét kết nối TCP, Nmap sẽ thực hiện việc quét bắt tay 3 bước 

    nmap -sT remote_host


Quét kết nôi UDP

    nmap -sU remote_host

Quét TCP và UDP từng port (khá lâu)

    nmap -n -PN -sT -sU -p- remote_host

Quét TCP SYN scan (-sS):

    nmap -sS remote_host

Quét xác định phiên bản dịch vụ đang chyaj trên host

    nmap -PN -p port_number -sV remote_host


**Ví dụ:** 

    nmap -sS -sU -p U:53,4000, T:1-100,444 192.168.169.192

Trong trường hợp này nmap sẽ quét các port UDP 53 và 4000, quét các port TCP 444, từ 1 đến 100, từ 8000 đến 8010 bằng kỹ thuật SYN scan.

### Nmap hỗ trợ chạy các script đặc biệt NSE (Nmap Scrpting Engine)
Đọc thêm tại http://nmap.org/book/nse-usage.html#nse-categories

**Ví dụ:**  `nmap -Pn -p80 --traceroute --script traceroute-geolocation amazon.com`

### Nmap Output Formats
- `-oN <filespec>` normal output
- `-oX <filespec>` XML output
- `-oS <filespec>` Script kiddie output
- `-oG <filespec>` grepable output
- `-oA <basename> ` Output to all formats




Read more: http://www.mystown.com/2016/03/huong-dan-su-dung-nmap-e-scan-port-tren.html#ixzz4bY6xQJ6a


