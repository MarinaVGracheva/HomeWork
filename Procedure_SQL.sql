---Вывести все фильмы без ограничения по возрасту (film.rating = ‘G’). По каждому из фильмов вывести:
--- - название (film.title)
--- - сколько всего дисков с этим фильмом (кол-во записей в inventory) (рассчитать отдельной функцией, которая принимает на вход film_id)
--- - сколько раз фильм сдавали в аренду (кол-во записей в rental) (рассчитать отдельной функцией, которая принимает на вход film_id)

drop function if exists count_film;
create function count_film(film_id int) returns int
as $$
select 
	count(*)
from inventory i
	join film m using (film_id)
where i.film_id = count_film.film_id and m.rating = 'G'
$$ language sql;

--
drop function if exists count_rental;
create function count_rental(film_id int) returns int
as $$
select 
	count(i.film_id)
from inventory i
	join film m using (film_id)
	join rental r using (inventory_id) 
where i.film_id = count_rental.film_id and m.rating = 'G'
$$ language sql;

--
select 
	m.title, 
	count_rental(i.film_id),
	count_film(i.film_id)
from inventory i
	join film m using (film_id)
	join rental r using (inventory_id) 
where m.rating = 'G'
group by m.title, i.film_id
order by i.film_id;

------------------------------------------------------------
-- Написать функцию, которая принимает на вход два целых числа типа int и возвращает наибольшее из них.
-- Написать запрос с пример использования этой функции.

drop function if exists max_number;
create function max_number(a1 int, a2 int) returns int
as $$
select  
	case 
		when a1 > a2 then a1
		else a2
	end
$$ language sql;

select max_number(2, 10);
select max_number(32, 10);
select max_number(0, 10);
select max_number(-10, -5);

-----------------------------------------------------------
--Написать функцию, которая добавляет в систему информацию о новом компакт диске (добавляет новую запись в таблицу inventory).

--Принимает параметры:
-- - film_id - id фильма, который находится на новом компакт диске
-- - store_id - id магазина, к которому будет привязан компакт диск
-- Добавить 3 новых компакт диска в систему, используя новую функцию.

drop function if exists new_disk;
create function new_disk(film_id int, store_id int) returns int
as $$
 	INSERT INTO inventory
		(film_id, store_id, last_update)
	VALUES(film_id, store_id, now());
select 1;
$$ language sql;

select new_disk(2, 1);
select new_disk(1, 1);
select new_disk(2, 2);

-----------------------------------------------------------
-- Написать функцию, которая принимает на вход film_id и возвращает пары значений:
-- - дату
-- - общую сумму платежей по данному фильму за эту дату (sum(payment.amount))

-- Выводим только даты, за которые был хотя бы один платеж по выбранному фильму.
-- Отсортировать результат в порядке увеличения даты.

drop function if exists total_sum_to_date;
create function total_sum_to_date(film_id int) returns table(total_sum_for_date numeric(5, 2), payment_date timestamp)
as $$
select 
	sum(p.amount) as total_sum_for_date,
	date_trunc('day', p.payment_date)
from payment p 
join rental r using(rental_id)
join inventory i using(inventory_id)
join film f using(film_id)
where i.film_id = total_sum_to_date.film_id and p.amount != 0
group by 
	date_trunc('day', p.payment_date)
order by date_trunc('day', p.payment_date)
$$ language sql;



select 
	* 
from total_sum_to_date(2);