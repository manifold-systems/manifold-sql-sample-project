package org.example;

import manifold.sql.rt.api.Dependencies;
import org.example.my.schema.Sakila;
import org.example.queries.ActorWithMostFilms;
import org.example.my.schema.Sakila.*;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

import static java.lang.System.out;

public class Main {
    public static void main(String[] args) throws SQLException {
        try {
            threeWaysToQuery();
            moreQueries();
            doSomeCrud();
        } finally {
            shutdown();
        }
    }

    private static void threeWaysToQuery() {
        //
        // inline SQL, anonymous type
        //
        var actorWithMostFilms = """
                [.sql/] SELECT first_name, last_name, count(*) films
                FROM actor a
                JOIN film_actor fa ON a.actor_id = fa.actor_id
                GROUP BY a.actor_id, first_name, last_name
                ORDER BY films DESC
                LIMIT 1
                """.fetchOne();
        out.println(actorWithMostFilms.getLastName() + ": " + actorWithMostFilms.getFilms());


        //
        // ActorWithMostFilms.sql resource file, quickly navigate to the file in the IDE with Ctrl+Click on the type
        //
        ActorWithMostFilms.Row actorWithMostFilms2 = ActorWithMostFilms.fetchOne();
        out.println(actorWithMostFilms2.getLastName() + ": " + actorWithMostFilms2.getFilms());

        //
        // Comment inlined SQL, for separating query type from use site[s].
        //
        /* [ActorWithMostFilms3.sql/]
          SELECT first_name, last_name, count(*) films
          FROM actor AS a
          JOIN film_actor fa ON a.actor_id = fa.actor_id
          GROUP BY a.actor_id, first_name, last_name
          ORDER BY films DESC
          LIMIT 1
         */
        ActorWithMostFilms3.Row actorWithMostFilms3 = ActorWithMostFilms3.fetchOne();
        out.println(actorWithMostFilms3.getLastName() + ": " + actorWithMostFilms3.getFilms());
    }

    private static void moreQueries() {

        //
        // Query with type-safe, injection-safe parameter
        //
        int year = 2000;
        for (var row : "[.sql/] select rating, count(*) from film where release_year > :release_year group by rating".fetch(year)) {
            out.println(row.getRating() + " : " + row.getCount__());
        }

        //
        // Top-N rented films
        //
        """
        [MostRented.sql/] SELECT title, COUNT(title) as rentals
        FROM film
        JOIN inventory ON film.film_id = inventory.film_id
        JOIN rental ON inventory.inventory_id = rental.inventory_id
        GROUP by title
        ORDER BY rentals desc
        LIMIT :topN
        """
        .fetch("10") // top 10 rented movies
        .forEach(row -> out.println(row.getTitle() + ": " + row.getRentals()));

        //
        // Query inlined in a comment defines Payments type available for use in this scope
        //
         /* [Payments.sql/]
            SELECT payment_date, amount, SUM(amount) OVER (ORDER BY payment_date) as total
            FROM (
              SELECT CAST(payment_date AS DATE) AS payment_date, SUM(amount) AS amount
              FROM payment
              WHERE payment_date > :payment_date
              GROUP BY CAST(payment_date AS DATE)
            ) p
            ORDER BY p.payment_date;
        */
        for (Payments.Row row : Payments.fetch(LocalDateTime.of(2006, 2, 1, 0, 0))) {
            out.println("\nDate: " + row.getPaymentDate() +
                    "\nAmount: " + row.getAmount() +
                    "\nSum: " + row.getTotal());
        }
    }

    private static void doSomeCrud() throws SQLException {
        Language english =
                "[.sql/]select * from Language where name = 'English'".fetchOne();
        Film film = Film.builder("My Movie", english)
                .withDescription("Nice movie")
                .withReleaseYear(2023)
                .build();
        // commit to db
        Sakila.commit(); // inserts the new film

        // continue making changes...

        film.setLength(82);
        film.setRating("R");
        film.setReplacementCost(BigDecimal.valueOf(30.50));
        // commit to db
        Sakila.commit(); // updates the film

        List<Film> result = Film.fetchByTitle("My Movie");
        film = result.get(0);
        out.println(film);

        film.delete();
        // commit to db
        Sakila.commit(); // deletes the film

        if (Film.fetchByTitle("My Movie").isEmpty()) {
            out.println("deleted");
        }
    }

    private static void shutdown() {
        Dependencies.instance().getConnectionProvider().closeAll();
    }
}
