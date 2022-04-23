===============================
= Họ và tên: Huỳnh Văn Thạnh. =    
= Lớp      : 19PFIEV3.        =
===============================

Cấu trúc folder:
- TinhHieuKiemThu
   + phone_F2.wav
   + phone_M2.wav
   + studio_F2.wav
   + studio_M2.wav
- main: file chính dùng để chạy chương trình.
- autoCorrelation: hàm dùng để tính độ tự tương quan cho 1 frame.
- ChiaKhung: hàm dùng để chia khung.
- ChuanHoa: hàm dùng để chuẩn hoá dữ liệu nằm trong khoảng từ [-1, 1].
- ChuanHoaACF: hàm dùng để chuẩn hoá dữ liệu nằm trong khoảng từ [0, 1].
- findMeanStd: hàm để tính ra giá trị trung bình và độ lệch chuẩn của các F0 trong dữ liệu tín hiệu.
- findThreshold: hàm dùng để tìm ngưỡng phân biệt voiced và uncoiced.
- TimDinhCucBo: hàm dùng để tìm đỉnh cục bộ của 1 frame, trả ra giá trị và vị trí của đỉnh đó.
- TimF0: hàm dùng để tính ra giá trị F0 khi biết được vị trí của đỉnh cục bộ.