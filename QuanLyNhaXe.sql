use master
go
create database dbQuanLyNhaXe
go
use dbQuanLyNhaXe
go

-- Bảng này dùng để tăng tự động khi 1 record được thêm vào.
-- Dùng để ghép chuỗi mã (VD: NV00001, trong đó NV là tiền tố tuỳ chọn 00001 lấy từ field tương ứng của bảng này)
create table Identify
(
	NhanVien int default 0,
	KhachHang int default 0,
	LoTrinh int default 0,
	Xe int default 0,
	LichChay int default 0,
	VeXe int default 0
)

create table LoaiNhanVien
(
	MaLoaiNhanVien int identity primary key,
	TenLoaiNhanVien nvarchar(100) not null
)
go

create table TaiKhoan
(
	TenDangNhap varchar(50) primary key,
	MatKhau varchar(1000) not null
)
go

create table NhanVien
(
	MaNhanVien varchar(10) primary key,
	TenNhanVien nvarchar(50) not null,
	GioiTinh nvarchar(3) not null,
	NgaySinh Datetime not null,
	DienThoai varchar(10) not null,
	DiaChi nvarchar(500) not null,
	MaLoaiNhanVien int not null,
	TenDangNhap varchar(50) not null,
	CONSTRAINT FK_NhanVien_LoaiNhanVien FOREIGN KEY (MaLoaiNhanVien) REFERENCES LoaiNhanVien(MaLoaiNhanVien),
	CONSTRAINT FK_NhanVien_TaiKhoan FOREIGN KEY (TenDangNhap) REFERENCES TaiKhoan(TenDangNhap)
)
go

create table KhachHang
(
	MaKhachHang varchar(10) primary key,
	TenKhachHang nvarchar(50) not null,
	GioiTinh nvarchar(3) not null,
	NgaySinh Datetime not null,
	DienThoai varchar(10) not null,
	DiaChi nvarchar(500) not null
)
go

create table LoTrinh
(
	MaLoTrinh varchar(10) not null primary key,
	DiemDi nvarchar(100) not null,
	DiemDen nvarchar(100) not null,
	QuangDuong int,
)
go

create table LoaiXe
(
	MaLoaiXe int identity primary key,
	TenLoaiXe nvarchar(100) not null,
)
go

create table BangGia
(
	MaLoTrinh varchar(10) not null references LoTrinh(MaLoTrinh),
	MaLoaiXe int not null references LoaiXe(MaLoaiXe),
	DonGia money not null,
	constraint pk_BangGia primary key(MaLoTrinh, MaLoaiXe)
)
go

create table Xe
(
	MaXe varchar(10) primary key,
	MaLoaiXe int not null,
	BienSo varchar(20) not null,
	SoGhe int not null,
	CONSTRAINT FK_Xe_LoaiXe FOREIGN KEY (MaLoaiXe) REFERENCES LoaiXe(MaLoaiXe)
)
go

create table Xe_GheNgoi
(
	MaGheNgoi int identity primary key,
	MaXe varchar(10) not null references Xe(MaXe),
	GheNgoi varchar(10) not null,
	TrangThai bit default 0 -- 0: chưa đặt, 1: đã được đặt
)

create table LichChay
(
	MaLichChay varchar(10) primary key,
	ThoiGianKhoiHanh Datetime not null,
	MaLoTrinh varchar(10) not null,
	MaNhanVien varchar(10) not null,
	TrangThai bit not null default 0, --0 chưa xuất phát; 1: đã xuất phát
	CONSTRAINT FK_LichChay_LoTrinh FOREIGN KEY (MaLoTrinh) REFERENCES LoTrinh(MaLoTrinh),
	CONSTRAINT FK_LichChay_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
)
go

create table LichChay_Xe 
(
	MaLichChay varchar(10) not null references LichChay(MaLichChay),
	MaXe varchar(10) not null references Xe(MaXe),
)
go

create table VeXe
(
	MaVeXe varchar(10) primary key,
	MaKhachHang varchar(10) not null,
	DonGia money,
	SoLuong int,
	ThanhTien money,
	CONSTRAINT FK_VeXe_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang),
)
go

create table ChiTietVeXe
(
	MaVeXe varchar(10) references VeXe(MaVeXe),
	MaGheNgoi int not null references Xe_GheNgoi(MaGheNgoi),
	constraint pk_ChiTietVeXe primary key(MaVeXe, MaGheNgoi)
)