1--!Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ.
select f.title 
FROM film f
WHERE rating = 'R';

2--!ACTOR_ID ENTRE 30 Y 40 , ENCONTRAR LOS NOMBRES DE LOS ACTORES
select a.first_name 
from actor a 
where a.actor_id between 30 and 40;

3--!peliculas cuyo idioma coincide con el idioma original
select *
from film f
where f.language_id = f.original_language_id --no existe ningun lenguaje original ya que este campo es null.

4--! Ordena las peliculas por duracion de forma ascendente
select *
from film f 
order by rental_duration asc

5--! encuentra el nombre y apellido de los actores que tengan 'Allen' en su apellido.
select a.first_name, a.last_name 
from actor a 
where a.last_name like '%Allen%'

6--! cantidad total de peliculas en cada clasificacion de la tabla film y muestra la clasificaion junto al recuento.
select count(*) 
from film f 

7--!titulo de todas las peliculas que son PG-13 y duracion mayor a 3 horas en la tabla film
select f.title 
from film f 
where f.rating ='PG-13' and f.rental_duration > 3

8--!variabilidad de lo que costaria reemplazar las peliculas
SELECT STDDEV(f.replacement_cost) AS desviacion_estandar
FROM film f 

SELECT VARIANCE(f.replacement_cost) AS varianza
FROM film f

9--! encuentra la mayor y menor duracion de una pelicula de nuestra bbdd.
SELECT
    MAX(length) AS mayor_duracion,
    MIN(length) AS menor_duracion
FROM film;

10--! encuentra lo que costo el antepenultimo alquiler ordenado por dia.
SELECT p.amount, ordered_rentals.rental_id ,ordered_rentals.rental_date
FROM (
    SELECT rental_id, rental_date,
           ROW_NUMBER() OVER (ORDER BY rental_date DESC) AS row_num
    FROM rental 
) AS ordered_rentals
JOIN payment p ON ordered_rentals.rental_id = p.rental_id
WHERE ordered_rentals.row_num = 3;


11--!Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.
SELECT f.rating, COUNT(*) AS total_peliculas
FROM film f
GROUP BY f.rating 
ORDER BY total_peliculas DESC; 

12--! Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC 17ʼ ni ‘Gʼ en cuanto a su clasificación.
select f.title 
from film f 
where f.rating <>'NC-17' and f.rating <>'G'

13--!Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT rating, AVG(length) AS promedio_duracion
FROM film
GROUP BY rating
ORDER BY promedio_duracion DESC;

14--!Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos
select f.title 
from film f 
where length > 180

15--!¿Cuánto dinero ha generado en total la empresa?

SELECT SUM(amount) AS total_generado
FROM payment;

16--! Muestra los 10 clientes con mayor valor de id.
SELECT *
FROM customer c
ORDER BY c.customer_id DESC
LIMIT 10;

17--!Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.
select  a.first_name , a.last_name 
from film_actor fa 
join actor a 
on(fa.actor_id=a.actor_id)
join film f 
on (fa.film_id=f.film_id)
where f.title ='EGG IGBY'

18--!Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT title
FROM film;

19--!Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ
select f.title 
from film f 
join film_category fc 
on (f.film_id=fc.film_id)
where fc.category_id = 6 and f.length > 180
 
20--!Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT c.name AS categoria,
       AVG(f.length) AS promedio_duracion
FROM film_category fc
JOIN film f ON fc.film_id = f.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > 110;

21--! ¿Cuál es la media de duración del alquiler de las películas?
SELECT AVG(RETURN_DATE - RENTAL_DATE) AS media_duracion_alquiler_dias
FROM rental
WHERE RETURN_DATE IS NOT NULL AND RENTAL_DATE IS NOT null

22--!Crea una columna con el nombre y apellidos de todos los actores y actrices.
ALTER TABLE actor
ADD COLUMN nombre_completo VARCHAR(255);
UPDATE actor
SET nombre_completo = CONCAT(first_name, ' ', last_name);
SELECT first_name, last_name, nombre_completo
FROM actor;

23--!Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT rental_date, COUNT(*) AS numero_alquileres
FROM rental
GROUP BY rental_date
ORDER BY numero_alquileres DESC;

24--!Encuentra las películas con una duración superior al promedio.
SELECT f.title, f.length
FROM film f
WHERE f.length > (SELECT AVG(length) FROM film);

25--!Averigua el número de alquileres registrados por mes.
SELECT 
    TO_CHAR(r.rental_date, 'YYYY-MM') AS mes,
    COUNT(r.rental_id) AS total_alquileres
FROM rental r
GROUP BY 
    TO_CHAR(r.rental_date, 'YYYY-MM')
ORDER BY mes;

26--!Encuentra el promedio, la desviación estándar y varianza del total pagado
select avg(amount) as promedio_total_pagado ,STDDEV(amount) as desviacion_tipica_pagado,VARIANCE(amount) as varianza_total_pagado
from payment

27--!¿Qué películas se alquilan por encima del precio medio?
SELECT f.title, p.amount
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
WHERE p.amount > (SELECT AVG(amount) FROM payment);

28--!Muestra el id de los actores que hayan participado en más de 40 películas
select a.actor_id 
from actor a 
join film_actor fa 
on (a.actor_id=fa.actor_id)
join film f
on(fa.film_id=f.film_id)
group by a.actor_id 
HAVING COUNT(f.film_id) > 40;

29--!Obtener todas las peliculas y, si estan disponibles en el inventario, mostrar la cantidad disponible.
SELECT f.title , 
       COUNT(i.inventory_id) AS cantidad_disponible
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
GROUP BY f.film_id, f.title 
ORDER BY f.title ;

30--!Obtener los actores y el numero de peliculas en las que ha actuado.
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS number_of_films
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY number_of_films DESC;

31--!Obtener todas las peliculas y mostrar los actores que han actuado en ellas, incluso si algunas plicuals no tienen actores asociados.
select  f.title , a.first_name ,a.last_name 
from film f 
left join film_actor fa 
on(f.film_id=fa.film_id)
left join actor a 
on (fa.actor_id=a.actor_id)
order by f.title ;

32--!Obtener todos los actores y mostrar las pelicula en las que han actuado, incluso si algunos actores no han actuado en ninguna pelicula.
select a.first_name , a.last_name , f.title 
from actor a 
join film_actor fa 
on a.actor_id = fa.actor_id 
join film f
on fa.film_id = f.film_id 
order by a.first_name , a.last_name 

33--!Obtener todas las peliculas que tenemos y todos los registros de alquiler. 
SELECT f.title , 
       r.rental_date, 
       r.return_date, 
       r.customer_id, 
       r.staff_id, 
       r.rental_id
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
ORDER BY f.title , r.rental_date;

34--!Encuentra los 5 clientes que mas dinero se hayan gastado con nosotros
SELECT c.customer_id, 
       c.first_name, 
       c.last_name, 
       SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;

35--!Selecciona todos los actores cuyo primer nombre es 'Johnny'
select *
from actor a 
where a.first_name ='JOHNNY'

36--!Reenombra la columna first_name como 'nombre' y last_name coomo 'apellido'
select a.first_name as nombre, a.last_name as apellido
from actor a 

37--!Encuentra el ID del actor mas bajo y mas alto en la tabla actor.
SELECT 
    MIN(actor_id) AS min_actor_id, 
    MAX(actor_id) AS max_actor_id
FROM actor;

38--!Cuenta cuantos actores hay en una tabla "actor"
select count(*) as total_actores
from actor a

39--!Selecciona todos los actores y ordenalos por apellido en orden ascendente
select a.first_name , a.last_name 
from actor a 
order by a.last_name asc

40--! Selecciona las primeras 5 peliculas de la tabla "film"
select *
from film f 
limit 5;


41--!Agrupa los actores por su nombre y cuenta cuantos actores tienen el mismo nombre. ¿cual es el nombre mas repetido?
SELECT first_name, COUNT(*) AS count
FROM actor
GROUP BY first_name
ORDER BY count DESC; 
--!Hay 4 nombres mas repetidos: Kenneth, penelope, julia, burt

42--!Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

select c.first_name , r.rental_id 
from customer c 
join rental r 
on (c.customer_id= r.customer_id)

43--!Muestra todso los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

SELECT c.customer_id, c.first_name, c.last_name, r.rental_id, r.rental_date
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id;

44--!Realiza un CROSS JOIN entre las tablas film y category.¿Aporta valor esta consulta?¿Por que? DEJA DESPUES DE LA CONSULTA LA CONTESTACION.
SELECT f.film_id, f.title, c.category_id, c.name
FROM film f
CROSS JOIN category c;
--!En este caso el cross join no aporta valor significativo porque no refleja una relación lógica entre ambas tablas a menos que tengas una tabla adicional que las vincule de forma más adecuada, normalmente se suele utilizar en consultas mas especificas.

45--!Encuentra los actores que han participado en peliculas de la categoria 'Action'
select a.actor_id ,a.first_name ,a.last_name, c."name" 
from actor a 
join film_actor fa 
on(a.actor_id=fa.actor_id)
join film_category fc 
on(fc.film_id=fa.film_id)
join category c 
on (fc.category_id=c.category_id)
where fc.category_id =1


46--!Encuentra todos los actores que no han participado en peliculas
select A.actor_id , A.first_name , A.last_name 
from actor a 
join film_actor fa 
on (a.actor_id=fa.actor_id)
where fa.actor_id is null

47--!Selecciona el nombre de los actores y la cantidad de peliculas en las que han participado.

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS num_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY num_peliculas DESC;

48--!Crea una vista llamada actor_num_peliculas que muestre los nombres de los actores y el numero de peliculas en las que han participado
CREATE VIEW actor_num_peliculas AS
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS num_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id;

49--! Calcula el numero total de alquileres realizados por cada cliente.
select count(r.rental_id) as total_alquileres, c.customer_id , c.first_name , c.last_name 
from rental r
join customer c 
on(r.customer_id =c.customer_id)
group by c.customer_id 
order by total_alquileres desc

50--! Calcula la duracion total de las peliculas en la categoria 'Action'
select SUM(f.length) as duracion_total
from film f
join film_category fc 
on(f.film_id=fc.film_id)
join category c 
on (fc.category_id =c.category_id)
where fc.category_id =1

51--!Crea una tabla temporal llamada "cliente_rentas_temporal" para almacenar el total de alquileres por cliente
create temporary table clientes_rentas_temporal(
customer_id INT,
total_alquileres INT,
first_name VARCHAR(100),
last_name VARCHAR(200)
);

INSERT INTO clientes_rentas_temporal (customer_id, total_alquileres)
SELECT c.customer_id, COUNT(r.rental_id) AS total_alquileres
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

52--!Crea una tabla temporal llamada "peliculas_alquiladas" que almacene las peliculas que han sido alquiladas al menso 10 veces.
CREATE TEMPORARY TABLE peliculas_alquiladas (
    film_id INT,
    titulo VARCHAR(255)
);

INSERT INTO peliculas_alquiladas (film_id, titulo)
SELECT f.film_id, f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
HAVING COUNT(r.rental_id) >= 10;

53--!Encuentra el titulo de las peliculas que han sido alquiladas por el cliente con el nombre "Tammy Sanders" y que aun no se han devuelto. Ordena los resultados alfabeticamente por titulo de peliculas.
SELECT f.title
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE c.first_name = 'TAMMY' AND c.last_name = 'SANDERS'
 AND r.return_date IS NULL
ORDER BY f.title;

54--!Encuentra los nombres de los actores que han actuado en al menos una pelicula que pertenece a la categoria 'Sci-Fi'. Ordena los resultados alfabeticamente por apellidos.
select distinct a.first_name ,a.last_name 
from actor a 
join film_actor fa 
on a.actor_id =fa.actor_id 
join film f 
on fa.film_id = f.film_id 
join film_category fc 
on fc.film_id =f.film_id 
join category c 
on fc.category_id = c.category_id 
where fc.category_id =14
order by a.last_name 

55--!Encuentra el nombre y apellido de los actores que han actuado en peliculas que se alquilaron despues de que la pelicula 'SPARTACUS CHEAPER' se alquilara por primera vez. Ordena los resultaods alfabeticamente por apellido.
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM rental r2
    JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    JOIN film f2 ON i2.film_id = f2.film_id
    WHERE f2.title = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name, a.first_name;

56--!Encuentra el nombre y apellido de los actores que no han actuado en ninguna pelicula de la categoria music.
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc ON fa.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Music'
)
ORDER BY a.last_name, a.first_name;

57--!Encuentra el titulo de todas las peliculas que fueron alquiladas por mas de 8 dias.
SELECT f.title 
FROM film f 
JOIN inventory i ON f.film_id = i.film_id 
JOIN rental r ON r.inventory_id = i.inventory_id 
WHERE (r.return_date - r.rental_date) > INTERVAL '8 days';

58--!Encuentra el titulo de todas las peliculas que son de la misma categoria que 'Animation'
select f.title , c."name" 
from film f 
join film_category fc 
on (f.film_id=fc.film_id)
join category c 
on (c.category_id=fc.category_id)
where c."name" = 'Animation';

59--!Encuentra los nombres de las peliculas que tienen la misma duracion que la pelicula con el titulo 'Dancing Fever'. Ordena los resultados alfabeticamente por titulo de pelicula.
--opcion 1
select *
from film 
where title ='DANCING FEVER';

select f.title 
from film f 
where f.length = 144
order by f.title ;

--opcion 2
SELECT f.title
FROM film f
WHERE f.length = (SELECT f2.length
                  FROM film f2
                  WHERE f2.title = 'Dancing Fever')
ORDER BY f.title;

60--!Encuentra los  nombres de los clientes que han alquilado al menos 7 peliculas distintas. Ordena los resultados alfabeticamente por apellido. 
select c.first_name , c.last_name 
from customer c 
join payment p 
on c.customer_id = p.customer_id 
join rental r 
on r.rental_id = p.rental_id 
join inventory i 
on i.inventory_id = r.inventory_id 
join film f 
on f.film_id = i.film_id 
group by c.customer_id 
having count (distinct f.film_id)>=7
order by c.last_name , c.first_name ;

61--! Encuentra la cantidad total de peliculas alquiladas por categoria y muestra el nombre de la categoria junto con el recuento de alquileres
select count(r.rental_id) as total_peliculas_alquiladas, c."name" as nombre_categoria
from film_category fc 
join category c 
on c.category_id =fc.category_id 
join film f
on f.film_id =fc.film_id 
join inventory i 
on i.film_id = f.film_id 
join rental r 
on r.inventory_id = i.inventory_id 
group by c.category_id 
order by total_peliculas_alquiladas desc;

62--!Encuentra el numero de peliculas por categoria estrenadas en 2006
SELECT COUNT(f.film_id) AS numero_peliculas, c."name" 
FROM film_category fc
JOIN category c ON fc.category_id = c.category_id
JOIN film f ON fc.film_id = f.film_id
WHERE f.release_year = 2006
GROUP BY c."name"
ORDER BY numero_peliculas DESC;

63--!Obten todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
select s.staff_id , s.first_name , s.last_name , s2.store_id
from staff s 
cross join store s2 ;

64--!Encuentra la cantidad total de peliculas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de peliculas alquiladas

SELECT c.customer_id, c.first_name, c.last_name, COUNT(DISTINCT r.rental_id) AS total_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id
ORDER BY total_rentals DESC;




