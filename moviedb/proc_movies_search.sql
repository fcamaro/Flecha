DELIMITER $$
CREATE DEFINER=`flecha`@`%` PROCEDURE `movies_search`(in movie_id int, in title nvarchar(1000),in  year int,in  genre nvarchar(1000),in cast nvarchar(1000))
BEGIN
	SELECT DISTINCT 
		m.movie_id,
        m.title, 
        m.year, 
        m.genreslist, 
        m.castlist
    FROM movies m 
	WHERE
    (movie_id = 0 OR m.movie_id = movie_id)
    AND (year = 0 or m.year = year)
    AND (title = '' OR m.title like CONCAT('%',title,'%'))
    AND (genre='' or m.genreslist like CONCAT('%',genre,'%'))
    AND  (cast='' or m.castlist like CONCAT('%',cast,'%'));
END$$

