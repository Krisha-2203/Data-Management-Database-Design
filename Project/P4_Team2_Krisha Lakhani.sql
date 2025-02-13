CREATE DATABASE T2_Test; 
USE T2_Test;
-- Create Table: RealPerson
CREATE TABLE RealPerson (
    StreamerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT,
    Gender VARCHAR(10)
);
-- Add Constraints to RealPerson
ALTER TABLE RealPerson
ADD CONSTRAINT check_realPersonage CHECK (Age > 0 AND Age <= 100);
ALTER TABLE RealPerson
ADD CONSTRAINT check_realpersongender CHECK (Gender IN ('Male', 'Female'));

CREATE TABLE VocalChanger ( 
	VoiceID INT PRIMARY KEY,
    VoiceModulationType VARCHAR(50) NOT NULL,
	VoiceFilter VARCHAR(50),
    RecordingDate DATE
);

CREATE TABLE MotionCaptureSpecialist ( 
	SpecialistID INT NOT NULL PRIMARY KEY,
    SpecialtyStyle VARCHAR(50) 
);

CREATE TABLE Painter ( 
	ArtistID INT NOT NULL PRIMARY KEY, 
    SpecialtyStyle VARCHAR(50) 
);

CREATE TABLE VirtualImage ( 
	VirtualImageID INT NOT NULL PRIMARY KEY, 
    Name VARCHAR(50) NOT NULL, 
	Age INT,
    Gender VARCHAR(50),
    ArtistID INT NOT NULL,
    SpecialistID INT NOT NULL,
    VoiceID INT,
    FOREIGN KEY (ArtistID) REFERENCES Painter(ArtistID),
    FOREIGN KEY (SpecialistID) REFERENCES MotionCaptureSpecialist(SpecialistID),
    FOREIGN KEY (VoiceID) REFERENCES VocalChanger(VoiceID)
);
ALTER TABLE VirtualImage
ADD CONSTRAINT check_age CHECK (Age >= 0);
ALTER TABLE VirtualImage
ADD CONSTRAINT check_gender CHECK (Gender IN ('Male', 'Female'));

CREATE TABLE MotionCaptureEquipment (
	EquipmentID INT NOT NULL PRIMARY KEY, 
    Brand VARCHAR(50) ,
    Cost DECIMAL(10, 2),
    PurchaseDate DATE
);
ALTER TABLE MotionCaptureEquipment
ADD CONSTRAINT check_cost CHECK (Cost >= 0);
ALTER TABLE MotionCaptureEquipment
ADD CONSTRAINT check_purchase_date CHECK (PurchaseDate <= GETDATE());

-- Create Table: VirtualIdol
CREATE TABLE VirtualIdol (
    VirtualIdolID INT PRIMARY KEY,
    VirtualImageID INT NOT NULL,
    StreamerID INT NOT NULL,
    FOREIGN KEY (StreamerID) REFERENCES RealPerson(StreamerID)
);
-- Add Constraints to VirtualIdol
ALTER TABLE VirtualIdol
ADD CONSTRAINT fk_streamer FOREIGN KEY (StreamerID) REFERENCES RealPerson(StreamerID);
ALTER TABLE VirtualIdol
ADD CONSTRAINT fk_virtualImage FOREIGN KEY (VirtualImageID) REFERENCES VirtualImage(VirtualImageID);

-- Create Table: Sponsor
CREATE TABLE Sponsor (
    SponsorID INT PRIMARY KEY,
    Industry VARCHAR(50),
    SponsorshipAmount DECIMAL(15, 2)
);

CREATE TABLE Merchandise (
    MerchID INT PRIMARY KEY,
    SponsorID INT,
    Brand VARCHAR(255),
    ProductName VARCHAR(255),
    Price DECIMAL(10, 2),
    ReleaseDate DATE,
    FOREIGN KEY (SponsorID) REFERENCES Sponsor(SponsorID)
);

CREATE TABLE YoutubeLiveStream (
    VirtualIdolID INT,
    StreamID INT PRIMARY KEY,
    Title VARCHAR(255),
    Duration INT,
    Date DATE,
    FOREIGN KEY (VirtualIdolID) REFERENCES VirtualIdol(VirtualIdolID)
);

CREATE TABLE Topic (
    TopicName VARCHAR(255) PRIMARY KEY,
    TopicDuration INT
);

CREATE TABLE YoutubeLiveStream_Topic (
    TopicName VARCHAR(255),
    StreamID INT,
    PRIMARY KEY (TopicName, StreamID),
    FOREIGN KEY (TopicName) REFERENCES Topic(TopicName),
    FOREIGN KEY (StreamID) REFERENCES YoutubeLiveStream(StreamID)
);

CREATE TABLE Advertisements (
    AdID INT PRIMARY KEY,
    StreamID INT,
    ProductName VARCHAR(255),
    StartTime TIME,
    EndTime TIME,
    MerchID INT,
    FOREIGN KEY (StreamID) REFERENCES YoutubeLiveStream(StreamID),
    FOREIGN KEY (MerchID) REFERENCES Merchandise(MerchID)
);

-- Insert Data: RealPerson
INSERT INTO RealPerson (StreamerID, FirstName, LastName, Age, Gender) VALUES
(101, 'Alice', 'Smith', 25, 'Female'),
(102, 'Bob', 'Johnson', 30, 'Male'),
(103, 'Charlie', 'Brown', 28, 'Male'),
(104, 'Diana', 'Evans', 26, 'Female'),
(105, 'Eve', 'Taylor', 24, 'Female'),
(106, 'Frank', 'Wright', 35, 'Male'),
(107, 'Grace', 'Hall', 29, 'Female'),
(108, 'Henry', 'Lee', 32, 'Male'),
(109, 'Ivy', 'Clark', 27, 'Female'),
(110, 'Jack', 'Walker', 33, 'Male');


INSERT INTO VocalChanger (VoiceID, VoiceModulationType, VoiceFilter, RecordingDate) VALUES
(301, 'High-Pitch', 'Reverb', '2024-01-01'),
(302, 'Low-Pitch', 'Echo', '2023-02-01'),
(303, 'Robotic', 'Distortion', '2024-03-01'),
(304, 'Childish', 'Flanger', '2023-04-01'),
(305, 'Deep', 'Chorus', '2021-05-01'),
(306, 'Soft', 'Auto-Tune', '2022-06-01'),
(307, 'Gravelly', 'Vocoder', '2023-07-01'),
(308, 'Smooth', 'Equalizer', '2021-08-01'),
(309, 'Squeaky', 'Compressor', '2019-09-01'),
(310, 'Melodic', 'Pitch-Shift', '2023-10-01');

INSERT INTO MotionCaptureSpecialist (SpecialistID, SpecialtyStyle) VALUES
(201, 'Realistic'),
(202, 'Anime-Style'),
(203, 'Cartoonish'),
(204, 'Fantasy'),
(205, 'Sci-Fi'),
(206, 'Horror'),
(207, 'Comedy'),
(208, 'Action'),
(209, 'Adventure'),
(210, 'Drama');

INSERT INTO Painter (ArtistID, SpecialtyStyle) VALUES
(101, 'Digital Art'),
(102, 'Traditional Art'),
(103, 'Anime-Style'),
(104, 'Realism'),
(105, 'Fantasy'),
(106, 'Sci-Fi'),
(107, 'Anime-Style'),
(108, 'Cartoonish'),
(109, 'Anime-Style'),
(110, 'Anime-Style');


INSERT INTO MotionCaptureEquipment (EquipmentID, Brand, Cost, PurchaseDate) VALUES
(401, 'BrandA', 978.45, '2020-01-15'),
(402, 'BrandB', 1293.75, '2019-02-25'),
(403, 'BrandC', 1592.87, '2021-03-05'),
(404, 'BrandD', 874.92, '2022-04-10'),
(405, 'BrandE', 1094.36, '2019-05-20'),
(406, 'BrandF', 803.24, '2023-06-30'),
(407, 'BrandG', 1389.99, '2020-07-15'),
(408, 'BrandH', 1487.65, '2021-08-25'),
(409, 'BrandI', 1212.43, '2024-09-05'),
(410, 'BrandJ', 998.67, '2023-10-10');

INSERT INTO VirtualImage (VirtualImageID, Name, Age, Gender, ArtistID, SpecialistID, VoiceID) VALUES
(201, 'Kizuna', 200, 'Female', 101, 201, 301),
(202, 'Shiro', 28, 'Male', 102, 202, 302),
(203, 'Korone', 18, 'Female', 103, 203, 303),
(204, 'Hololive', 20, 'Female', 104, 204, 304),
(205, 'Hikaru', 15, 'Male', 105, 205, 305),
(206, 'Aqua', 17, 'Female', 106, 206, 306),
(207, 'Ren', 21, 'Male', 107, 207, 307),
(208, 'Fubuki', 19, 'Female', 108, 208, 308),
(209, 'Marine', 22, 'Female', 109, 209, 309),
(210, 'Yuki', 23, 'Male', 110, 210, 310);

-- Insert Data: VirtualIdol
INSERT INTO VirtualIdol (VirtualIdolID, VirtualImageID, StreamerID) VALUES
(1, 201, 101), 
(2, 202, 102), 
(3, 203, 103), 
(4, 204, 104), 
(5, 205, 105), 
(6, 206, 106), 
(7, 207, 107), 
(8, 208, 108), 
(9, 209, 109), 
(10, 210, 110);

-- YoutubeLiveStream data
INSERT INTO YoutubeLiveStream (VirtualIdolID, StreamID, Title, Duration, Date) VALUES
(1, 101, 'Live Art Session', 120, '2024-11-01'),
(2, 102, 'Gaming Session', 90, '2024-11-02'),
(1, 103, 'Q&A with Fans', 60, '2024-11-03'),
(3, 104, 'Music Livestream', 150, '2024-11-04'),
(4, 105, 'Cooking Show', 110, '2024-11-05'),
(1, 106, 'Dance Performance', 95, '2024-11-06'),
(2, 107, 'Film Discussion', 100, '2024-11-07'),
(3, 108, 'Podcast Live', 130, '2024-11-08'),
(4, 109, 'Tech Talk', 80, '2024-11-09'),
(5, 110, 'Book Club', 75, '2024-11-10');

-- Topic data
INSERT INTO Topic (TopicName, TopicDuration) VALUES
('Art', 45),
('Gaming', 60),
('Q&A', 30),
('Music', 50),
('Cooking', 40),
('Dance', 35),
('Film', 50),
('Podcast', 70),
('Tech', 45),
('Books', 55);

-- YoutubeLiveStream_Topic data
INSERT INTO YoutubeLiveStream_Topic (TopicName, StreamID) VALUES
('Art', 101),
('Gaming', 102),
('Q&A', 103),
('Music', 104),
('Cooking', 105),
('Dance', 106),
('Film', 107),
('Podcast', 108),
('Tech', 109),
('Books', 110);

-- Insert Data: Sponsor
INSERT INTO Sponsor (SponsorID, Industry, SponsorshipAmount) VALUES
(401, 'Gaming', 50000.00),
(402, 'Fashion', 40000.00),
(403, 'Technology', 60000.00),
(404, 'Food', 35000.00),
(405, 'Entertainment', 45000.00),
(406, 'Sports', 55000.00),
(407, 'Education', 30000.00),
(408, 'Health', 38000.00),
(409, 'Travel', 42000.00),
(410, 'Finance', 48000.00);

CREATE TABLE YoutubeLiveStream_Sponsor (
	StreamID INT NOT NULL
		REFERENCES YoutubeLiveStream(StreamID),
	SponsorID INT NOT NULL
		REFERENCES Sponsor(SponsorID),
	CONSTRAINT PKYoutubeLiveStreamSponsor PRIMARY KEY CLUSTERED
		(StreamID, SponsorID)
);

INSERT INTO YoutubeLiveStream_Sponsor (StreamID, SponsorID) VALUES
(101, 401),
(102, 402),
(103, 403),
(104, 404),
(105, 405),
(106, 406),
(107, 407),
(108, 408),
(109, 409),
(110, 410);

-- Merchandise data
INSERT INTO Merchandise (MerchID, SponsorID, Brand, ProductName, Price, ReleaseDate) VALUES
(301, 401, 'ArtBrand', 'Art Supplies', 25.99, '2024-11-01'),
(302, 402, 'GameGear', 'Gaming Headset', 79.99, '2024-11-02'),
(303, 403, 'SoundPro', 'Q&A Mic', 49.99, '2024-11-03'),
(304, 404, 'TicketMaster', 'Concert Tickets', 150.00, '2024-11-04'),
(305, 405, 'CookWare', 'Cooking Utensils', 30.50, '2024-11-05'),
(306, 406, 'DanceMarket', 'Dance Shoes', 90.00, '2024-11-06'),
(307, 407, 'FilmHouse', 'Film Subscription', 15.00, '2024-11-07'),
(308, 408, 'PodcastWorld', 'Podcast Service', 9.99, '2024-11-08'),
(309, 409, 'Techies', 'Tech Gadgets', 199.99, '2024-11-09'),
(310, 410, 'BookHaven', 'Books Collection', 60.00, '2024-11-10');


-- Advertisements data
INSERT INTO Advertisements (AdID, StreamID, ProductName, StartTime, EndTime, MerchID) VALUES
(201, 101, 'Art Supplies', '10:00', '10:35', 301),
(202, 102, 'Gaming Headset', '12:00', '12:16', 302),
(203, 103, 'Q&A Mic', '14:00', '14:23', 303),
(204, 104, 'Concert Tickets', '15:00', '15:25', 304),
(205, 105, 'Cooking Utensils', '16:00', '16:45', 305),
(206, 106, 'Dance Shoes', '11:00', '11:45', 306),
(207, 107, 'Film Subscription', '17:00', '17:11', 307),
(208, 108, 'Podcast Service', '18:00', '18:05', 308),
(209, 109, 'Tech Gadgets', '19:00', '19:34', 309),
(210, 110, 'Books Collection', '20:00', '20:19', 310);


-- Adding constraints to YoutubeLiveStream
ALTER TABLE YoutubeLiveStream
ADD CONSTRAINT check_duration CHECK (Duration > 0);
ALTER TABLE YoutubeLiveStream
ADD CONSTRAINT check_date CHECK (Date <= GETDATE());

-- Adding constraints to Topic
ALTER TABLE Topic
ADD CONSTRAINT check_topic_duration CHECK (TopicDuration > 0);

-- Adding constraints to Advertisements
ALTER TABLE Advertisements
ADD CONSTRAINT check_ad_time CHECK (StartTime < EndTime);
ALTER TABLE Advertisements
ADD CONSTRAINT unique_ad_time UNIQUE (StreamID, StartTime);

-- Adding constraints to Merchandise
ALTER TABLE Merchandise
ADD CONSTRAINT check_price CHECK (Price > 0);
ALTER TABLE Merchandise
ADD CONSTRAINT check_release CHECK (ReleaseDate <= GETDATE());
ALTER TABLE Merchandise
ADD CONSTRAINT unique_product UNIQUE (Brand, ProductName);


CREATE TABLE VirtualImage_Equipment ( 
	VirtualImageID INT NOT NULL,
    EquipmentID INT NOT NULL,
    PRIMARY KEY (VirtualImageID, EquipmentID),
    FOREIGN KEY (VirtualImageID) REFERENCES VirtualImage(VirtualImageID),
    FOREIGN KEY (EquipmentID) REFERENCES MotionCaptureEquipment(EquipmentID)
);



INSERT INTO VirtualImage_Equipment (VirtualImageID, EquipmentID) VALUES
(201, 401),
(202, 402),
(203, 403),
(204, 404),
(205, 401),
(206, 406),
(207, 402),
(208, 406),
(209, 409),
(210, 404);


-- Create Table: Platform
CREATE TABLE Platform (
    PlatformName VARCHAR(50) PRIMARY KEY,
    VirtualIdolID INT NOT NULL,
    TotalSubscribers INT,
    FOREIGN KEY (VirtualIdolID) REFERENCES VirtualIdol(VirtualIdolID)
);

-- Create Table: YoutubeChannels
CREATE TABLE YoutubeChannels (
    ChannelID INT PRIMARY KEY,
    VirtualIdolID INT NOT NULL,
    Subscriptions INT,
    FOREIGN KEY (VirtualIdolID) REFERENCES VirtualIdol(VirtualIdolID)
);



-- Insert Data: Platform
INSERT INTO Platform (PlatformName, VirtualIdolID, TotalSubscribers) VALUES
('Twitch', 1, 15000),
('YouTube', 2, 25000),
('TikTok', 3, 10000),
('Facebook', 4, 5000),
('Instagram', 5, 12000),
('Snapchat', 6, 8000),
('Mixer', 7, 3000),
('Vimeo', 8, 2000),
('Dailymotion', 9, 4000),
('Reddit', 10, 6000);

-- Insert Data: YoutubeChannels
INSERT INTO YoutubeChannels (ChannelID, VirtualIdolID, Subscriptions) VALUES
(3301, 1, 10000),
(3302, 2, 20000),
(3303, 3, 15000),
(3304, 4, 5000),
(3305, 5, 12000),
(3306, 6, 7000),
(3307, 7, 3500),
(3308, 8, 2500),
(3309, 9, 4500),
(3310, 10, 6000);

-- Add Constraints to Platform
ALTER TABLE Platform
ADD CONSTRAINT fk_virtual_idol_platform FOREIGN KEY (VirtualIdolID) REFERENCES VirtualIdol(VirtualIdolID);
ALTER TABLE Platform
ADD CONSTRAINT check_subscribers CHECK (TotalSubscribers >= 0);

-- Add Constraints to YoutubeChannels
ALTER TABLE YoutubeChannels
ADD CONSTRAINT fk_virtual_idol_channels FOREIGN KEY (VirtualIdolID) REFERENCES VirtualIdol(VirtualIdolID);
ALTER TABLE YoutubeChannels
ADD CONSTRAINT check_subscriptions CHECK (Subscriptions >= 0);

-- Add Constraints to Sponsor
ALTER TABLE Sponsor
ADD CONSTRAINT check_sponsorship_amount CHECK (SponsorshipAmount > 0);


CREATE TABLE Viewer (
	ViewerID INT NOT NULL PRIMARY KEY,
	UserName VARCHAR(100) NOT NULL,
	Age INT NOT NULL,
	YoutubeChannelSubscribed INT NOT NULL
);

CREATE TABLE Review (
	ReviewID INT NOT NULL PRIMARY KEY,
	StreamID INT NOT NULL
		REFERENCES YoutubeLiveStream(StreamID),
	ViewerID INT NOT NULL
		REFERENCES Viewer(ViewerID),
	ReviewType VARCHAR(10) NOT NULL CHECK (ReviewType IN ('Positive', 'Average', 'Negative', 'Other'))
);

CREATE TABLE YoutubeLiveStream_Viewer (
	StreamID INT NOT NULL
		REFERENCES YoutubeLiveStream(StreamID),
	ViewerID INT NOT NULL
		REFERENCES Viewer(ViewerID),
	CONSTRAINT PKYoutubeLiveStreamViewer PRIMARY KEY CLUSTERED
		(StreamID, ViewerID)
);

CREATE TABLE Donations (
	DonationID INT NOT NULL PRIMARY KEY ,
	StreamID INT NOT NULL
		REFERENCES YoutubeLiveStream(StreamID),
	ViewerID INT NOT NULL
		REFERENCES Viewer(ViewerID),
	DonationAmount DECIMAL(10,2) 
);


-- Insert Data into Viewer Table
INSERT INTO Viewer (ViewerID, UserName, Age, YoutubeChannelSubscribed)
VALUES 
(1,'JohnDoe', 25, 1),
(2,'JaneSmith', 30, 2),
(3,'MikeJohnson', 22, 0),
(4,'SarahLee', 28, 3),
(5,'ChrisBrown', 35, 1),
(6,'EmilyDavis', 26, 4),
(7,'RobertTaylor', 40, 0),
(8,'SophiaWilson', 18, 2),
(9,'DanielMartinez', 32, 5),
(10,'LisaClark', 29, 1);

-- Insert Data into YoutubeLiveStream_Viewer Table
INSERT INTO YoutubeLiveStream_Viewer (StreamID, ViewerID)
VALUES 
(101, 1),
(101, 2),
(102, 3),
(103, 4),
(103, 5),
(104, 6),
(105, 7),
(105, 8),
(106, 9),
(107, 10);

-- Insert Data into Donations Table
INSERT INTO Donations (DonationID, StreamID, ViewerID, DonationAmount)
VALUES 
(401,101, 1, 25.00),
(402,101, 2, 50.00),
(403,102, 3, 15.00),
(404,103, 4, 30.00),
(405,103, 5, 10.00),
(406,104, 6, 20.00),
(407,105, 7, 100.00),
(408,105, 8, 200.00),
(409,106, 9, 5.00),
(410,107, 10, 50.00);

-- Insert Data into Review Table
INSERT INTO Review (ReviewID,StreamID, ViewerID, ReviewType)
VALUES 
(501,101, 1, 'Positive'),
(502,101, 2, 'Negative'),
(503,102, 3, 'Average'),
(504,103, 4, 'Positive'),
(505,103, 5, 'Positive'),
(506,104, 6, 'Negative'),
(507,105, 7, 'Positive'),
(508,105, 8, 'Average'),
(509,106, 9, 'Positive'),
(510,107, 10, 'Negative');

-- Viewer Table Constraints
ALTER TABLE Viewer
ADD CONSTRAINT CHK_ViewerAge CHECK (Age > 0 AND Age <= 120); -- Age must be positive and realistic
ALTER TABLE Viewer
ADD CONSTRAINT CHK_YoutubeChannelSubscribed CHECK (YoutubeChannelSubscribed >= 0); -- Channels subscribed cannot be negative

-- YoutubeLiveStream_Viewer Table Constraints
ALTER TABLE YoutubeLiveStream_Viewer
ADD CONSTRAINT FK_StreamID_YoutubeLiveStreamViewer FOREIGN KEY (StreamID) REFERENCES YoutubeLiveStream(StreamID);
ALTER TABLE YoutubeLiveStream_Viewer
ADD CONSTRAINT FK_ViewerID_YoutubeLiveStreamViewer FOREIGN KEY (ViewerID) REFERENCES Viewer(ViewerID);

-- Donations Table Constraints
ALTER TABLE Donations
ADD CONSTRAINT FK_StreamID_Donations FOREIGN KEY (StreamID) REFERENCES YoutubeLiveStream(StreamID);
ALTER TABLE Donations
ADD CONSTRAINT FK_ViewerID_Donations FOREIGN KEY (ViewerID) REFERENCES Viewer(ViewerID);
ALTER TABLE Donations
ADD CONSTRAINT CHK_DonationAmount CHECK (DonationAmount > 0); -- Donations must be positive

-- Review Table Constraints
ALTER TABLE Review
ADD CONSTRAINT FK_StreamID_Review FOREIGN KEY (StreamID) REFERENCES YoutubeLiveStream(StreamID);
ALTER TABLE Review
ADD CONSTRAINT FK_ViewerID_Review FOREIGN KEY (ViewerID) REFERENCES Viewer(ViewerID);
ALTER TABLE Review
ADD CONSTRAINT CHK_ReviewType CHECK (ReviewType IN ('Positive', 'Average', 'Negative', 'Other')); -- Restrict review type to specific values

DROP FUNCTION IF EXISTS dbo.fn_CalcAdDuration;
GO
-- Computed Columns based on a function
-- Function to calculate advertisement duration
-- Ensure functions are created
CREATE FUNCTION dbo.fn_CalcAdDuration(@StreamID INT)
RETURNS INT
AS
BEGIN
    DECLARE @AdDuration INT;
    SELECT @AdDuration = SUM(DATEDIFF(MINUTE, StartTime, EndTime))
    FROM Advertisements
    WHERE StreamID = @StreamID;
    RETURN ISNULL(@AdDuration, 0);
END;
GO

DROP FUNCTION IF EXISTS dbo.fn_CalcTotalDonations;
GO
CREATE FUNCTION dbo.fn_CalcTotalDonations(@StreamID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalDonations DECIMAL(10, 2);
    SELECT @TotalDonations = SUM(DonationAmount)
    FROM Donations
    WHERE StreamID = @StreamID;
    RETURN ISNULL(@TotalDonations, 0);
END;
GO

-- Add columns to the table
ALTER TABLE YoutubeLiveStream
ADD AdDuration INT,
    TotalDonations DECIMAL(10, 2);
GO

-- Update columns with calculated values
UPDATE YoutubeLiveStream
SET AdDuration = dbo.fn_CalcAdDuration(StreamID),
    TotalDonations = dbo.fn_CalcTotalDonations(StreamID);

GO
-- Create LiveStreamInfoView
CREATE VIEW LiveStreamInfoView AS
SELECT 
    ls.StreamID,
    ls.Duration,
    t.TopicName,
    t.TopicDuration,
    ls.AdDuration, -- Computed column: Advertisement duration
    mer.ProductName,
    sp.Industry,
    sp.SponsorshipAmount,
    ls.TotalDonations -- Computed column: Total donations (revenue)
FROM 
    YoutubeLiveStream ls
JOIN 
    Advertisements ad ON ls.StreamID = ad.StreamID
JOIN 
    Merchandise mer ON ad.MerchID = mer.MerchID
JOIN
    Sponsor sp ON mer.SponsorID = sp.SponsorID
JOIN 
    YoutubeLiveStream_Topic yt ON ls.StreamID = yt.StreamID
JOIN
    Topic t ON yt.TopicName = t.TopicName;


-- Create VtuberImageInfoView
GO
CREATE VIEW VtuberImageInfoView AS
SELECT 
    vi.VirtualImageID,
    vi.Name,
    vi.Age,
    vi.Gender,
    p.SpecialtyStyle AS PainterStyle,
    m.SpecialtyStyle AS MotionCaptureSpecialistStyle,
    vc.VoiceModulationType,
    vc.VoiceFilter,
    mce.Brand AS MotionCaptureEquipmentBrand
FROM 
    VirtualImage vi
JOIN 
    Painter p ON vi.ArtistID = p.ArtistID
JOIN 
    MotionCaptureSpecialist m ON vi.SpecialistID = m.SpecialistID
JOIN 
    VocalChanger vc ON vi.VoiceID = vc.VoiceID
JOIN 
    VirtualImage_Equipment vie ON vi.VirtualImageID = vie.VirtualImageID
JOIN 
    MotionCaptureEquipment mce ON vie.EquipmentID = mce.EquipmentID;

-- Create DMK
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = '6210team2';
-- Create certificate to protect symmetric key
CREATE CERTIFICATE ViewerCertificate
WITH SUBJECT = 'Viewer Encryption Certificate',
EXPIRY_DATE = '2026-10-31';
-- Create symmetric key to encrypt data
CREATE SYMMETRIC KEY ViewerSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE ViewerCertificate;
-- Open symmetric key
OPEN SYMMETRIC KEY ViewerSymmetricKey
DECRYPTION BY CERTIFICATE ViewerCertificate;
-- Use VARBINARY as the data type for the encrypted column
ALTER TABLE Viewer
ADD EncryptedUserName varchar(256);
UPDATE Viewer 
SET EncryptedUserName = ENCRYPTBYKEY(KEY_GUID('ViewerSymmetricKey'), UserName);
ALTER TABLE Viewer 
DROP COLUMN UserName;
EXEC sp_rename 'Viewer.EncryptedUserName', 'UserName', 'COLUMN';
CLOSE SYMMETRIC KEY ViewerSymmetricKey;

-- check viewer table
SELECT * FROM Viewer;

-- -- Use DecryptByKey to decrypt the encrypted data and see what we have in the table
OPEN SYMMETRIC KEY ViewerSymmetricKey
DECRYPTION BY CERTIFICATE ViewerCertificate;

-- DecryptByKey returns VARBINARY with a maximum size of 8,000 bytes
SELECT ViewerID, CONVERT(VARCHAR(100), DECRYPTBYKEY(UserName)) AS DecryptedUserName
FROM Viewer;

-- close DecryptByKey
CLOSE SYMMETRIC KEY ViewerSymmetricKey;

