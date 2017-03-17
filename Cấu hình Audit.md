#Audit 

##1. Overview

Auditd là dịch vụ được sử dụng với mục đích hỗ trợ kiểm soát hệ thống (system auditing). Nó chịu trách nhiệm ghi lại các sự kiện xảy ra trong hệ thống.

##Mục đích 
Audit có thể theo dõi nhiều loại sự kiện để giám sát và kiểm toán hệ thống. Ví dụ như:
* Audit file access and modification: 
	<ul>
  	<li>Xem ai truy cập một tập tin cụ thể</li>
  	<li>Phát hiện thay đổi trái phép</li></ul>	
* Giám sát cuộc gọi hệ thống và các function
* Phát hiện các bất thường như  crashing processes
* Set tripwires cho mục đích phát hiện xâm nhập
* Ghi các lệnh được sử dụng bởi người dùng cá nhân

###Các thành phần
- **kernel:**
<ul>
<li>**audit**: can thiệp vào kernel để bắt các sự kiện và cung cấp cho auditd</li>
</ul>
- **binaties:**
<ul>
<li>**auditd** : daemon để bắt các sự kiện và lưu trữ chúng (log file)</li>
<li>**auditctl** : là một công cụ để kiểm soát hành vi của các daemon trên bay, các quy tắc bổ sung,..</li>
<li>**audispd** : là một công cụ có thể được sử dụng để chuyển tiếp các thông báo sự kiện cho các ứng dụng khác thay vì viết chúng vào disk trong audit log</li>
<li>**aureport** : là công cụ để tạo ra và xem báo cáo audit (auditd.log)</li>
<li>**ausearch** : tìm kiếm và xem các sự kiện (auditd.log)</li>
<li>**autrace** : là một lệnh có thể được sử dụng để theo dõi một quá trình, sử dụng thành phần audit trong kernel để theo dõi những chương trình</li>
<li>**aulast** : similar to last, but instaed using audit framework</li>
<li>**aulastlog** : similar to lastlog, also using audit framework instead</li>
<li>**ausyscall** : map syscall ID and name</li>
<li>**auvirt** : hiển thị thông tin audit liên quan đến  virtual machines</li>
</ul>

###Các tập tin: 

<li>**audit.rules**: được sử dụng bởi auditctl để đọc những gì rules cần phải được sử dụng</li>
<li>**auditd.conf**: file cấu hình của auditd</li>


##2. Installation
Debian/Ubuntu: `apt-get install auditd audispd-plugins`

Red Hat/CentOS/Fedora: thường được cài đặt sẵn (package: audit and audit-libs)

##3. Configuration

Các cấu hình của trình nền kiểm toán được sắp xếp bởi hai tập tin, một cho các daemon chính nó ( auditd.conf ) và một cho các quy tắc sử dụng bởi auditctl tool( audit.rules ).

Như với hầu hết mọi thứ, sử dụng một khởi đầu sạch sẽ và không có bất kỳ quy tắc nạp. Quy tắc hoạt động có thể được xác định bằng cách chạy auditctl với tham số -l: ` auditctl -l `

Thời gian để bắt đầu với giám sát vài thứ, hãy nói những file / etc / passwd. Chúng tôi đặt một 'watch' trên các file bằng cách định nghĩa path và cho phép để tìm kiếm:

`auditctl -a exit,always -F path=/etc/passwd -F perm=wa`

Bốn option:
* r = read
* w = write
* x = execute
* a = attribute change

###Cấu hình đẩy log từ audit bằng rsyslog
##Trên server
####Cấu hình cho server nhận log theo UDP trên cổng 514

Trên file /etc/rsyslog.conf bỏ dấu `#` 2 dòng như hình dưới

<img src = "https://github.com/trangnth/Audit-Ubuntu-14.04/blob/master/img/rsyslog-conf-server-udp.png">

####Cấu hình vị trí lưu các log nhận được
Thêm các dòng như sau vào file /etc/rsyslog.conf:

```
$template TmplAuth,"/data/log/%HOSTNAME%/%PROGRAMNAME%.log"
Auth.*  ?TmplAuth
*.*    ?TmplAuth
& ~
```
<img src = "https://github.com/trangnth/Audit-Ubuntu-14.04/blob/master/img/rsyslog-conf-server.png">

##Trên client
####Cấu hình audit
* Cấu hình audit tạo log ghi lại lịch sử người dùng

Thêm đoạn sau vào trong /etc/audit/audit.rules
```
-a exit,always -F arch=b64 -S execve
-a exit,always -F arch=b32 -S execve
```

* Chuyển log của audit log sang rsyslog trong file `/var/log/syslog`

Trong file `/etc/audisp/plugins.d/syslog.conf ` sửa *active = no* sang *yes*

<img src = "https://github.com/trangnth/Audit-Ubuntu-14.04/blob/master/img/audit-conf.png">

Sau đó restart audit bằng lệnh: `/etc/init.d/auditd restart`

####Cấu hình rsyslog
* Cấu hình file /etc/rsyslog.d/60-output.conf

Thêm dòng sau:

<img src = "https://github.com/trangnth/Audit-Ubuntu-14.04/blob/master/img/60-output.png">

`@196.168.169.135:514` là địa chỉ server được đẩy đến bằng UDP theo cổng 514 (nếu là TCP thì trước địa chỉ server là @@).

Restart rsyslog: `service rsyslog restart`

###Kết quả:

Cuối cùng các log sẽ được lưu trên server theo đường dẫn đã được cấu hình.

Ví dụ: `/data/log/ubuntu` "ubuntu" là tên hostname của máy client

<img src = "https://github.com/trangnth/Audit-Ubuntu-14.04/blob/master/img/server2.png">

Log audit lưu trong file audispd.log (tên chương trình trong syslog)

<img src = "https://raw.github.com/trangnth/Audit-Ubuntu-14.04/master/img/server3.png">

Chẳng hạn khi ssh đến client và gõ một lệnh `tail -40 /var/log/syslog` log sẽ được tạo ra như hình dưới đây:

<img src = "https://github.com/trangnth/Audit-Ubuntu-14.04/blob/master/img/LOG.png">

Thông thường, khi chạy một lệnh log sẽ được tạo ra với 5 type (SYSCALL, EXECVE, CWD, PATH, EOE)

- Dòng `type=SYSCALL` chứa các thông tin về người dùng (ví dụ uid - User ID, pid - Process ID,  gid - Group ID,...)
- Dòng `type=EXECVE` cho biết lệnh đã được chạy => `argc=3 a0="tail" a1="-40" a2="/var/log/syslog"`
- Dòng `type=CWD` cho biết vị trí gõ lệnh => lệnh được thao tác trên thư mục `/root`

Chi tiết hơn về các tham số trên http://manpages.ubuntu.com/manpages/precise/man8/auditctl.8.html

##Tham khảo:
http://serverfault.com/questions/202044/sending-audit-logs-to-syslog-server

https://linux-audit.com/configuring-and-auditing-linux-systems-with-audit-daemon/

