DROP DATABASE IF EXISTS COMP;
CREATE DATABASE COMP DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE COMP;

CREATE TABLE `User` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `Email` varchar(45) NOT NULL,
  `Name` varchar(45) NOT NULL,
  `Role` int NOT NULL DEFAULT '0',
  `Salt` varchar(45) NOT NULL,
  `HashedPW` varchar(45) NOT NULL,
  `registration_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `JoinDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Education` VARCHAR(45) NOT NULL DEFAULT 'N.A.',
  `ITLevel` VARCHAR(45) NOT NULL DEFAULT 'N.A.',
  PRIMARY KEY (`UserID`)
);

-- Create group Table
CREATE TABLE `Group` (
  `GroupID` int NOT NULL AUTO_INCREMENT,
  `GroupName` varchar(100) NOT NULL,
  PRIMARY KEY (`GroupID`)
);

-- Create group_user Bridge Table
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
  `Email` varchar(45) NOT NULL,
  PRIMARY KEY (`key`)
);

CREATE TABLE `ClickEvent` (
  `id` int NOT NULL AUTO_INCREMENT,
  `key` varchar(45) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `MailEvent` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ClickKeys` json NOT NULL,
  `Content` json NOT NULL,
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Status` int NOT NULL DEFAULT '0', -- 0: not completed, 1: completed
  PRIMARY KEY (`ID`)
);

CREATE TABLE `ResetTokens` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `token` VARCHAR(64) NOT NULL,
    `token_expiry` DATETIME NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `User`(`UserID`) ON DELETE CASCADE
);

-- Create Course Table
CREATE TABLE `Course` (
  `CourseID` int NOT NULL AUTO_INCREMENT,
  `CourseName` varchar(100) NOT NULL,
  `CourseDescription` varchar(100) DEFAULT 'Course Description',
  PRIMARY KEY (`CourseID`)
);

-- Create CourseUser Bridge Table
CREATE TABLE `CourseUser` (
  `UserID` int NOT NULL,
  `CourseID` int NOT NULL,
  PRIMARY KEY (`CourseID`, `UserID`),
  FOREIGN KEY (`CourseID`) REFERENCES `Course`(`CourseID`) ON DELETE CASCADE,
  FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE
);

-- Create Quiz Table 
CREATE TABLE `Quiz` (
  `QuizID` int NOT NULL AUTO_INCREMENT,
  `QuizName` varchar(100) NOT NULL,
  `QuizDescription` varchar(100) DEFAULT 'Quiz Description',
  -- `StartTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- `DueTime` timestamp,?
  PRIMARY KEY (`QuizID`)
);

-- Create QuizCourse Bridge Table -- 1 quiz to many courses
CREATE TABLE `QuizCourse` (
  `QuizID` int NOT NULL,
  `CourseID` int NOT NULL,
  `Status` int DEFAULT 1, -- 1: ToDo, 2: End
  PRIMARY KEY (`QuizID`, `CourseID`),
  FOREIGN KEY (`QuizID`) REFERENCES `Quiz`(`QuizID`) ON DELETE CASCADE,
  FOREIGN KEY (`CourseID`) REFERENCES `Course`(`CourseID`) ON DELETE CASCADE
);

-- Create QuestionType Table
CREATE TABLE `QuestionType` (
  `QuestionTypeID` int NOT NULL AUTO_INCREMENT,
  `QuestionTypeName` varchar(100) NOT NULL,
  PRIMARY KEY (`QuestionTypeID`)
);

-- Create Question Table
CREATE TABLE `Question` (
  `QuestionID` int NOT NULL AUTO_INCREMENT,
  `Question` TEXT NOT NULL,
  `QuestionType` int NOT NULL,
  `Answer` JSON,
  PRIMARY KEY (`QuestionID`),
  FOREIGN KEY (`QuestionType`) REFERENCES `QuestionType`(`QuestionTypeID`)
);

-- Create QuizQuestion Bridge Table
CREATE TABLE `QuizQuestion` (
  `QuizID` int NOT NULL,
  `QuestionID` int NOT NULL,
  PRIMARY KEY (`QuizID`, `QuestionID`),
  FOREIGN KEY (`QuizID`) REFERENCES `Quiz`(`QuizID`) ON DELETE CASCADE,
  FOREIGN KEY (`QuestionID`) REFERENCES `Question`(`QuestionID`) ON DELETE CASCADE
);

-- Create UserQuizQuestionAnswer Table
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

-- Create UserQuizAnswer Table
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

-- Create UserQuizScore Table
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

-- Create QuizStatusType Table
CREATE TABLE `QuizStatusType` (
  `StatusID` int NOT NULL AUTO_INCREMENT,
  `StatusName` varchar(100) NOT NULL,
  PRIMARY KEY (`StatusID`)
);

-- Create UserQuizStatus Table
CREATE TABLE `UserQuizStatus` (
  `UserID` int NOT NULL,
  `QuizID` int NOT NULL,
  `StatusID` int NOT NULL,
  PRIMARY KEY (`UserID`, `QuizID`),
  FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE,
  FOREIGN KEY (`QuizID`) REFERENCES `Quiz`(`QuizID`) ON DELETE CASCADE,
  FOREIGN KEY (`StatusID`) REFERENCES `QuizStatusType`(`StatusID`) ON DELETE CASCADE
);

-- Create Material Table
CREATE TABLE `Material` (
  `MaterialID` int NOT NULL AUTO_INCREMENT,
  `MaterialName` varchar(100) DEFAULT 'Course Material',
  `MaterialDescription` varchar(100) DEFAULT 'Material Description',
  `MaterialType` int DEFAULT 1, -- 1: video, 2: pdf
  `MaterialLink` varchar(100), -- link to the material(a webpage or youtube video?)
  PRIMARY KEY (`MaterialID`)
);

-- Create CourseMaterial Bridge Table
CREATE TABLE `CourseMaterial` (
  `CourseID` int NOT NULL,
  `MaterialID` int NOT NULL,
  PRIMARY KEY (`CourseID`, `MaterialID`),
  FOREIGN KEY (`CourseID`) REFERENCES `Course`(`CourseID`) ON DELETE CASCADE,
  FOREIGN KEY (`MaterialID`) REFERENCES `Material`(`MaterialID`) ON DELETE CASCADE
);

-- Create Reward Table
CREATE TABLE `Reward` (
  `RewardID` int NOT NULL AUTO_INCREMENT,
  `RewardName` varchar(100) NOT NULL,
  `RewardDescription` varchar(100) DEFAULT 'Reward Description',
  `RewardPoint` int NOT NULL, -- Price for the reward
  `RewardLink` varchar(100), -- link to the reward(a webpage?)
  PRIMARY KEY (`RewardID`)
);

-- Create UserRewardPoint Table
CREATE TABLE `UserRewardPoint` (
  `UserID` int NOT NULL,
  `RewardPoint` int NOT NULL,
  PRIMARY KEY (`UserID`),
  FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE
);

-- Create UserRewardPointHistory Table
CREATE TABLE `UserRewardPointHistory` (
  `ActionID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `Action` varchar(100) NOT NULL, -- Action: get + or use -
  `ActionDetail` varchar(100), -- ActionDetail: the reward name
  `RewardPoint` int NOT NULL,
  `ActionTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Time when the user get the reward
  PRIMARY KEY (`ActionID`, `UserID`) -- 1ActionID to multiple UserID
);

-- Create UserReward Table
CREATE TABLE `UserReward` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `RewardID` int NOT NULL,
  `RewardTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Time when the user get the reward
  `Status` int DEFAULT 1, -- 1: ToDo, 2: Completed
  PRIMARY KEY (`ID`),
  FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE,
  FOREIGN KEY (`RewardID`) REFERENCES `Reward`(`RewardID`) ON DELETE CASCADE
);

INSERT INTO `COMP`.`User` (`UserID`, `Email`, `Name`, `Role`, `Salt`, `HashedPW`, `registration_time`) VALUES ('1', 'admin@staffcanvas.xyz', 'AdminTest', '1', 'ceedfeb40d54fcd60c4aec77a67486fe', '6a04f435bb6c4d16ee440f1e982402b6', '2024-10-08 15:20:44'); -- admin default password: !&4*$f0YB6gII3**

INSERT INTO `COMP`.`Group` (`GroupID`, `GroupName`) VALUES ('1', 'Group1');

INSERT INTO `COMP`.`Course` (`CourseID`, `CourseName`) VALUES ('1', 'Anti-Phishing');
INSERT INTO `COMP`.`CourseUser` (`UserID`, `CourseID`) VALUES ('1', '1');

INSERT INTO `COMP`.`QuestionType` (`QuestionTypeID`, `QuestionTypeName`) VALUES ('1', 'MCQ');
INSERT INTO `COMP`.`QuestionType` (`QuestionTypeID`, `QuestionTypeName`) VALUES ('2', 'Fill in the Blanks');

INSERT INTO `COMP`.`QuizStatusType` (`StatusID`, `StatusName`) VALUES ('1', 'ToDo');
INSERT INTO `COMP`.`QuizStatusType` (`StatusID`, `StatusName`) VALUES ('2', 'Completed');

INSERT INTO `COMP`.`Quiz` (`QuizID`, `QuizName`, `QuizDescription`) VALUES ('1', 'Testing', 'TestingDescription');
INSERT INTO `COMP`.`Question` (`QuestionID`, `Question`, `QuestionType`, `Answer`) VALUES 
('1',  'Which of the following is a common characteristic of phishing emails?',  '1',  '[{\"text\": \"A.Using an email address from an official domain\", \"correct\": false}, {\"text\": \"B.Using urgent language and threatening words\", \"correct\": true}, {\"text\": \"C. Using harmless images and attachments\", \"correct\": false}, {\"text\": \"D.Simple personal greetings\", \"correct\": false}]'),
('2', 'What do phishing emails usually ask users to do?', '1', '[{\"text\": \"A. Reply to the email to confirm their identity\", \"correct\": false}, {\"text\": \"B. Provide financial information\", \"correct\": true}, {\"text\": \"C. Take a survey\", \"correct\": false}, {\"text\": \"D. Install a new application\", \"correct\": false}]'),
('3', 'Which of the following is incorrect when identifying phishing emails?', '1', '[{\"text\": \"A. Check the body of the email for spelling and grammatical errors\", \"correct\": false}, {\"text\": \"B. Click on all links to check if they are valid\", \"correct\": true}, {\"text\": \"C. Check if the sender\'s email address is authentic\", \"correct\": false}, {\"text\": \"D. Verify the authenticity of the email directly from the sender\", \"correct\": false}]'),
('4', 'Which of the following email attachment formats is most likely to contain malware?', '1', '[{\"text\": \"A. .docx\", \"correct\": false}, {\"text\": \"B. .pdf\", \"correct\": false}, {\"text\": \"C. .exe\", \"correct\": true}, {\"text\": \"D. .txt\", \"correct\": false}]'),
('5', 'If you receive a suspicious email, what should you do first?', '1', '[{\"text\": \"A. Open and read the content\", \"correct\": false}, {\"text\": \"B. Delete the email directly\", \"correct\": false}, {\"text\": \"C. Click the link to view details\", \"correct\": false}, {\"text\": \"D. Report to the IT department\", \"correct\": true}]'),
('6', 'Which of the following is not a type of phishing email?', '1', '[{\"text\": \"A. Impersonated bank email\", \"correct\": false}, {\"text\": \"B. Impersonating an instruction email from the boss\", \"correct\": false}, {\"text\": \"C. Untitled spam\", \"correct\": true}, {\"text\": \"D. Charity email asking for donations\", \"correct\": false}]'),
('7', 'The email claims \"Your account has been locked, please click the link below to reset your password.\" What type of attack is this?', '1', '[{\"text\": \"A. Social engineering\", \"correct\": false}, {\"text\": \"B. Spear phishing\", \"correct\": true}, {\"text\": \"C. Malware attack\", \"correct\": false}, {\"text\": \"D. Denial of service attack\", \"correct\": false}]'),
('8', 'If the email appears to be from the company\'s IT department, but asks you to provide password information, you should:', '1', '[{\"text\": \"A. Reply to the email directly and provide the information\", \"correct\": false}, {\"text\": \"B. Ignore the email\", \"correct\": false}, {\"text\": \"C. Call the official phone number of the IT department to verify\", \"correct\": true}, {\"text\": \"D. Forward it to a colleague for advice\", \"correct\": false}]'),
('9', 'Common traps in phishing emails include:', '1', '[{\"text\": \"A. Provide a link to the company\'s latest policies\", \"correct\": false}, {\"text\": \"B. Invite to participate in internal company training\", \"correct\": false}, {\"text\": \"C. Notify of winning and ask for payment of handling fees\", \"correct\": true}, {\"text\": \"D. Advertising emails promoting products\", \"correct\": false}]'),
('10', 'How to verify the authenticity of the link in the email?', '1', '[{\"text\": \"A. Click the link directly to check\", \"correct\": false}, {\"text\": \"B. Hover the mouse over the link to view the real URL\", \"correct\": true}, {\"text\": \"C. Use the phone number in the email to confirm\", \"correct\": false}, {\"text\": \"D. Ask a colleague about the reliability of the link\", \"correct\": false}]'),
('11', 'Malicious links in phishing emails usually redirect to:', '1', '[{\"text\": \"A. Official websites\", \"correct\": false}, {\"text\": \"B. Legitimate advertising pages\", \"correct\": false}, {\"text\": \"C. Fake login pages\", \"correct\": true}, {\"text\": \"D. Social media homepages\", \"correct\": false}]'),
('12', 'Which of the following actions may reduce your risk of being attacked by phishing?', '1', '[{\"text\": \"A. Use the same password on all websites\", \"correct\": false}, {\"text\": \"B. Change passwords from time to time\", \"correct\": false}, {\"text\": \"C. Enable two-step verification\", \"correct\": true}, {\"text\": \"D. Use public Wi-Fi to log in to company email in public places\", \"correct\": false}]'),
('13', 'Which of the following describes a spear phishing attack?', '1', '[{\"text\": \"A. Emails sent randomly to a large number of users\", \"correct\": false}, {\"text\": \"B. Email attacks targeting a specific person or organization\", \"correct\": true}, {\"text\": \"C. Use Trojans to infect computers\", \"correct\": false}, {\"text\": \"D. Advanced forms of phishing attacks\", \"correct\": false}]'),
('14', 'Which of the following is a best practice for preventing phishing emails?', '1', '[{\"text\": \"A. Ignore all additional information in the email\", \"correct\": false}, {\"text\": \"B. Open all attachments in the email\", \"correct\": false}, {\"text\": \"C. Report to the IT department when encountering suspicious emails\", \"correct\": true}, {\"text\": \"D. Frequently interact with the sender\'s emails\", \"correct\": false}]'),
('15', 'When the content of the email is found to be inconsistent with the company\'s official policy, you should:', '1', '[{\"text\": \"A. Ignore it\", \"correct\": false}, {\"text\": \"B. Respond to the question immediately\", \"correct\": false}, {\"text\": \"C. Forward it to all employees\", \"correct\": false}, {\"text\": \"D. Verify through other official channels\", \"correct\": true}]'),
('16', 'The email does not show the recipient\'s name, but uses \"Dear Customer\". This is a possible:', '1', '[{\"text\": \"A. Regular email\", \"correct\": false}, {\"text\": \"B. Security notification\", \"correct\": false}, {\"text\": \"C. Phishing email\", \"correct\": true}, {\"text\": \"D. Internal notification\", \"correct\": false}]'),
('17', 'If you receive an email claiming to be from a friend, but the content seems abnormal, you should:', '1', '[{\"text\": \"A. Reply to the email directly\", \"correct\": false}, {\"text\": \"B. Click on the link to view details\", \"correct\": false}, {\"text\": \"C. Contact your friend to verify the authenticity of the email\", \"correct\": true}, {\"text\": \"D. Ignore this email\", \"correct\": false}]'),
('18', 'Which of the following is unlikely to appear in a phishing email?', '1', '[{\"text\": \"A. Request to update personal information\", \"correct\": false}, {\"text\": \"B. Provide a link for financial support\", \"correct\": false}, {\"text\": \"C. Official event notification\", \"correct\": true}, {\"text\": \"D. Provide a harmless PDF file\", \"correct\": false}]'),
('19', 'Why do links in phishing emails usually use URL shortening services?', '1', '[{\"text\": \"A. To keep the link beautiful\", \"correct\": false}, {\"text\": \"B. To hide the real address of the malicious website\", \"correct\": true}, {\"text\": \"C. To increase the chance of clicks\", \"correct\": false}, {\"text\": \"D. To improve the credibility of the email\", \"correct\": false}]'),
('20', 'If you have clicked on a malicious link in a phishing email, the best thing to do is:', '1', '[{\"text\": \"A. Ignore it\", \"correct\": false}, {\"text\": \"B. Change your password as soon as possible and contact the IT department\", \"correct\": true}, {\"text\": \"C. Continue browsing the link\", \"correct\": false}, {\"text\": \"D. Share the link with others\", \"correct\": false}]');

INSERT INTO `COMP`.`Question` (`QuestionID`, `Question`, `QuestionType`, `Answer`) VALUES 
('21', 'Phishing emails usually use __________ technology to induce users to disclose personal information.', '2', '[{\"text\": \"Social engineering\", \"correct\": true}]'),
('22', 'When you find a suspicious email, you should mark it as a __________ email and report it to the IT department.', '2', '[{\"text\": \"Phishing\", \"correct\": true}]'),
('23', 'When you encounter a phishing email, it is best not to click on any __________ in the email or download attachments.', '2', '[{\"text\": \"Links\", \"correct\": true}]'),
('24', '__________ phishing emails are attacks against specific individuals or organizations.', '2', '[{\"text\": \"Spear\", \"correct\": true}]'),
('25', 'In order to prevent phishing email attacks, it is recommended that users enable the __________ function to increase account security.', '2', '[{\"text\": \"Two-factor authentication\", \"correct\": true}]');


INSERT INTO `COMP`.`QuizCourse` (`QuizID`, `CourseID`) VALUES ('1', '1');
INSERT INTO `COMP`.`QuizQuestion` (`QuizID`, `QuestionID`) VALUES
('1', '1'),('1', '2'),('1', '3'),('1', '4'),('1', '5'),('1', '6'),('1', '7'),('1', '8'),('1', '9'),('1', '10'),('1', '11'),('1', '12'),('1', '13'),('1', '14'),('1', '15'),('1', '16'),('1', '17'),('1', '18'),('1', '19'),('1', '20'),('1', '21'),('1', '22'),('1', '23'),('1', '24'),('1', '25');

INSERT INTO `COMP`.`Material` (`MaterialID`, `MaterialName`, `MaterialDescription`, `MaterialType`, `MaterialLink`) VALUES
('1', 'Phishing Attacks Guide', 'Phishing Attacks Guide', '2', 'https://staffcanvs.xyz/user/material/PhishingEmailMaterials.pdf'),
('2', 'Phishing Attacks Video', 'Youtube Video', '1', 'https://www.youtube.com/watch?v=XBkzBrXlle0');

INSERT INTO `COMP`.`CourseMaterial` (`CourseID`, `MaterialID`) VALUES
('1', '1'), ('1', '2');
