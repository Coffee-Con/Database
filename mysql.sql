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

CREATE TABLE `reset_tokens` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(64) NOT NULL,
    token_expiry DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(UserID) ON DELETE CASCADE
);

-- 创建 Course 表
CREATE TABLE `Course` (
  `CourseID` int NOT NULL AUTO_INCREMENT,
  `CourseName` varchar(100) NOT NULL,
  `CourseDescription` varchar(100) DEFAULT 'Course Description',
  PRIMARY KEY (`CourseID`)
);

-- 创建 Course_User 中间表
CREATE TABLE `Course_User` (
  `UserID` int NOT NULL,
  `CourseID` int NOT NULL,
  PRIMARY KEY (`CourseID`, `UserID`),
  FOREIGN KEY (`CourseID`) REFERENCES `Course`(`CourseID`),
  FOREIGN KEY (`UserID`) REFERENCES `user`(`UserID`)
);

INSERT INTO `COMP`.`user` (`UserID`, `User`, `Email`, `Name`, `Role`, `Salt`, `HashedPW`, `registration_time`) VALUES ('1', 'xyz@email.com', 'xyz@email.com', 'Yu', '1', 'ceedfeb40d54fcd60c4aec77a67486fe', '67598873cfaaeb78bc468add9f104900', '2024-10-08 15:20:44'); -- admin default password: 123456

INSERT INTO `COMP`.`Course` (`CourseID`, `CourseName`) VALUES ('1', 'Anti-Phishing');
INSERT INTO `COMP`.`Course_User` (`UserID`, `CourseID`) VALUES ('1', '1');