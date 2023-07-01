---#1 Создать функцию (ручной вариант coalesce), принимающий 2 аргумента, и возвращающую первый непустой из этих двух аргументов. Функция принимает на вход любые типы данных
drop function if exists hh_coalesce2;
create function hh_coalesce2 (a1 anyelement, a2 anyelement) returns anyelement	
as $$
	select 
		case 
			when a1 is null then a2
			else a1
		end
$$ language sql;

select hh_coalesce(51, 1);  
select hh_coalesce(null, 1); 
select hh_coalesce(11, null); 

---#2 Создать функцию как в первом пункте, но принимающую 3 параметра
drop function if exists hh_coalesce3;
create function hh_coalesce3 (a1 anyelement, a2 anyelement, a3 anyelement) returns anyelement
as $$
	select 
		case 
			when a1 is not null then a1
			when a2 is not null then a2
			else a3
		end
$$ language sql;

select hh_coalesce3(1, 2, 3);
select hh_coalesce3(null, 2, 3);
select hh_coalesce3(null, null, 3);

---#3 Пересоздать функцию из пункта 2, используя create or replace, добавив в ее тело комментарии, поясняющие логику выполнения.
create or replace function hh_coalesce(a1 anyelement, a2 anyelement, a3 anyelement) returns anyelement
as $$
	select 
		case 
			when a1 is not null then a1 --если a1 не null, то выводим a1
			when a2 is not null then a2 --если a1 null и a2 не null, то выводим a2
			else a3 --иначе a3
		end
$$ language sql;

select hh_coalesce3(1, 2, 3);
select hh_coalesce3(null, 2, 3);
select hh_coalesce3(null, null, 3);

---#4 Создать таблицу с одним вещественным полем. Создать процедуру, которая заполняет созданную таблицу случайными вещественными числами от 0 до 1.
---Процедура должна принимать на вход одно целое число - количество элементов, которое надо вставить в таблицу.
---Процедура должна вернуть среднее значение из всех элементов в таблице.
create table table1 (a float not null);
select * from table1;

create or replace procedure insert_num(in a1 int, inout a2 float)
as $$
	insert into table1 
		select
			random()
		from generate_series(1, a1);
	select 
		avg(a)
	from table1
$$ language sql;

call insert_num(0, 1);