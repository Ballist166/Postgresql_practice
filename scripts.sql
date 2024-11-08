Посчитайте выручку по каждой неделе 1998-го года.
Какова максимальная недельная выручка? Ответ округлите до целого числа.

select date_part('week', o.order_date), sum(od.unit_price * od.quantity * (1 - od.discount)) as t
from orders o join order_details od on o.order_id = od.order_id
where date_part('year', o.order_date ) = 1998
group by date_part('week', o.order_date)
order by t desc

-- ******************************************

Посчитайте по месяцам количество заказов, которые совершили клиенты из США.
Сколько заказов было сделано в декабре 1996 года?

select count(*)
from customers c join orders o on c.customer_id = o.customer_id
where c.country = 'USA' and date_part('year', o.order_date ) = 1996
						and date_part('month', o.order_date ) = 12

-- ******************************************

Какое максимальное количество заказов в месяц было оформлено одним сотрудником?

select date_part('year', o.order_date),
	   date_part('month', o.order_date),
	   concat (e.last_name,' ',e.first_name),
	   count(*) as t
from employees e join orders o on e.employee_id = o.employee_id
group by date_part('year', o.order_date),
		 date_part('month', o.order_date),
		 concat (e.last_name,' ',e.first_name)
order by t desc

-- ******************************************

Выведите заказы, которые были оформлены в 1997 году.
С помощью CASE добавьте временный столбец.
Если дата фактической доставки (shipped_date) больше запланированной даты доставки (required_date),
то значение - "delay", а иначе - "in time".
С помощью вложенного запроса посчитайте сколько заказов были доставлено с задержкой.

select count(*)
from(
select *, case when o.shipped_date > o.required_date then 'delay' else 'in time' end as td
from orders o
where date_part('year', o.order_date) = 1997) as t
where t.td = 'delay'

-- ******************************************

Выведите имена клиентов и должности. С помощью CASE добавьте временный столбец prof_group.
Если в должности присутствует слово Marketing, тогда значение - 'Marketing'.
Если в должности присутствует слово Sales, тогда значение - 'Sales'.
В остальных случаях значение - 'Other'.
Посчитайте количество клиентов в разрезе групп профессий.

select t.prof_group, count(*)
from
(select c.contact_name , c.contact_title ,
case when c.contact_title like '%Marketing%' then 'Marketing'
	 when c.contact_title like '%Sales%' then 'Sales'
	 else 'Other' end as prof_group
from customers c)  as t
group by t.prof_group

-- ******************************************

Среди всех заказов клиента Jose Pavarotti найдите заказ с наименьшей выручкой.
Какова выручка заказа?

select o.order_id , sum(od.unit_price * od.quantity * (1-od.discount))
from customers c join orders o on c.customer_id = o.customer_id  join order_details od on od.order_id = o.order_id
where c.contact_name = 'Jose Pavarotti'
group by o.order_id

-- ******************************************

Как зовут сотрудников, которые когда-либо оформляли заказ на клиента Martín Sommer?

select e.first_name, e.last_name
from customers c join orders o on c.customer_id = o.customer_id
				 join employees e on o.employee_id = e.employee_id
where c.contact_name = 	'Martín Sommer'
group by e.first_name, e.last_name

-- ******************************************

В каком месяце была рекордная общая выручка
по продуктам с названиями, которые начинаются на Chef Anton?

select date_part('month', o.order_date), sum(od.unit_price * od.quantity * (1 - od.discount)) as t
from products p join order_details od on p.product_id = od.product_id
                join orders o on od.order_id = o.order_id
where p.product_name like 'Chef Anton%'
group by date_part('month', o.order_date)
order by t desc

-- ******************************************

Выведите 3 столбца: год, название категории и выручку. Какова выручка по категории Condiments в 1996 году? Округлите ответ до целого числа.

select date_part('year', o.order_date), c.category_name, sum(od.unit_price * od.quantity * (1 - od.discount)) as t
from categories c join products p on c.category_id = p.category_id
                  join order_details od on od.product_id = p.product_id
                  join orders o on o.order_id = od.order_id
where c.category_name = 'Condiments' and date_part('year', o.order_date) = 1996
group by date_part('year', o.order_date),c.category_name





