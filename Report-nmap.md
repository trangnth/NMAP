# Kết quả trên Kibana

### Để xem kết quả thì vào Mannagement -> Index Patters -> add new và điền thông tin như trong hình

<img src = "img/1.png">

Sau đó có thể xem kết quả trong Discover

<img src = "https://raw.github.com/trangnth/NMAP/master/img/2.png">

### Tạo báo cáo trên kibana

Trong Discover tìm kiếm với từ khóa `*Pots` rồi lưu lại với tên `nmap-results` để xem kết quả quét được

<img src = "https://github.com/trangnth/NMAP/blob/master/img/3.png">

Tiếp tục với từ khóa `*done*` để xem thời gian quét xong, quét bao nhiêu host, quét trong bao lâu, lưu với tên `Scan Done`

<img src = "https://github.com/trangnth/NMAP/blob/master/img/4.png">

Vào Dashboard chọn add -> Saved Search add `Scan Done` và `nmap-results` và lưu lại với tên `Nmap-report`

<img src = "https://raw.github.com/trangnth/NMAP/master/img/5.png">

Báo cáo 

<img src = "https://github.com/trangnth/NMAP/blob/master/img/6.png"> 
