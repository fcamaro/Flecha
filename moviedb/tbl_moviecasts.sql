CREATE TABLE `moviecasts` (
  `moviecast_id` int NOT NULL AUTO_INCREMENT,
  `movie_id` int NOT NULL,
  `cast_id` int NOT NULL,
  PRIMARY KEY (`moviecast_id`),
  KEY `ixmcmovie_idx` (`movie_id`),
  KEY `ixmccasts_idx` (`cast_id`),
  CONSTRAINT `ixmccasts` FOREIGN KEY (`cast_id`) REFERENCES `casts` (`cast_id`),
  CONSTRAINT `ixmcmovies` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`movie_id`)
) ENGINE=InnoDB AUTO_INCREMENT=448 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
