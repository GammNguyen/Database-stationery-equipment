create database QuanLyBanHang_NguyenThiGam
go

create table tblLoaiHang
(
sMaloaihang nvarchar(10) primary key not null,
sTenloaihang nvarchar(30) not null
)

create table tblNhaCungCap
(
iMaNCC int Identity(1,1) primary key not null,
sTenNhaCC nvarchar(50) not null,
sTengiaodich nvarchar(50) not null,
sDiachi nvarchar(50) not null,
sDienThoai nvarchar(12) not null
)

create table tblMatHang
(
sMahang nvarchar(10) primary key not null,
sTenhang nvarchar(30) not null,
iMaNCC int not null,
sMaloaihang nvarchar(10) not null,
fSoluong float not null,
fGiahang float not null,
constraint FK_tblMatHang_iMaNCC foreign key (iMaNCC) references tblNhaCungCap(iMaNCC),
constraint FK_tblMatHang_sMaloaihang foreign key (sMaloaihang) references tblLoaiHang(sMaloaihang) 
)

create table tblKhachHang
(
iMaKH int primary key not null,
sTenKH nvarchar(30) not null,
sDiachi nvarchar(50) not null ,
sDienThoai nvarchar(12) not null,
dNgaysinh date not null
)

create table tblNhanVien
(
iMaNV int primary key not null,
sTenNV nvarchar(30) not null,
sDiachi nvarchar(50) not null ,
sDienThoai nvarchar(12) not null,
dNgaySinh date not null,
dNgayvaolam date not null,
fLuongcoban float not null,
fPhucap float not null,
sCMND nvarchar(20) unique
)


-- Thiết lập ràng buộc ngày vào làm việc so với ngày sinh tối thiểu đủ 18 tuổi
alter table tblNhanvien add check (Datediff(day,dNgaysinh,dNgayvaolam)>=18)
--Thêm cột sDonvitinh cho bảng Mặt hàng.
alter table tblMatHang add sDonvitinh nvarchar(10) not null

create index ChiMucTH on tblMathang(sTenhang)

create table tblDonNhapHang
(
iSoHD int primary key not null,
iMaNV int not null,
dNgaynhaphang date not null,
constraint FK_tblDonNhapHang_iMaNV foreign key (iMaNV) references tblNhanvien(iMaNV)
)

-- Trong bảng tblChiTietNhapHang đảm bảo ràng buộc 
-- fGianhap > 0
-- fSoLuongNhap > 0
create table tblChiTietNhapHang
(
iSoHD int not null,
sMahang nvarchar(10) not null,
fGianhap float constraint CK_GN check (fGianhap>0) not null,
fSoluongnhap float constraint CK_SLN check (fSoluongnhap>0) not null,
primary key (iSoHD,sMahang),
constraint FK_tblChiTietNhapHang_iSoHD foreign key (iSoHD) references tblDonNhapHang(iSoHD),
constraint FK_tblChiTietNhapHang_sMahang foreign key (sMahang) references tblMathang(sMahang)
)

alter table tblKhachHang add bGioitinh bit not null;

create table tblDonDatHang
(
iSoHD int primary key not null,
iMaNV int not null,
iMaKH int not null,
dNgaydathang date constraint DFT_NDH default getdate(),
dNgaygiaohang date not null,
sDiachigiaohang nvarchar(50) not null,
constraint FK_tblDonDatHang_iMaNV foreign key (iMaNV) references tblNhanVien(iMaNV),
constraint FK_tblDonDatHang_iMaKH foreign key (iMaKH) references tblKhachHang(iMaKH)
)

-- dNgaygiaohang luôn lớn hơn hoặc bằng dNgaydathang
-- dNgaydathang mặc định bằng thời gian hiện tại và luôn nhỏ hơn hoặc bằng thời gian hiện tại
alter table tblDonDatHang
add check (year(month(day(dNgaygiaohang))) >= year(month(day(dNgaydathang)))),
    check (year(month(day(dNgaydathang))) <= getdate())

--Trong bảng tblChiTietDatHang, đảm bảo rằng:
-- fGiaban>0
-- fSoluongMua>0
-- fMucgiamgia>=0
create table tblChiTietDatHang 
(
iSoHD int not null,
sMahang nvarchar(20) not null,
fGiaban float constraint CK_GB check (fGiaban >0),
fSoluongmua float constraint CK_SLM check (fSoluongmua >0),
fMucgiamgia float constraint CK_MGG check (fMucgiamgia >=0 ),
)
-- Trong bảng tblChiTietDatHang, sửa cấu trúc trường sMaHang sang kiểu kí tự có độ dài 10
alter table tblChiTietDatHang 
alter column sMahang nvarchar(10) not null

alter table tblChiTietDatHang 
add
primary key (iSoHD,sMaHang),
constraint FK_tblChiTietDatHang_iSoHD foreign key (iSoHD) references tblDonDatHang(iSoHD),
constraint FK_tblChiTietDatHang_sMahang foreign key (sMahang) references tblMatHang(sMahang)

insert into tblLoaiHang(sMaloaihang, sTenloaihang)
values(N'B00', N'Bút'),
      (N'V00', N'Vở viết'),
      (N'ST00',N'Sổ tay')
	  
select * from tblLoaiHang 

insert into tblNhaCungCap(sTenNhaCC, sTengiaodich,sDiachi,sDienThoai)
values
( N'Nhà Máy SX Xưởng A',N'GD Bút',N'Hà Nội',N'0230242932'),
( N'Nhà Máy SX Xưởng B',N'GD Sổ tay',N'Thái Bình',N'0234234322'),
( N'Nhà Máy SX Xưởng C',N'GD Vở viết',N'Nam Định',N'0482827391')

select * from tblNhaCungCap

insert into tblMatHang(sMahang, sTenhang, iMaNCC, sMaloaihang, fSoluong, fGiahang, sDonvitinh)
values
(N'BC01',N'Bút chì',1,N'B00',15,4000,N'Cây'),
(N'BB02',N'Bút bi',1,N'B00',20,3000,N'Cây'),
(N'BL03',N'Bút lông',1,N'B00',10,6000,N'Cây')

insert into tblMatHang(sMahang, sTenhang, iMaNCC, sMaloaihang, fSoluong, fGiahang, sDonvitinh)
values
(N'ST01',N'Sổ tay loại 1',2,N'ST00',12,40000,N'Quyển'),
(N'ST02',N'Sổ tay loại 2',2,N'ST00',8,45000,N'Quyển'),
(N'ST03',N'Sổ tay loại 3',2,N'ST00',0,37000,N'Quyển')

insert into tblMatHang(sMahang, sTenhang, iMaNCC, sMaloaihang, fSoluong, fGiahang, sDonvitinh)
values
(N'VV01',N'Vở 80 trang',3,N'V00',50,7000,N'Quyển'),
(N'VV02',N'Vở 120 trang',3,N'V00',30,9000,N'Quyển'),
(N'VV03',N'Vở 200 trang',3,N'V00',20,12000,N'Quyển')

select * from tblMatHang

-- Xóa mặt hàng có số lượng = 0
delete from tblMatHang
where fSoluong=0

-- Tăng phụ cấp 10% cho những nhân viên có thâm niên làm việc 5 năm trở lên
update tblNhanVien
set fPhucap=fPhucap+fPhucap*0.1
where datediff(day,dNgayvaolam,getdate())/365>=5

insert into tblKhachHang(iMaKH,sTenKH,sDiachi,sDienThoai,bGioitinh,dNgaysinh)
values
(1,N'Nguyễn Thị Lan',N'Nam Định','0845712489',0,'1999-06-18'),
(2,N'Phạm Đức Anh',N'Hà Nội','0987124578',1,'2000-01-08'),
(3,N'Nguyễn Hoàng Đức',N'Thái Bình','0947124723',1,'2002-05-21')

select * from tblKhachHang

insert into tblNhanVien(iMaNV,sTenNV,sDiachi,sDienThoai,dNgaySinh,dNgayvaolam,fLuongcoban,fPhucap,sCMND)
values
(1,N'Đặng Thị Hoa',N'Hải Dương','0123457824','1999-06-07','2019-10-20',6000000,550000,'0302002157'),
(2,N'Phan Thế Vinh',N'Thanh Xuân','0912417358','2001-07-29','2020-05-16',4000000,300000,'0352148548'),
(3,N'Trần Hồng Nhung',N'Trương Định','0987012437','1998-07-17','2020-04-10',5000000,450000,'0361478213')

select * from tblNhanVien

insert into tblDonDatHang(iSoHD,iMaNV,iMaKH,dNgaydathang,dNgaygiaohang,sDiachigiaohang)
values
(1,2,3,'2020-05-10','2020-05-20',N'Thái Bình'),
(2,1,2,'2016-07-03','2016-07-15',N'Hà Nội'),
(3,3,1,'2019-09-19','2019-09-27',N'Nam Định')

select * from tblDonDatHang

insert into tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
values
(1,N'BL03',7000,7,0.2),
(1,N'BB02',3500,6,0),
(2,N'ST01',50000,3,0.2),
(2,N'ST02',55000,2,0.3),
(3,N'VV01',8000,4,0.1),
(3,N'VV03',15000,5,0.2)

select * from tblChiTietDatHang

--Thực hiện cho phép mức giảm giá là 10% cho các mặt hàng bán trong tháng 7 năm 2016
update tblChiTietDatHang
set fMucgiamgia = 0.1
from tblChiTietDatHang,tblDonDatHang
where tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD
and year(dNgaydathang)=2016 and month(dNgaydathang)=7

insert into tblDonDatHang(iSoHD,iMaNV,iMaKH,dNgaydathang,dNgaygiaohang,sDiachigiaohang)
values
(4,1,2,'2020-08-25','2020-09-06',N'Hà Đông'),
(5,1,2,'2019-07-01','2019-07-10',N'Bắc Từ Liêm'),
(6,2,2,'2020-02-27','2020-03-05',N'Long Biên'),
(7,2,3,'2020-12-03','2020-12-12',N'Cầu Giấy'),
(8,3,3,'2020-10-28','2020-11-06',N'Hoàng Mai'),
(9,3,3,'2018-02-10','2018-02-20',N'Thanh Xuân')

select * from tblDonDatHang

insert into tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
values
(4,N'BC01',5000,10,0.2),
(4,N'BB02',3500,12,0.1),
(4,N'BL03',7000,15,0.3),
(5,N'ST01',50000,9,0.4),
(5,N'ST02',55000,10,0.4),
(5,N'VV01',8000,8,0.3),
(6,N'ST01',50000,7,0.3),
(6,N'VV02',10000,9,0.2),
(6,N'VV03',15000,15,0.3),
(7,N'ST02',55000,12,0.5),
(7,N'BL03',7000,35,0.5),
(7,N'VV01',8000,10,0.3),
(8,N'BB02',3500,13,0.1),
(8,N'BC01',5000,15,0.3),
(8,N'VV02',10000,15,0.4)

select * from tblChiTietDatHang

insert into tblKhachHang(iMaKH,sTenKH,sDiachi,sDienThoai,bGioitinh,dNgaysinh)
values 
(4,N'Triệu Hải Anh',N'TP Hồ Chí Minh',N'0394223283',0,'2002-11-08'),
(5,N'Đào Hải Yến',N'Hải Phòng',N'0847124576',0,'2001-05-25')

select * from tblKhachHang

insert into tblDonDatHang(iSoHD,iMaNV,iMaKH,dNgaydathang,dNgaygiaohang,sDiachigiaohang)
values
(10,1,3,'2020-02-15','2020-02-25',N'Thái Bình'),
(11,3,4,'2021-03-04','2021-03-13',N'TP Hồ Chí Minh'),
(12,2,1,'2020-05-04','2020-05-15',N'Nam Định'),
(13,1,5,'2021-06-24','2021-07-03',N'Hải Phòng')

select * from tblDonDatHang

insert into tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
values
(10,N'VV03',15000,4,0.1),
(11,N'TT04',300000,5,0.3),
(11,N'BC01',5000,6,0),
(12,N'TT01',100000,7,0.2),
(12,N'TT05',120000,4,0.2),
(13,N'TT02',250000,9,0.3),
(13,N'TT03',110000,3,0.1)

select * from tblChiTietDatHang

insert into tblDonNhapHang(iSoHD,iMaNV,dNgaynhaphang)
values
(20,3,'2017-03-17'),
(21,1,'2016-08-12'),
(22,2,'2017-06-24')

select * from tblDonNhapHang

insert into tblChiTietNhapHang(iSoHD,sMahang,fGianhap,fSoluongnhap)
values
(20,N'BC01',4000,100),
(20,N'ST02',40000,150),
(21,N'VV03',12000,90),
(21,N'TT05',80000,250),
(22,N'ST01',45000,80),
(22,N'TT03',70000,200)

select * from tblChiTietNhapHang

-- Cho biết những mặt hàng nào có số lượng dưới 100 (tblMatHang)
select sTenHang from tblMatHang
where fSoluong < 100

--Tạo View số mặt hàng của từng loại hàng
create view vw31b_SoMatHang
as
select sTenloaihang, count(sMahang) as [Số mặt hàng]
from tblMatHang,tblLoaiHang
where tblMatHang.sMaloaihang = tblLoaiHang.sMaloaihang
group by sTenloaihang

select * from vw31b_SoMatHang

-- Cho biết số tiền phải trả của từng đơn đặt hàng
create view vw31c_TienTraDDH
as
select iSoHD, sum(fGiaban*fSoluongmua*(1-fMucgiamgia)) as [Tổng tiền]
from tblChiTietDatHang
group by iSoHD

select * from vw31c_TienTraDDH
-- Cho biết tổng số tiền hàng thu được trong mỗi tháng của năm 2016 (tính theo ngày đặt hàng)
create view vw31d_Tongtienhang2016
as
select month(dNgaydathang)as [Tháng], sum(fGiaban*fSoluongmua*(1-fMucgiamgia)) as [Tổng tiền hàng mỗi tháng ]
from tblDonDatHang inner join tblChiTietDatHang
on tblChiTietDatHang.iSoHD=dbo.tblDonDatHang.iSoHD
where year(dNgaydathang) = 2016
group by month(dNgaydathang)

select * from vw31d_Tongtienhang2016

-- Trong năm 2016, những mặt hàng nào chỉ được đặt mua đúng một lần
create view vw31e_MatHangMua1Lan
as 
select tblMatHang.sMahang,sTenHang
from tblChiTietDatHang inner join tblMatHang on tblChiTietDatHang.sMahang = tblMatHang.sMahang
inner join tblDonDatHang on tblChiTietDatHang.iSoHD=tblDonDatHang.iSoHD
where year(dNgayDatHang)= 2016
group by tblMatHang.sMahang,sTenhang
having count(tblChiTietDatHang.sMahang)= 1

select * from vw31e_MatHangMua1Lan

-- Tạo View tính tổng tiền hàng và tổng số mặt hàng của từng đơn nhập hàng
create view vw32aTTH_TSMH
as 
select iSoHD,sum(fGianhap*fSoluongnhap) as [Tổng tiền hàng nhập],
count(sMahang) as [Tổng số mặt hàng nhập]
from tblChiTietNhapHang
group by iSoHD

select * from vw32aTTH_TSMH

-- Cho biết danh sách tên các mặt hàng mà không được nhập về trong tháng 6 năm 2017 
create view vw32bMHKNV
as
select sTenhang from tblMatHang
where sMahang not in
(select sMahang 
from tblChiTietNhapHang inner join tblDonNhapHang 
on tblChiTietNhapHang.iSoHD=tblDonNhapHang.iSoHD
where year(dNgaynhaphang) = 2017 
and month(dNgaynhaphang)= 6)

select * from vw32bMHKNV

--Cho biết tên nhà cung cấp đã cung cấp những mặt hàng thuộc một loại 
--hàng xác định nào đó (phụ thuộc dữ liệu nhập vào - Ví dụ: Vở viết )
create view vw32c_TenNCC
as
select sTenNhaCC,sTenhang
from tblMatHang inner join tblNhaCungCap
on tblMatHang.iMaNCC = tblNhaCungCap.iMaNCC
inner join tblLoaiHang
on tblMatHang.sMaloaihang = tblLoaiHang.sMaloaihang
where sTenloaihang = N'Vở viết'

select * from vw32c_TenNCC

-- Cho biết tổng số tiền hàng đã bán được của từng nhân viên trong năm 2016 
create view vw32e_TongTienNV2016
as
select tblNhanVien.iMaNV,sTenNV, sum(fGiaban*fSoluongmua*(1-fMucgiamgia)) as [Tổng số tiền bán hàng năm 2016]
from tblNhanVien left join tblDonDatHang on tblNhanVien.iMaNV = tblDonDatHang.iMaNV
left join tblChiTietDatHang on tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD
where year(dNgaydathang) = 2016
group by sTenNV,tblNhanVien.iMaNV

select * from vw32e_TongTienNV2016

--Lấy danh sách các khách hàng Nam và Tổng tiền đặt hàng của mỗi người
create view vw33c_TongtienhangKHNam
as
select sTenKH,
case
when sum(fGiaban*fSoluongmua*(1-fMucgiamgia)) is null then 0
when sum(fGiaban*fSoluongmua*(1-fMucgiamgia)) is not null then sum(fGiaban*fSoluongmua*(1-fMucgiamgia))
end
as [Tổng tiền hàng]
from tblKhachHang left join tblDonDatHang
on tblKhachHang.iMaKH = tblDonDatHang.iMaKH
left join tblChiTietDatHang
on tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD
where bGioitinh = 1
group by sTenKH

select * from vw33c_TongtienhangKHNam

-- Tạo View thống kê số lượng khách hàng theo Giới tính
create view vw33d_SLKHtheoGT
as
select bGioitinh,
case
when bGioitinh = 1 then N'Nam'
when bGioitinh = 0 then N'Nữ'
end
as [Giới tính],
count(sTenKH) as [Tổng số khách hàng]
from tblKhachHang
group by bGioitinh

select * from vw33d_SLKHtheoGT

-- Tạo View cho xem danh sách 3 khách hàng mua hàng nhiều lần nhất
create view vw33e_DSKHMNN
as
select top 3 sTenKH,count(iSoHD) as [Số lượng mua]
from tblKhachHang, tblDonDatHang 
where tblKhachHang.iMaKH=tblDonDatHang.iMaKH
group by sTenKH
order by count(iSoHD) desc

select * from vw33e_DSKHMNN

-- Tạo View cho xem danh sách mặt hàng và giá bán trung bình của từng mặt hàng 
create view vw33f_DSMH_TTB
as
select sTenhang , avg(fGiaban) as [ Giá trung bình ]
from tblMatHang inner join tblChiTietDatHang 
on tblMatHang.sMahang= tblChiTietDatHang.sMahang
group by sTenhang

select * from vw33f_DSMH_TTB

-- Cập nhật giá bán(tblMatHang.fGiaHang) theo qui tắc: 
--Giá bán 1 mặt hàng = Giá mua lớn nhất trong vòng 30 ngày của mặt hàng đó + 10% 
create view vw33gMathang_GiaBanMax
as
	select  tblMatHang.sMahang, max(fGiaban) as [Max]
	from  tblChiTietDatHang, tblDonDatHang ,tblMatHang
	where  tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD
	and tblMatHang.sMahang= tblChiTietDatHang.sMahang
	and datediff(day,dNgaydathang,getdate())<= 30
	group by tblMatHang.sMahang
drop view vw33gMathang_GiaBanMax

update tblMathang
set tblMathang.fGiahang = [Max] *1.1
from vw33gMathang_GiaBanMax
where tblMathang.sMahang = vw33gMathang_GiaBanMax.sMahang

select * from vw33gMathang_GiaBanMax

-- Tạo thủ tục có tham số truyền vào là năm cho biết các mặt hàng không bán được trong năm đó
create proc pr_41a_MHkoban 
@nam int
as
begin
    select sTenHang, sMahang
    from tblMatHang
    where sMahang not in 
            (select sMahang 
             from tblChiTietDatHang,tblDonDatHang
             where tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD and year(dNgayDatHang) = @nam)
end

exec pr_41a_MHkoban @nam=2020
go

-- Viết thủ tục:
-- Tham số truyền vào: số lượng hàng và năm
-- Thực hiện tăng lương cơ bản lên gấp rưỡi cho những nhân viên bán 
-- được số lượng hàng nhiều hơn số lượng hàng truyền vào trong năm đó
create proc pr_41b_tangluongNV
@SL int, @nam int
as
begin
   update tblNhanVien
   set fLuongcoban = fLuongcoban *1.5
   where tblNhanVien.iMaNV in
              (select tblNhanVien.iMaNV
			   from tblDonDatHang inner join tblChiTietDatHang
			   on tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD
			   where year(dNgayDatHang) = @nam
			   group by iMaNV
			   having sum(fSoluongmua) > @SL)
end

exec pr_41b_tangluongNV @SL=10, @nam = 2020
go

-- Tạo thủ tục thống kê tổng số lượng hàng bán được của một mặt hàng có 
-- mã hàng là tham số truyền vào
create proc pr_41c_tongSLHangtheoma
@Mahang nvarchar(10)
as
begin
     select sTenHang, 
	 case
     when sum(fSoluongmua) is null then 0
     when sum(fSoluongmua) is not null then sum(fSoluongmua)
     end
	 as [Tổng số lượng hàng bán được]
	 from tblMatHang inner join tblChiTietDatHang
	 on tblMatHang.sMahang = tblChiTietDatHang.sMahang
	 where tblMatHang.sMahang = @Mahang
	 group by sTenHang
end

exec pr_41c_tongSLHangtheoma @Mahang = 'BC01'
go

--Tạo thủ tục có tham số truyền vào là năm, cho biết tổng số tiền hàng thu được trong năm đó
create proc pr_41d_Tongtienhangtheonam
@nam int
as
begin
   select year(dNgayDatHang) as [Năm], sum(fGiaban*fSoluongmua*(1-fMucgiamgia)) as [Tổng số tiền hàng]
   from tblDonDatHang inner join tblChiTietDatHang
   on tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD
   where year(dNgayDatHang) = @nam
   group by year(dNgayDatHang)
end

exec pr_41d_Tongtienhangtheonam @nam=2020
go

-- Viết trigger cho bảng tblChiTietDatHang để sao cho khi thêm 1 bản ghi 
-- hoặc khi sửa tblChiTietDatHang.fGiaban chỉ chấp nhận giá bán ra phải lớn hơn hoặc bằng giá gốc (tblMatHang.fGiaHang)
create trigger tg_41e_giaban_giagoc
on tblChiTietDatHang
for insert, update
as
begin 
    if update(fGiaban)
	declare @mahang nvarchar(10), @giaban float, @giagoc float
	select @mahang=sMahang,@giaban=fGiaban from inserted
	select @giagoc=fGiahang from tblMatHang
	where sMahang=@mahang

		if(@giaban>=@giagoc)
		begin 
		    update tblChiTietDatHang set fGiaban = @giaban where sMahang = @mahang
	    end
		else
		begin
		   print N'Giá bán phải lớn hơn hoặc bằng giá gốc, mời nhập lại'
		   rollback tran
		end
end

update tblChiTietDatHang set fGiaban = 150000 where sMahang=N'TT02'
go

-- Viết trigger để đảm bảo lượng hàng bán  ra không vượt quá lượng hàng hiện có
alter trigger tg_41f_hangbanra_kovuot_hanghienco
on tblChiTietDatHang
for insert, update
as
begin
	declare @mahang nvarchar(10), @SLban float, @SLco float
	select @mahang=sMahang, @SLban=fSoluongmua from inserted
	select @SLco = fSoluong from tblMatHang 
	where sMahang=@mahang

	if(@SLban<@SLco)
	begin
	   update tblMatHang set @SLco = @SLco - @SLban
	   where sMahang = @mahang
	end
	else
	   begin
	     print N'số lượng bán không được vượt quá số lượng hàng hiện có, mời nhập lại'
	     rollback tran
       end
end

insert tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
values(2,N'BB02',3500,22,0.3)
go

-- Tạo thủ tục để bổ sung thêm một bản ghi mới cho tblDonDatHang (thủ tục cần kiểm tra 
--tính hợp lệ của dữ liệu cần bổ sung như: dNgaydathang phải <= ngày hiện tại và dNgaygiaohang phải >= dNgaydathang)
create proc pr_42a_ThembanghiDDH 
@soHD int,@manv int,@maKH int ,@ngaydathang date, @ngaygiaohang date,@diachi nvarchar(50)
as
begin
    if exists(
		select iSoHD
		from tblDonDatHang
		where iSoHD=@soHD)
		print(N'Mã hóa đơn này đã tồn tại')
	
	else if(@ngaydathang<=getdate() and @ngaygiaohang>=@ngaydathang)
	insert into tblDonDatHang values(@soHD,@manv,@makh,@ngaydathang,@ngaygiaohang,@diachi)
	else
	print(N'Ngày đặt hàng và ngày giao hàng bạn nhập không hợp lệ')
end

exec pr_42a_ThembanghiDDH 13,2,4,'2021-10-12','2021-10-20',N'Hà Nội'

exec pr_42a_ThembanghiDDH 14,2,4,'2021-10-12','2021-10-20',N'Hà Nội'
go

--Thêm cột TongTienHang (float) vào bảng tblKhachHang, tạo trigger sao cho 
--giá trị TongTienHang tự động tăng lên mỗi khi khách hàng đến tham gia mua hàng tại cửa hàng
alter table tblKhachHang
add TongTienHang float

update tblKhachHang set TongTienHang=0
go

create trigger tg_42b_TTHtang_muahang
on tblChiTietDatHang
after insert
as
begin
    declare @Tong float, @MaKH int,@SoHD int
	select @SoHD= iSoHD, @Tong=sum(fGiaban* fSoluongmua*(1-fMucgiamgia)) from inserted group by iSoHD
	select @MaKH=iMaKH from tblDonDatHang 
	where iSoHD=@SoHD

	update tblKhachHang
	set TongTienHang=TongTienHang+@Tong
	where iMaKH=@maKH
end

insert tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
values(14,N'TT01',100000,12,0.3)

select * from tblChiTietDatHang
select * from tblKhachHang
go

-- Thêm cột TongSoMatHang(float) vào bảng tblDONDATHANG, tạo trigger sao cho giá trị của 
--TongSoMatHang tự động tăng lên mỗi khi bổ sung thêm một mặt hàng khách đặt mua trong đơn đặt hàng tương ứng
alter table tblDonDatHang
add TongSoMatHang float

update tblDonDatHang set TongSoMatHang=0
go

create trigger tg_42e_TongSMHtang_KHmua
on tblChiTietDatHang
for insert
as
begin
    declare @SoHD int
    select @soHD=iSoHD from inserted
	update tblDonDatHang set TongSoMatHang = TongSoMatHang + 1 
	where iSoHD = @SoHD
end

insert tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
values(12,N'TT02',250000,7,0.2)

select * from tblChiTietDatHang
select * from tblDonDatHang
go

--Tạo Stored Procedure thêm dữ liệu cho bảng tblMatHang theo các tham số truyền vào
create proc pr_43a_ThemDLMatHang 
@maHang nvarchar(10),@tenHang nvarchar(30),@maNCC int,@maLoaiHang nvarchar(10),
@soLuong float,@giaHang float,@donViTinh nvarchar(10)
as
begin
    insert into tblMatHang(sMahang,sTenhang,iMaNCC,sMaloaihang,fSoluong,fGiahang,sDonvitinh)
    values(@maHang,@tenHang,@maNCC, @maLoaiHang,@soLuong,@giaHang,@donViTinh)
end

exec pr_43a_ThemDLMatHang N'BM04',N'Bút máy',1,'B00',30,30000,N'Cây'

select * from tblMatHang
go

-- Tạo Stored Procedure:
--○ Nhận vào các tham số: Giá trị, Mức giảm giá
--○ Thực hiện giảm giá cho các mặt hàng được đặt trong tháng hiện tại,
--có (fGiaban*fSoluongmua)>=Giá trị và đang có fMucGiamgia=0.

create proc pr_43b_GiamGiaMHHienTai
@giaTri float, @mucGG float
as
begin
			declare @maHang nvarchar(10)
			select @maHang = sMaHang 
			from tblChiTietDatHang inner join tblDonDatHang 
			on tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD
			where month(dNgaydathang) = month(getdate())

			update tblChiTietDatHang set fGiaban= fGiaban - fGiaban*@mucGG
			where sMahang = @maHang and fMucgiamgia =0
			and (fGiaban *fSoluongmua) >=@giaTri
end

exec pr_43b_GiamGiaMHHienTai 30000,0.2

--Tạo tài khoản đăng nhập SQL Server có tên 'Capnhat'
create login capnhat
with password ='1234a'

-- Tạo user trong DB tương ứng với login 'Capnhat' và thực hiện cấp quyền Insert, Update, Delete
create user nguoidungCN
for login capnhat

grant update, insert, delete
on tblMatHang
to nguoidungCN

-- Kiểm trả kết quả phân quyền bằng việc thực hiện lệnh Select, Insert trên bảng bất kì
insert into tblMatHang(sMahang, sTenhang, iMaNCC, sMaloaihang, fSoluong, fGiahang, sDonvitinh)
values (N'ST03',N'Sổ tay loại 3',2,N'ST00',8,47000,N'Quyển')

select * from tblMatHang

--Tạo user đăng nhập SQL Server có tên "BanHang" và thực hiện 
-- cấp quyền Insert trên bảng tblDONDATHANG và tblCHITIETDATHANG
create login banhang
with password ='bh123'

create user BanHang
for login banhang

grant insert on tblDonDatHang to Banhang
grant insert on tblChiTietDatHang to Banhang

--Tạo 1 tài khoản SQL server login với tên truy cập "U1" và mật khẩu là "a1b2c3"
create login U1
with password ='a1b2c3'

-- Tạo 1 user trong DB của bài tập này cho U1
create user u1
for login U1

-- Cho phép cho U1 được toàn quyền trên bảng tblKhachHang
grant all on tblKhachHang to u1

--Tạo Role có tên "BPNhapHang" và cấp quyền:
-- Được Thêm và Xem dữ liệu của tblNhaCungCap,tblDonNhapHang, tblChiTietNhapHang
-- Được Xem dữ liệu của tblNhanvien, tblMatHang
-- Cấm Thêm, Sửa, Xoá trên bảng tblKhachHang
create role BPNhapHang

grant insert,select on tblNhaCungCap to BPNhapHang
grant insert,select on tblDonNhapHang to BPNhapHang
grant insert,select on tblChiTietNhapHang to BPNhapHang

grant select on tblNhanVien to BPNhapHang
grant select on tblMatHang to BPNhapHang

deny insert,update,delete on tblKhachHang to BPNhapHang1

-- Đưa U1 vào làm thành viên của role BPNhapHang. Kiểm tra kết quả phân quyền bằng việc:
-- Thêm 1 đơn nhập hàng với 3 mặt hàng cần nhập (bất kì)
-- Thêm 1 Khách hàng bất kì

exec sp_addrolemember 'BPNhapHang','u1'

alter role BPNhapHang add member u1

insert into tblDonNhapHang(iSoHD,iMaNV,dNgaynhaphang)
values(23,1,'2020-05-17')

insert into tblChiTietNhapHang(iSoHD,sMahang,fGianhap,fSoluongnhap)
values
(23,N'TT01',75000,120),
(23,N'ST03',45000,80),
(23,N'BC01',4000,50)

insert into tblKhachHang(iMaKH,sTenKH,sDiachi,sDienThoai,bGioitinh,dNgaysinh)
values(6,N'Nguyễn Hà Anh',N'Nam Định','0947225392',0,'1999-06-01')

select * from tblDonNhapHang
select * from tblChiTietNhapHang
select * from tblKhachHang
 
-- Thực hiện phân tán ngang bảng tblKhachhang theo điều kiện khách hàng
--có địa chỉ 'Hà Nội' đặt tại trạm 1 và khác 'Hà Nội' đặt ở trạm 2
-- Tạo nhãn 
create synonym KhachTaiHaNoi for Tram1.dbo.tblKhachHang
create synonym KhachKhacHaNoi for Phantan.Tram2.dbo.tblKhachHang


--Truyền dữ liệu vào các trạm
insert into KhachTaiHaNoi
select * from tblKhachHang where sDiachi like N'%Hà Nội'

insert into KhachKhacHaNoi
select * from tblKhachHang where sDiachi not like N'%Hà Nội'

select * from tblKhachHang
select * from KhachTaiHaNoi
select * from KhachKhacHaNoi 
-- Viết lệnh lấy danh sách của khách hàng ở 'Hà Nội' hoặc 'TP HCM' có độ tuổi từ 18 - 25 đã mua hàng
create view vvDSKhachHang 
as 
select * from KhachTaiHaNoi 
union
select * from KhachKhacHaNoi

select * from vvDSKhachHang

select * from vvDSKhachHang
where sDiaChi = N'Hà Nội' or sDiachi = N'TP Hồ Chí Minh'
and datediff(year, dNgaysinh,getdate()) > 18 and datediff(year, dNgaysinh,getdate()) < 25

-- Viết thủ tục thêm dữ liệu Khách hàng và đưa vào trạm phù hợp
create proc ThemKH
@iMaKH int,
@sTenKH nvarchar(30),
@sDiachi nvarchar(50),
@sDienThoai nvarchar(12),
@dNgaysinh date,
@bGioitinh bit,
@TongTienHang float
as
begin
    if exists (select * from vvDSKhachHang where iMaKH = @iMaKH)
	   print N'Mã khách hàng đã tồn tại'
	else
	begin
        if(@sDiachi = N'Hà Nội')
		   insert into KhachTaiHaNoi
		   values(@iMaKH,@sTenKH,@sDiachi,@sDienThoai,@dNgaysinh,@bGioitinh,@TongTienHang)
		else
		   insert into KhachKhacHaNoi
		   values(@iMaKH,@sTenKH,@sDiachi,@sDienThoai,@dNgaysinh,@bGioitinh,@TongTienHang)
		  
	end
end

exec ThemKH 7,N'Vũ Đức Thịnh',N'Hà Nội','0842759241','1999-09-10',1,0

select * from tblKhachHang
select * from KhachTaiHaNoi
select * from KhachKhacHaNoi 

-- Thực hiện phân tán ngang bảng tblNHANVIEN theo điều kiện nhân viên có Lương cơ bản 
-- dưới 4 triệu đặt tại máy trạm 1 và các nhân viên còn lại đặt ở máy trạm 2
-- Tạo nhãn 
create synonym NVLuongduoi4tr for Tram1.dbo.tblNhanVien
create synonym NVLuongtren4tr for Phantan.Tram2.dbo.tblNhanVien


--Truyền dữ liệu vào các trạm
insert into NVLuongduoi4tr
select * from tblNhanVien where fLuongcoban < 4000000

insert into NVLuongtren4tr
select * from tblNhanVien where fLuongcoban > 4000000

select * from tblNhanVien
select * from NVLuongduoi4tr
select * from NVLuongtren4tr

-- Viết thủ tục để thêm một nhân viên mới vào CSDL tương ứng
create view vvDSNhanVien
as
select * from NVLuongduoi4tr
union 
select * from NVLuongtren4tr

select * from vvDSNhanVien

--Thủ tục thêm NV
create proc ThemNV
@iMaNV int,
@sTenNV nvarchar(30),
@sDiachi nvarchar(50),
@sDienThoai nvarchar(12),
@dNgaySinh date,
@dNgayvaolam date,
@fLuongcoban float,
@fPhucap float,
@sCMND nvarchar(20) 
as
begin 
    if exists (select * from vvDSNhanVien where iMaNV = @iMaNV)
	   print N'Mã nhân viên đã tồn tại'
	else
	begin
        if(@fLuongcoban < 4000000)
		   insert into NVLuongduoi4tr
		   values(@iMaNV,@sTenNV,@sDiachi,@sDienThoai,@dNgaysinh,@dNgayvaolam,@fLuongcoban,@fPhucap,@sCMND)
		else
		   insert into NVLuongtren4tr
	       values(@iMaNV,@sTenNV,@sDiachi,@sDienThoai,@dNgaysinh,@dNgayvaolam,@fLuongcoban,@fPhucap,@sCMND)

	end
end

exec ThemNV 5,N'Trần Thị Diệp',N'Nam Định','0987514238','1999-05-21','2019-10-20',4500000,300000,036712495829

select * from tblNhanVien
select * from NVLuongduoi4tr
select * from NVLuongtren4tr

--Tạo View cho xem danh sách tên các nhân viên đã làm ở cửa hàng trên 1 năm
create view NVlamtren2nam
as
select iMaNV,sTenNV from vvDSNhanVien 
where datediff(year,dNgayvaolam,getdate()) >1

select * from NVlamtren2nam

-- Chia tách dọc trên tblDonDathang thành 2 bảng theo cấu trúc như sau
-- tblThongtinGiaohang (iSoHD, dNgaygiaohang, sDiachiGiaohang)
-- tblDonDathang (iSoHD, iMaNV, iMaKH, dNgayDathang)

-- Tạo nhãn 
create synonym Tram2 for PHANTAN.Tram2.dbo.tblThongTinGiaoHang

--Truyền dữ liệu vào các trạm 

CREATE TABLE tblDonDatHang_Phantan
(
	iSoHD INT NOT NULL,
	iMaNV INT NOT NULL,
	iMaKH INT NOT NULL,
	dNgaydathang DATE NOT NULL,
	CONSTRAINT pk_SoHD PRIMARY KEY (iSoHD)
);
GO

--Bảng thông tin giao hàng       tblThongtinGiaohang (iSoHD, dNgaygiaohang, sDiachiGiaohang)
CREATE TABLE tblThongtinGiaohang
(
	iSoHD INT NOT NULL,
	dNgaygiaohang DATE NOT NULL,
	sDiachigiaohang NVARCHAR(50) NOT NULL,
	CONSTRAINT pk_GiaoHang PRIMARY KEY (iSoHD)
);
GO

Declare myCursor CURSOR Scroll Static For
select iSoHD, iMaNV, iMaKH, dNgaydathang, dNgaygiaohang, sDiachigiaohang from dbo.tblDonDatHang
Open myCursor
DECLARE @iSoHD int,@iMaNV int,@iMaKH int, @dNgaydathang date,@dNgaygiaohang date,@sDiachigiaohang nvarchar(50)
Fetch next from myCursor Into @iSoHD, @iMaNV, @iMaKH, @dNgaydathang, @dNgaygiaohang, @sDiachigiaohang
While @@fetch_status=0
BEGIN
    IF NOT EXISTS (select * from tblThongtinGiaohang where @iSoHD = tblThongtinGiaohang.iSoHD)  
		BEGIN
	    INSERT INTO tblThongtinGiaohang VALUES(@iSoHD,@dNgaygiaohang,@sDiachigiaohang)
		END
    IF NOT EXISTS(select * from tblDonDatHang_Phantan where @iSoHD = tblDonDatHang_Phantan.iSoHD)  
		BEGIN
		INSERT INTO tblDonDatHang_Phantan VALUES(@iSoHD,@iMaNV,@iMaKH,@dNgaydathang)
		END
	Fetch next from myCursor Into @iSoHD, @iMaNV, @iMaKH, @dNgaydathang, @dNgaygiaohang, @sDiachigiaohang
END
CLOSE myCursor
Deallocate myCursor
GO

Declare myCursor CURSOR Scroll Static For
select iSoHD, dNgaygiaohang, sDiachigiaohang from dbo.tblThongtinGiaohang
Open myCursor
DECLARE @iSoHD int,@dNgaygiaohang date,@sDiachigiaohang nvarchar(50)
Fetch next from myCursor Into @iSoHD, @dNgaygiaohang, @sDiachigiaohang
While @@fetch_status=0
BEGIN
    IF NOT EXISTS (select * from Tram2 where @iSoHD = Tram2.iSoHD)  
		BEGIN
	    INSERT INTO Tram2 VALUES(@iSoHD,@dNgaygiaohang,@sDiachigiaohang)
		END
	Fetch next from myCursor Into @iSoHD, @dNgaygiaohang, @sDiachigiaohang
END
CLOSE myCursor
Deallocate myCursor
GO

Select * from Tram2

--Gộp 2 bảng
create view vvDSDDH
as
select DonDatHang.iSoHD, DonDatHang.iMaNV, DonDatHang.iMaKH, dNgayDatHang, dNgaygiaohang,sDiachigiaohang
from DonDatHang inner join ThongTinGiaoHang
on DonDatHang.iSoHD = ThongTinGiaoHang.iSoHD

--Tạo View cho xem danh sách nhân viên và số đơn hàng chưa đến ngày giao của từng nhân viên
create view NhanVienVaSoLuongDonChuaGiao
as
select sTenNV, vvDSDDH.iMaNV , count(iSoHD) as[Số đơn hàng]
from  tblNhanVien, vvDSDDH
where tblNhanVien.iMaNV = vvDSDDH.iMaNV
and datediff(day,getdate(),dNgaygiaohang) > 0
group by sTenNV, vvDSDDH.iMaNV

select * from NhanVienVaSoLuongDonChuaGiao