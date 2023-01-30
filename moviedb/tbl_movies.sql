CREATE TABLE `movies` (
  `movie_id` int NOT NULL AUTO_INCREMENT,
  `year` int DEFAULT NULL,
  `title` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `genreslist` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `castlist` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`movie_id`),
  KEY `ixyeartitle` (`year`,`title`) /*!80000 INVISIBLE */,
  KEY `ixtitleyear` (`title`,`year`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
