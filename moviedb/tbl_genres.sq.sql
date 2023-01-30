CREATE TABLE `genres` (
  `genre_id` int NOT NULL AUTO_INCREMENT,
  `genre` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`genre_id`),
  KEY `ixgenres` (`genre`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
