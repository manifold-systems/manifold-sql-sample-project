SELECT first_name, last_name, count(*) films
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, first_name, last_name
ORDER BY films DESC
LIMIT 1
