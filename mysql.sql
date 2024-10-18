CREATE DATABASE COMP;

USE COMP;

CREATE TABLE `user` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `User` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `Name` varchar(45) NOT NULL,
  `Role` int NOT NULL DEFAULT '0',
  `Salt` varchar(45) NOT NULL,
  `HashedPW` varchar(45) NOT NULL,
  `registration_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 创建 group 表
CREATE TABLE `group` (
  `GroupID` int NOT NULL AUTO_INCREMENT,
  `GroupName` varchar(100) NOT NULL,
  PRIMARY KEY (`GroupID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 创建 group_user 中间表
CREATE TABLE `group_user` (
  `GroupID` int NOT NULL,
  `UserID` int NOT NULL,
  PRIMARY KEY (`GroupID`, `UserID`),
  FOREIGN KEY (`GroupID`) REFERENCES `group`(`GroupID`),
  FOREIGN KEY (`UserID`) REFERENCES `user`(`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `email_template` (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` json NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `click_key` (
  `key` varchar(45) NOT NULL,
  `userid` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `click_event` (
  `id` int NOT NULL AUTO_INCREMENT,
  `key` varchar(45) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `COMP`.`user` (`UserID`, `User`, `Email`, `Name`, `Role`, `Salt`, `HashedPW`, `registration_time`) VALUES ('1', 'xyz@email.com', 'xyz@email.com', 'Yu', '1', 'ceedfeb40d54fcd60c4aec77a67486fe', '67598873cfaaeb78bc468add9f104900', '2024-10-08 15:20:44'); -- admin default password: 123456
