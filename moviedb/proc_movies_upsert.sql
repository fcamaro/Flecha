DELIMITER $$
CREATE DEFINER=`flecha`@`%` PROCEDURE `movies_upsert`(
								  in title nvarchar(1000),
                                  in year int,
                                  in genres_js nvarchar(2000),
                                  in casts_js nvarchar(2000), 
                                  in param_movie_id int
                                  )
BEGIN
	
   DECLARE movie_id int;
   DECLARE genres JSON;
   DECLARE casts JSON;
   
   SET genres = CAST(CONCAT('{"genres":',genres_js,'}') as JSON);
   SET casts = CAST(CONCAT('{"cast":',casts_js,'}') as JSON);
   
   select genres;
   select casts;
   
   
   START TRANSACTION;
    
    -- check if movie already exists and get ID if so 
   IF param_movie_id =0	THEN
		SELECT  movie_id INTO movie_id FROM movies m WHERE m.title = title AND m.year = year LIMIT 1;
   ELSE
		SET movie_id = param_movie_id;
   END IF;
    
   
-- IF to update or delete movie

   IF movie_id IS NOT NULL THEN      
   
		-- -----------------------------------------
       -- Movie exists, update record 
       -- -----------------------------------------
       -- 
       -- update movie title and year if ID is passed in, otherwise no need as we are using those as keys for matching so they are the same
       -- 
		IF param_movie_id >0  THEN 
				UPDATE movies m
				SET m.title = title, m.year = year
				WHERE m.movie_id = movie_id;
		END IF;
        
		-- Delete genres and casts as they will be added later
		DELETE mg FROM moviegenres mg 
		WHERE
			mg.movie_id = movie_id;	
		
		DELETE mc FROM moviecasts mc 
		WHERE
			mc.movie_id = movie_id;
		
	ELSE
			-- 
			-- New movie so needs to be inserted movie and ID retrieved
			--
			INSERT INTO movies (title, year) VALUES (title, year);
			SET movie_id = LAST_INSERT_ID();
	END IF;

   -- we should always have an ID here, otherwise something went wrong		
   IF movie_id IS NOT NULL THEN        
   
	-- ---------------------------------
	-- Add Genres 
	-- --------------------------------
     IF (select count(*) FROM JSON_TABLE(genres, '$.genres[*]' COLUMNS (genre varchar(100) PATH '$[0]')) AS genrelist) >0 THEN 
		INSERT INTO genres (genre)
		SELECT genrelist.genre 
		FROM JSON_TABLE(genres, '$.genres[*]' COLUMNS (genre varchar(100) PATH '$[0]')) AS genrelist
		LEFT JOIN genres g ON g.genre = genrelist.genre
		WHERE g.genre_id is null;
	
	
	-- Add new genres to genre table 
	-- Add new mappings to movie genres 
		INSERT INTO moviegenres (movie_id, genre_id)
		SELECT movie_id, g.genre_id 
		FROM JSON_TABLE(genres, '$.genres[*]' COLUMNS (genre varchar(100) PATH '$[0]')) AS genrelist
		JOIN genres g ON g.genre = genrelist.genre;
        
	-- Update cache lists for easy extraction 
		UPDATE movies SET genreslist  =  genres_js where movies.movie_id = movie_id;
    ELSE 
		-- update movie with empty list 		
		UPDATE movies SET genreslist  =  '[]' where movies.movie_id = movie_id;
	END IF;
	-- ---------------------------------
	-- Add casts 
	-- ---------------------------------
    IF (select count(*) FROM JSON_TABLE(casts, '$.cast[*]' COLUMNS (cast varchar(100) PATH '$[0]')) AS castlist) >0 THEN 
		-- Add new casts to casts table 
		INSERT INTO casts (cast)
		SELECT castlist.cast 
		FROM JSON_TABLE(casts, '$.cast[*]' COLUMNS (cast varchar(100) PATH '$[0]')) AS castlist
		LEFT JOIN casts c ON c.cast = castlist.cast
		WHERE c.cast_id is null;
		
		-- Add new mappings to movie genres 
		INSERT INTO moviecasts(movie_id, cast_id)
		SELECT movie_id, g.cast_id 
		FROM JSON_TABLE(casts, '$.cast[*]' COLUMNS (cast varchar(100) PATH '$[0]')) AS castlist
		JOIN casts g ON g.cast = castlist.cast;
        
        -- Update cache lists for easy extraction 
		UPDATE movies SET castlist  =  casts_js where movies.movie_id = movie_id;
    ELSE 
		UPDATE movies SET castlist  =    '[]' where movies.movie_id = movie_id;
	END IF;	
  ELSE 
	-- Somehting went wrong as there should be an id after update or creation
    -- TO DO raise error
	ROLLBACK;
  
  END IF;
    
COMMIT ;

END$$
DELIMITER ;
