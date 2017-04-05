# NMAP SCAN

    Ubuntu 14.04
    Rsyslog-v8
    Nmap v7.12

## File rsyslog-v8.install.sh
Cài đăt rsyslog v8 để đẩy file nmap.results tới rsyslog server

## File nmap-7.12.install.sh
Cài đặt nmap v7.12 

Check version, nếu chưa có thì cài v7.12, có rồi thì check xem đúng phiên bản cần không, không đúng thì gỡ đi cài lại.

## File nmap.scan.sh
Check file config xem có được quét không

Check file results.log, nếu đã tồn tại thì xóa đi tạo file mới

Add config rsyslog theo cấu trúc của v8 để đầy file nmap.results.log về server

Scan và save vào file results

Sửa một số thứ cho phù hợp như server, port, path. 

## File nmap.conf
Gồm có 3 dòng, vd: `RUN  y` dùng `tab` để phân cách

- Dòng 1: `y` hoặc `n` để check xem có đc quét ko
- Dòng 2: là target-scan có thể là 1 ip, range ip, subnet. Ví dụ

      192.168.169.192
      192.168.169.100-200
      192.168.169.0/24
      google.com


- Dòng 3: là các tùy chọn quét: TCP, UDP hay port

      -sT : quét TCP
      -sU : quét UDP
      -p U:53,4000, T:1-100,444 : quét port UDP 53 và 4000, quét TCP port từ 1 đến 100 và port 444

**Tất cả các file trên đều để trong /home/huyentrang/nmap**

**File config rsyslog /etc/rsyslog.d**

**File kết quả quét /var/log/nmap.results.log**

## Tạo crontab  
Tạo crontab để check file config 1h 1 lần xem có quét hay không

Gõ `crontab -e` thêm dòng sau:

    0 * * * * sh /home/huyentrang/nmap/nmap.scan.sh
