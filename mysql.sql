CREATE DATABASE COMP;

USE COMP;

CREATE TABLE `User` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `User` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `Name` varchar(45) NOT NULL,
  `Role` int NOT NULL DEFAULT '0',
  `Salt` varchar(45) NOT NULL,
  `HashedPW` varchar(45) NOT NULL,
  `registration_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserID`)
);

-- 创建 group 表
CREATE TABLE `Group` (
  `GroupID` int NOT NULL AUTO_INCREMENT,
  `GroupName` varchar(100) NOT NULL,
  PRIMARY KEY (`GroupID`)
);

-- 创建 group_user 中间表
CREATE TABLE `GroupUser` (
  `GroupID` int NOT NULL,
  `UserID` int NOT NULL,
  PRIMARY KEY (`GroupID`, `UserID`),
  FOREIGN KEY (`GroupID`) REFERENCES `Group`(`GroupID`) ON DELETE CASCADE,
  FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE
);

CREATE TABLE `EmailTemplate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` json NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `ClickKey` (
  `key` varchar(45) NOT NULL,
  `userid` int NOT NULL,
  PRIMARY KEY (`key`)
);

CREATE TABLE `ClickEvent` (
  `id` int NOT NULL AUTO_INCREMENT,
  `key` varchar(45) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `ResetTokens` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `token` VARCHAR(64) NOT NULL,
    `token_expiry` DATETIME NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `User`(`UserID`) ON DELETE CASCADE
);

-- 创建 Course 表
CREATE TABLE `Course` (
  `CourseID` int NOT NULL AUTO_INCREMENT,
  `CourseName` varchar(100) NOT NULL,
  `CourseDescription` varchar(100) DEFAULT 'Course Description',
  PRIMARY KEY (`CourseID`)
);

-- 创建 CourseUser 中间表
CREATE TABLE `CourseUser` (
  `UserID` int NOT NULL,
  `CourseID` int NOT NULL,
  PRIMARY KEY (`CourseID`, `UserID`),
  FOREIGN KEY (`CourseID`) REFERENCES `Course`(`CourseID`) ON DELETE CASCADE,
  FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE
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
  FOREIGN KEY (`QuizID`) REFERENCES `Quiz`(`QuizID`) ON DELETE CASCADE,
  FOREIGN KEY (`CourseID`) REFERENCES `Course`(`CourseID`) ON DELETE CASCADE
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

-- 创建 UserQuizQuestionAnswer 表
CREATE TABLE `UserQuizQuestionAnswer` (
  `UserID` int NOT NULL,
  `QuizID` int NOT NULL,
  `QuestionID` int NOT NULL,
  `Answer` varchar(100) NOT NULL,
  PRIMARY KEY (`UserID`, `QuizID`, `QuestionID`),
  FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE,
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
  FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE,
  FOREIGN KEY (`QuizID`) REFERENCES `Quiz`(`QuizID`) ON DELETE CASCADE
);

-- 创建 UserQuizScore 表
CREATE TABLE `UserQuizScore` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `QuizID` int NOT NULL,
  `Score` int NOT NULL,
  `SubmitTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE,
  FOREIGN KEY (`QuizID`) REFERENCES `Quiz`(`QuizID`) ON DELETE CASCADE
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
  FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE,
  FOREIGN KEY (`QuizID`) REFERENCES `Quiz`(`QuizID`) ON DELETE CASCADE,
  FOREIGN KEY (`StatusID`) REFERENCES `QuizStatusType`(`StatusID`) ON DELETE CASCADE
);

-- 创建 CourseMaterial 表
CREATE TABLE `CourseMaterial` (
  `MaterialID` int NOT NULL AUTO_INCREMENT,
  `CourseID` int NOT NULL,
  `MaterialName` varchar(100) DEFAULT 'Course Material',
  `MaterialDescription` varchar(100) DEFAULT 'Material Description',
  `MaterialLink` varchar(100), -- link to the material(a webpage or youtube video?)
  PRIMARY KEY (`MaterialID`),
  FOREIGN KEY (`CourseID`) REFERENCES `Course`(`CourseID`) ON DELETE CASCADE
);

-- 创建 Reward 表
CREATE TABLE `Reward` (
  `RewardID` int NOT NULL AUTO_INCREMENT,
  `RewardName` varchar(100) NOT NULL,
  `RewardDescription` varchar(100) DEFAULT 'Reward Description',
  `RewardPoint` int NOT NULL, -- Price for the reward
  `RewardLink` varchar(100), -- link to the reward(a webpage?)
  PRIMARY KEY (`RewardID`)
);

-- 创建 UserRewardPoint 表
CREATE TABLE `UserRewardPoint` (
  `UserID` int NOT NULL,
  `RewardPoint` int NOT NULL,
  PRIMARY KEY (`UserID`),
  FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE
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
  FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE,
  FOREIGN KEY (`RewardID`) REFERENCES `Reward`(`RewardID`) ON DELETE CASCADE
);

INSERT INTO `COMP`.`User` (`UserID`, `User`, `Email`, `Name`, `Role`, `Salt`, `HashedPW`, `registration_time`) VALUES ('1', 'xyz@email.com', 'xyz@email.com', 'Yu', '1', 'ceedfeb40d54fcd60c4aec77a67486fe', '67598873cfaaeb78bc468add9f104900', '2024-10-08 15:20:44'); -- admin default password: 123456

INSERT INTO `COMP`.`Course` (`CourseID`, `CourseName`) VALUES ('1', 'Anti-Phishing');
INSERT INTO `COMP`.`CourseUser` (`UserID`, `CourseID`) VALUES ('1', '1');

INSERT INTO `COMP`.`QuestionType` (`QuestionTypeID`, `QuestionTypeName`) VALUES ('1', 'MCQ');
INSERT INTO `COMP`.`QuestionType` (`QuestionTypeID`, `QuestionTypeName`) VALUES ('2', 'Fill in the Blanks');

INSERT INTO `COMP`.`QuizStatusType` (`StatusID`, `StatusName`) VALUES ('1', 'ToDo');
INSERT INTO `COMP`.`QuizStatusType` (`StatusID`, `StatusName`) VALUES ('2', 'Completed');

INSERT INTO `COMP`.`Quiz` (`QuizID`, `QuizName`, `QuizDescription`) VALUES ('1', 'Testing', 'TestingDescription');
INSERT INTO `COMP`.`Question` (`QuestionID`, `Question`, `QuestionType`, `Answer`) VALUES ('1', 'A?', '1', '[{\"text\": \"A\", \"correct\": true}, {\"text\": \"B\", \"correct\": false}]');
INSERT INTO `COMP`.`Question` (`QuestionID`, `Question`, `QuestionType`, `Answer`) VALUES ('2', 'B?', '1', '[{\"text\": \"A\", \"correct\": false}, {\"text\": \"B\", \"correct\": true}]');
INSERT INTO `COMP`.`QuizCourse` (`QuizID`, `CourseID`) VALUES ('1', '1');
INSERT INTO `COMP`.`QuizQuestion` (`QuizID`, `QuestionID`) VALUES ('1', '1');
INSERT INTO `COMP`.`QuizQuestion` (`QuizID`, `QuestionID`) VALUES ('1', '2');
INSERT INTO `COMP`.`UserQuizQuestionAnswer` (`UserID`, `QuizID`, `QuestionID`, `Answer`) VALUES ('1', '1', '1', 'A');
INSERT INTO `COMP`.`UserQuizQuestionAnswer` (`UserID`, `QuizID`, `QuestionID`, `Answer`) VALUES ('1', '1', '2', 'B');