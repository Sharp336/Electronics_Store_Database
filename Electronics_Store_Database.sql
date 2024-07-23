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


ALTER TABLE [dbo].[Goods] DROP CONSTRAINT [FK_Goods_Goods];
ALTER TABLE [dbo].[Goods] DROP COLUMN [Goods_ID];
go

ALTER TABLE [dbo].[Goods]
ADD [Goods_Description] [varchar] (500) NULL;
go

INSERT INTO [dbo].[Goods_Type] ([Goods_Type_Name])
VALUES 
('Вибраторы'), ('Накопители'), ('Периферия'), ('Мониторы'), ('Наушники'), ('Внешние накопители'), ('Роутеры'), ('Веб-камеры'), 
('Принтеры'), ('ИБП'), ('Аудио системы'), ('МФУ'), ('Модемы'), ('Сканеры'), ('Графические планшеты'), ('Портативные колонки'), 
('Карты памяти'), ('Медиаплееры'), ('Звуковые карты'), ('Портативные проекторы'), ('Умные часы'), ('Видеокамеры'), 
('Bluetooth-колонки'), ('Умные колонки'), ('Экшн-камеры');
GO

INSERT INTO [dbo].[Goods] ([Goods_Name], [Goods_Article], [Manufacturer_ID], [Goods_Price], [Photo_Tag], [Goods_Type_ID])
VALUES 
('Видеокарта MSI GeForce RTX 3080 GAMING X TRIO', 'RTX3080GAMINGXTRIO', 5, 120000.00, 'E7AC374CA0D7A47C54811A55DF7ACAF5A1', 2),
('Видеокарта ASUS TUF Gaming GeForce RTX 3070', 'TUF-RTX3070', 5, 80000.00, '9B2F53DE3F54A8B54B2FB6E1F1F99C55A2', 2),
('Видеокарта Zotac Gaming GeForce RTX 3060', 'ZT-A30600H-10M', 5, 50000.00, 'A78B8765347BAE758127B5C7F89C43D8A3', 2),
('Процессор AMD Ryzen 9 5900X', '100-100000061WOF', 6, 40000.00, 'FDB2BEB27A34568CDE9A7A2C55B0D5C1A4', 5),
('Процессор AMD Ryzen 7 5800X', '100-100000063WOF', 6, 30000.00, '4C573BFC9DAA4A98B5A3E8B8EFAAA8DFA5', 5),
('Процессор Intel Core i7-12700K', 'BX8071512700K', 5, 35000.00, 'BF3C4EACDFA9F5D95F6FA48B2A55556FA6', 5),
('Материнская плата MSI MPG Z590 Gaming Carbon WiFi', '7D06-002R', 5, 20000.00, 'D4BF8E7BC4A1A9B7C2F8C6E7A8BF7A5FA7', 1),
('Материнская плата ASRock B450M Steel Legend', 'B450MSTEELLEGEND', 6, 10000.00, 'A4C57D8E7FA8C9B2D8F9A7E7B5F5D6F5A8', 1),
('Материнская плата Gigabyte B550 AORUS Elite', 'B550AORUSELITE', 5, 15000.00, 'E3C8B7DFA6A5B2C8D6F8E7B7A5B8E6C5A9', 1),
('Оперативная память G.Skill Trident Z RGB 32GB', 'F4-3200C16D-32GTZR', 5, 12000.00, '2A3F7CDE8A4B5E7A8B6F8D9E6A4B2F7DA1', 4),
('Оперативная память Kingston HyperX Fury 16GB', 'HX432C16FB3/16', 5, 6000.00, 'C6D9F8E7A4B5C2D8E7B4C5D8A9F6B7D8A2', 4),
('Оперативная память Corsair Dominator Platinum 64GB', 'CMT64GX4M2C3200C16', 5, 24000.00, 'F8E7A4B6D9C5B2D8E7B4A6F5C9D8A4F5A3', 4),
('Корпус Cooler Master MasterBox Q300L', 'MCB-Q300L-KANN-S00', 5, 4000.00, 'D8E7B4A5C9F8D6E7B2A4C8F5A7D6F4B7A4', 3),
('Корпус Fractal Design Meshify C', 'FD-CA-MESH-C-BKO-TG', 5, 8000.00, 'E7A4B5C8F6D7E8A4B6C5D7F4A9E6C8B7A5', 3),
('Корпус NZXT H710', 'CA-H710B-B1', 5, 10000.00, 'A4B6E7C5D8F7A4C5B2E6D8F7A5B4C9D8A6', 3),
('Мышь Logitech MX Master 3', '910-005710', 5, 8000.00, 'E7B5D8C6F4A5B7E9A4D8F5A6C5D8B7A4A7', 6),
('Клавиатура Razer BlackWidow V3', 'RZ03-03540100-R3M1', 5, 12000.00, 'A5D8E7C6F4B5A4E7D8C5B6F7A4C9E8D7A8', 6),
('Монитор Dell UltraSharp U2720Q', 'U2720Q', 5, 60000.00, 'C6D7E8F5A4B7E9A5D8F4C6A7B9D8F6E7A9', 6),
('Наушники Sony WH-1000XM4', 'WH1000XM4B.CE7', 5, 25000.00, 'B6A4E8D7F5C4B5A7E6D8F5B6C7A4E9F5B1', 7),
('Внешний накопитель Samsung T7 Touch 1TB', 'MU-PC1T0K', 5, 12000.00, 'A4E7B6C5D8F7A4E6D8F5B6A7C5D9F8E7B2', 10),
('Роутер ASUS RT-AX88U', 'RT-AX88U', 5, 20000.00, 'D8E7C6B5F4A5E7B6D8F4A7C5B8D9F6E7B3', 11),
('Веб-камера Logitech C920', '960-001055', 5, 7000.00, 'A5D8E7C6F4B6A5E7D8F5C6A4B7D9F8E7B4', 12),
('SSD диск Samsung 970 EVO Plus 1TB', 'MZ-V7S1T0BW', 5, 15000.00, 'C6D8E7A4B5F6A7D8F4C5B7E9D8F6A4C5B5', 10),
('Блок питания Corsair RM850x', 'CP-9020180-EU', 5, 10000.00, 'E7A4D8B6C5F7A5E9D8F4C6B5A4D7F8E6B6', 1),
('Коврик для мыши SteelSeries QcK', '63004', 5, 2000.00, 'B6A5D8E7C6F4A7E8D8F5C4B7A6E9D8F5B7', 6),
('Принтер HP LaserJet Pro M404dn', 'W1A53A', 5, 20000.00, 'A5B7E8D6C5F4A7E9D8F5C6B4A5D7F8E7B8', 13),
('ИБП APC Back-UPS BE700G-RS', 'BE700G-RS', 5, 8000.00, 'C5D8E7A4B6F5A7E8D6F4C5B7A9E8F7D6B9', 14),
('Колонки Edifier R1280T', 'R1280T', 5, 5000.00, 'E7D8C5A6B4F5A7E9D6F5C4B7A5D8F6E7C1', 15),
('МФУ Canon PIXMA G3411', '2315C025', 5, 15000.00, 'A5D7E8B6C4F5A7E8D5F4C6B7A9D8F5E6C2', 16),
('Модем Huawei E8372h-320', 'E8372H-320', 5, 4000.00, 'B6A5E8D7F5C4A7E8D6F5C7B4A5D8F6E7C3', 17),
('Сканер Epson Perfection V600', 'B11B198033', 5, 25000.00, 'C5A7D8E7F4B6A5E9D6F4C5B7A5D8F6E7C4', 18),
('Роутер TP-Link Archer AX50', 'Archer AX50', 5, 9000.00, 'E7C5D8A4B6F5A7E8D5F4C6B5A7D8F6E7C5', 11),
('Графический планшет Wacom Intuos Pro', 'PTH-660-N', 5, 35000.00, 'A5B7E8D6C5F4A7E9D8F5C6B4A5D7F8E6C6', 19),
('Портативная колонка JBL Charge 4', 'JBLCHARGE4BLK', 5, 10000.00, 'D6E7A4B5C8F5A7E8D4F5C7A5D8B6F9E7C7', 20),
('Карта памяти SanDisk Extreme Pro 128GB', 'SDSDXXY-128G-GN4IN', 5, 5000.00, 'E7C6A5D8F4B6A5E9D5F4C7B4A5D8F6E7C8', 21),
('Медиаплеер Apple TV 4K 32GB', 'MQD22RS/A', 5, 15000.00, 'A5D8E7C5F4B6A7E8D5F4C6B7A5D8F6E7C9', 22),
('Звуковая карта Creative Sound Blaster Z', '70SB150000002', 5, 8000.00, 'C6D8E7A4B5F6A7D8F4C5B7E9D8F6A4C5D1', 23),
('Портативный проектор Anker Nebula Capsule II', 'D2421G11', 5, 30000.00, 'E7A4D8B6C5F7A5E9D8F4C6B5A4D7F8E6D2', 24),
('Умные часы Samsung Galaxy Watch 4', 'SM-R870NZKAEUE', 5, 20000.00, 'B6A5E8D7F5C4A7E8D6F5C7B4A5D8F6E7D3', 25),
('Видеокамера Sony FDR-AX43', 'FDRAX43/B', 5, 60000.00, 'C5A7D8E7F4B6A5E9D6F4C5B7A5D8F6E7D4', 26),
('Bluetooth-колонка Bose SoundLink Revolve+', '739617-1110', 5, 25000.00, 'E7C5D8A4B6F5A7E8D5F4C6B5A7D8F6E7D5', 27),
('Умная колонка Яндекс.Станция', 'YSTATION1', 5, 10000.00, 'A5B7E8D6C5F4A7E9D8F5C6B4A5D7F8E6D6', 28),
('Экшн-камера GoPro HERO9 Black', 'CHDHX-901-RW', 5, 40000.00, 'D6E7A4B5C8F5A7E8D4F5C7A5D8B6F9E7D7', 28);
GO

CREATE TABLE [dbo].[Goods_Parts]
(
    [ID_Goods_Parts] [int] NOT NULL IDENTITY(1,1),
    [Parent_Goods_ID] [int] NOT NULL,
    [Part_Goods_ID] [int] NOT NULL,
    CONSTRAINT [PK_Goods_Parts] PRIMARY KEY CLUSTERED ([ID_Goods_Parts] ASC),
    CONSTRAINT [FK_Goods_Parts_Parent_Goods] FOREIGN KEY ([Parent_Goods_ID]) REFERENCES [dbo].[Goods]([ID_Goods]),
    CONSTRAINT [FK_Goods_Parts_Part_Goods] FOREIGN KEY ([Part_Goods_ID]) REFERENCES [dbo].[Goods]([ID_Goods])
);
go

--CREATE PROCEDURE CreatePCAssembly
--    @AssemblyName NVARCHAR(100),
--    @AssemblyArticle NVARCHAR(100),
--    @ManufacturerID INT,
--    @PhotoTag NVARCHAR(64),
--    @GoodsTypeID INT,
--    @PartArticles NVARCHAR(MAX),
--    @IsSuccess BIT OUTPUT
--AS
--BEGIN
--    SET NOCOUNT ON;

--    DECLARE @AssemblyID INT;
--    DECLARE @PartIDs NVARCHAR(MAX);
--    DECLARE @TotalPrice DECIMAL(10, 2);
--    DECLARE @Article NVARCHAR(100);
--    DECLARE @PartID INT;
--    DECLARE @AllPartsExist BIT;
--    SET @AllPartsExist = 1;
--    SET @PartIDs = '';
--    SET @TotalPrice = 0;

--    DECLARE @XML XML = CAST('<i>' + REPLACE(@PartArticles, ',', '</i><i>') + '</i>' AS XML);

--    DECLARE cursor_Articles CURSOR FOR
--    SELECT T.X.value('.', 'NVARCHAR(100)')
--    FROM @XML.nodes('/i') AS T(X);

--    OPEN cursor_Articles;
--    FETCH NEXT FROM cursor_Articles INTO @Article;

--    WHILE @@FETCH_STATUS = 0
--    BEGIN
--        PRINT 'Проверка артикула: ' + @Article;

--        SET @PartID = NULL;

--        SELECT @PartID = ID_Goods
--        FROM [dbo].[Goods]
--        WHERE Goods_Article = @Article;

--        IF @PartID IS NULL
--        BEGIN
--            PRINT 'Товар с артикулом ' + @Article + ' не найден';
--            SET @AllPartsExist = 0;
--            BREAK;
--        END
--        ELSE
--        BEGIN
--            PRINT 'Товар найден с ID: ' + CAST(@PartID AS NVARCHAR);
--            SET @PartIDs = @PartIDs + CAST(@PartID AS NVARCHAR) + ',';
--            SET @TotalPrice = @TotalPrice + (SELECT Goods_Price FROM [dbo].[Goods] WHERE ID_Goods = @PartID);
--            PRINT 'Текущая общая цена: ' + CAST(@TotalPrice AS NVARCHAR(20));
--        END

--        FETCH NEXT FROM cursor_Articles INTO @Article;
--    END

--    CLOSE cursor_Articles;
--    DEALLOCATE cursor_Articles;

--    IF @AllPartsExist = 0
--    BEGIN
--        SET @IsSuccess = 0;
--        RETURN;
--    END

--    IF LEN(@PartIDs) > 0
--        SET @PartIDs = LEFT(@PartIDs, LEN(@PartIDs) - 1);

--    BEGIN TRY
--        BEGIN TRANSACTION;

--        INSERT INTO [dbo].[Goods] ([Goods_Name], [Goods_Article], [Manufacturer_ID], [Goods_Price], [Photo_Tag], [Goods_Type_ID], [Goods_Description])
--        VALUES (@AssemblyName, @AssemblyArticle, @ManufacturerID, @TotalPrice, @PhotoTag, @GoodsTypeID, 'Сборка ПК');

--        SET @AssemblyID = SCOPE_IDENTITY();
--        PRINT 'Новый товар-сборка создан с ID: ' + CAST(@AssemblyID AS NVARCHAR);

--        INSERT INTO [dbo].[Goods_Parts] ([Parent_Goods_ID], [Part_Goods_ID])
--        SELECT @AssemblyID, T.X.value('.', 'INT')
--        FROM (SELECT CAST('<i>' + REPLACE(@PartIDs, ',', '</i><i>') + '</i>' AS XML) AS XMLData) AS XMLDataTable
--        CROSS APPLY XMLDataTable.XMLData.nodes('/i') AS T(X);

--        PRINT 'Комплектующие добавлены для товара-сборки с ID: ' + CAST(@AssemblyID AS NVARCHAR);

--        COMMIT;

--        SET @IsSuccess = 1;
--    END TRY
--    BEGIN CATCH
--        ROLLBACK;
--        PRINT 'Произошла ошибка при создании сборки ПК: ' + ERROR_MESSAGE();
--        SET @IsSuccess = 0;
--    END CATCH;
--END;
--GO


CREATE PROCEDURE CreatePCAssembly
    @AssemblyName NVARCHAR(100),
    @AssemblyArticle NVARCHAR(100),
    @ManufacturerID INT,
    @PhotoTag NVARCHAR(64),
    @GoodsTypeID INT,
    @PartArticles NVARCHAR(MAX),
    @IsSuccess BIT OUTPUT 
AS
BEGIN
    SET NOCOUNT ON;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

    IF LEN(@PartArticles) - LEN(REPLACE(@PartArticles, ',', '')) + 1 < 2
    BEGIN
        PRINT 'Список артикулов должен содержать как минимум 2 артикула.';
        SET @IsSuccess = 0;
        RETURN;
    END

    DECLARE @AssemblyID INT;
    DECLARE @PartIDs NVARCHAR(MAX);
    DECLARE @TotalPrice DECIMAL(10, 2);
    DECLARE @AllPartsExist BIT;
    SET @AllPartsExist = 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT @PartIDs = STRING_AGG(CAST(ID_Goods AS NVARCHAR), ','), @TotalPrice = SUM(Goods_Price)
        FROM [dbo].[Goods]
        WHERE Goods_Article IN (SELECT value FROM STRING_SPLIT(@PartArticles, ','));

        IF (SELECT COUNT(*) FROM STRING_SPLIT(@PartArticles, ',')) != (SELECT COUNT(*) FROM [dbo].[Goods] WHERE Goods_Article IN (SELECT value FROM STRING_SPLIT(@PartArticles, ',')))
        BEGIN
            PRINT 'Один или более артикулов не найдены.';
            SET @IsSuccess = 0;
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO [dbo].[Goods] ([Goods_Name], [Goods_Article], [Manufacturer_ID], [Goods_Price], [Photo_Tag], [Goods_Type_ID], [Goods_Description])
        VALUES (@AssemblyName, @AssemblyArticle, @ManufacturerID, @TotalPrice, @PhotoTag, @GoodsTypeID, 'Сборка ПК');

        SET @AssemblyID = SCOPE_IDENTITY();
        PRINT 'Новый товар-сборка создан с ID: ' + CAST(@AssemblyID AS NVARCHAR);

        INSERT INTO [dbo].[Goods_Parts] ([Parent_Goods_ID], [Part_Goods_ID])
        SELECT @AssemblyID, CAST(value AS INT)
        FROM STRING_SPLIT(@PartIDs, ',');

        PRINT 'Комплектующие добавлены для товара-сборки с ID: ' + CAST(@AssemblyID AS NVARCHAR);

        COMMIT;

        SET @IsSuccess = 1;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Произошла ошибка при создании сборки ПК: ' + ERROR_MESSAGE();
        SET @IsSuccess = 0;
    END CATCH;
END;
GO



CREATE FUNCTION GetAssemblyPrice(@Parent_Goods_ID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalPrice DECIMAL(10, 2);
    
    SELECT @TotalPrice = SUM(G.Goods_Price)
    FROM [dbo].[Goods_Parts] GP
    JOIN [dbo].[Goods] G ON GP.Part_Goods_ID = G.ID_Goods
    WHERE GP.Parent_Goods_ID = @Parent_Goods_ID;
    
    RETURN ISNULL(@TotalPrice, 0);
END;
go

CREATE TRIGGER trg_UpdateAssemblyPrice
ON [dbo].[Goods]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @GoodsID INT;

    IF UPDATE(Goods_Price)
    BEGIN
        DECLARE updated_cursor CURSOR FOR
        SELECT ID_Goods
        FROM inserted;

        OPEN updated_cursor;
        FETCH NEXT FROM updated_cursor INTO @GoodsID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE G
            SET G.Goods_Price = dbo.GetAssemblyPrice(G.ID_Goods)
            FROM [dbo].[Goods] G
            INNER JOIN [dbo].[Goods_Parts] GP ON G.ID_Goods = GP.Parent_Goods_ID
            WHERE GP.Part_Goods_ID = @GoodsID;

            FETCH NEXT FROM updated_cursor INTO @GoodsID;
        END;

        CLOSE updated_cursor;
        DEALLOCATE updated_cursor;
    END;
END;
go

CREATE INDEX idx_Goods_Article ON [dbo].[Goods](Goods_Article);


------------------------------------------------------------------------------------------------------------------------------------------------------



USE Electronics_Store_Database;
GO

DECLARE @IsSuccess BIT;

-- Попытка создать сборку с неверным артикулом
EXEC CreatePCAssembly
    @AssemblyName = 'Сборка ПК для гейминга',
    @AssemblyArticle = 'PC-GAMING-001',
    @ManufacturerID = 5,
    @PhotoTag = 'ASSEMBLY_PHOTO_001',
    @GoodsTypeID = 2, 
    @PartArticles = 'RTX3080GAMINGXTRIO,NON_EXISTING_ARTICLE',
    @IsSuccess = @IsSuccess OUTPUT;

IF @IsSuccess = 0
    PRINT 'Сборка ПК не была создана из-за неверного артикула';
ELSE
    PRINT 'Сборка ПК успешно создана';

-- Попытка создать сборку с корректными артикулами
EXEC CreatePCAssembly
    @AssemblyName = 'Сборка ПК для работы',
    @AssemblyArticle = 'PC-WORK-001',
    @ManufacturerID = 5,
    @PhotoTag = 'ASSEMBLY_PHOTO_002',
    @GoodsTypeID = 2, 
    @PartArticles = 'RTX3080GAMINGXTRIO,TUF-RTX3070,ZT-A30600H-10M,100-100000061WOF,100-100000063WOF,BX8071512700K', -- Все артикулы верные
    @IsSuccess = @IsSuccess OUTPUT;

IF @IsSuccess = 0
    PRINT 'Сборка ПК не была создана';
ELSE
    PRINT 'Сборка ПК успешно создана';

PRINT 'Проверка созданной сборки и её комплектующих';
SELECT * FROM [dbo].[Goods] WHERE Goods_Article IN ('PC-GAMING-001', 'PC-WORK-001');
SELECT * FROM [dbo].[Goods_Parts] WHERE Parent_Goods_ID IN (SELECT ID_Goods FROM [dbo].[Goods] WHERE Goods_Article = 'PC-WORK-001');

PRINT 'Обновление цены комплектующего для проверки триггера';
UPDATE [dbo].[Goods]
SET Goods_Price = Goods_Price * 1.1
WHERE Goods_Article = 'RTX3080GAMINGXTRIO';

PRINT 'Проверка обновления цены сборки';
SELECT * FROM [dbo].[Goods] WHERE Goods_Article = 'PC-WORK-001';
GO

PRINT 'Проверка данных в таблице товаров';
SELECT * FROM [dbo].[Goods];
GO

PRINT 'Проверка данных в таблице частей товаров';
SELECT * FROM [dbo].[Goods_Parts];
GO


/*
=============================
Уровни изоляции в MS SQL Server
=============================

1. READ UNCOMMITTED
   - Позволяет читать данные, которые были изменены, но еще не зафиксированы.
   - Проблемы: Грязное чтение, Неповторяющееся чтение, Фантомные чтения.
   - Блокировки: Не накладывает блокировки на чтение.
   
2. READ COMMITTED
   - Позволяет читать только зафиксированные данные.
   - Проблемы: Неповторяющееся чтение, Фантомные чтения.
   - Блокировки: Накладывает S-блокировк, снимает  сразу после чтения.

3. REPEATABLE READ
   - Не даёт изменять данные, которые были прочитаны до завершения текущей транзакции.
   - Проблемы: Фантомные чтения.
   - Блокировки: Накладывает S-блокировки на прочитанные строки до завершения транзакции.

4. SNAPSHOT
   - Транзакции видят данные в состоянии на момент начала транзакции.
   - Проблемы: Не допускает грязных, неповторяющихся и фантомных чтений.
   - Блокировки: Не накладывает блокировки на чтение, но возможны конфликты при записи.

5. SERIALIZABLE
   - Самый строгий уровень изоляции, транзакции исполняются последовательно.
   - Проблемы: Минимизация параллелизма, может привести к блокировкам.
   - Блокировки: Накладывает S-блокировки на прочитанные строки и блокирует диапазоны для предотвращения вставок.
   
=============================
Read Committed Snapshot Isolation (RCSI)
=============================

1. Влияет только на уровень изоляции READ COMMITTED.
2. Использует версионность данных для предоставления снимков на момент начала чтения.
3. Чтения получают данные в состоянии на момент начала запроса, избегая блокировок.
4. Включение RCSI:
   ALTER DATABASE [YourDatabaseName] SET READ_COMMITTED_SNAPSHOT ON;

Преимущества RCSI:
- Улучшенная параллельность за счет отсутствия блокировок на чтение.
- Уменьшение вероятности блокировок и тупиков.
- Прозрачность для приложений: нет необходимости менять код.

Недостатки RCSI:
- Дополнительное использование пространства в tempdb.
- Потенциальное увеличение накладных расходов на запись.

=============================
Типы блокировок
=============================

1. S (Shared, Разделяемая)
   - Используется для операций чтения.
   - Позволяет другим транзакциям также читать, но блокирует записи.

2. X (Exclusive, Эксклюзивная)
   - Используется для операций записи.
   - Блокирует как чтения, так и записи другими транзакциями.

3. IS (Intent Shared, Намерение разделяемой)
   - Указывает, что транзакция намеревается установить S-блокировку на некоторые ресурсы.

4. IX (Intent Exclusive, Намерение эксклюзивной)
   - Указывает, что транзакция намеревается установить X-блокировку на некоторые ресурсы.

5. U (Update, Обновление)
   - Используется для операций, которые могут привести к записи.
   - Предотвращает взаимные блокировки при обновлении.

6. Sch-S (Schema Stability, Стабильность схемы)
   - Предотвращает изменения схемы объекта.
   - Применяется во время выполнения SELECT запросов.

7. Sch-M (Schema Modification, Изменение схемы)
   - Эксклюзивная блокировка для изменения схемы объекта.
   - Применяется при изменении структуры таблицы.

*/


CREATE NONCLUSTERED INDEX idx_Buyer_Card_Buyer_ID ON [Buyer_Card] (Buyer_ID);
CREATE NONCLUSTERED INDEX idx_Buyer_Login ON [Buyer] (Buyer_Login); -- не используется
CREATE NONCLUSTERED INDEX idx_Buyer_Phone_Number ON [Buyer] (Buyer_Phone_Number); -- не используется
CREATE NONCLUSTERED INDEX idx_Order_Buyer_Card_ID_Covering ON [Order] (Buyer_Card_ID) INCLUDE (ID_Order); -- не используется
--StatementSubTreeCost="0.0103618"
SELECT B.Buyer_Login, B.Buyer_Phone_Number,
       (SELECT COUNT(*) FROM [Order] O WHERE O.Buyer_Card_ID = BC.ID_Buyer_Card) AS OrderCount -- Подзапрос в SELECT
FROM Buyer B
JOIN Buyer_Card BC ON B.ID_Buyer = BC.Buyer_ID;
--StatementSubTreeCost="0.0143107"
SELECT B.Buyer_Login, B.Buyer_Phone_Number, COALESCE(COUNT(O.ID_Order), 0) AS OrderCount
FROM Buyer B
JOIN Buyer_Card BC ON B.ID_Buyer = BC.Buyer_ID
LEFT JOIN [Order] O ON O.Buyer_Card_ID = BC.ID_Buyer_Card
GROUP BY B.Buyer_Login, B.Buyer_Phone_Number;


CREATE INDEX idx_Employee_Covering ON Employee (Emp_First_Name, Emp_Second_Name, Outlet_ID);
CREATE INDEX idx_Outlet_Covering ON Outlet (ID_Outlet) INCLUDE (Outlet_Adress);
--StatementSubTreeCost="0.0186034"
SELECT DISTINCT E.Emp_First_Name, E.Emp_Second_Name, O.Outlet_Adress -- Использование DISTINCT
FROM Employee E
JOIN Outlet O ON E.Outlet_ID = O.ID_Outlet;
--StatementSubTreeCost="0.0186034"
SELECT E.Emp_First_Name, E.Emp_Second_Name, O.Outlet_Adress
FROM Employee E
JOIN Outlet O ON E.Outlet_ID = O.ID_Outlet
GROUP BY E.Emp_First_Name, E.Emp_Second_Name, O.Outlet_Adress;


CREATE INDEX idx_Goods_Name_Covering ON Goods (Goods_Name) INCLUDE (Goods_Price);
--StatementSubTreeCost="0.0033315"
SELECT G.Goods_Name, G.Goods_Price
FROM Goods G
WHERE LEFT(G.Goods_Name, 10) = 'Видеокарта'; -- Использование функции в WHERE
--StatementSubTreeCost="0.00328612"
SELECT G.Goods_Name, G.Goods_Price
FROM Goods G
WHERE G.Goods_Name LIKE 'Видеокарта%';


-- StatementSubTreeCost="0.0164332" до индексов
CREATE INDEX idx_Order_Date_ID ON [Order] (Order_Date) INCLUDE (ID_Order, Buyer_Card_ID); -- не используется
CREATE INDEX idx_Order_Parts_Order_Goods ON Order_Parts (Order_ID, Goods_ID);
CREATE INDEX idx_Goods_Type_ID ON Goods (Goods_Type_ID, ID_Goods) INCLUDE (Goods_Name, Goods_Price); 
CREATE INDEX idx_Buyer_Card_ID_Buyer ON Buyer_Card (ID_Buyer_Card, Buyer_ID); 
CREATE INDEX idx_Buyer_ID ON Buyer (ID_Buyer) INCLUDE (Buyer_Login);
-- StatementSubTreeCost="0.0164327" после индексов


SELECT O.ID_Order, O.Order_Date, B.Buyer_Login, G.Goods_Name, G.Goods_Price
FROM [Order] O
JOIN Order_Parts OP ON O.ID_Order = OP.Order_ID
JOIN Goods G ON OP.Goods_ID = G.ID_Goods
JOIN Buyer_Card BC ON O.Buyer_Card_ID = BC.ID_Buyer_Card
JOIN Buyer B ON BC.Buyer_ID = B.ID_Buyer
WHERE O.Order_Date >= '2023-01-01' AND G.Goods_Type_ID = 2;
GO

UPDATE STATISTICS dbo.[Order];
UPDATE STATISTICS dbo.Order_Parts;
UPDATE STATISTICS dbo.Goods;
UPDATE STATISTICS dbo.Buyer;
UPDATE STATISTICS dbo.Buyer_Card;
DBCC FREEPROCCACHE;
-- не помогло, idx_Order_Date_ID всё равно игнорируется

SELECT O.ID_Order, O.Order_Date, B.Buyer_Login, G.Goods_Name, G.Goods_Price
FROM [Order] O WITH (INDEX(idx_Order_Date_ID)) -- форсим использование индекса
JOIN Order_Parts OP ON O.ID_Order = OP.Order_ID
JOIN Goods G ON OP.Goods_ID = G.ID_Goods
JOIN Buyer_Card BC ON O.Buyer_Card_ID = BC.ID_Buyer_Card
JOIN Buyer B ON BC.Buyer_ID = B.ID_Buyer
WHERE O.Order_Date >= '2023-01-01' AND G.Goods_Type_ID = 2;
-- StatementSubTreeCost="0.0165956" после форсирования


/*
-- Способы анализа блокировок в SQL Server

-- 1. Использование системных представлений и функций

-- Просмотр текущих блокировок
SELECT 
    request_session_id AS SessionID,
    resource_type AS ResourceType,
    resource_database_id AS DatabaseID,
    resource_associated_entity_id AS EntityID,
    request_mode AS LockMode,
    request_status AS LockStatus,
    resource_description AS ResourceDescription
FROM sys.dm_tran_locks;

-- Просмотр текущих запросов и их состояния
SELECT 
    session_id AS SessionID,
    blocking_session_id AS BlockingSessionID,
    wait_type AS WaitType,
    wait_time AS WaitTime,
    wait_resource AS WaitResource,
    status AS RequestStatus,
    command AS Command
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;

-- 2. Использование системных хранимых процедур

-- Получение информации о блокировках с помощью sp_who2
EXEC sp_who2;

-- 3. Использование SQL Server Management Studio (SSMS)

-- Журнал блокировок и ожиданий
-- Открыть Activity Monitor в SSMS, разделы "Processes" и "Resource Waits".

-- 4. Использование трассировки и Extended Events

-- Трассировка блокировок с помощью SQL Server Profiler
-- Создать новую трассировку и включить события блокировок ("Lock: Deadlock", "Lock: Deadlock Chain", "Lock: Timeout").

-- Использование Extended Events для анализа блокировок
CREATE EVENT SESSION [LockMonitoring] ON SERVER 
ADD EVENT sqlserver.lock_acquired,
ADD EVENT sqlserver.lock_released,
ADD EVENT sqlserver.lock_timeout
ADD TARGET package0.event_file (SET filename=N'lock_monitoring.xel')
WITH (MAX_MEMORY=4096 KB, EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS, MAX_DISPATCH_LATENCY=30 SECONDS, MAX_EVENT_SIZE=0 KB, MEMORY_PARTITION_MODE=NONE, TRACK_CAUSALITY=ON, STARTUP_STATE=OFF);

-- Запуск сессии
ALTER EVENT SESSION [LockMonitoring] ON SERVER STATE = START;

-- Остановка и удаление сессии
ALTER EVENT SESSION [LockMonitoring] ON SERVER STATE = STOP;
DROP EVENT SESSION [LockMonitoring] ON SERVER;

-- 5. Анализ Deadlock Graph
-- Получение из SQL Server Profiler, Extended Events или Error Log.

-- 6. Wait Stats

-- Анализ ожиданий, связанных с блокировками
SELECT 
    wait_type, 
    waiting_tasks_count, 
    wait_time_ms, 
    max_wait_time_ms, 
    signal_wait_time_ms
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE 'LCK%';

-- 7. Анализ планов выполнения

-- Использование Actual Execution Plan и секции, связанные с WaitStats и RunTimeInformation.
*/
