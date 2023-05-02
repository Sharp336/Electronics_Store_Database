use master
drop database if exists [Agronomic_App_TestUser]
go


set ansi_nulls on
go
set ansi_padding on
go
set quoted_identifier on
go
create database [Agronomic_App_TestUser]
go
use [Agronomic_App_TestUser]
go


CREATE TABLE [post] (
	id_post integer NOT NULL identity(1,1),
	post_name varchar(50) NOT NULL UNIQUE,
	superior_post_id integer NOT NULL,
	CONSTRAINT [PK_post] PRIMARY KEY CLUSTERED ([id_post] ASC)

)
GO

CREATE TABLE [agricultural_machinery_types] (
	id_agricultural_machinery_type integer NOT NULL identity(1,1),
	agricultural_machinery_type_name varchar(66) NOT NULL UNIQUE,
	CONSTRAINT [PK_agricultural_machinery_types] PRIMARY KEY CLUSTERED([id_agricultural_machinery_type] ASC)
)
GO

CREATE TABLE [chemicals_types] (
	id_chemical_type integer NOT NULL identity(1,1),
	chemical_type_name varchar(300) NOT NULL UNIQUE,
	CONSTRAINT [PK_chemicals_types] PRIMARY KEY CLUSTERED([id_chemical_type] ASC)
)
GO

CREATE TABLE [task_statuses] (
	id_task_status integer NOT NULL identity(1,1),
	task_status_name varchar(200) NOT NULL UNIQUE,
	CONSTRAINT [PK_task_statuses] PRIMARY KEY CLUSTERED([id_task_status] ASC)
)
GO

CREATE TABLE [plants_types] (
	id_plant_type integer NOT NULL identity(1,1),
	plant_type_name varchar(50) NOT NULL UNIQUE,
	CONSTRAINT [PK_plants_types] PRIMARY KEY CLUSTERED([id_plant_type] ASC)
)
GO

CREATE TABLE [users] (
	id_user integer NOT NULL identity(1,1),
	user_middle_name varchar(40) NOT NULL,
	user_first_name varchar(40) NOT NULL,
	user_last_name varchar(40) NOT NULL,
	user_post_id integer NOT NULL,
	user_login varchar(30) NOT NULL UNIQUE,
	user_password varchar(30) NOT NULL,
	CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED([id_user] ASC),
	constraint [FK_users_post] foreign key ([user_post_id])
	    references [dbo].[post] ([id_post]),
	constraint [CH_user_login] check (len([user_login])>=8 and len([user_login])<=30),
	constraint [CH_user_password] check (len([user_password])>=8 and len([user_password])<=30),
	constraint [CH_user_password_Upper] check ([user_password] like ('%[A-Z]%')),
	constraint [CH_user_password_Lower] check ([user_password] like ('%[a-z]%')),
	constraint [CH_user_password_Symbols] check ([user_password] like ('%[!@#$%^&*()]%')),
)
GO

CREATE TABLE [agricultural_machinery] (
	id_agricultural_machinery integer NOT NULL identity(1,1),
	agricultural_machinery_name varchar(300) NOT NULL,
	agricultural_machinery_type_id integer NOT NULL,
	CONSTRAINT [PK_agricultural_machinery] PRIMARY KEY CLUSTERED([id_agricultural_machinery] ASC),
	constraint [FK_agricultural_machinery_machinery_types] foreign key ([agricultural_machinery_type_id])
	    references [dbo].[agricultural_machinery_types] ([id_agricultural_machinery_type])
)
GO

CREATE TABLE [chemicals] (
	id_chemical integer NOT NULL identity(1,1),
	chemical_name varchar(300) NOT NULL UNIQUE,
	chemicals_type_id integer NOT NULL,
	CONSTRAINT [PK_chemicals] PRIMARY KEY CLUSTERED([id_chemical] ASC),
	constraint [FK_chemicals_chemical_types] foreign key ([chemicals_type_id])
	    references [dbo].[chemicals_types] ([id_chemical_type])

)
GO

CREATE TABLE [plants] (
	id_plant integer NOT NULL identity(1,1),
	plant_name varchar(200) NOT NULL UNIQUE,
	plant_type_id integer NOT NULL,
	CONSTRAINT [PK_plants] PRIMARY KEY CLUSTERED([id_plant] ASC),
	constraint [FK_plants_plant_types] foreign key ([plant_type_id])
	    references [dbo].[plants_types] ([id_plant_type])
)
GO

CREATE TABLE [fields] (
	id_field integer NOT NULL identity(1,1),
	field_area integer NOT NULL,
	field_identifier varchar(200) NOT NULL UNIQUE,
	field_plant_id integer NOT NULL,
	CONSTRAINT [PK_fields] PRIMARY KEY CLUSTERED([id_field] ASC),
	constraint [CH_field_area] check (field_area >= 1),
	constraint [FK_fields_field_plant] foreign key ([field_plant_id])
	    references [dbo].[plants] ([id_plant])

)
GO

CREATE TABLE [task_types] (
	id_task_type integer NOT NULL identity(1,1),
	task_type_name varchar(100) NOT NULL UNIQUE,
	superior_type_id integer NOT NULL,
	chemical_id integer NULL,
	chemical_amount integer NULL,
	agricultural_machinery_id integer NOT NULL,
	CONSTRAINT [PK_task_types] PRIMARY KEY CLUSTERED([id_task_type] ASC),
	constraint [FK_task_types_superior] foreign key ([superior_type_id])
	    references [dbo].[task_types] ([id_task_type]),
	constraint [FK_task_types_chemical] foreign key ([chemical_id])
	    references [dbo].[chemicals] ([id_chemical]),
	constraint [FK_task_types_agricultural_machinery] foreign key ([agricultural_machinery_id])
	    references [dbo].[agricultural_machinery] ([id_agricultural_machinery])
)
GO

CREATE TABLE [Atasks] (
	id_task integer NOT NULL identity(1,1),
	task_executor_id integer NULL,
	task_field_id integer NOT NULL,
	task_type_id integer NOT NULL,
	task_status_id integer NOT NULL,
	task_start_date date NOT NULL,
	task_finishing_date date NOT NULL,
	task_start_time time NULL,
	task_finishing_time time NULL,
	task_description varchar(max) NULL,
	task_weather_info varchar(max) NULL,
	CONSTRAINT [PK_Atasks] PRIMARY KEY CLUSTERED([id_task] ASC),
	constraint [FK_Atasks_executor] foreign key ([task_executor_id])
	    references [dbo].[users] ([id_user]),
	constraint [FK_Atasks_field] foreign key ([task_field_id])
	    references [dbo].[fields] ([id_field]),
	constraint [FK_Atasks_type] foreign key ([task_type_id])
	    references [dbo].[task_types] ([id_task_type]),
	constraint [FK_Atasks_status] foreign key ([task_status_id])
	    references [dbo].[task_statuses] ([id_task_status]),
	constraint [CH_Atasks_start_date] check (task_start_date >= CAST(getdate() as date)),
	constraint [CH_Atasks_finishing_date] check (datediff(day, task_start_date, task_finishing_date) >= 0),
	constraint [CH_Atasks_start_time] check ([task_start_time] > CAST(getdate() as time) or task_start_date >= CAST(getdate() as date)),
	constraint [CH_Atasks_finishing_time] check (dateadd(minute , 5, task_start_time) >= [task_finishing_time])
)
GO

insert into post(post_name, superior_post_id) values ('Владелец', 1)
go
insert into post(post_name, superior_post_id) values ('Агроном', 1),('Тракторист', 2),('Пилот', 2),('Водитель комбайна', 2), ('Не указано', 1)
go

insert into agricultural_machinery_types(agricultural_machinery_type_name) values ('Не указано'), ('Трактор'), ('Самолёт'), ('Комбайн')
go

insert into chemicals_types(chemical_type_name) values ('Не указано'),('Протравители'),('Гербициды'),('Инсектициды'),('Фунгициды'),('Десикант'),('Регулятор роста'),('Родентицид'),('Пестицид')
go

insert into task_statuses(task_status_name) values
                                                ('Ожидает заполнения'), ('Ожидает выполнения'),
                                                ('Ожидает уточнения'), ('Ожидает поставки расходников'),
                                                ('Поиск подрядчика'), ('Выполняется'),
                                                ('Прервано в связи с погодными условиями'),
                                                ('Прервано в связи с технической неполадкой'),
                                                ('Прервано в связи с форс-мажором'),
                                                ('Выполнено'), ('Выполнено с накладками'), ('Отменено')
go

insert into plants_types(plant_type_name) values ('Не указано'), ('Зерновые'), ('Зернобобовые'), ('Кормовые'),
                                                 ('Масличные'), ('Эфиромасличные'), ('Технические'),
                                                 ('Лекарственные'), ('Ягодные'), ('Картофель'),
                                                 ('Сахарная свёкла'), ('Виноград')
go

insert into users(user_post_id, user_middle_name, user_first_name, user_last_name, user_login, user_password) values
                                                                  (1, 'Савельева', 'Кира', 'Михайловна', 'Own3r4test', '0wn3r4test#'),
                                                                  (2, 'Горшкова', 'Мария', 'Матвеевна', 'Agr0nom4test', 'Agr0n0m4test#'),
                                                                  (3, 'Князева', 'Полина', 'Руслановна','Tract0rist4test1', 'Tract0rist4test#'),
                                                                  (3, 'Степанова', 'Александра', 'Лукинична','Tract0rist4test2', 'Tract0rist4test#'),
                                                                  (3, 'Фролов', 'Кирилл', 'Владиславович','Tract0rist4test3', 'Tract0rist4test#'),
                                                                  (4, 'Потапов', 'Егор', 'Иванович','Pi10t4test1', 'Pi10t4test#'),
                                                                  (4, 'Егорова', 'Алина', 'Данииловна', 'Pi10t4test2', 'Pi10t4test#'),
                                                                  (4, 'Блинова', 'Ангелина', 'Марковна', 'Pi10t4test3', 'Pi10t4test#'),
                                                                  (5, 'Петровская', 'Дарья', 'Павловна', 'Dr1v3r4test1', 'Dr1v3r4test#'),
                                                                  (5, 'Савельева', 'Варвара', 'Ивановна', 'Dr1v3r4test2', 'Dr1v3r4test#'),
                                                                  (5, 'Гончаров', 'Никита', 'Ильич', 'Dr1v3r4test3', 'Dr1v3r4test#')
go

insert into agricultural_machinery(agricultural_machinery_name, agricultural_machinery_type_id) values ('Не указано' , 1),
                                                                                                       ('Беларус МТЗ 82.1' , 2),
                                                                                                       ('Уралец 224б' , 2),
                                                                                                       ('AT-802A' , 3),
                                                                                                       ('GS 3219КР' , 4),
                                                                                                       ('NOVA-340' , 4)
go

insert into chemicals(chemical_name, chemicals_type_id) values ('Не указано', 1),
                                                               ('АПРОН Голд, ВЭ', 2),
                                                               ('ВАЙБРАНС Интеграл, КС', 2),
                                                               ('АКСИАЛ Кросс, КЭ', 3),
                                                               ('АКСИАЛ, КЭ', 3),
                                                               ('БАНВЕЛ, ВР', 3),
                                                               ('Адвион гель', 4),
                                                               ('АКТАРА, ВДГ', 5)
go

insert into plants(plant_name, plant_type_id) values ('Не указано', 1),
                                                     ('Пшеница', 2),
                                                     ('Рожь', 2),
                                                     ('фасоль обыкновенная', 3),
                                                     ('каролинские бобы', 3),
                                                     ('кукуруза', 4),
                                                     ('кабачок', 4),
                                                     ('тыква', 4),
                                                     ('соя', 5)
go

insert into fields(field_area, field_identifier, field_plant_id) values (1 , 'Сектор 2С', 2),
                                                                        (2 , 'Сектор 2Б', 3),
                                                                        (3 , 'Сектор 4А', 4)
go

insert into task_types(task_type_name, superior_type_id, chemical_id, chemical_amount, agricultural_machinery_id) values
('Не указано', 1, 1, 0, 1),
('Возделать поле', 2, 1, 0, 1),
('Засеять поле', 3, 1, 0, 1),
('Полить поле', 4, 1, 0, 1),
('Обработать поле', 5, 2, 0, 1),
('Пропахать поле трактором', 2, 1, 0, 2),
('Собрать урожай коомбайном', 2, 1, 0, 4),
('Обработать поле пестицидом', 5, 8, 250, 6)
go


insert into Atasks(task_executor_id, task_field_id, task_type_id, task_status_id, task_start_date, task_finishing_date, task_finishing_time, task_start_time, task_description, task_weather_info)values
(2, 1, 6, 2, DATEADD(day, 2, CAST(getdate() as date)), DATEADD(day, 2, CAST(getdate() as date)), CAST('12:00' as time), CAST('18:00' as time), 'Пройтись трактором по полю и вспахать в установленное время', 'Погода шикарная')
go

insert into Atasks(task_field_id, task_type_id, task_status_id, task_start_date, task_finishing_date, task_finishing_time, task_start_time, task_description, task_weather_info)values
(2, 8, 5, DATEADD(day, 4, CAST(getdate() as date)), DATEADD(day, 4, CAST(getdate() as date)), CAST('16:00' as time), CAST('20:00' as time), 'Пролететь над полем в указанный промежуток времени и распылить указанный химикат', 'Погода лётная, но есть небольшой ветер, берите упреждение при распылении')
go

create or alter procedure [dbo].[Get_Task_Card]
    @ID_Task int = 0
    as
    select
       field_identifier as 'Поле работ', task_type_name as 'Тип работ', agricultural_machinery_name as 'Инструмент',
       task_status_name as 'Статус задачи',
       (CAST(task_start_date as varchar) + ' - ' + CAST(task_finishing_date as varchar) + ' ' + CAST(task_start_time as varchar(5))
            + '-' + CAST(task_finishing_time as varchar(5))) as 'Дата и время выполнения',
    task_description as 'Описание задачи', task_weather_info as 'Погодные условия'
from Atasks
    join fields f on f.id_field = Atasks.task_field_id
    join task_types tt on tt.id_task_type = Atasks.task_type_id
    join task_statuses ts on ts.id_task_status = Atasks.task_status_id
    join agricultural_machinery am on am.id_agricultural_machinery = tt.agricultural_machinery_id
where id_task = iif(@ID_Task = 0, id_task, @ID_Task) and (task_start_date > getdate() or (task_start_date = getdate() and task_start_time < cast(getdate() as time))) and task_status_name = 'Поиск подрядчика'
group by id_task, field_identifier, task_type_name,agricultural_machinery_name, task_status_name, (CAST(task_start_date as varchar) + ' - ' + CAST(task_finishing_date as varchar) + ' ' + CAST(task_start_time as varchar(5))
            + '-' + CAST(task_finishing_time as varchar(5))), task_description, task_weather_info
    return
go

create or alter view [dbo].[Short_Tasks]
    as
    select
       task_field_id as "task_field_id", id_task as 'task_id', task_type_name as 'task_type', task_status_name as 'task_status', task_start_date as 'task_start_date', task_finishing_date as 'task_finishing_date'
from Atasks
    join task_types tt on tt.id_task_type = Atasks.task_type_id
    join task_statuses ts on ts.id_task_status = Atasks.task_status_id
go

create or alter view [dbo].[Fields_View]
    as
    select
       id_field as "field_id", field_identifier as "field_identifier", plant_name as "field_plant"
    from fields
        join plants p on p.id_plant = fields.field_plant_id
go

create or alter view [dbo].[Posts_Order]
    as
    select
       ROW_NUMBER() OVER(order by post_name) AS 'Номер строки', post_name as 'Должность'
    from post
go

select * from Posts_Order