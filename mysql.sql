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

-- 创建 Quiz 表 
CREATE TABLE `Quiz` (
  `QuizID` int NOT NULL AUTO_INCREMENT,
  `QuizName` varchar(100) NOT NULL,
  `QuizDescription` varchar(100) DEFAULT 'Quiz Description',
  -- `StartTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- `DueTime` timestamp,?
  PRIMARY KEY (`QuizID`)
);

-- 创建 QuizCourse 中间表 -- 一个quiz可以对应多个course
CREATE TABLE `QuizCourse` (
  `QuizID` int NOT NULL,
  `CourseID` int NOT NULL,
  PRIMARY KEY (`QuizID`, `CourseID`),
  FOREIGN KEY (`QuizID`) REFERENCES `Quiz`(`QuizID`),
  FOREIGN KEY (`CourseID`) REFERENCES `Course`(`CourseID`)
);

-- 创建 QuestionType 表
CREATE TABLE `QuestionType` (
  `QuestionTypeID` int NOT NULL AUTO_INCREMENT,
  `QuestionTypeName` varchar(100) NOT NULL,
  PRIMARY KEY (`QuestionTypeID`)
);

-- 创建 Question 表
CREATE TABLE `Question` (
  `QuestionID` int NOT NULL AUTO_INCREMENT,
  `Question` varchar(100) NOT NULL,
  `QuestionType` int NOT NULL,
  `Answer` JSON,
  PRIMARY KEY (`QuestionID`),
  FOREIGN KEY (`QuestionType`) REFERENCES `QuestionType`(`QuestionTypeID`)
);

-- 创建 QuizQuestion 中间表
CREATE TABLE `QuizQuestion` (
  `QuizID` int NOT NULL,
  `QuestionID` int NOT NULL,
  PRIMARY KEY (`QuizID`, `QuestionID`),
  FOREIGN KEY (`QuizID`) REFERENCES `Quiz`(`QuizID`) ON DELETE CASCADE,
  FOREIGN KEY (`QuestionID`) REFERENCES `Question`(`QuestionID`) ON DELETE CASCADE
);

-- 创建 UserQuizAnswer 表
CREATE TABLE `UserQuizAnswer` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `QuizID` int NOT NULL,
  `Answer` JSON NOT NULL,
  `SubmitTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  FOREIGN KEY (`UserID`) REFERENCES `user`(`UserID`),
  FOREIGN KEY (`QuizID`) REFERENCES `Quiz`(`QuizID`)
);

-- 创建 UserQuizScore 表
CREATE TABLE `UserQuizScore` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `QuizID` int NOT NULL,
  `Score` int NOT NULL,
  `SubmitTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  FOREIGN KEY (`UserID`) REFERENCES `user`(`UserID`),
  FOREIGN KEY (`QuizID`) REFERENCES `Quiz`(`QuizID`)
);

-- 创建 QuizStatusType 表
CREATE TABLE `QuizStatusType` (
  `StatusID` int NOT NULL AUTO_INCREMENT,
  `StatusName` varchar(100) NOT NULL,
  PRIMARY KEY (`StatusID`)
);

-- 创建 UserQuizStatus 表
CREATE TABLE `UserQuizStatus` (
  `UserID` int NOT NULL,
  `QuizID` int NOT NULL,
  `StatusID` int NOT NULL,
  PRIMARY KEY (`UserID`, `QuizID`),
  FOREIGN KEY (`UserID`) REFERENCES `user`(`UserID`),
  FOREIGN KEY (`QuizID`) REFERENCES `Quiz`(`QuizID`),
  FOREIGN KEY (`StatusID`) REFERENCES `QuizStatusType`(`StatusID`)
);

-- 创建 CourseMaterial 表
CREATE TABLE `CourseMaterial` (
  `MaterialID` int NOT NULL AUTO_INCREMENT,
  `CourseID` int NOT NULL,
  `MaterialName` varchar(100) NOT NULL,
  `MaterialDescription` varchar(100) DEFAULT 'Material Description',
  `MaterialLink` varchar(100) NOT NULL, -- link to the material(a webpage or youtube video?)
  PRIMARY KEY (`MaterialID`),
  FOREIGN KEY (`CourseID`) REFERENCES `Course`(`CourseID`)
);

-- 创建 Reward 表
CREATE TABLE `Reward` (
  `RewardID` int NOT NULL AUTO_INCREMENT,
  `RewardName` varchar(100) NOT NULL,
  `RewardDescription` varchar(100) DEFAULT 'Reward Description',
  `RewardPoint` int NOT NULL, -- Price for the reward
  `RewardLink` varchar(100) NOT NULL, -- link to the reward(a webpage?)
  PRIMARY KEY (`RewardID`)
);

-- 创建 UserRewardPoint 表
CREATE TABLE `UserRewardPoint` (
  `UserID` int NOT NULL,
  `RewardPoint` int NOT NULL,
  PRIMARY KEY (`UserID`),
  FOREIGN KEY (`UserID`) REFERENCES `user`(`UserID`)
);

-- 创建 UserRewardPointHistory 表
CREATE TABLE `UserRewardPointHistory` (
  `ActionID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `Action` varchar(100) NOT NULL, -- Action: get + or use -
  `ActionDetail` varchar(100), -- ActionDetail: the reward name
  `RewardPoint` int NOT NULL,
  `ActionTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Time when the user get the reward
  PRIMARY KEY (`ActionID`, `UserID`) -- 1ActionID to multiple UserID
);

-- 创建 UserReward 表
CREATE TABLE `UserReward` (
  `UserID` int NOT NULL,
  `RewardID` int NOT NULL,
  `RewardTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Time when the user get the reward
  PRIMARY KEY (`UserID`, `RewardID`),
  FOREIGN KEY (`UserID`) REFERENCES `user`(`UserID`),
  FOREIGN KEY (`RewardID`) REFERENCES `Reward`(`RewardID`)
);

INSERT INTO `COMP`.`user` (`UserID`, `User`, `Email`, `Name`, `Role`, `Salt`, `HashedPW`, `registration_time`) VALUES ('1', 'xyz@email.com', 'xyz@email.com', 'Yu', '1', 'ceedfeb40d54fcd60c4aec77a67486fe', '67598873cfaaeb78bc468add9f104900', '2024-10-08 15:20:44'); -- admin default password: 123456

INSERT INTO `COMP`.`Course` (`CourseID`, `CourseName`) VALUES ('1', 'Anti-Phishing');
INSERT INTO `COMP`.`Course_User` (`UserID`, `CourseID`) VALUES ('1', '1');

INSERT INTO `COMP`.`QuestionType` (`QuestionTypeID`, `QuestionTypeName`) VALUES ('1', 'MCQ');
INSERT INTO `COMP`.`QuestionType` (`QuestionTypeID`, `QuestionTypeName`) VALUES ('2', 'Fill in the Blanks');

INSERT INTO `COMP`.`QuizStatusType` (`StatusID`, `StatusName`) VALUES ('1', 'ToDo');
INSERT INTO `COMP`.`QuizStatusType` (`StatusID`, `StatusName`) VALUES ('2', 'Completed');
INSERT INTO `COMP`.`Quiz` (`QuizID`, `QuizName`, `QuizDescription`) VALUES ('1', 'Testing', 'TestingDescription');
INSERT INTO `COMP`.`Question` (`QuestionID`, `Question`, `QuestionType`, `Answer`) VALUES ('1', 'A?', '1', '[{\"text\": \"A\", \"correct\": true}, {\"text\": \"B\", \"correct\": false}]');
INSERT INTO `COMP`.`QuizCourse` (`QuizID`, `CourseID`) VALUES ('1', '1');
INSERT INTO `COMP`.`QuizQuestion` (`QuizID`, `QuestionID`) VALUES ('1', '1');