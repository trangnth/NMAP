#  NMAP (Network Mapper)
## Khái niệm
Nmap (Network Mapper) là một công cụ quét, theo dõi và đánh giá bảo mật một hệ thống mạng được phát triển bởi Gordon Lyon (hay còn được biết đến với tên gọi Fyodor Vaskovich).

Nmap được công bố lần đầu tiên vào tháng 9 năm 1997.

Nmap là phần mềm mã nguồn mở miễn phí, ban đầu chỉ được phát triển trên nền tảng Linux sau đó được phát triển trên nhiều nền tảng khác nhau như Windows, Solari, Mac OS… và phát triển thêm phiên bản giao diện người dùng (zenmap).

Các chức năng của nmap:  
- Phát hiện host trong mạng.
- Liệt kê các port đang mở trên một host.
- Xác định các dịch vụ chạy trên các port đang mở cùng với phần mềm và phiên bản đang dùng.
- Xác đinh hệ điều hành của thiết bị.
- Chạy các script đặc biệt.

## Install
```
apt-get update
apt-get install nmap
```
## Scan với Nmap
Bắt đầu với các lệch cơ bản:
- Quét 1 IP	`nmap 192.168.1.1`
- Quét 1 dải IP	`nmap 192.168.1.1/24`
- Quét 1 domain	`nmap google.com`
- Quét 1 danh sách các mục tiêu từ 1 file với tùy chọn -iL	`nmap -iL list.txt`

Phát hiện các host trong mạng (host discovery)
- TCP SYN Ping:`–PS`
- TCP ACK Ping: `–PA`
- UDP Ping: `–PU`
- ARP Ping (sử dụng trong mạng LAN): `-PR`
- ICMP type 8 (echo request): `-PE`
- ICMP type 13 (timestamp request): `-PP`
- ICMP type 17(Address mask request): `-PA`

Khi gửi các gói tin trên tới 1 port của mục tiêu nếu nmap nhận được phản hồi (có thể là SYN-ACK, RST, các gói tin ICMP) thì nmap sẽ coi host đó tồn tại trong mạng, không quan tâm đến trạng thái của port. Nếu không nhận được gói tin phản hồi thì nmap sẽ coi là host không tồn tại. Mặc đinh nmap sử dụng gói tin ICMP echo request, ICMP timespam request, TCP SYN to port 443, TCP ACK to port 80, tương đương với 
```
–PE –PP –PS443 –PA80
```

- No port scan `-sn` sử dụng tùy chọn này để thực hiện quá trình discovery (nmap sẽ dừng lại sau khi xác định các host đang chạy và không thực hiện việc quét port). 
- Tùy chọn `Pn` để bỏ qua host discovery và chuyển qua quá trình quét port.
- Tùy chon `–F` (Fast scan): nmap quét 100 port phổ biến nhất thay vì mặc định 1000 port.
- Tùy chọn `–top-ports` : quét n port phổ biến nhất.
- Tùy chọn `–r`: thứ tự quét các port từ thấp lên cao thay vì mặc định là ngẫu nhiên.
## Một số lệnh phổ biến
Quét hệ điều hành của server: 
```
nmap -O remote_host
```
Sử dụng "-" hoặc "/24" để quét nhiều host / server cùng lúc 
```
nmap -PN xxx.xxx.xxx.xxx-yyy
```
Quét một mạng rộng hơn 
```
nmap -sP network_address_range
```
Quét mà không tra cứu DNS (Điều này sẽ giúp bạn quét nhanh hơn) 
```
nmap -n remote_host
```
Quét một port cụ thể thay vì quét chung các port thông dụng
```
nmap -p port_number remote_host
```
Quét kết nối TCP, Nmap sẽ thực hiện việc quét bắt tay 3 bước 
```
nmap -sT remote_host
```

Quét kết nôi UDP
```
nmap -sU remote_host
```
Quét TCP và UDP từng port (khá lâu)
```
nmap -n -PN -sT -sU -p- remote_host
```
Quét TCP SYN scan (-sS):
```
nmap -sS remote_host
```
Quét xác định phiên bản dịch vụ đang chyaj trên host
```
nmap -PN -p port_number -sV remote_host
```

**Ví dụ:** 
```
nmap -sS -sU -p U:53,4000, T:1-100,444 192.168.169.192
```
Trong trường hợp này nmap sẽ quét các port UDP 53 và 4000, quét các port TCP 444, từ 1 đến 100, từ 8000 đến 8010 bằng kỹ thuật SYN scan.

### Nmap hỗ trợ chạy các script đặc biệt NSE (Nmap Scrpting Engine)
Đọc thêm tại http://nmap.org/book/nse-usage.html#nse-categories

Ví dụ: `nmap -Pn -p80 --traceroute --script traceroute-geolocation amazon.com`





Read more: http://www.mystown.com/2016/03/huong-dan-su-dung-nmap-e-scan-port-tren.html#ixzz4bY6xQJ6a
