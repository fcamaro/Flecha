SELECT * FROM movies.sqllog;CREATE TABLE `casts` (
  `cast_id` int NOT NULL AUTO_INCREMENT,
  `cast` varchar(254) DEFAULT NULL,
  PRIMARY KEY (`cast_id`),
  KEY `ixcast` (`cast`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
