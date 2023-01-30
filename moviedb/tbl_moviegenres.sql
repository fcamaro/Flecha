CREATE TABLE `moviegenres` (
  `moviegenre_id` int NOT NULL AUTO_INCREMENT,
  `movie_id` int NOT NULL,
  `genre_id` int NOT NULL,
  PRIMARY KEY (`moviegenre_id`),
  KEY `ixmgmovies_idx` (`movie_id`),
  KEY `ixmggenres_idx` (`genre_id`),
  CONSTRAINT `ixmggenres` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`genre_id`),
  CONSTRAINT `ixmgmovies` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`movie_id`)
) ENGINE=InnoDB AUTO_INCREMENT=232 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
