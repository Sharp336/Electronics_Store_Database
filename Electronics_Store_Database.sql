use master
drop database if exists Electronics_Store_Database
go


set ansi_nulls on
go
set ansi_padding on
go
set quoted_identifier on
go
create database [Electronics_Store_Database]
go
use [Electronics_Store_Database]
go

------------------------------------------------------------------------------------------------------------------------

create table [dbo].[Country]
(
   [ID_Country] [int] not null identity(1,1),
   [Country_Name] [varchar] (50) not null
   constraint [PK_Country] primary key clustered
   ([ID_Country] ASC) on [PRIMARY],
   constraint [UQ_Country_Name] unique ([Country_Name])
)
go

create table [dbo].[Manufacturer]
(
   [ID_Manufacturer] [int] not null identity(1,1),
   [Manufacturer_Name] [varchar] (50) not null,
   [Manufacturer_Country_ID] [int] not null
   constraint [PK_Manufacturer] primary key clustered
   ([ID_Manufacturer] ASC) on [PRIMARY],
   constraint [UQ_Manufacturer_Name] unique ([Manufacturer_Name]),
   constraint [FK_Country_Manufacturer] foreign key ([Manufacturer_Country_ID])
   references [dbo].[Country] ([ID_Country])
)
go

create table [dbo].[Buyer]
(
   [ID_Buyer] [int] not null identity(1,1),
   [Buyer_Login] [varchar] (32) not null,
   [Buyer_Password] [varchar] (32) not null,
   [Buyer_Phone_Number] [varchar] (17)  not null,
   [Buyer_Address] [varchar] (max) not null,
   constraint [PK_Buyer] primary key clustered
   ([ID_Buyer] ASC) on [PRIMARY],
   constraint [UQ_Buyer_Login] unique ([Buyer_Login]),
   constraint [UQ_Buyer_Phone_Number] unique ([Buyer_Phone_Number]),
   constraint [CH_Buyer_Login] check (len([Buyer_Login])>=8),
   constraint [CH_Buyer_Password_Upper] check ([Buyer_Password] like ('%[A-Z]%')),
   constraint [CH_Buyer_Password_Lower] check ([Buyer_Password] like ('%[a-z]%')),
   constraint [CH_Buyer_Password_Symbols] check ([Buyer_Password] like ('%[!@#$%^&*()]%')),
   constraint [CH_Buyer_Phone_Number] check ([Buyer_Phone_Number] like '+7([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')

)
go

create table [dbo].[Buyer_Card]
(
   [ID_Buyer_Card] [int] not null identity(1,1),
   [Card_Number] [varchar] (19) not null,
   [Card_Holder] [varchar] (60) not null,
   [Card_Validity] [varchar] (5) not null,
   [Buyer_ID] [int] not null
   constraint [PK_Buyer_Card] primary key clustered
   ([ID_Buyer_Card] ASC) on [PRIMARY],
   constraint [UQ_Card_Number] unique ([Card_Number]),
   constraint [CH_Card_Number] check ([Card_Number] like '[0-9][0-9][0-9][0-9] [0-9][0-9][0-9][0-9] [0-9][0-9][0-9][0-9] [0-9][0-9][0-9][0-9]'),
   constraint [CH_Card_Holder] check ([Card_Holder] = UPPER([Card_Holder])),
   constraint [CH_Card_Validity] check ([Card_Validity] like ('[0-1][0-9]/[0-9][0-9]')),
   constraint [FK_Buyer_Buyer_Card] foreign key ([Buyer_ID])
   references [dbo].[Buyer] ([ID_Buyer])
)
go

create table [dbo].[Supplier]
(
   [ID_Supplier] [int] not null identity(1,1),
   [Supplier_Full_Name] [varchar] (max) not null,
   [Supplier_Short_Name] [varchar] (50) not null,
   [Supplier_Legal_Address] [varchar] (max) not null,
   [Supplier_Physical_Address] [varchar] (max) not null,
   [Supplier_E_Mail] [varchar] (max) not null,
   [Supplier_Phone_Number] [varchar] (17)  not null
   constraint [PK_Supplier] primary key clustered
   ([ID_Supplier] ASC) on [PRIMARY],
   constraint [UQ_Supplier_Short_Name] unique ([Supplier_Short_Name]),
   constraint [UQ_Supplier_Phone_Number] unique ([Supplier_Phone_Number]),
   constraint [CH_Supplier_E_Mail] check ([Supplier_E_Mail] like ('%@%.%')),
   constraint [CH_Supplier_Phone_Number] check ([Supplier_Phone_Number] like '+7([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
)
go

create table [dbo].[Representative]
(
   [ID_Representative] [int] not null identity(1,1),
   [Supplier_ID] [int] not null,
   [Repres_First_Name] [varchar] (30) not null,
   [Repres_Second_Name] [varchar] (30) not null,
   [Repres_Middle_Name] [varchar] (30) null default('-')
   constraint [PK_Representative] primary key clustered
   ([ID_Representative] ASC) on [PRIMARY],
   constraint [FK_Supplier_Representative] foreign key ([Supplier_ID])
   references [dbo].[Supplier] ([ID_Supplier])
)
go

create table [dbo].[Contract]
(
   [ID_Contract] [int] not null identity(1,1),
   [Representative_ID] [int] not null,
   [Contract_Expiry_Date] [date] not null,
   [Contract_Conclusion_Date] [date] null default(getdate())
   constraint [PK_Contract] primary key clustered
   ([ID_Contract] ASC) on [PRIMARY],
   constraint [CH_Contract_Expiry_Date] check ([Contract_Expiry_Date] >= CAST(getdate() as date)),
   constraint [CH_Contract_Conclusion_Date] check ([Contract_Conclusion_Date] <= CAST(getdate() as date)),
   constraint [FK_Representative_Contract] foreign key ([Representative_ID])
   references [dbo].[Representative] ([ID_Representative])
)
go

create table [dbo].[Characteristics_Name]
(
   [ID_Characteristic_Name] [int] not null identity(1,1),
   [Characteristic_Name] [varchar] (30) not null
   constraint [PK_Characteristic_Name] primary key clustered
   ([ID_Characteristic_Name] ASC) on [PRIMARY],
   constraint [UQ_Characteristic_Name] unique ([Characteristic_Name])
)
go

create table [dbo].[Goods_Type]
(
   [ID_Goods_Type] [int] not null identity(1,1),
   [Goods_Type_Name] [varchar] (30) not null
   constraint [PK_Goods_Type] primary key clustered
   ([ID_Goods_Type] ASC) on [PRIMARY],
   constraint [UQ_Goods_Type_Name] unique ([Goods_Type_Name])
)
go

create table [dbo].[Outlets_Name]
(
   [ID_Name] [int] not null identity(1,1),
   [Outlet_Name] [varchar] (50) not null
   constraint [PK_Outlets_Name] primary key clustered
   ([ID_Name] ASC) on [PRIMARY],
   constraint [UQ_Outlet_Name] unique ([Outlet_Name])
)
go

create table [dbo].[Outlet]
(
   [ID_Outlet] [int] not null identity(1,1),
   [Outlet_Adress] [varchar] (MAX) not null,
   [Name_ID] [int] not null
   constraint [PK_Outlet] primary key clustered
   ([ID_Outlet] ASC) on [PRIMARY],
   constraint [FK_Name_Outlet] foreign key ([Name_ID])
   references [dbo].[Outlets_Name] ([ID_Name])
)
go

create table [dbo].[Post]
(
   [ID_Post] [int] not null identity(1,1),
   [Post_Name] [varchar] (50) not null,
   [Post_Salary] [int] not null,
   [Superior_Post_ID] [int] not null
   constraint [PK_Post] primary key clustered
   ([ID_Post] ASC) on [PRIMARY],
   constraint [UQ_Post_Name] unique ([Post_Name]),
   constraint [CH_Post_Salary] check ([Post_Salary] > 0),
   constraint [FK_Superior_Post] foreign key ([Superior_Post_ID])
   references [dbo].[Post] ([ID_Post])
)
go

create table [dbo].[Employee]
(
   [ID_Employee] [int] not null identity(1,1),
   [Emp_First_Name] [varchar] (30) not null,
   [Emp_Second_Name] [varchar] (30) not null,
   [Emp_Middle_Name] [varchar] (30) null default ('-'),
    [Post_ID] [int] not null,
    [Outlet_ID] [int] not null,
   [Emp_Login] [varchar] (32) not null,
   [Emp_Password] [varchar] (32) not null
   constraint [PK_Employee] primary key clustered
   ([ID_Employee] ASC) on [PRIMARY],
   constraint [UQ_Emp_Login] unique ([Emp_Login]),
   constraint [CH_Emp_Login] check (len([Emp_Login])>=8),
   constraint [CH_Emp_Password_Upper] check ([Emp_Password] like ('%[A-Z]%')),
   constraint [CH_Emp_Password_Lower] check ([Emp_Password] like ('%[a-z]%')),
   constraint [CH_Emp_Password_Symbols] check ([Emp_Password] like ('%[!@#$%^&*()]%')),
    constraint [FK_Post_Emp] foreign key ([Post_ID])
    references [dbo].[Post] ([ID_Post]),
    constraint [FK_Outlet_Emp] foreign key ([Outlet_ID])
    references [dbo].[Outlet] ([ID_Outlet])
)
go

create table [dbo].[Passport]
(
   [ID_Passport] [int] not null identity(1,1),
   [Buyer_ID] [int] not null,
   [Buyer_First_Name] [varchar] (30) not null,
   [Buyer_Second_Name] [varchar] (30) not null,
   [Buyer_Middle_Name] [varchar] (30) null default ('-'),
   [Passport_Series] [varchar] (5) not null,
   [Passport_Code] [varchar] (6) not null,
   [Buyer_Gender] [varchar] (3) not null,
   [Buyer_Birthday] [date] not null,
   [Buyer_Birthplace] [varchar] (30) not null,
   [Passport_Issued_By] [varchar] (100) not null
   constraint [PK_Passport] primary key clustered
   ([ID_Passport] ASC) on [PRIMARY],
   constraint [FK_Passport_Buyer] foreign key ([Buyer_ID])
   references [dbo].[Buyer] ([ID_Buyer]),
   constraint [CH_Passport_Series] check ([Passport_Series] like ('[0-9][0-9] [0-9][0-9]')),
   constraint [UQ_Passport_Code] unique ([Passport_Code]),
   constraint [CH_Passport_Code] check ([Passport_Code] like '[0-9][0-9][0-9][0-9][0-9][0-9]'),
   constraint [CH_Buyer_Gender] check ([Buyer_Gender] in ('МУЖ','ЖЕН')),
   constraint [CH_Buyer_Birthday] check (DATEDIFF(YEAR, [Buyer_Birthday], getdate()) >= 14)
)
go

create table [dbo].[Payment_Type]
(
   [ID_Payment_Type] [int] not null identity(1,1),
   [Payment_Type_Name] [varchar] (30) not null
   constraint [PK_Payment_Type] primary key clustered
   ([ID_Payment_Type] ASC) on [PRIMARY],
   constraint [UQ_Payment_Type] unique ([Payment_Type_Name])
)
go

create table [dbo].[Order]
(
   [ID_Order] [int] not null identity(1,1),
   [Buyer_Card_ID] [int] not null,
   [Order_Date] [date] null default getdate(),
   [Order_Time] [time] null default getdate(),
   [Payment_Type_ID] [int] not null
   constraint [PK_Order] primary key clustered
   ([ID_Order] ASC) on [PRIMARY],
   constraint [FK_Card_Order] foreign key ([Buyer_Card_ID])
   references [dbo].[Buyer_Card] ([ID_Buyer_Card]),
   constraint [CH_Order_Date] check ([Order_Date] = cast(getdate() as date)),
   constraint [CH_Order_Time] check ([Order_Time] between DATEADD(MINUTE, -1, cast(getdate() as time)) and DATEADD(MINUTE, 1, cast(getdate() as time))),
   constraint [FK_Payment_Type_Order] foreign key ([Payment_Type_ID])
   references [dbo].[Payment_Type] ([ID_Payment_Type])
)
go

create table [dbo].[Receipt]
(
   [ID_Receipt] [int] not null identity(1,1),
   [Order_ID] [int] not null,
   [Receipt_Sum] [money] not null,
   [Receipt_Total] [money] not null,
   [Employee_ID] [int] not null,
   [Closure_Date] [date] null default getdate(),
   [Closure_Time] [time] null default getdate()
   constraint [PK_Receipt] primary key clustered
   ([ID_Receipt] ASC) on [PRIMARY],
   constraint [FK_Order_Receipt] foreign key ([Order_ID])
   references [dbo].[Order] ([ID_Order]),
   constraint [CH_Receipt_Sum] check ([Receipt_Sum] > 0),
   constraint [CH_Receipt_Total] check ([Receipt_Total] >= 0),
   constraint [FK_Employee_Receipt] foreign key ([Employee_ID])
   references [dbo].[Employee] ([ID_Employee]),
   constraint [CH_Closure_Date] check ([Closure_Date] = cast(getdate() as date)),
   constraint [CH_Closure_Time] check ([Closure_Time] between DATEADD(MINUTE, -1, cast(getdate() as time)) and DATEADD(MINUTE, 1, cast(getdate() as time)))
)
go

create table [dbo].[Requests_For_Supply]
(
   [ID_Request] [int] not null identity(1,1),
   [Request_Status] [varchar] (10) not null,
   [Request_Date] [date] null default getdate(),
   [Request_Time] [time] null default getdate(),
   [Contract_ID] [int] not null,
   [Employee_ID] [int] not null
   constraint [PK_Requests_For_Supply] primary key clustered
   ([ID_Request] ASC) on [PRIMARY],
   constraint [CH_Request_Status] check ([Request_Status] in ('ОТПРАВЛЕНО','ПОЛУЧЕНО','НАРУШЕНО')),
   constraint [CH_Request_Date] check ([Request_Date] = cast(getdate() as date)),
   constraint [CH_Request_Time] check ([Request_Time] between DATEADD(MINUTE, -1, cast(getdate() as time)) and DATEADD(MINUTE, 1, cast(getdate() as time))),
   constraint [FK_Contract_Request] foreign key ([Contract_ID])
   references [dbo].[Contract] ([ID_Contract]),
   constraint [FK_Employee_Request] foreign key ([Employee_ID])
   references [dbo].[Employee] ([ID_Employee])
)
go

create table [dbo].[Goods]
(
   [ID_Goods] [int] not null identity(1,1),
   [Goods_Name] [varchar] (100) not null,
   [Goods_Article] [varchar] (100) not null,
   [Goods_ID] [int] not null,
   [Manufacturer_ID] [int] not null,
   [Goods_Price] [decimal] (10,2) not null,
   [Photo_Tag] [varchar] (64) not null,
   [Goods_Type_ID] [int] not null
   constraint [PK_Goods] primary key clustered
   ([ID_Goods] ASC) on [PRIMARY],
   constraint [UQ_Goods_Article] unique ([Goods_Article]),
   constraint [FK_Goods_Goods] foreign key ([Goods_ID])
   references [dbo].[Goods] ([ID_Goods]),
   constraint [FK_Manufacturer_Goods] foreign key ([Manufacturer_ID])
   references [dbo].[Manufacturer] ([ID_Manufacturer]),
   constraint [CH_Goods_Price] check ([Goods_Price] > 0),
   constraint [UQ_Photo_Tag] unique ([Photo_Tag]),
   constraint [FK_Type_Goods] foreign key ([Goods_Type_ID])
   references [dbo].[Goods_Type] ([ID_Goods_Type])
)
go

create table [dbo].[Order_Parts]
(
   [ID_Order_Parts] [int] not null identity(1,1),
   [Goods_ID] [int] not null,
   [Order_Goods_Amount] [int] not null,
   [Order_ID] [int] not null
   constraint [PK_Order_Parts] primary key clustered
   ([ID_Order_Parts] ASC) on [PRIMARY],
   constraint [FK_Order_Parts_Goods] foreign key ([Goods_ID])
   references [dbo].[Goods] ([ID_Goods]),
   constraint [CH_Order_Goods_Amount] check ([Order_Goods_Amount] > 0),
   constraint [FK_Order_Parts_Order] foreign key ([Order_ID])
   references [dbo].[Order] ([ID_Order])
)
go

create table [dbo].[Requests_Parts]
(
   [ID_Requests_Parts] [int] not null identity(1,1),
   [Goods_ID] [int] not null,
   [Request_ID] [int] not null,
   [Requests_Goods_Amount] [int] not null
   constraint [PK_Requests_Parts] primary key clustered
   ([ID_Requests_Parts] ASC) on [PRIMARY],
   constraint [FK_Requests_Parts_Goods] foreign key ([Goods_ID])
   references [dbo].[Goods] ([ID_Goods]),
   constraint [FK_Requests_Parts_Request] foreign key ([Request_ID])
   references [dbo].[Requests_For_Supply] ([ID_Request]),
   constraint [CH_Requests_Goods_Amount] check ([Requests_Goods_Amount] > 0)
)
go

create table [dbo].[Characteristics]
(
   [ID_Characteristics] [int] not null identity(1,1),
   [Goods_ID] [int] not null,
   [Characteristic_Name_ID] [int] not null,
   [Characteristics_Value] [varchar] (50) not null
   constraint [PK_Characteristics] primary key clustered
   ([ID_Characteristics] ASC) on [PRIMARY],
   constraint [FK_Characteristics_Goods] foreign key ([Goods_ID])
   references [dbo].[Goods] ([ID_Goods]),
   constraint [FK_Characteristics_Characteristic_Name] foreign key ([Characteristic_Name_ID])
   references [dbo].[Characteristics_Name] ([ID_Characteristic_Name])
)
go

------------------------------------------------------------------------------------------------------------------------

insert into [dbo].[Country] ([Country_Name])
values ('Кувейт'), ('Ливия'), ('Сирия'), ('Сомали'), ('Уганда'), ('Цар'), ('Эритрея'), ('Эфиопия');
go

insert into [dbo].[Manufacturer] ([Manufacturer_Name], [Manufacturer_Country_ID])
values  ('Nokia', 1), ('Vagner', 2), ('Kia', 3), ('Lada', 4),('Bugatti', 2), ('РУССКИЕ ТРАВЫ', 2), ('ИГИЛ', 1);
go

insert into [dbo].[Buyer] ([Buyer_Login], [Buyer_Password], [Buyer_Phone_Number], [Buyer_Address])
values  ('Rootroot', 'R@0t', '+7(777)777-77-77', '798595, Владимирская область, город Подольск, пл. Славы, 23'),
        ('Userbebra1', 'R@0t', '+7(111)111-11-11', '023316, Ленинградская область, город Озёры, пер. Сталина, 75'),
        ('Userbebra2', 'R@0t', '+7(222)222-22-22', '155667, Смоленская область, город Егорьевск, въезд Космонавтов, 44'),
        ('Userbebra3', 'R@0t', '+7(333)333-33-33', '584271, Ивановская область, город Ступино, наб. Ладыгина, 11');
go

insert into [dbo].[Buyer_Card] ([Card_Number], [Card_Holder], [Card_Validity], [Buyer_ID])
values  ('1111 1111 1111 1111', 'FIRST BUYER', '01/01', 2),
        ('2222 2222 2222 2222', 'SECOND BUYER', '02/02', 3),
        ('9999 9999 9999 9999', 'FIRST BUYER', '09/09', 4);
go

insert into [dbo].[Supplier] ([Supplier_Full_Name], [Supplier_Short_Name],[Supplier_Legal_Address], [Supplier_Physical_Address],[Supplier_E_Mail], [Supplier_Phone_Number])
values  ('BuerakCongressman.USACrackBundle', 'CUM', 'USA, Tokio, Снежая улица', 'Подворотня', 'really@unreal.email', '+7(123)456-78-91'),
        ('Navy_Aluminium0Shih_Tzu', 'UWU', 'Москва, Воронежская переулок 12 Э', 'Кабинет физики', 'first@second.third', '+7(011)121-31-41'),
        ('Olive_Flea_Sonata', 'LOLi', 'Пакистан, 7755', 'Галакика Андромеда', 'wtfis@this.email', '+7(516)171-81-91');
go

insert into [dbo].[Representative] ([Supplier_ID], [Repres_First_Name], [Repres_Second_Name], [Repres_Middle_Name])
values  (1, 'Howard', 'Kunze', 'Bar'),
        (2, 'Billy', 'Casper', 'BTS'),
        (3, 'Elvis', 'Grant', 'UAR'),
        (1, 'Catharine', 'Becker', 'NAN');
go

insert into [dbo].[Contract] ([Representative_ID], [Contract_Expiry_Date])
values  (1, DATEADD(month, 1, getdate())),(2, DATEADD(year, 1, getdate())),(4, DATEADD(year, 5, getdate()));
go

insert into [dbo].[Characteristics_Name] (Characteristic_Name)
values  ('Профиль XMP'),('Тип памяти'),('Частота DDR'),('Частота ГП'),('Частота ЦП');
go

insert into [dbo].[Goods_Type] ([Goods_Type_Name])
values  ('Блоки питания'),('Графические ускорители'),('Корпуса ПК'),('Оперативная память'),('Процессоры');
go

insert into [dbo].[Outlets_Name] ([Outlet_Name])
values  ('DNS'),('Pleer.ru'),('М.Видео'),('Регард');
go

insert into [dbo].[Outlet] ([Outlet_Adress], [Name_ID])
values  ('063447, Тюменская область, город Наро-Фоминск, спуск Домодедовская, 68', 1),
        ('099001, Брянская область, город Озёры, пл. Ленина, 79', 2),
        ('508768, Тамбовская область, город Дорохово, наб. Сталина, 51', 3),
        ('522727, Рязанская область, город Лотошино, пл. Косиора, 52', 3),
        ('901387, Брянская область, город Подольск, ул. Ленина, 96', 3);
go

insert into [dbo].[Post] ([Post_Name], [Superior_Post_ID], [Post_Salary])
values  ('Директор', 1, 500000),
        ('Зам.Директора', 1, 300000),
        ('Управляющий Филиалом', 2, 150000),
        ('Главный Техник Филлиала', 3, 100000),
        ('Кассир', 3, 50000),
        ('Уборщик', 3, 30000),
        ('Помощник Техника', 4, 15000);
go

insert into [dbo].[Employee] ([Emp_First_Name], [Emp_Second_Name], [Emp_Middle_Name], [Post_ID], [Outlet_ID], [Emp_Login], [Emp_Password])
values  ('Root', 'Root', 'Root', 1, 1, 'Rootroot', 'R@0t'),
        ('Мария', 'Чижова', 'Мироновна', 4, 1, 'Outlet1_User4', 'R@0t'),
        ('Алина', 'Петрова', 'Сергеевна', 5, 1, 'Outlet1_User5', 'R@0t'),
        ('Руслан', 'Михайлов', 'Дмитриевич', 4, 2, 'Outlet2_User4', 'R@0t'),
        ('Александра', 'Самойлова', 'Максимовна', 5, 2, 'Outlet2_User5', 'R@0t');
go

insert into [dbo].[Passport] ([Buyer_ID], [Buyer_First_Name], [Buyer_Second_Name], [Buyer_Middle_Name], [Passport_Series], [Passport_Code], [Buyer_Gender], [Buyer_Birthday], [Buyer_Birthplace], [Passport_Issued_By])
values  (2, 'Рут', 'Рутов', 'Рутович', '22 22', '222222', 'МУЖ', '2002-02-02', 'ГОР. ПОДОЛЬСК', 'ОТДЕЛОМ ВНУТРЕННИХ ДЕЛ НЕСУЩЕСТВУЮЩЕГО РАЙОНА Г.ПОДОЛЬСК'),
        (3, 'Ольга', 'Акимова', 'Михайловна', '33 33', '333333', 'ЖЕН', '2003-03-03', 'ГОР. ОЗЁРЫ', 'ОТДЕЛОМ ВНУТРЕННИХ ДЕЛ НЕСУЩЕСТВУЮЩЕГО РАЙОНА Г.ОЗЁРЫ'),
        (4, 'Алексей', 'Сальников', 'Даниилович', '44 44', '444444', 'МУЖ', '2004-04-04', 'Г. ЕГОРЬЕВСК', 'ОТДЕЛОМ ВНУТРЕННИХ ДЕЛ НЕСУЩЕСТВУЮЩЕГО РАЙОНА Г.ЕГОРЬЕВСК');
go

insert into [dbo].[Payment_Type] ([Payment_Type_Name])
values ('Картой курьеру'),('Наличными курьеру'),('Переводом курьеру');
go

insert into [dbo].[Order] ([Buyer_Card_ID], [Payment_Type_ID])
values  (1, 2), (2, 3);
go

insert into [dbo].[Receipt] ([Order_ID], [Receipt_Sum], [Receipt_Total], [Employee_ID])
values  (1, 10000, 10000, 3);
go

insert into [dbo].[Requests_For_Supply] ([Request_Status], [Contract_ID], [Employee_ID])
values  ('ОТПРАВЛЕНО', 3, 4), ('ПОЛУЧЕНО', 3, 2);
go

insert into [dbo].[Goods] ([Goods_Name], [Goods_Article], [Goods_ID], [Manufacturer_ID], [Goods_Price], [Photo_Tag], [Goods_Type_ID])
values  ('Видеокарта GIGABYTE GeForce RTX 4090 GAMING OC', 'GV-N4090GAMING OC-24GD', 1, 5, 170000.00, '0B4A38E366B06A267A2389880A428B526D8011E88C5B29AC5FDCE13849B7E2FD', 2);
go

insert into [dbo].[Order_Parts] ([Goods_ID], [Order_Goods_Amount], [Order_ID]) values  (1, 1, 1);
go

insert into [dbo].[Requests_Parts] ([Goods_ID], [Request_ID], [Requests_Goods_Amount]) values  (1, 2, 10);
go

insert into [dbo].[Characteristics] ([Goods_ID], [Characteristic_Name_ID], [Characteristics_Value])
values  (1, 4, '2520');
go

------------------------------------------------------------------------------------------------------------------------

create or alter procedure [dbo].[Country_insert]
@Country_Name [varchar] (50)
as
    begin try
        insert into [dbo].[Country] ([Country_Name])
        values (@Country_Name)
    end try
    begin catch
        print('Не удалось вставить название страны')
    end catch
go

create or alter procedure [dbo].[Country_update]
@ID_Country [int], @Country_Name [varchar] (50)
as
    declare @exist_record [int] = (select count(*) from [dbo].[Country]
	where [Country_Name] = @Country_Name)
	if (@exist_record > 0)
	print('Данная страна уже есть в таблице!')
	else
	update [dbo].[Country] set
        [Country_Name] = @Country_Name
        where [ID_Country] = @ID_Country
go

create or alter procedure [dbo].[Country_delete]
@ID_Country int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Manufacturer] where Manufacturer_Country_ID = @ID_Country)
    if (@any_child_record > 0)
        print('Страна не может быть удалена, т.к. используеся в таблице "Производитель"')
    else
        delete from [dbo].[Country] where ID_Country = @ID_Country
go

create or alter procedure [dbo].[Manufacturer_insert]
@Manufacturer_Name [varchar] (50),
@Manufacturer_Country_ID int
as
    begin try
        insert into [dbo].[Manufacturer] ([Manufacturer_Name], [Manufacturer_Country_ID])
        values (@Manufacturer_Name, @Manufacturer_Country_ID)
    end try
    begin catch
        print('Не удалось вставить производителя')
    end catch
go

create or alter procedure [dbo].[Manufacturer_update]
@ID_Manufacturer int,
@Manufacturer_Name [varchar] (50),
@Manufacturer_Country_ID int
as
    declare @exist_record [int] = (select count(*) from [dbo].[Manufacturer]
	where [Manufacturer_Name] = @Manufacturer_Name or [Manufacturer_Country_ID] = @Manufacturer_Country_ID)
	if (@exist_record > 0)
	print('Производитель с такими данными уже есть в таблице!')
	else
	update [dbo].[Manufacturer] set
        [Manufacturer_Name] = @Manufacturer_Name,
        [Manufacturer_Country_ID] = @Manufacturer_Country_ID
        where [ID_Manufacturer] = @ID_Manufacturer
go

create or alter procedure [dbo].[Manufacturer_delete]
@ID_Manufacturer int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Goods] where Manufacturer_ID = @ID_Manufacturer)
    if (@any_child_record > 0)
        print('Производитель не может быть удален, т.к. используеся в таблице "Товар"')
    else
        delete from [dbo].[Manufacturer] where ID_Manufacturer = @ID_Manufacturer
go

create or alter procedure [dbo].[Buyer_insert]
@Buyer_Login varchar(32),
@Buyer_Password varchar(32),
@Buyer_Phone_Number varchar(17),
@Buyer_Address varchar(max)
as
    begin try
        insert into [dbo].[Buyer] ([Buyer_Login], [Buyer_Password], [Buyer_Phone_Number], [Buyer_Address])
        values (@Buyer_Login, @Buyer_Password, @Buyer_Phone_Number, @Buyer_Address)
    end try
    begin catch
        print('Не удалось вставить покупателя')
    end catch
go

create or alter procedure [dbo].[Buyer_update]
@ID_Buyer int,
@Buyer_Login varchar(32),
@Buyer_Password varchar(32),
@Buyer_Phone_Number varchar(17),
@Buyer_Address varchar(max)
as
    declare @exist_record [int] = (select count(*) from [dbo].[Buyer]
	where [Buyer_Login] = @Buyer_Login or [Buyer_Phone_Number] = @Buyer_Phone_Number)
	if (@exist_record > 0)
	print('Покупатель с таким телефоном или логином уже есть в таблице!')
	else
        update [dbo].[Buyer] set
        [Buyer_Login] = @Buyer_Login,
        [Buyer_Password] = @Buyer_Password,
        [Buyer_Phone_Number] = @Buyer_Phone_Number,
        [Buyer_Address] = @Buyer_Address
        where [ID_Buyer] = @ID_Buyer
go

create or alter procedure [dbo].[Buyer_delete]
@ID_Buyer int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Buyer_Card] where Buyer_ID = @ID_Buyer) + (select count(*)
    from [dbo].[Passport] where Buyer_ID = @ID_Buyer)
    if (@any_child_record > 0)
        print('Покупатель не может быть удален, т.к. используеся в таблице "Паспорт" или "Карта"')
    else
        delete from [dbo].[Buyer] where ID_Buyer = @ID_Buyer
go

create or alter procedure [dbo].[Buyer_Card_insert]
@Card_Number varchar(19),
@Card_Holder varchar(60),
@Card_Validity varchar(5),
@Buyer_ID int
as
    begin try
        insert into [dbo].[Buyer_Card] ([Card_Number],[Card_Holder],[Card_Validity],[Buyer_ID])
        values (@Card_Number,@Card_Holder,@Card_Validity,@Buyer_ID)
    end try
    begin catch
        print('Не удалось вставить карту покупателя')
    end catch
go

create or alter procedure [dbo].[Buyer_Card_update]
@ID_Buyer_Card int,
@Card_Number varchar(19),
@Card_Holder varchar(60),
@Card_Validity varchar(5),
@Buyer_ID int
as
    declare @exist_record [int] = (select count(*) from [dbo].[Buyer_Card]
	where [Card_Number] = @Card_Number)
	if (@exist_record > 0)
	print('Карта с данным номером уже есть в таблице!')
	else
        update [dbo].[Buyer_Card] set
        [Card_Number] = @Card_Number,
        [Card_Holder] = @Card_Holder,
        [Card_Validity] = @Card_Validity,
        [Buyer_ID] = @Buyer_ID
        where [ID_Buyer_Card] = @ID_Buyer_Card
go

create or alter procedure [dbo].[Buyer_Card_delete]
@ID_Buyer_Card int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Order] where Buyer_Card_ID = @ID_Buyer_Card)
    if (@any_child_record > 0)
        print('Карта покупателя не может быть удалена, т.к. используеся в таблице "Заказ"')
    else
        delete from [dbo].[Buyer_Card] where ID_Buyer_Card = @ID_Buyer_Card
go

create or alter procedure [dbo].[Supplier_insert]
@Supplier_Full_Name varchar(max),
@Supplier_Short_Name varchar(50),
@Supplier_Legal_Address varchar(max),
@Supplier_Physical_Address varchar(max),
@Supplier_E_Mail varchar(max),
@Supplier_Phone_Number varchar(17)
as
    begin try
        insert into [dbo].[Supplier] ([Supplier_Full_Name], [Supplier_Short_Name],
        [Supplier_Legal_Address], [Supplier_Physical_Address], [Supplier_E_Mail], [Supplier_Phone_Number])
        values (@Supplier_Full_Name, @Supplier_Short_Name, @Supplier_Legal_Address,
        @Supplier_Physical_Address, @Supplier_E_Mail, @Supplier_Phone_Number)return 1
    end try
    begin catch
        print('Не удалось вставить поставщика')
    end catch
go

create or alter procedure [dbo].[Supplier_update]
@ID_Supplier int,
@Supplier_Full_Name varchar(max),
@Supplier_Short_Name varchar(50),
@Supplier_Legal_Address varchar(max),
@Supplier_Physical_Address varchar(max),
@Supplier_E_Mail varchar(max),
@Supplier_Phone_Number varchar(17)
as
    declare @exist_record [int] = (select count(*) from [dbo].[Supplier]
	where [Supplier_Full_Name] = @Supplier_Full_Name or
        [Supplier_Short_Name] = @Supplier_Short_Name or
        [Supplier_E_Mail] = @Supplier_E_Mail or
        [Supplier_Phone_Number] = @Supplier_Phone_Number)
	if (@exist_record > 0)
	print('Поставщик с такими данными уже есть в таблице!')
	else
        update [dbo].[Supplier] set
        [Supplier_Full_Name] = @Supplier_Full_Name,
        [Supplier_Short_Name] = @Supplier_Short_Name,
        [Supplier_Legal_Address] = @Supplier_Legal_Address,
        [Supplier_Physical_Address] = @Supplier_Physical_Address,
        [Supplier_E_Mail] = @Supplier_E_Mail,
        [Supplier_Phone_Number] = @Supplier_Phone_Number
        where [ID_Supplier] = @ID_Supplier
go

create or alter procedure [dbo].[Supplier_delete]
@ID_Supplier int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Representative] where Supplier_ID = @ID_Supplier)
    if (@any_child_record > 0)
        print('Поставщик не может быть удален, т.к. используеся в таблице "Представитель"')
    else
        delete from [dbo].[Supplier] where ID_Supplier = @ID_Supplier
go

create or alter procedure [dbo].[Representative_insert]
@Supplier_ID int,
@Repres_First_Name varchar(30),
@Repres_Second_Name varchar(30),
@Repres_Middle_Name varchar(30)
as
    begin try
        insert into [dbo].[Representative] ([Supplier_ID], [Repres_First_Name],
        [Repres_Second_Name], [Repres_Middle_Name])
        values (@Supplier_ID, @Repres_First_Name, @Repres_Second_Name,
        @Repres_Middle_Name)
    end try
    begin catch
        print('Не удалось вставить поставщика')
    end catch
go

create or alter procedure [dbo].[Representative_update]
@ID_Representative int,
@Supplier_ID int,
@Repres_First_Name varchar(30),
@Repres_Second_Name varchar(30),
@Repres_Middle_Name varchar(30)
as
    update [dbo].[Representative] set
        [Supplier_ID] = @Supplier_ID,
        [Repres_First_Name] = @Repres_First_Name,
        [Repres_Second_Name] = @Repres_Second_Name,
        [Repres_Middle_Name] = @Repres_Middle_Name
        where [ID_Representative] = @ID_Representative
go

create or alter procedure [dbo].[Representative_delete]
@ID_Representative int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Contract] where Representative_ID = @ID_Representative)
    if (@any_child_record > 0)
        print('Представитель не может быть удален, т.к. используеся в таблице "Поставщик"')
    else
        delete from [dbo].[Representative] where ID_Representative = @ID_Representative
go

create or alter procedure [dbo].[Contract_insert]
@Representative_ID int,
@Contract_Expiry_Date date,
@Contract_Conclusion_Date date
as
    begin try
        insert into [dbo].[Contract] ([Representative_ID], [Contract_Expiry_Date],
        [Contract_Conclusion_Date])
        values (@Representative_ID, @Contract_Expiry_Date, @Contract_Conclusion_Date)
        return 1
    end try
    begin catch
        print('Не удалось вставить контракт')
    end catch
go

create or alter procedure [dbo].[Contract_update]
@ID_Contract int,
@Representative_ID int,
@Contract_Expiry_Date date,
@Contract_Conclusion_Date date
as
    update [dbo].[Contract] set
        [Representative_ID] = @Representative_ID,
        [Contract_Expiry_Date] = @Contract_Expiry_Date,
        [Contract_Conclusion_Date] = @Contract_Conclusion_Date
        where [ID_Contract] = @ID_Contract
go

create or alter procedure [dbo].[Contract_delete]
@ID_Contract int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Requests_For_Supply] where Contract_ID = @ID_Contract)
    if (@any_child_record > 0)
        print('Контракт не может быть удален, т.к. используеся в таблице "Заявки на поставки"')
    else
        delete from [dbo].[Contract] where ID_Contract = @ID_Contract
go

create or alter procedure [dbo].[Characteristics_Name_insert]
@Characteristic_Name varchar(30)
as
    begin try
        insert into [dbo].[Characteristics_Name] ([Characteristic_Name])
        values (@Characteristic_Name)
        return 1
    end try
    begin catch
        print('Не удалось вставить имя характеристики')
    end catch
go

create or alter procedure [dbo].[Characteristics_Name_update]
@ID_Characteristic_Name int,
@Characteristic_Name varchar(30)
as
    declare @exist_record [int] = (select count(*) from [dbo].[Characteristics_Name]
	where [Characteristic_Name] = @Characteristic_Name)
	if (@exist_record > 0)
	print('Такое название характеристики уже есть в таблице!')
	else
        update [dbo].[Characteristics_Name] set
        [Characteristic_Name] = @Characteristic_Name
        where [ID_Characteristic_Name] = @ID_Characteristic_Name
go

create or alter procedure [dbo].[Characteristics_Name_delete]
@ID_Characteristic_Name int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Characteristics] where Characteristic_Name_ID = @ID_Characteristic_Name)
    if (@any_child_record > 0)
        print('Название характеристики не может быть удалено, т.к. используеся в таблице "Характеристики"')
    else
        delete from [dbo].[Characteristics_Name] where ID_Characteristic_Name = @ID_Characteristic_Name
go

create or alter procedure [dbo].[Goods_Type_insert]
@Goods_Type_Name varchar(30)
as
    begin try
        insert into [dbo].[Goods_Type] ([Goods_Type_Name])
        values (@Goods_Type_Name)
        return 1
    end try
    begin catch
        print('Не удалось вставить тип товара')
    end catch
go

create or alter procedure [dbo].[Goods_Type_update]
@ID_Goods_Type int,
@Goods_Type_Name varchar(30)
as
    declare @exist_record [int] = (select count(*) from [dbo].[Goods_Type]
	where [Goods_Type_Name] = @Goods_Type_Name)
	if (@exist_record > 0)
	print('Такое название типа товара уже есть в таблице!')
	else
        update [dbo].[Goods_Type] set
        [Goods_Type_Name] = @Goods_Type_Name
        where [ID_Goods_Type] = @ID_Goods_Type
go

create or alter procedure [dbo].[Goods_Type_delete]
@ID_Goods_Type int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Goods] where Goods_Type_ID = @ID_Goods_Type)
    if (@any_child_record > 0)
        print('Типт товара не может быть удален, т.к. используеся в таблице "Товар"')
    else
        delete from [dbo].[Goods_Type] where ID_Goods_Type = @ID_Goods_Type
go

create or alter procedure [dbo].[Outlets_Name_insert]
@Outlet_Name varchar(50)
as
    begin try
        insert into [dbo].[Outlets_Name] ([Outlet_Name])
        values (@Outlet_Name)
        return 1
    end try
    begin catch
        print('Не удалось вставить имя торговой точки')
    end catch
go

create or alter procedure [dbo].[Outlets_Name_update]
@ID_Name int,
@Outlet_Name varchar(50)
as
    declare @exist_record [int] = (select count(*) from [dbo].[Outlets_Name]
	where [Outlet_Name] = @Outlet_Name)
	if (@exist_record > 0)
	print('Такое название торговой точки уже есть в таблице!')
	else
        update [dbo].[Outlets_Name] set
        [Outlet_Name] = @Outlet_Name
        where [ID_Name] = @ID_Name
go

create or alter procedure [dbo].[Outlets_Name_delete]
@ID_Name int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Outlet] where Name_ID = @ID_Name)
    if (@any_child_record > 0)
        print('Название торговых точек не может быть удалено, т.к. используеся в таблице "Торговая точка"')
    else
        delete from [dbo].[Outlets_Name] where ID_Name = @ID_Name
go

create or alter procedure [dbo].[Outlet_insert]
@Outlet_Adress varchar(max),
@Name_ID int
as
    begin try
        insert into [dbo].[Outlet] ([Outlet_Adress],[Name_ID])
        values (@Outlet_Adress, @Name_ID)
        return 1
    end try
    begin catch
        print('Не удалось вставить торговую точку')
    end catch
go

create or alter procedure [dbo].[Outlet_update]
@ID_Outlet int,
@Outlet_Adress varchar(max),
@Name_ID int
as
    declare @exist_record [int] = (select count(*) from [dbo].[Outlet]
	where [Outlet_Adress] = @Outlet_Adress)
	if (@exist_record > 0)
	print('Торговая точка с таким адресом уже есть в таблице!')
	else
        update [dbo].[Outlet] set
        [Outlet_Adress] = @Outlet_Adress,
        [Name_ID] = @Name_ID
        where [ID_Outlet] = @ID_Outlet
go

create or alter procedure [dbo].[Outlet_delete]
@ID_Outlet int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Employee] where Outlet_ID = @ID_Outlet)
    if (@any_child_record > 0)
        print('Торговая точка не может быть удалена, т.к. используеся в таблице "Сотрудник"')
    else
        delete from [dbo].[Outlet] where ID_Outlet = @ID_Outlet
go

create or alter procedure [dbo].[Post_insert]
@Post_Name varchar(50),
@Post_Salary int,
@Superior_Post_ID int
as
    begin try
        set @Superior_Post_ID = (select max(ID_Post) from Post) + 1
        insert into [dbo].[Post] ([Post_Name],[Post_Salary],[Superior_Post_ID])
        values (@Post_Name, @Post_Salary, @Superior_Post_ID)
        return 1
    end try
    begin catch
        print('Не удалось вставить должность')
    end catch
go

create or alter procedure [dbo].[Post_update]
@ID_Post int,
@Post_Name varchar(50),
@Post_Salary int,
@Superior_Post_ID int
as
    declare @exist_record [int] = (select count(*) from [dbo].[Post]
	where [Post_Name] = @Post_Name)
	if (@exist_record > 0)
	print('Такое название должности уже есть в таблице!')
	else
        set @Superior_Post_ID = (select ID_Post from Post where ID_Post = @ID_Post)
        update [dbo].[Post] set
        [Post_Name] = @Post_Name,
        [Post_Salary] = @Post_Salary,
        [Superior_Post_ID] = @Superior_Post_ID
        where [ID_Post] = @ID_Post
go

create or alter procedure [dbo].[Post_delete]
@ID_Post int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Post] where Superior_Post_ID = @ID_Post) + (select count(*)
    from [dbo].[Employee] where Post_ID = @ID_Post)
    if (@any_child_record > 0)
        print('Должность не может быть удалена, т.к. используеся в таблице "Сотрудник" или является превосходящей')
    else
        delete from [dbo].[Post] where ID_Post = @ID_Post
go

create or alter procedure [dbo].[Employee_insert]
@Emp_First_Name varchar(30),
@Emp_Second_Name varchar(30),
@Emp_Middle_Name varchar(30),
@Post_ID int,
@Outlet_ID int,
@Emp_Login varchar(32),
@Emp_Password varchar(32)
as
    begin try
        insert into [dbo].[Employee] ([Emp_First_Name],[Emp_Second_Name],
        [Emp_Middle_Name],[Post_ID],[Outlet_ID],[Emp_Login],[Emp_Password])
        values (@Emp_First_Name, @Emp_Second_Name, @Emp_Middle_Name,
        @Post_ID, @Outlet_ID, @Emp_Login, @Emp_Password)
        return 1
    end try
    begin catch
        print('Не удалось вставить сотрудника')
    end catch
go

create or alter procedure [dbo].[Employee_update]
@ID_Employee int,
@Emp_First_Name varchar(30),
@Emp_Second_Name varchar(30),
@Emp_Middle_Name varchar(30),
@Post_ID int,
@Outlet_ID int,
@Emp_Login varchar(32),
@Emp_Password varchar(32)
as
    declare @exist_record [int] = (select count(*) from [dbo].[Employee]
	where [Emp_Login] = @Emp_Login)
	if (@exist_record > 0)
	print('Сортудник с таким логином уже есть в таблице!')
	else
        update [dbo].[Employee] set
        [Emp_First_Name] = @Emp_First_Name,
        [Emp_Second_Name] = @Emp_Second_Name,
        [Emp_Middle_Name] = @Emp_Middle_Name,
        [Post_ID] = @Post_ID,
        [Outlet_ID] = @Outlet_ID,
        [Emp_Login] = @Emp_Login,
        [Emp_Password] = @Emp_Password
        where [ID_Employee] = @ID_Employee
go

create or alter procedure [dbo].[Employee_delete]
@ID_Employee int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Requests_For_Supply] where Employee_ID = @ID_Employee) + (select count(*)
    from [dbo].[Receipt] where Employee_ID = @ID_Employee)
    if (@any_child_record > 0)
        print('Сотрудник не может быть удален, т.к. используеся в таблице "Чек"')
    else
        delete from [dbo].[Employee] where ID_Employee = @ID_Employee
go

create or alter procedure [dbo].[Passport_insert]
@Buyer_ID int,
@Buyer_First_Name varchar(30),
@Buyer_Second_Name varchar(30),
@Buyer_Middle_Name varchar(30),
@Passport_Series varchar(5),
@Passport_Code varchar(6),
@Buyer_Gender varchar(3),
@Buyer_Birthday date,
@Buyer_Birthplace varchar(30),
@Passport_Issued_By varchar(100)
as
    begin try
        insert into [dbo].[Passport] ([Buyer_ID],[Buyer_First_Name],
        [Buyer_Second_Name],[Buyer_Middle_Name],[Passport_Series],
        [Passport_Code],[Buyer_Gender],[Buyer_Birthday],
        [Buyer_Birthplace],[Passport_Issued_By])
        values (@Buyer_ID, @Buyer_First_Name, @Buyer_Second_Name,
        @Buyer_Middle_Name, @Passport_Series, @Passport_Code, @Buyer_Gender,
        @Buyer_Birthday,@Buyer_Birthplace,@Passport_Issued_By)
        return 1
    end try
    begin catch
        print('Не удалось вставить паспорт покупателя')
    end catch
go

create or alter procedure [dbo].[Passport_update]
@ID_Passport int,
@Buyer_ID int,
@Buyer_First_Name varchar(30),
@Buyer_Second_Name varchar(30),
@Buyer_Middle_Name varchar(30),
@Passport_Series varchar(5),
@Passport_Code varchar(6),
@Buyer_Gender varchar(3),
@Buyer_Birthday date,
@Buyer_Birthplace varchar(30),
@Passport_Issued_By varchar(100)
as
    declare @exist_record [int] = (select count(*) from [dbo].[Passport]
	where [Passport_Series] = @Passport_Series and [Passport_Code] = @Passport_Code)
	if (@exist_record > 0)
	print('Паспорт с таким номером уже есть в таблице!')
	else
        update [dbo].[Passport] set
        [Buyer_ID] = @Buyer_ID,
        [Buyer_First_Name] = @Buyer_First_Name,
        [Buyer_Second_Name] = @Buyer_Second_Name,
        [Buyer_Middle_Name] = @Buyer_Middle_Name,
        [Passport_Series] = @Passport_Series,
        [Passport_Code] = @Passport_Code,
        [Buyer_Gender] = @Buyer_Gender,
        [Buyer_Birthday] = @Buyer_Birthday,
        [Buyer_Birthplace] = @Buyer_Birthplace,
        [Passport_Issued_By] = @Passport_Issued_By
        where [ID_Passport] = @ID_Passport
go

create or alter procedure [dbo].[Passport_delete]
@ID_Passport int
as
    begin try
        delete from [dbo].[Passport] where ID_Passport = @ID_Passport
    end try
    begin catch
        print('Не получилось удалить паспорт')
    end catch
go

create or alter procedure [dbo].[Payment_Type_insert]
@Payment_Type_Name varchar(30)
as
    begin try
        insert into [dbo].[Payment_Type] ([Payment_Type_Name])
        values (@Payment_Type_Name)
        return 1
    end try
    begin catch
        print('Не удалось вставить тип оплаты')
    end catch
go

create or alter procedure [dbo].[Payment_Type_update]
@ID_Payment_Type int,
@Payment_Type_Name varchar(30)
as
    declare @exist_record [int] = (select count(*) from [dbo].[Payment_Type]
	where [Payment_Type_Name] = @Payment_Type_Name)
	if (@exist_record > 0)
	print('Такое название типа оплаты уже есть в таблице!')
	else
        update [dbo].[Payment_Type] set
        [Payment_Type_Name] = @Payment_Type_Name
        where [ID_Payment_Type] = @ID_Payment_Type
go

create or alter procedure [dbo].[Payment_Type_delete]
@ID_Payment_Type int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Order] where Payment_Type_ID = @ID_Payment_Type)
    if (@any_child_record > 0)
        print('Ти оплаты не может быть удален, т.к. используеся в таблице "Заказ"')
    else
        delete from [dbo].[Payment_Type] where ID_Payment_Type = @ID_Payment_Type
go

create or alter procedure [dbo].[Order_insert]
@Buyer_Card_ID int,
@Payment_Type_ID int
as
    begin try
        insert into [dbo].[Order] ([Buyer_Card_ID],[Payment_Type_ID])
        values (@Buyer_Card_ID,@Payment_Type_ID)
        return 1
    end try
    begin catch
        print('Не удалось вставить заказ')
    end catch
go

create or alter procedure [dbo].[Order_update]
@ID_Order int,
@Buyer_Card_ID int,
@Payment_Type_ID int
as
    update [dbo].[Order] set
        [Buyer_Card_ID] = @Buyer_Card_ID,
        [Payment_Type_ID] = @Payment_Type_ID
        where [ID_Order] = @ID_Order
go

create or alter procedure [dbo].[Order_delete]
@ID_Order int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Receipt] where Order_ID = @ID_Order) + (select count(*)
    from [dbo].[Order_Parts] where Order_ID = @ID_Order)
    if (@any_child_record > 0)
        print('Заказ не может быть удален, т.к. используеся в таблице "Чек" или "Часть заказа"')
    else
        delete from [dbo].[Order] where ID_Order = @ID_Order
go

create or alter procedure [dbo].[Receipt_insert]
@Order_ID int,
@Employee_ID int
as
    begin try
        declare @Receipt_Sum [money] = (select sum(G.Goods_Price * OP.Order_Goods_Amount)
                                      from Goods G
                                          join [dbo].[Order_Parts] OP on OP.Order_ID = @Order_ID
                                      where G.ID_Goods = OP.Goods_ID)
        declare @Receipt_Total [money] = @Receipt_Sum * 1.2
        insert into [dbo].[Receipt] ([Order_ID],[Receipt_Sum],[Receipt_Total],[Employee_ID])
        values (@Order_ID,@Receipt_Sum,@Receipt_Total,@Employee_ID)
        return 1
    end try
    begin catch
        print('Не удалось вставить чек')
    end catch
go

create or alter procedure [dbo].[Receipt_update]
@ID_Receipt int,
@Order_ID int,
@Receipt_Sum int,
@Receipt_Total int,
@Employee_ID int
as
    update [dbo].[Receipt] set
        [Order_ID] = @Order_ID,
        [Receipt_Sum] = @Receipt_Sum,
        [Receipt_Total] = @Receipt_Total,
        [Employee_ID] = @Employee_ID
        where [ID_Receipt] = @ID_Receipt
go

create or alter procedure [dbo].[Receipt_delete]
@ID_Receipt int
as
    begin try
        delete from [dbo].[Receipt] where ID_Receipt = @ID_Receipt
    end try
    begin catch
        print('Не удалось удалить чек')
    end catch
go

create or alter procedure [dbo].[Requests_For_Supply_insert]
@Request_Status varchar(10),
@Contract_ID int,
@Employee_ID int
as
    begin try
        insert into [dbo].[Requests_For_Supply] ([Request_Status],[Contract_ID],[Employee_ID])
        values (@Request_Status,@Contract_ID,@Employee_ID)
        return 1
    end try
    begin catch
        print('Не удалось вставить запрос на поставку')
    end catch
go

create or alter procedure [dbo].[Requests_For_Supply_update]
@ID_Request int,
@Request_Status varchar(10),
@Contract_ID int,
@Employee_ID int
as
    update [dbo].[Requests_For_Supply] set
        [Request_Status] = @Request_Status,
        [Contract_ID] = @Contract_ID,
        [Employee_ID] = @Employee_ID
        where [ID_Request] = @ID_Request
go

create or alter procedure [dbo].[Requests_For_Supply_delete]
@ID_Request int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Requests_Parts] where Request_ID = @ID_Request)
    if (@any_child_record > 0)
        print('Заявка на поставку не может быть удалена, т.к. используеся в таблице "Часть заявки на поставку"')
    else
        delete from [dbo].[Requests_For_Supply] where ID_Request = @ID_Request
go

create or alter procedure [dbo].[Goods_insert]
@Goods_Name varchar(100),
@Goods_Article varchar(100),
@Goods_ID int,
@Manufacturer_ID int,
@Goods_Price decimal(10,2),
@Photo_Tag varchar(64),
@Goods_Type_ID int
as
    begin try
        insert into [dbo].[Goods] ([Goods_Name],[Goods_Article],[Goods_ID],[Manufacturer_ID],[Goods_Price],[Photo_Tag],[Goods_Type_ID])
        values (@Goods_Name,@Goods_Article,@Goods_ID,@Manufacturer_ID,@Goods_Price,@Photo_Tag,@Goods_Type_ID)
        return 1
    end try
    begin catch
        print('Не удалось вставить товар')
    end catch
go

create or alter procedure [dbo].[Goods_update]
@ID_Goods int,
@Goods_Name varchar(100),
@Goods_Article varchar(100),
@Goods_ID int = @ID_Goods,
@Manufacturer_ID int,
@Goods_Price decimal(10,2),
@Photo_Tag varchar(64),
@Goods_Type_ID int
as
    declare @exist_record [int] = (select count(*) from [dbo].[Goods]
	where [Goods_Article] = @Goods_Article)
	if (@exist_record > 0)
	print('Товар с данным артикулом уже есть в таблице!')
	else
        update [dbo].[Goods] set
        [Goods_Name] = @Goods_Name,
        [Goods_Article] = @Goods_Article,
        [Goods_ID] = @Goods_ID,
        [Manufacturer_ID] = @Manufacturer_ID,
        [Goods_Price] = @Goods_Price,
        [Photo_Tag] = @Photo_Tag,
        [Goods_Type_ID] = @Goods_Type_ID
        where [ID_Goods] = @ID_Goods
go

create or alter procedure [dbo].[Goods_delete]
@ID_Goods int
as
    declare @any_child_record [int] = (select count(*)
    from [dbo].[Characteristics] where Goods_ID = @ID_Goods) + (select count(*)
    from [dbo].[Requests_Parts] where Goods_ID = @ID_Goods) + (select count(*)
    from [dbo].[Order_Parts] where Goods_ID = @ID_Goods)
    if (@any_child_record > 0)
        print('Товар не может быть удален, т.к. используеся в таблице "Характеристики", "Часть заявки на поставку" или "Часть заказа"')
    else
        delete from [dbo].[Goods] where ID_Goods = @ID_Goods
go

create or alter procedure [dbo].[Order_Parts_insert]
@Goods_ID int,
@Order_Goods_Amount int,
@Order_ID int
as
    begin try
        insert into [dbo].[Order_Parts] ([Goods_ID], [Order_Goods_Amount], [Order_ID])
        values (@Goods_ID, @Order_Goods_Amount, @Order_ID)
        return 1
    end try
    begin catch
        print('Не удалось вставить часть заказа')
    end catch
go

create or alter procedure [dbo].[Order_Parts_update]
@ID_Order_Parts int,
@Goods_ID int,
@Order_Goods_Amount int,
@Order_ID int
as
    declare @exist_record [int] = (select count(*) from [dbo].[Order_Parts]
	where [Goods_ID] = @Goods_ID and [Order_ID] = @Order_ID)
	if (@exist_record > 0)
	print('Данный товар уже есть в заказе!')
	else
        update [dbo].[Order_Parts] set
        [Goods_ID] = @Goods_ID,
        [Order_Goods_Amount] = @Order_Goods_Amount,
        [Order_ID] = @Order_ID
        where [ID_Order_Parts] = @ID_Order_Parts
go

create or alter procedure [dbo].[Order_Parts_delete]
@ID_Order_Parts int
as
    begin try
        delete from [dbo].[Order_Parts] where ID_Order_Parts = @ID_Order_Parts
    end try
    begin catch
        print('Не удалось удалить часть заказа')
    end catch
go

create or alter procedure [dbo].[Requests_Parts_insert]
@Goods_ID int,
@Request_ID int,
@Requests_Goods_Amount int
as
    begin try
        insert into [dbo].[Requests_Parts] ([Goods_ID], [Request_ID], [Requests_Goods_Amount])
        values (@Goods_ID, @Request_ID, @Requests_Goods_Amount)
        return 1
    end try
    begin catch
        print('Не удалось вставить часть запроса')
    end catch
go

create or alter procedure [dbo].[Requests_Parts_update]
@ID_Requests_Parts int,
@Goods_ID int,
@Request_ID int,
@Requests_Goods_Amount int
as
    declare @exist_record [int] = (select count(*) from [dbo].[Requests_Parts]
	where [Goods_ID] = @Goods_ID and [Request_ID] = @Request_ID)
	if (@exist_record > 0)
	print('Данный товар уже есть в заявке!')
	else
        update [dbo].[Requests_Parts] set
        [Goods_ID] = @Goods_ID,
        [Request_ID] = @Request_ID,
        [Requests_Goods_Amount] = @Requests_Goods_Amount
        where [ID_Requests_Parts] = @ID_Requests_Parts
go

create or alter procedure [dbo].[Requests_Parts_delete]
@ID_Requests_Parts int
as
    begin try
        delete from [dbo].[Requests_Parts] where ID_Requests_Parts = @ID_Requests_Parts
    end try
    begin catch
        print('Не удалось удалить часть заявки на поставку')
    end catch
go

create or alter procedure [dbo].[Characteristics_insert]
@Goods_ID int,
@Characteristic_Name_ID int,
@Characteristics_Value varchar(50)
as
    begin try
        insert into [dbo].[Characteristics] ([Goods_ID], [Characteristic_Name_ID], [Characteristics_Value])
        values (@Goods_ID, @Characteristic_Name_ID, @Characteristics_Value)
        return 1
    end try
    begin catch
        print('Не удалось вставить характеристику')
    end catch
go

create or alter procedure [dbo].[Characteristics_update]
@ID_Characteristics int,
@Goods_ID int,
@Characteristic_Name_ID int,
@Characteristics_Value varchar(50)
as
    declare @exist_record [int] = (select count(*) from [dbo].[Characteristics]
	where [Goods_ID] = @Goods_ID and [Characteristic_Name_ID] = @Characteristic_Name_ID)
	if (@exist_record > 0)
	print('У товара уже есть данная характеристика!')
	else
        update [dbo].[Characteristics] set
        [Goods_ID] = @Goods_ID,
        [Characteristic_Name_ID] = @Characteristic_Name_ID,
        [Characteristics_Value] = @Characteristics_Value
        where [ID_Characteristics] = @ID_Characteristics
go

create or alter procedure [dbo].[Characteristics_delete]
@ID_Characteristics int
as
    begin try
        delete from [dbo].[Characteristics] where ID_Characteristics = @ID_Characteristics
    end try
    begin catch
        print('Не удалось удалить характеристику')
    end catch
go