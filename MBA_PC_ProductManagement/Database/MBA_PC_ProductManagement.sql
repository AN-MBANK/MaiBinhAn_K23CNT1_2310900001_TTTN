/*
============================================================
MBA-PC PRODUCT MANAGEMENT
DATABASE FINAL
============================================================
CHỈ CẦN CHẠY FILE NÀY.

Script:
- Tạo database MBA_PC_ProductManagement.
- Tạo cấu trúc bảng/quan hệ.
- Có sẵn bộ dữ liệu mẫu hoàn chỉnh.
- 17 Mba_Categories / 340 Mba_Products / 340 Mba_Reviews / 10 Mba_Employees.
- Có đủ 4 trạng thái workflow.

Mở bằng SQL Server Management Studio -> Execute (F5).
============================================================
*/

/*
    MBA-PC ProductManagement
    SQL Server database setup + sample data
    Compatible with SQL Server / SQL Server Express / SSMS
*/

IF DB_ID(N'MBA_PC_ProductManagement') IS NULL
BEGIN
    CREATE DATABASE [MBA_PC_ProductManagement];
END
GO

USE [MBA_PC_ProductManagement];
GO
/* ============================================================
   MIGRATION TỪ PHIÊN BẢN CŨ
   Đổi toàn bộ tên bảng và tên trường sang tiền tố Mba.
   Có thể chạy an toàn trên DB cũ: chỉ đổi khi tên mới chưa tồn tại.
   ============================================================ */
IF OBJECT_ID(N'dbo.Categories', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Categories', N'U') IS NULL EXEC sp_rename N'dbo.Categories', N'Mba_Categories';
IF OBJECT_ID(N'dbo.Products', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Products', N'U') IS NULL EXEC sp_rename N'dbo.Products', N'Mba_Products';
IF OBJECT_ID(N'dbo.Reviews', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Reviews', N'U') IS NULL EXEC sp_rename N'dbo.Reviews', N'Mba_Reviews';
IF OBJECT_ID(N'dbo.Accounts', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Accounts', N'U') IS NULL EXEC sp_rename N'dbo.Accounts', N'Mba_Accounts';
IF OBJECT_ID(N'dbo.Admins', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Admins', N'U') IS NULL EXEC sp_rename N'dbo.Admins', N'Mba_Admins';
IF OBJECT_ID(N'dbo.MbaCategories', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Categories', N'U') IS NULL EXEC sp_rename N'dbo.MbaCategories', N'Mba_Categories';
IF OBJECT_ID(N'dbo.MbaProducts', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Products', N'U') IS NULL EXEC sp_rename N'dbo.MbaProducts', N'Mba_Products';
IF OBJECT_ID(N'dbo.MbaReviews', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Reviews', N'U') IS NULL EXEC sp_rename N'dbo.MbaReviews', N'Mba_Reviews';
IF OBJECT_ID(N'dbo.MbaAccounts', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Accounts', N'U') IS NULL EXEC sp_rename N'dbo.MbaAccounts', N'Mba_Accounts';
IF OBJECT_ID(N'dbo.MbaAdmins', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Admins', N'U') IS NULL EXEC sp_rename N'dbo.MbaAdmins', N'Mba_Admins';
IF OBJECT_ID(N'dbo.MbaEmployees', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Employees', N'U') IS NULL EXEC sp_rename N'dbo.MbaEmployees', N'Mba_Employees';

DECLARE @RenameColumns TABLE (TableName sysname, OldName sysname, NewName sysname);
INSERT INTO @RenameColumns VALUES
(N'Mba_Categories',N'MbaId',N'Mba_Id'),(N'Mba_Categories',N'MbaCode',N'Mba_Code'),(N'Mba_Categories',N'MbaName',N'Mba_Name'),(N'Mba_Categories',N'MbaDescription',N'Mba_Description'),(N'Mba_Categories',N'MbaIsActive',N'Mba_IsActive'),
(N'Mba_Products',N'MbaId',N'Mba_Id'),(N'Mba_Products',N'MbaCategoryId',N'Mba_CategoryId'),(N'Mba_Products',N'MbaCode',N'Mba_Code'),(N'Mba_Products',N'MbaName',N'Mba_Name'),(N'Mba_Products',N'MbaCategory',N'Mba_Category'),(N'Mba_Products',N'MbaBrand',N'Mba_Brand'),(N'Mba_Products',N'MbaDescription',N'Mba_Description'),(N'Mba_Products',N'MbaImageUrl',N'Mba_ImageUrl'),(N'Mba_Products',N'MbaPrice',N'Mba_Price'),(N'Mba_Products',N'MbaQuantity',N'Mba_Quantity'),(N'Mba_Products',N'MbaTechnicalInfo',N'Mba_TechnicalInfo'),(N'Mba_Products',N'MbaDataStatus',N'Mba_DataStatus'),
(N'Mba_Accounts',N'MbaId',N'Mba_Id'),(N'Mba_Accounts',N'MbaUsername',N'Mba_Username'),(N'Mba_Accounts',N'MbaPasswordHash',N'Mba_PasswordHash'),(N'Mba_Accounts',N'MbaRole',N'Mba_Role'),(N'Mba_Accounts',N'MbaIsActive',N'Mba_IsActive'),(N'Mba_Accounts',N'MbaCreatedAt',N'Mba_CreatedAt'),
(N'Mba_Admins',N'MbaId',N'Mba_Id'),(N'Mba_Admins',N'MbaAccountId',N'Mba_AccountId'),(N'Mba_Admins',N'MbaFullName',N'Mba_FullName'),(N'Mba_Admins',N'MbaEmail',N'Mba_Email'),(N'Mba_Admins',N'MbaPhone',N'Mba_Phone'),(N'Mba_Admins',N'MbaAvatarUrl',N'Mba_AvatarUrl'),
(N'Mba_Employees',N'MbaId',N'Mba_Id'),(N'Mba_Employees',N'MbaAccountId',N'Mba_AccountId'),(N'Mba_Employees',N'MbaFullName',N'Mba_FullName'),(N'Mba_Employees',N'MbaEmail',N'Mba_Email'),(N'Mba_Employees',N'MbaPhone',N'Mba_Phone'),(N'Mba_Employees',N'MbaAvatarUrl',N'Mba_AvatarUrl'),(N'Mba_Employees',N'MbaIsActive',N'Mba_IsActive'),
(N'Mba_Reviews',N'MbaId',N'Mba_Id'),(N'Mba_Reviews',N'MbaProductId',N'Mba_ProductId'),(N'Mba_Reviews',N'MbaStatus',N'Mba_Status'),(N'Mba_Reviews',N'MbaCheckedItems',N'Mba_CheckedItems'),(N'Mba_Reviews',N'MbaTotalItems',N'Mba_TotalItems'),(N'Mba_Reviews',N'MbaSourceNote',N'Mba_SourceNote'),(N'Mba_Reviews',N'MbaReviewNote',N'Mba_ReviewNote'),(N'Mba_Reviews',N'MbaEmployeeId',N'Mba_EmployeeId'),(N'Mba_Reviews',N'MbaAssignedAt',N'Mba_AssignedAt'),(N'Mba_Reviews',N'MbaDeadline',N'Mba_Deadline'),(N'Mba_Reviews',N'MbaClosedAt',N'Mba_ClosedAt'),(N'Mba_Reviews',N'MbaIsLocked',N'Mba_IsLocked'),(N'Mba_Reviews',N'MbaIsOverdue',N'Mba_IsOverdue'),
(N'Mba_Categories',N'Id',N'Mba_Id'),(N'Mba_Categories',N'Code',N'Mba_Code'),(N'Mba_Categories',N'Name',N'Mba_Name'),(N'Mba_Categories',N'Description',N'Mba_Description'),(N'Mba_Categories',N'IsActive',N'Mba_IsActive'),
(N'Mba_Products',N'Id',N'Mba_Id'),(N'Mba_Products',N'CategoryId',N'Mba_CategoryId'),(N'Mba_Products',N'Code',N'Mba_Code'),(N'Mba_Products',N'Name',N'Mba_Name'),(N'Mba_Products',N'Category',N'Mba_Category'),(N'Mba_Products',N'Brand',N'Mba_Brand'),(N'Mba_Products',N'Description',N'Mba_Description'),(N'Mba_Products',N'ImageUrl',N'Mba_ImageUrl'),(N'Mba_Products',N'Price',N'Mba_Price'),(N'Mba_Products',N'Quantity',N'Mba_Quantity'),(N'Mba_Products',N'TechnicalInfo',N'Mba_TechnicalInfo'),(N'Mba_Products',N'DataStatus',N'Mba_DataStatus'),
(N'Mba_Accounts',N'Id',N'Mba_Id'),(N'Mba_Accounts',N'Username',N'Mba_Username'),(N'Mba_Accounts',N'PasswordHash',N'Mba_PasswordHash'),(N'Mba_Accounts',N'Role',N'Mba_Role'),(N'Mba_Accounts',N'IsActive',N'Mba_IsActive'),(N'Mba_Accounts',N'CreatedAt',N'Mba_CreatedAt'),
(N'Mba_Admins',N'Id',N'Mba_Id'),(N'Mba_Admins',N'AccountId',N'Mba_AccountId'),(N'Mba_Admins',N'FullName',N'Mba_FullName'),(N'Mba_Admins',N'Email',N'Mba_Email'),(N'Mba_Admins',N'Phone',N'Mba_Phone'),(N'Mba_Admins',N'AvatarUrl',N'Mba_AvatarUrl'),
(N'Mba_Employees',N'Id',N'Mba_Id'),(N'Mba_Employees',N'AccountId',N'Mba_AccountId'),(N'Mba_Employees',N'FullName',N'Mba_FullName'),(N'Mba_Employees',N'Email',N'Mba_Email'),(N'Mba_Employees',N'Phone',N'Mba_Phone'),(N'Mba_Employees',N'AvatarUrl',N'Mba_AvatarUrl'),(N'Mba_Employees',N'IsActive',N'Mba_IsActive'),
(N'Mba_Reviews',N'Id',N'Mba_Id'),(N'Mba_Reviews',N'ProductId',N'Mba_ProductId'),(N'Mba_Reviews',N'Status',N'Mba_Status'),(N'Mba_Reviews',N'CheckedItems',N'Mba_CheckedItems'),(N'Mba_Reviews',N'TotalItems',N'Mba_TotalItems'),(N'Mba_Reviews',N'SourceNote',N'Mba_SourceNote'),(N'Mba_Reviews',N'ReviewNote',N'Mba_ReviewNote'),(N'Mba_Reviews',N'EmployeeId',N'Mba_EmployeeId'),(N'Mba_Reviews',N'AssignedAt',N'Mba_AssignedAt'),(N'Mba_Reviews',N'Deadline',N'Mba_Deadline'),(N'Mba_Reviews',N'ClosedAt',N'Mba_ClosedAt'),(N'Mba_Reviews',N'IsLocked',N'Mba_IsLocked'),(N'Mba_Reviews',N'IsOverdue',N'Mba_IsOverdue');
DECLARE @T sysname,@O sysname,@N sysname,@S nvarchar(4000);
DECLARE C CURSOR LOCAL FAST_FORWARD FOR SELECT TableName,OldName,NewName FROM @RenameColumns;
OPEN C; FETCH NEXT FROM C INTO @T,@O,@N;
WHILE @@FETCH_STATUS=0
BEGIN
    IF OBJECT_ID(N'dbo.'+@T,N'U') IS NOT NULL AND COL_LENGTH(N'dbo.'+@T,@O) IS NOT NULL AND COL_LENGTH(N'dbo.'+@T,@N) IS NULL
    BEGIN
        SET @S=N'EXEC sp_rename N''dbo.'+@T+N'.'+@O+N''', N'''+@N+N''', N''COLUMN'';';
        EXEC sp_executesql @S;
    END
    FETCH NEXT FROM C INTO @T,@O,@N;
END
CLOSE C; DEALLOCATE C;
GO

IF OBJECT_ID(N'dbo.Mba_Categories', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Mba_Categories
    (
        Mba_Id INT IDENTITY(1,1) NOT NULL CONSTRAINT Mba_PK_Categories PRIMARY KEY,
        Mba_Code NVARCHAR(50) NOT NULL CONSTRAINT Mba_UQ_Categories_Code UNIQUE,
        Mba_Name NVARCHAR(100) NOT NULL,
        Mba_Description NVARCHAR(500) NULL,
        Mba_IsActive BIT NOT NULL CONSTRAINT Mba_DF_Categories_IsActive DEFAULT (1)
    );
END
GO

IF OBJECT_ID(N'dbo.Mba_Products', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Mba_Products
    (
        Mba_Id INT IDENTITY(1,1) NOT NULL CONSTRAINT Mba_PK_Products PRIMARY KEY,
        Mba_CategoryId INT NULL,
        Mba_Code NVARCHAR(50) NOT NULL CONSTRAINT Mba_UQ_Products_Code UNIQUE,
        Mba_Name NVARCHAR(200) NULL,
        Mba_Category NVARCHAR(100) NULL,
        Mba_Brand NVARCHAR(100) NULL,
        Mba_Description NVARCHAR(1000) NULL,
        Mba_ImageUrl NVARCHAR(500) NULL,
        Mba_Price DECIMAL(18,2) NOT NULL CONSTRAINT Mba_DF_Products_Price DEFAULT (0),
        Mba_Quantity INT NOT NULL CONSTRAINT Mba_DF_Products_Quantity DEFAULT (0),
        Mba_TechnicalInfo NVARCHAR(2000) NULL,
        Mba_DataStatus NVARCHAR(50) NULL
    );
END
GO

IF COL_LENGTH(N'dbo.Mba_Products', N'Mba_CategoryId') IS NULL
BEGIN
    ALTER TABLE dbo.Mba_Products ADD Mba_CategoryId INT NULL;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'Mba_FK_Products_Categories')
BEGIN
    ALTER TABLE dbo.Mba_Products ADD CONSTRAINT Mba_FK_Products_Categories FOREIGN KEY (Mba_CategoryId) REFERENCES dbo.Mba_Categories(Mba_Id) ON DELETE SET NULL;
END
GO

IF OBJECT_ID(N'dbo.Mba_Accounts', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Mba_Accounts
    (
        Mba_Id INT IDENTITY(1,1) NOT NULL CONSTRAINT Mba_PK_Accounts PRIMARY KEY,
        Mba_Username NVARCHAR(100) NOT NULL CONSTRAINT Mba_UQ_Accounts_Username UNIQUE,
        Mba_PasswordHash NVARCHAR(500) NOT NULL,
        Mba_Role NVARCHAR(30) NOT NULL,
        Mba_IsActive BIT NOT NULL CONSTRAINT Mba_DF_Accounts_IsActive DEFAULT (1),
        Mba_CreatedAt DATETIME2 NOT NULL CONSTRAINT Mba_DF_Accounts_CreatedAt DEFAULT (SYSDATETIME())
    );
END
GO

IF OBJECT_ID(N'dbo.Mba_Admins', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Mba_Admins
    (
        Mba_Id INT IDENTITY(1,1) NOT NULL CONSTRAINT Mba_PK_Admins PRIMARY KEY,
        Mba_AccountId INT NOT NULL CONSTRAINT Mba_UQ_Admins_AccountId UNIQUE,
        Mba_FullName NVARCHAR(150) NOT NULL,
        Mba_Email NVARCHAR(150) NULL,
        Mba_Phone NVARCHAR(30) NULL,
        Mba_AvatarUrl NVARCHAR(500) NULL,
        CONSTRAINT Mba_FK_Admins_Accounts FOREIGN KEY (Mba_AccountId) REFERENCES dbo.Mba_Accounts(Mba_Id) ON DELETE CASCADE
    );
END
GO

IF OBJECT_ID(N'dbo.Mba_Employees', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Mba_Employees
    (
        Mba_Id INT IDENTITY(1,1) NOT NULL CONSTRAINT Mba_PK_Employees PRIMARY KEY,
        Mba_AccountId INT NOT NULL CONSTRAINT Mba_UQ_Employees_AccountId UNIQUE,
        Mba_FullName NVARCHAR(150) NOT NULL,
        Mba_Email NVARCHAR(150) NULL,
        Mba_Phone NVARCHAR(30) NULL,
        Mba_AvatarUrl NVARCHAR(500) NULL,
        Mba_IsActive BIT NOT NULL CONSTRAINT Mba_DF_Employees_IsActive DEFAULT (1),
        CONSTRAINT Mba_FK_Employees_Accounts FOREIGN KEY (Mba_AccountId) REFERENCES dbo.Mba_Accounts(Mba_Id) ON DELETE CASCADE
    );
END
GO

IF OBJECT_ID(N'dbo.Mba_Reviews', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Mba_Reviews
    (
        Mba_Id INT IDENTITY(1,1) NOT NULL CONSTRAINT Mba_PK_Reviews PRIMARY KEY,
        Mba_ProductId INT NOT NULL,
        Mba_Status NVARCHAR(50) NOT NULL CONSTRAINT Mba_DF_Reviews_Status DEFAULT (N'Chờ rà soát'),
        Mba_CheckedItems INT NOT NULL CONSTRAINT Mba_DF_Reviews_CheckedItems DEFAULT (0),
        Mba_TotalItems INT NOT NULL CONSTRAINT Mba_DF_Reviews_TotalItems DEFAULT (5),
        Mba_SourceNote NVARCHAR(500) NOT NULL CONSTRAINT Mba_DF_Reviews_SourceNote DEFAULT (N'Phiếu giấy do quản lý bàn giao'),
        Mba_ReviewNote NVARCHAR(1000) NOT NULL CONSTRAINT Mba_DF_Reviews_ReviewNote DEFAULT (N''),
        Mba_EmployeeId INT NULL,
        Mba_AssignedAt DATETIME2 NULL,
        Mba_Deadline DATETIME2 NULL,
        Mba_ClosedAt DATETIME2 NULL,
        Mba_IsLocked BIT NOT NULL CONSTRAINT Mba_DF_Reviews_IsLocked DEFAULT (0),
        Mba_IsOverdue BIT NOT NULL CONSTRAINT Mba_DF_Reviews_IsOverdue DEFAULT (0),
        CONSTRAINT Mba_UQ_Reviews_Product UNIQUE (Mba_ProductId),
        CONSTRAINT Mba_FK_Reviews_Products FOREIGN KEY (Mba_ProductId) REFERENCES dbo.Mba_Products(Mba_Id) ON DELETE CASCADE
    );
END
GO

IF COL_LENGTH('dbo.Mba_Reviews', 'Mba_AssignedAt') IS NULL ALTER TABLE dbo.Mba_Reviews ADD Mba_AssignedAt DATETIME2 NULL;
IF COL_LENGTH('dbo.Mba_Reviews', 'Mba_Deadline') IS NULL ALTER TABLE dbo.Mba_Reviews ADD Mba_Deadline DATETIME2 NULL;
IF COL_LENGTH('dbo.Mba_Reviews', 'Mba_ClosedAt') IS NULL ALTER TABLE dbo.Mba_Reviews ADD Mba_ClosedAt DATETIME2 NULL;
IF COL_LENGTH('dbo.Mba_Reviews', 'Mba_IsLocked') IS NULL ALTER TABLE dbo.Mba_Reviews ADD Mba_IsLocked BIT NOT NULL CONSTRAINT Mba_DF_Reviews_IsLocked DEFAULT (0);
IF COL_LENGTH('dbo.Mba_Reviews', 'Mba_IsOverdue') IS NULL ALTER TABLE dbo.Mba_Reviews ADD Mba_IsOverdue BIT NOT NULL CONSTRAINT Mba_DF_Reviews_IsOverdue DEFAULT (0);

/* Seed categories */
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories)
BEGIN
    SET IDENTITY_INSERT dbo.Mba_Categories ON;
    INSERT INTO dbo.Mba_Categories (Mba_Id, Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES
    (1, N'DM001', N'Máy tính bộ', N'PC Gaming, PC văn phòng', 1),
    (2, N'DM002', N'Laptop', N'Laptop học tập, làm việc', 1),
    (3, N'DM003', N'CPU', N'Bộ vi xử lý máy tính', 1),
    (4, N'DM004', N'RAM', N'Bộ nhớ trong', 1),
    (5, N'DM005', N'Card đồ họa', N'GPU NVIDIA, AMD', 1),
    (6, N'DM006', N'Ổ cứng', N'SSD, HDD, NVMe', 1),
    (7, N'DM007', N'Mainboard', N'Bo mạch chủ máy tính', 1),
    (8, N'DM008', N'Phụ kiện', N'Bàn phím, chuột, tai nghe', 1);
    SET IDENTITY_INSERT dbo.Mba_Categories OFF;
END
GO

/* Seed products */
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products)
BEGIN
    SET IDENTITY_INSERT dbo.Mba_Products ON;
    INSERT INTO dbo.Mba_Products (Mba_Id, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus) VALUES
    (1, N'PC001', N'PC Gaming MBA 01', N'Máy tính bộ', N'MBA', N'PC Gaming phục vụ học tập, lập trình và giải trí.', NULL, 25000000, 12, N'i5-14400F / 16GB DDR5 / SSD NVMe 1TB / RTX 4060 8GB', N'Cần rà soát'),
    (2, N'CPU001', N'Intel Core i5-14400F', N'CPU', N'Intel', N'Bộ vi xử lý desktop.', NULL, 0, 30, N'10 nhân / 16 luồng / LGA1700', N'Đang kiểm tra'),
    (3, N'VGA001', N'NVIDIA RTX 4060', N'Card đồ họa', N'NVIDIA', N'Card đồ họa cho gaming và đồ họa.', NULL, 8490000, 8, N'8GB GDDR6', N'Đã chuẩn hóa'),
    (4, N'RAM001', N'Kingston Fury 16GB', N'RAM', N'Kingston', N'Bộ nhớ RAM.', NULL, 1290000, 20, N'DDR5 / 5200MHz / 16GB', N'Cần báo lại'),
    (5, N'SSD001', N'Samsung 980 1TB', N'Ổ cứng', N'Samsung', N'SSD NVMe.', NULL, 2190000, 14, N'NVMe / 1TB', N'Đang kiểm tra');
    SET IDENTITY_INSERT dbo.Mba_Products OFF;
END
GO

/* Seed tài khoản quản trị thật và hồ sơ quản trị */
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'Maibinhan')
BEGIN
    IF EXISTS (SELECT 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'admin' AND Mba_Role = N'Admin')
    BEGIN
        UPDATE dbo.Mba_Accounts
        SET Mba_Username = N'Maibinhan'
        WHERE Mba_Username = N'admin' AND Mba_Role = N'Admin';
    END
    ELSE
    BEGIN
        INSERT INTO dbo.Mba_Accounts (Mba_Username, Mba_PasswordHash, Mba_Role, Mba_IsActive)
        VALUES (N'Maibinhan', N'PBKDF2$100000$pQ81Q0fEuy49LBCX8/iDTg==$adxH/JsUnBGaoefBvJRjGNqO3nnTxQvTrW+i+NwiFTM=', N'Admin', 1);
    END
END
GO

UPDATE dbo.Mba_Accounts
SET Mba_PasswordHash = N'PBKDF2$100000$pQ81Q0fEuy49LBCX8/iDTg==$adxH/JsUnBGaoefBvJRjGNqO3nnTxQvTrW+i+NwiFTM=',
    Mba_Role = N'Admin',
    Mba_IsActive = 1
WHERE Mba_Username = N'Maibinhan';
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Admins WHERE Mba_AccountId = (SELECT Mba_Id FROM dbo.Mba_Accounts WHERE Mba_Username = N'Maibinhan'))
BEGIN
    INSERT INTO dbo.Mba_Admins (Mba_AccountId, Mba_FullName, Mba_Email, Mba_Phone)
    SELECT Mba_Id, N'Mai Binh An', N'Mastershining000@gmail.com', N'+84 394772786'
    FROM dbo.Mba_Accounts WHERE Mba_Username = N'Maibinhan';
END
ELSE
BEGIN
    UPDATE dbo.Mba_Admins
    SET Mba_FullName = N'Mai Binh An',
        Mba_Email = N'Mastershining000@gmail.com',
        Mba_Phone = N'+84 394772786'
    WHERE Mba_AccountId = (SELECT Mba_Id FROM dbo.Mba_Accounts WHERE Mba_Username = N'Maibinhan');
END
GO

/* Tài khoản nhân viên mẫu: dùng tên thật, không dùng username chung chung "employee" */
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'nguyenminhanh')
BEGIN
    INSERT INTO dbo.Mba_Accounts (Mba_Username, Mba_PasswordHash, Mba_Role, Mba_IsActive)
    VALUES (N'nguyenminhanh', N'PBKDF2$100000$jypMbZ4RM1V3qiLMRN2ImQ==$T8taluTz6p3FrV2HpwivZ27xzD4tNPd/hGEB8ZaIF7c=', N'Employee', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Employees WHERE Mba_AccountId = (SELECT Mba_Id FROM dbo.Mba_Accounts WHERE Mba_Username = N'nguyenminhanh'))
BEGIN
    INSERT INTO dbo.Mba_Employees (Mba_AccountId, Mba_FullName, Mba_Email, Mba_Phone, Mba_IsActive)
    SELECT Mba_Id, N'Nguyễn Minh Anh', N'nguyenminhanh@mba-pc.local', N'0901000001', 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'nguyenminhanh';
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'tranquochuy')
BEGIN
    INSERT INTO dbo.Mba_Accounts (Mba_Username, Mba_PasswordHash, Mba_Role, Mba_IsActive)
    VALUES (N'tranquochuy', N'PBKDF2$100000$jypMbZ4RM1V3qiLMRN2ImQ==$T8taluTz6p3FrV2HpwivZ27xzD4tNPd/hGEB8ZaIF7c=', N'Employee', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Employees WHERE Mba_AccountId = (SELECT Mba_Id FROM dbo.Mba_Accounts WHERE Mba_Username = N'tranquochuy'))
BEGIN
    INSERT INTO dbo.Mba_Employees (Mba_AccountId, Mba_FullName, Mba_Email, Mba_Phone, Mba_IsActive)
    SELECT Mba_Id, N'Trần Quốc Huy', N'tranquochuy@mba-pc.local', N'0901000002', 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'tranquochuy';
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'lehoangnam')
BEGIN
    INSERT INTO dbo.Mba_Accounts (Mba_Username, Mba_PasswordHash, Mba_Role, Mba_IsActive)
    VALUES (N'lehoangnam', N'PBKDF2$100000$jypMbZ4RM1V3qiLMRN2ImQ==$T8taluTz6p3FrV2HpwivZ27xzD4tNPd/hGEB8ZaIF7c=', N'Employee', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Employees WHERE Mba_AccountId = (SELECT Mba_Id FROM dbo.Mba_Accounts WHERE Mba_Username = N'lehoangnam'))
BEGIN
    INSERT INTO dbo.Mba_Employees (Mba_AccountId, Mba_FullName, Mba_Email, Mba_Phone, Mba_IsActive)
    SELECT Mba_Id, N'Lê Hoàng Nam', N'lehoangnam@mba-pc.local', N'0901000003', 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'lehoangnam';
END
GO

IF COL_LENGTH(N'dbo.Mba_Reviews', N'Mba_EmployeeId') IS NULL
BEGIN
    ALTER TABLE dbo.Mba_Reviews ADD Mba_EmployeeId INT NULL;
END
GO

/* Tương thích với database cũ từng dùng AssignedTo.
   Dùng dynamic SQL để SQL Server không kiểm tra cột AssignedTo ở thời điểm compile
   khi database mới đã không còn cột này. */
IF COL_LENGTH(N'dbo.Mba_Reviews', N'AssignedTo') IS NOT NULL
BEGIN
    EXEC sys.sp_executesql N'
        UPDATE r
        SET r.Mba_EmployeeId = e.Mba_Id
        FROM dbo.Mba_Reviews AS r
        INNER JOIN dbo.Mba_Accounts AS a ON a.Mba_Username = r.AssignedTo
        INNER JOIN dbo.Mba_Employees AS e ON e.Mba_AccountId = a.Mba_Id
        WHERE r.Mba_EmployeeId IS NULL AND r.AssignedTo IS NOT NULL;';

    EXEC sys.sp_executesql N'ALTER TABLE dbo.Mba_Reviews DROP COLUMN AssignedTo;';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_Reviews_Employees')
BEGIN
    ALTER TABLE dbo.Mba_Reviews ADD CONSTRAINT FK_Reviews_Employees FOREIGN KEY (Mba_EmployeeId) REFERENCES dbo.Mba_Employees(Mba_Id) ON DELETE SET NULL;
END
GO

/* Đồng bộ Mba_CategoryId theo tên danh mục */
UPDATE p
SET p.Mba_CategoryId = c.Mba_Id
FROM dbo.Mba_Products p
INNER JOIN dbo.Mba_Categories c ON c.Mba_Name = p.Mba_Category
WHERE p.Mba_CategoryId IS NULL;
GO

/* Seed review workflow */
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Reviews)
BEGIN
    SET IDENTITY_INSERT dbo.Mba_Reviews ON;
    INSERT INTO dbo.Mba_Reviews (Mba_Id, Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId) VALUES
    (1, 1, N'Chờ rà soát', 1, 5, N'Phiếu giấy do quản lý bàn giao', N'', NULL),
    (2, 2, N'Đang xử lý', 3, 5, N'Phiếu giấy do quản lý bàn giao', N'', 1),
    (3, 3, N'Đã hoàn tất', 5, 5, N'Phiếu giấy do quản lý bàn giao', N'', 1),
    (4, 4, N'Cần báo lại', 2, 5, N'Phiếu giấy do quản lý bàn giao', N'Cần đối chiếu lại thông tin trên phiếu giấy.', NULL),
    (5, 5, N'Chờ rà soát', 0, 5, N'Phiếu giấy do quản lý bàn giao', N'', NULL);
    SET IDENTITY_INSERT dbo.Mba_Reviews OFF;
END
GO

SELECT 'Mba_Categories' AS TableName, COUNT(*) AS TotalRows FROM dbo.Mba_Categories
UNION ALL
SELECT 'Mba_Products', COUNT(*) FROM dbo.Mba_Products
UNION ALL
SELECT 'Mba_Reviews', COUNT(*) FROM dbo.Mba_Reviews
UNION ALL
SELECT 'Mba_Accounts', COUNT(*) FROM dbo.Mba_Accounts
UNION ALL
SELECT 'Mba_Admins', COUNT(*) FROM dbo.Mba_Admins
UNION ALL
SELECT 'Mba_Employees', COUNT(*) FROM dbo.Mba_Employees;
GO


/* ========================================================
   BỔ SUNG BỘ DỮ LIỆU MẪU 17/340/340
   ======================================================== */
/*
 MBA-PC ProductManagement
 BỔ SUNG DỮ LIỆU MẪU MỞ RỘNG
 17 danh mục / 340 sản phẩm / 340 phiếu rà soát / 10 nhân viên
 Chạy script này SAU khi đã tạo database MBA_PC_ProductManagement.
*/
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM001')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive)
    VALUES (N'DM001', N'Máy tính bộ', N'PC Gaming, PC văn phòng và workstation', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM002')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive)
    VALUES (N'DM002', N'Laptop', N'Laptop học tập, làm việc, gaming và đồ họa', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM003')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive)
    VALUES (N'DM003', N'CPU', N'Bộ vi xử lý Intel và AMD', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM004')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive)
    VALUES (N'DM004', N'RAM', N'Bộ nhớ RAM DDR4 và DDR5', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM005')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive)
    VALUES (N'DM005', N'Card đồ họa', N'GPU NVIDIA và AMD', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM006')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive)
    VALUES (N'DM006', N'SSD', N'SSD SATA và SSD NVMe', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM007')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive)
    VALUES (N'DM007', N'HDD', N'Ổ cứng HDD lưu trữ dữ liệu', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM008')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive)
    VALUES (N'DM008', N'Mainboard', N'Bo mạch chủ Intel và AMD', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM009')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive)
    VALUES (N'DM009', N'Bộ nguồn (PSU)', N'Nguồn máy tính theo công suất và chuẩn 80 Plus', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM010')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive)
    VALUES (N'DM010', N'Vỏ máy (Case)', N'Vỏ PC Mini Tower, Mid Tower và Full Tower', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM011')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive)
    VALUES (N'DM011', N'Tản nhiệt', N'Tản nhiệt khí và tản nhiệt nước AIO', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM012')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive)
    VALUES (N'DM012', N'Màn hình (Monitor)', N'Màn hình văn phòng, gaming và đồ họa', 1);
END
GO

-- Mba_Products
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC001')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'PC001', N'PC Gaming MBA 01', N'Máy tính bộ', N'MBA', N'PC Gaming phục vụ học tập, lập trình và giải trí.', NULL, 25000000, 12, N'Intel Core i5-14400F / 16GB DDR5 / SSD NVMe 1TB / RTX 4060 8GB', N'Chờ rà soát');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC002')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'PC002', N'PC Gaming MBA 02', N'Máy tính bộ', N'MBA', N'PC Gaming hiệu năng cao.', NULL, 32900000, 7, N'Intel Core i7-14700F / 32GB DDR5 / SSD NVMe 1TB / RTX 4070 SUPER 12GB', N'Chờ rà soát');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC003')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'PC003', N'PC Office MBA 01', N'Máy tính bộ', N'MBA', N'PC văn phòng và học tập.', NULL, 12900000, 15, N'Intel Core i5-12400 / 16GB DDR4 / SSD NVMe 512GB / UHD Graphics', N'Chờ rà soát');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC004')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'PC004', N'PC Workstation MBA 01', N'Máy tính bộ', N'MBA', N'Máy trạm cho lập trình và thiết kế.', NULL, 41900000, 4, N'Ryzen 9 7900 / 64GB DDR5 / SSD NVMe 2TB / RTX 4070 12GB', N'Chờ rà soát');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP001')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'LAP001', N'ASUS Vivobook 15', N'Laptop', N'ASUS', N'Laptop học tập và văn phòng.', NULL, 16990000, 8, N'Core i5-13420H / 16GB / SSD 512GB / 15.6 FHD', N'Chờ rà soát');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP002')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'LAP002', N'Lenovo LOQ 15', N'Laptop', N'Lenovo', N'Laptop gaming tầm trung.', NULL, 24990000, 6, N'Core i5-13450HX / 16GB DDR5 / SSD 512GB / RTX 4050', N'Chờ rà soát');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP003')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'LAP003', N'Acer Nitro V 15', N'Laptop', N'Acer', N'Laptop gaming phổ thông.', NULL, 21990000, 5, N'Core i5-13420H / 16GB / SSD 512GB / RTX 4050', N'Chờ rà soát');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU001')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'CPU001', N'Intel Core i5-14400F', N'CPU', N'Intel', N'Bộ vi xử lý desktop.', NULL, 3990000, 30, N'10 nhân / 16 luồng / LGA1700 / Turbo 4.7GHz', N'Chờ rà soát');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU002')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'CPU002', N'Intel Core i7-14700K', N'CPU', N'Intel', N'CPU hiệu năng cao cho gaming và workstation.', NULL, 10990000, 12, N'20 nhân / 28 luồng / LGA1700 / Turbo 5.6GHz', N'Chờ rà soát');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU003')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'CPU003', N'AMD Ryzen 5 7600', N'CPU', N'AMD', N'CPU gaming socket AM5.', NULL, 4990000, 18, N'6 nhân / 12 luồng / AM5 / Boost 5.1GHz', N'Chờ rà soát');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU004')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'CPU004', N'AMD Ryzen 7 7800X3D', N'CPU', N'AMD', N'CPU gaming 3D V-Cache.', NULL, 10990000, 10, N'8 nhân / 16 luồng / AM5 / 3D V-Cache', N'Đang xử lý');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU005')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'CPU005', N'Intel Core i3-14100', N'CPU', N'Intel', N'CPU phổ thông cho văn phòng.', NULL, 3290000, 14, N'4 nhân / 8 luồng / LGA1700 / Turbo 4.7GHz', N'Đang xử lý');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM001')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'RAM001', N'Kingston Fury Beast 16GB', N'RAM', N'Kingston', N'Bộ nhớ DDR5 phổ biến.', NULL, 1290000, 20, N'DDR5 / 5200MHz / 16GB / CL40', N'Đang xử lý');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM002')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'RAM002', N'Corsair Vengeance 32GB', N'RAM', N'Corsair', N'Bộ nhớ DDR5 hiệu năng cao.', NULL, 2590000, 16, N'DDR5 / 6000MHz / 32GB (2x16GB) / CL36', N'Đang xử lý');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM003')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'RAM003', N'G.Skill Ripjaws V 16GB', N'RAM', N'G.Skill', N'Bộ nhớ DDR4 cho PC.', NULL, 1090000, 22, N'DDR4 / 3200MHz / 16GB (2x8GB) / CL16', N'Đang xử lý');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM004')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'RAM004', N'Kingston Fury Beast 64GB', N'RAM', N'Kingston', N'Bộ nhớ dung lượng lớn.', NULL, 4890000, 8, N'DDR5 / 5600MHz / 64GB (2x32GB) / CL36', N'Đang xử lý');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA001')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'VGA001', N'NVIDIA RTX 4060', N'Card đồ họa', N'NVIDIA', N'GPU gaming phổ thông.', NULL, 8490000, 8, N'8GB GDDR6 / 128-bit / Boost 2460MHz', N'Đang xử lý');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA002')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'VGA002', N'NVIDIA RTX 4070 SUPER', N'Card đồ họa', N'NVIDIA', N'GPU gaming 1440p hiệu năng cao.', NULL, 16990000, 5, N'12GB GDDR6X / 192-bit / Boost 2475MHz', N'Đang xử lý');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA003')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'VGA003', N'AMD Radeon RX 7800 XT', N'Card đồ họa', N'AMD', N'GPU gaming 1440p.', NULL, 13990000, 6, N'16GB GDDR6 / 256-bit / Boost 2430MHz', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA004')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'VGA004', N'NVIDIA RTX 4060 Ti 16GB', N'Card đồ họa', N'NVIDIA', N'GPU gaming và đồ họa.', NULL, 11990000, 7, N'16GB GDDR6 / 128-bit / Ada Lovelace', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD001')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'SSD001', N'Samsung 980 1TB', N'SSD', N'Samsung', N'SSD NVMe PCIe.', NULL, 2190000, 14, N'NVMe PCIe 3.0 / 1TB / đọc 3500MB/s', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD002')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'SSD002', N'Samsung 990 EVO 1TB', N'SSD', N'Samsung', N'SSD NVMe tốc độ cao.', NULL, 2690000, 11, N'NVMe PCIe 4.0 / 1TB / đọc tới 5000MB/s', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD003')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'SSD003', N'WD Black SN850X 2TB', N'SSD', N'Western Digital', N'SSD gaming dung lượng cao.', NULL, 4490000, 7, N'NVMe PCIe 4.0 / 2TB / đọc tới 7300MB/s', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD004')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'SSD004', N'Kingston NV2 500GB', N'SSD', N'Kingston', N'SSD NVMe phổ thông.', NULL, 990000, 19, N'NVMe PCIe 4.0 / 500GB', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD001')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'HDD001', N'WD Blue 1TB', N'HDD', N'Western Digital', N'Ổ cứng lưu trữ phổ thông.', NULL, 1390000, 20, N'3.5 inch / SATA / 1TB / 7200RPM', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD002')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'HDD002', N'Seagate Barracuda 2TB', N'HDD', N'Seagate', N'Ổ cứng lưu trữ dung lượng cao.', NULL, 1790000, 13, N'3.5 inch / SATA / 2TB / 7200RPM', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD003')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'HDD003', N'WD Purple 4TB', N'HDD', N'Western Digital', N'Ổ cứng tối ưu cho lưu trữ camera.', NULL, 3490000, 9, N'3.5 inch / SATA / 4TB / 5400RPM', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB001')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'MB001', N'ASUS PRIME B760M-A', N'Mainboard', N'ASUS', N'Mainboard Intel DDR5.', NULL, 3690000, 9, N'LGA1700 / B760 / DDR5 / Micro-ATX', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB002')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'MB002', N'MSI PRO B650M-A WIFI', N'Mainboard', N'MSI', N'Mainboard AMD AM5.', NULL, 3890000, 8, N'AM5 / B650 / DDR5 / Wi-Fi / Micro-ATX', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB003')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'MB003', N'Gigabyte B760 AORUS ELITE AX', N'Mainboard', N'Gigabyte', N'Mainboard gaming Intel.', NULL, 4990000, 6, N'LGA1700 / B760 / DDR5 / Wi-Fi / ATX', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB004')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'MB004', N'ASRock B650M Pro RS', N'Mainboard', N'ASRock', N'Mainboard AMD AM5.', NULL, 3290000, 10, N'AM5 / B650 / DDR5 / Micro-ATX', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU001')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'PSU001', N'Corsair RM750e', N'Bộ nguồn (PSU)', N'Corsair', N'Nguồn modular chuẩn ATX 3.0.', NULL, 2990000, 12, N'750W / 80 Plus Gold / Fully Modular / ATX 3.0', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU002')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'PSU002', N'Cooler Master MWE 650 Bronze V2', N'Bộ nguồn (PSU)', N'Cooler Master', N'Nguồn phổ thông cho gaming.', NULL, 1690000, 15, N'650W / 80 Plus Bronze / ATX', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU003')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'PSU003', N'Seasonic Focus GX-850', N'Bộ nguồn (PSU)', N'Seasonic', N'Nguồn công suất cao.', NULL, 3590000, 7, N'850W / 80 Plus Gold / Fully Modular', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE001')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'CASE001', N'Montech Air 100 ARGB', N'Vỏ máy (Case)', N'Montech', N'Case Micro-ATX thông thoáng.', NULL, 1590000, 10, N'Micro-ATX / Tempered Glass / hỗ trợ radiator 240mm', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE002')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'CASE002', N'NZXT H5 Flow', N'Vỏ máy (Case)', N'NZXT', N'Case Mid Tower tối ưu airflow.', NULL, 2390000, 7, N'ATX / Mid Tower / GPU tối đa 365mm', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE003')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'CASE003', N'Lian Li Lancool 216', N'Vỏ máy (Case)', N'Lian Li', N'Case gaming airflow cao.', NULL, 2990000, 5, N'ATX / Mid Tower / quạt 160mm / GPU tối đa 392mm', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL001')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'COOL001', N'DeepCool AK400', N'Tản nhiệt', N'DeepCool', N'Tản nhiệt khí tháp đơn.', NULL, 890000, 16, N'Air Cooler / 120mm / hỗ trợ TDP 220W', N'Đã hoàn tất');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL002')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'COOL002', N'Thermalright Peerless Assassin 120 SE', N'Tản nhiệt', N'Thermalright', N'Tản nhiệt khí hai tháp.', NULL, 1190000, 12, N'Dual Tower / 2x120mm / hỗ trợ AM5, LGA1700', N'Cần báo lại');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL003')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'COOL003', N'Cooler Master ML240L V2', N'Tản nhiệt', N'Cooler Master', N'Tản nhiệt nước AIO.', NULL, 1890000, 8, N'AIO 240mm / ARGB / AM5 / LGA1700', N'Cần báo lại');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON001')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'MON001', N'LG UltraGear 24GN60R', N'Màn hình (Monitor)', N'LG', N'Màn hình gaming 24 inch.', NULL, 4290000, 9, N'24 inch / FHD / IPS / 144Hz / 1ms', N'Cần báo lại');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON002')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'MON002', N'ASUS TUF Gaming VG27AQ3A', N'Màn hình (Monitor)', N'ASUS', N'Màn hình gaming 2K.', NULL, 7490000, 6, N'27 inch / QHD / Fast IPS / 180Hz / 1ms', N'Cần báo lại');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON003')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'MON003', N'AOC Q27G2S', N'Màn hình (Monitor)', N'AOC', N'Màn hình gaming 2K.', NULL, 5990000, 8, N'27 inch / QHD / IPS / 165Hz / Adaptive Sync', N'Cần báo lại');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON004')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'MON004', N'Dell UltraSharp U2723QE', N'Màn hình (Monitor)', N'Dell', N'Màn hình phục vụ đồ họa và văn phòng.', NULL, 13990000, 4, N'27 inch / 4K / IPS Black / USB-C / 60Hz', N'Cần báo lại');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON005')
BEGIN
    INSERT INTO dbo.Mba_Products
        (Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    VALUES
        (N'MON005', N'Samsung Odyssey G5 32', N'Màn hình (Monitor)', N'Samsung', N'Màn hình gaming cong 32 inch.', NULL, 8990000, 5, N'32 inch / QHD / VA / 165Hz / 1ms / FreeSync', N'Cần báo lại');
END
GO

-- Mba_Reviews / workflow
IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'PC001'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Chờ rà soát', 0, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'PC001';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'PC002'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Chờ rà soát', 0, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'PC002';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'PC003'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Chờ rà soát', 0, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'PC003';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'PC004'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Chờ rà soát', 0, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'PC004';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'LAP001'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Chờ rà soát', 0, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'LAP001';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'LAP002'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Chờ rà soát', 0, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'LAP002';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'LAP003'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Chờ rà soát', 0, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'LAP003';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'CPU001'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Chờ rà soát', 0, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'CPU001';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'CPU002'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Chờ rà soát', 0, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'CPU002';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'CPU003'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Chờ rà soát', 0, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'CPU003';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'CPU004'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đang xử lý', 3, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'CPU004';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'CPU005'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đang xử lý', 3, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'CPU005';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'RAM001'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đang xử lý', 3, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'RAM001';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'RAM002'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đang xử lý', 3, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'RAM002';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'RAM003'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đang xử lý', 3, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'RAM003';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'RAM004'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đang xử lý', 3, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'RAM004';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'VGA001'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đang xử lý', 3, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'VGA001';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'VGA002'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đang xử lý', 3, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'VGA002';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'VGA003'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'VGA003';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'VGA004'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'VGA004';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'SSD001'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'SSD001';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'SSD002'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'SSD002';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'SSD003'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'SSD003';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'SSD004'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'SSD004';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'HDD001'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'HDD001';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'HDD002'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'HDD002';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'HDD003'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'HDD003';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'MB001'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'MB001';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'MB002'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'MB002';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'MB003'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'MB003';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'MB004'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'MB004';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'PSU001'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'PSU001';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'PSU002'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'PSU002';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'PSU003'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'PSU003';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'CASE001'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'CASE001';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'CASE002'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'CASE002';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'CASE003'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'CASE003';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'COOL001'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Đã hoàn tất', 5, 5,
        N'Phiếu giấy do quản lý bàn giao', N'', 1
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'COOL001';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'COOL002'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Cần báo lại', 2, 5,
        N'Phiếu giấy do quản lý bàn giao', N'Cần đối chiếu lại thông tin trên phiếu giấy.', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'COOL002';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'COOL003'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Cần báo lại', 2, 5,
        N'Phiếu giấy do quản lý bàn giao', N'Cần đối chiếu lại thông tin trên phiếu giấy.', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'COOL003';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'MON001'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Cần báo lại', 2, 5,
        N'Phiếu giấy do quản lý bàn giao', N'Cần đối chiếu lại thông tin trên phiếu giấy.', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'MON001';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'MON002'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Cần báo lại', 2, 5,
        N'Phiếu giấy do quản lý bàn giao', N'Cần đối chiếu lại thông tin trên phiếu giấy.', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'MON002';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'MON003'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Cần báo lại', 2, 5,
        N'Phiếu giấy do quản lý bàn giao', N'Cần đối chiếu lại thông tin trên phiếu giấy.', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'MON003';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'MON004'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Cần báo lại', 2, 5,
        N'Phiếu giấy do quản lý bàn giao', N'Cần đối chiếu lại thông tin trên phiếu giấy.', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'MON004';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mba_Reviews r
    INNER JOIN dbo.Mba_Products p ON p.Mba_Id = r.Mba_ProductId
    WHERE p.Mba_Code = N'MON005'
)
BEGIN
    INSERT INTO dbo.Mba_Reviews
        (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote, Mba_EmployeeId)
    SELECT
        Mba_Id, N'Cần báo lại', 2, 5,
        N'Phiếu giấy do quản lý bàn giao', N'Cần đối chiếu lại thông tin trên phiếu giấy.', NULL
    FROM dbo.Mba_Products
    WHERE Mba_Code = N'MON005';
END
GO

-- Đồng bộ trạng thái sản phẩm theo Review
UPDATE p
SET p.Mba_DataStatus = r.Mba_Status
FROM dbo.Mba_Products p
INNER JOIN dbo.Mba_Reviews r ON r.Mba_ProductId = p.Mba_Id;
GO

-- Đồng bộ Mba_CategoryId sau khi bổ sung đủ 12 danh mục/sản phẩm
UPDATE p
SET p.Mba_CategoryId = c.Mba_Id
FROM dbo.Mba_Products p
INNER JOIN dbo.Mba_Categories c ON c.Mba_Name = p.Mba_Category
WHERE p.Mba_CategoryId IS NULL OR p.Mba_CategoryId <> c.Mba_Id;
GO

-- Verification
SELECT 'Mba_Categories' AS TableName, COUNT(*) AS TotalRows FROM dbo.Mba_Categories
UNION ALL
SELECT 'Mba_Products', COUNT(*) FROM dbo.Mba_Products
UNION ALL
SELECT 'Mba_Reviews', COUNT(*) FROM dbo.Mba_Reviews
UNION ALL
SELECT 'Mba_Accounts', COUNT(*) FROM dbo.Mba_Accounts
UNION ALL
SELECT 'Mba_Admins', COUNT(*) FROM dbo.Mba_Admins
UNION ALL
SELECT 'Mba_Employees', COUNT(*) FROM dbo.Mba_Employees;
GO

SELECT Mba_Category, COUNT(*) AS ProductCount
FROM dbo.Mba_Products
GROUP BY Mba_Category
ORDER BY Mba_Category;
GO


/* ========================================================
   BỘ DỮ LIỆU MẪU MỞ RỘNG: 17 DANH MỤC x 20 SẢN PHẨM
   Tổng mục tiêu: 17 Mba_Categories / 340 Mba_Products / 340 Mba_Reviews / 10 Mba_Employees
   Có thể chạy lại an toàn: các bản ghi đã tồn tại sẽ được bỏ qua.
   ======================================================== */
SET NOCOUNT ON;

-- Bổ sung đủ 17 danh mục
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM001')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM001', N'Máy tính bộ', N'PC Gaming, PC văn phòng và workstation', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM002')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM002', N'Laptop', N'Laptop học tập, làm việc, gaming và đồ họa', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM003')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM003', N'CPU', N'Bộ vi xử lý Intel và AMD', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM004')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM004', N'RAM', N'Bộ nhớ RAM DDR4 và DDR5', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM005')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM005', N'Card đồ họa', N'GPU NVIDIA và AMD', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM006')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM006', N'SSD', N'SSD SATA và SSD NVMe', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM007')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM007', N'HDD', N'Ổ cứng HDD lưu trữ dữ liệu', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM008')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM008', N'Mainboard', N'Bo mạch chủ Intel và AMD', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM009')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM009', N'Bộ nguồn (PSU)', N'Nguồn máy tính theo công suất và chuẩn 80 Plus', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM010')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM010', N'Vỏ máy (Case)', N'Vỏ PC Mini Tower, Mid Tower và Full Tower', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM011')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM011', N'Tản nhiệt', N'Tản nhiệt khí và tản nhiệt nước AIO', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM012')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM012', N'Màn hình (Monitor)', N'Màn hình văn phòng, gaming và đồ họa', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM013')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM013', N'Bàn phím', N'Bàn phím cơ, membrane và wireless', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM014')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM014', N'Chuột', N'Chuột gaming, văn phòng và wireless', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM015')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM015', N'Tai nghe', N'Tai nghe gaming, học tập và hội họp', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM016')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM016', N'Webcam', N'Webcam học tập, họp trực tuyến và streaming', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Categories WHERE Mba_Code = N'DM017')
BEGIN
    INSERT INTO dbo.Mba_Categories (Mba_Code, Mba_Name, Mba_Description, Mba_IsActive) VALUES (N'DM017', N'Thiết bị mạng', N'Router, switch, Wi-Fi adapter và thiết bị mạng', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC001', N'PC Gaming MBA 01', c.Mba_Name, N'MBA', N'PC gaming mẫu 01', NULL, 24210000, 12, N'Core i5-12401F / 16GB RAM / SSD NVMe 512GB / GPU rời', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC002', N'PC Office MBA 02', c.Mba_Name, N'MBA', N'PC văn phòng mẫu 02', NULL, 36420000, 19, N'Core i5-12402F / 32GB RAM / SSD NVMe 1024GB / GPU rời', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC003', N'PC Workstation MBA 03', c.Mba_Name, N'MBA', N'máy trạm mẫu 03', NULL, 15300000, 26, N'Core i7-12403F / 16GB RAM / SSD NVMe 512GB / GPU rời', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC004', N'PC Creator MBA 04', c.Mba_Name, N'MBA', N'PC sáng tạo nội dung mẫu 04', NULL, 27510000, 33, N'Core i5-12404F / 32GB RAM / SSD NVMe 1024GB / GPU rời', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC005', N'PC Gaming MBA 05', c.Mba_Name, N'MBA', N'PC gaming mẫu 05', NULL, 39720000, 40, N'Core i5-12400F / 16GB RAM / SSD NVMe 512GB / GPU rời', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC006', N'PC Office MBA 06', c.Mba_Name, N'MBA', N'PC văn phòng mẫu 06', NULL, 18600000, 11, N'Core i7-12401F / 32GB RAM / SSD NVMe 1024GB / GPU rời', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC007', N'PC Workstation MBA 07', c.Mba_Name, N'MBA', N'máy trạm mẫu 07', NULL, 30810000, 18, N'Core i5-12402F / 16GB RAM / SSD NVMe 512GB / GPU rời', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC008', N'PC Creator MBA 08', c.Mba_Name, N'MBA', N'PC sáng tạo nội dung mẫu 08', NULL, 43020000, 25, N'Core i5-12403F / 32GB RAM / SSD NVMe 1024GB / GPU rời', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC009', N'PC Gaming MBA 09', c.Mba_Name, N'MBA', N'PC gaming mẫu 09', NULL, 21900000, 32, N'Core i7-12404F / 16GB RAM / SSD NVMe 512GB / GPU rời', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC010', N'PC Office MBA 10', c.Mba_Name, N'MBA', N'PC văn phòng mẫu 10', NULL, 34110000, 39, N'Core i5-12400F / 32GB RAM / SSD NVMe 1024GB / GPU rời', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC011', N'PC Workstation MBA 11', c.Mba_Name, N'MBA', N'máy trạm mẫu 11', NULL, 12990000, 10, N'Core i5-12401F / 16GB RAM / SSD NVMe 512GB / GPU rời', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC012', N'PC Creator MBA 12', c.Mba_Name, N'MBA', N'PC sáng tạo nội dung mẫu 12', NULL, 25200000, 17, N'Core i7-12402F / 32GB RAM / SSD NVMe 1024GB / GPU rời', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC013', N'PC Gaming MBA 13', c.Mba_Name, N'MBA', N'PC gaming mẫu 13', NULL, 37410000, 24, N'Core i5-12403F / 16GB RAM / SSD NVMe 512GB / GPU rời', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC014', N'PC Office MBA 14', c.Mba_Name, N'MBA', N'PC văn phòng mẫu 14', NULL, 16290000, 31, N'Core i5-12404F / 32GB RAM / SSD NVMe 1024GB / GPU rời', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC015', N'PC Workstation MBA 15', c.Mba_Name, N'MBA', N'máy trạm mẫu 15', NULL, 28500000, 38, N'Core i7-12400F / 16GB RAM / SSD NVMe 512GB / GPU rời', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC016', N'PC Creator MBA 16', c.Mba_Name, N'MBA', N'PC sáng tạo nội dung mẫu 16', NULL, 40710000, 9, N'Core i5-12401F / 32GB RAM / SSD NVMe 1024GB / GPU rời', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC017', N'PC Gaming MBA 17', c.Mba_Name, N'MBA', N'PC gaming mẫu 17', NULL, 19590000, 16, N'Core i5-12402F / 16GB RAM / SSD NVMe 512GB / GPU rời', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC018', N'PC Office MBA 18', c.Mba_Name, N'MBA', N'PC văn phòng mẫu 18', NULL, 31800000, 23, N'Core i7-12403F / 32GB RAM / SSD NVMe 1024GB / GPU rời', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC019', N'PC Workstation MBA 19', c.Mba_Name, N'MBA', N'máy trạm mẫu 19', NULL, 44010000, 30, N'Core i5-12404F / 16GB RAM / SSD NVMe 512GB / GPU rời', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PC020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PC020', N'PC Creator MBA 20', c.Mba_Name, N'MBA', N'PC sáng tạo nội dung mẫu 20', NULL, 22890000, 37, N'Core i5-12400F / 32GB RAM / SSD NVMe 1024GB / GPU rời', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM001';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP001', N'ASUS Vivobook 01', c.Mba_Name, N'ASUS', N'laptop học tập mẫu 01', NULL, 27910000, 12, N'Core i5 / 16GB / SSD 512GB / màn hình FHD', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP002', N'Lenovo LOQ 02', c.Mba_Name, N'Lenovo', N'laptop gaming mẫu 02', NULL, 43820000, 19, N'Core i5 / 32GB / SSD 512GB / màn hình FHD', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP003', N'Acer Nitro V 03', c.Mba_Name, N'Acer', N'laptop gaming mẫu 03', NULL, 16300000, 26, N'Core i7 / 16GB / SSD 512GB / màn hình FHD', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP004', N'HP ProBook 04', c.Mba_Name, N'HP', N'laptop văn phòng mẫu 04', NULL, 32210000, 33, N'Core i5 / 32GB / SSD 512GB / màn hình FHD', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP005', N'Dell Inspiron 05', c.Mba_Name, N'Dell', N'laptop học tập mẫu 05', NULL, 48120000, 40, N'Core i5 / 16GB / SSD 512GB / màn hình FHD', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP006', N'ASUS Vivobook 06', c.Mba_Name, N'ASUS', N'laptop học tập mẫu 06', NULL, 20600000, 11, N'Core i7 / 32GB / SSD 512GB / màn hình FHD', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP007', N'Lenovo LOQ 07', c.Mba_Name, N'Lenovo', N'laptop gaming mẫu 07', NULL, 36510000, 18, N'Core i5 / 16GB / SSD 512GB / màn hình FHD', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP008', N'Acer Nitro V 08', c.Mba_Name, N'Acer', N'laptop gaming mẫu 08', NULL, 52420000, 25, N'Core i5 / 32GB / SSD 512GB / màn hình FHD', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP009', N'HP ProBook 09', c.Mba_Name, N'HP', N'laptop văn phòng mẫu 09', NULL, 24900000, 32, N'Core i7 / 16GB / SSD 512GB / màn hình FHD', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP010', N'Dell Inspiron 10', c.Mba_Name, N'Dell', N'laptop học tập mẫu 10', NULL, 40810000, 39, N'Core i5 / 32GB / SSD 512GB / màn hình FHD', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP011', N'ASUS Vivobook 11', c.Mba_Name, N'ASUS', N'laptop học tập mẫu 11', NULL, 13290000, 10, N'Core i5 / 16GB / SSD 512GB / màn hình FHD', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP012', N'Lenovo LOQ 12', c.Mba_Name, N'Lenovo', N'laptop gaming mẫu 12', NULL, 29200000, 17, N'Core i7 / 32GB / SSD 512GB / màn hình FHD', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP013', N'Acer Nitro V 13', c.Mba_Name, N'Acer', N'laptop gaming mẫu 13', NULL, 45110000, 24, N'Core i5 / 16GB / SSD 512GB / màn hình FHD', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP014', N'HP ProBook 14', c.Mba_Name, N'HP', N'laptop văn phòng mẫu 14', NULL, 17590000, 31, N'Core i5 / 32GB / SSD 512GB / màn hình FHD', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP015', N'Dell Inspiron 15', c.Mba_Name, N'Dell', N'laptop học tập mẫu 15', NULL, 33500000, 38, N'Core i7 / 16GB / SSD 512GB / màn hình FHD', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP016', N'ASUS Vivobook 16', c.Mba_Name, N'ASUS', N'laptop học tập mẫu 16', NULL, 49410000, 9, N'Core i5 / 32GB / SSD 512GB / màn hình FHD', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP017', N'Lenovo LOQ 17', c.Mba_Name, N'Lenovo', N'laptop gaming mẫu 17', NULL, 21890000, 16, N'Core i5 / 16GB / SSD 512GB / màn hình FHD', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP018', N'Acer Nitro V 18', c.Mba_Name, N'Acer', N'laptop gaming mẫu 18', NULL, 37800000, 23, N'Core i7 / 32GB / SSD 512GB / màn hình FHD', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP019', N'HP ProBook 19', c.Mba_Name, N'HP', N'laptop văn phòng mẫu 19', NULL, 53710000, 30, N'Core i5 / 16GB / SSD 512GB / màn hình FHD', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'LAP020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'LAP020', N'Dell Inspiron 20', c.Mba_Name, N'Dell', N'laptop học tập mẫu 20', NULL, 26190000, 37, N'Core i5 / 32GB / SSD 512GB / màn hình FHD', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM002';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU001', N'Intel Core i3 01', c.Mba_Name, N'Intel', N'CPU phổ thông mẫu 01', NULL, 8240000, 12, N'8 nhân / 16 luồng / socket desktop / Turbo cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU002', N'Intel Core i5 02', c.Mba_Name, N'Intel', N'CPU desktop mẫu 02', NULL, 13970000, 19, N'10 nhân / 20 luồng / socket desktop / Turbo cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU003', N'Intel Core i7 03', c.Mba_Name, N'Intel', N'CPU hiệu năng cao mẫu 03', NULL, 4050000, 26, N'12 nhân / 24 luồng / socket desktop / Turbo cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU004', N'AMD Ryzen 5 04', c.Mba_Name, N'AMD', N'CPU gaming mẫu 04', NULL, 9780000, 33, N'14 nhân / 12 luồng / socket desktop / Turbo cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU005', N'AMD Ryzen 7 05', c.Mba_Name, N'AMD', N'CPU gaming mẫu 05', NULL, 15520000, 40, N'6 nhân / 16 luồng / socket desktop / Turbo cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU006', N'AMD Ryzen 9 06', c.Mba_Name, N'AMD', N'CPU workstation mẫu 06', NULL, 5600000, 11, N'8 nhân / 20 luồng / socket desktop / Turbo cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU007', N'Intel Core i3 07', c.Mba_Name, N'Intel', N'CPU phổ thông mẫu 07', NULL, 11340000, 18, N'10 nhân / 24 luồng / socket desktop / Turbo cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU008', N'Intel Core i5 08', c.Mba_Name, N'Intel', N'CPU desktop mẫu 08', NULL, 17070000, 25, N'12 nhân / 12 luồng / socket desktop / Turbo cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU009', N'Intel Core i7 09', c.Mba_Name, N'Intel', N'CPU hiệu năng cao mẫu 09', NULL, 7150000, 32, N'14 nhân / 16 luồng / socket desktop / Turbo cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU010', N'AMD Ryzen 5 10', c.Mba_Name, N'AMD', N'CPU gaming mẫu 10', NULL, 12880000, 39, N'6 nhân / 20 luồng / socket desktop / Turbo cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU011', N'AMD Ryzen 7 11', c.Mba_Name, N'AMD', N'CPU gaming mẫu 11', NULL, 2960000, 10, N'8 nhân / 24 luồng / socket desktop / Turbo cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU012', N'AMD Ryzen 9 12', c.Mba_Name, N'AMD', N'CPU workstation mẫu 12', NULL, 8700000, 17, N'10 nhân / 12 luồng / socket desktop / Turbo cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU013', N'Intel Core i3 13', c.Mba_Name, N'Intel', N'CPU phổ thông mẫu 13', NULL, 14440000, 24, N'12 nhân / 16 luồng / socket desktop / Turbo cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU014', N'Intel Core i5 14', c.Mba_Name, N'Intel', N'CPU desktop mẫu 14', NULL, 4520000, 31, N'14 nhân / 20 luồng / socket desktop / Turbo cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU015', N'Intel Core i7 15', c.Mba_Name, N'Intel', N'CPU hiệu năng cao mẫu 15', NULL, 10250000, 38, N'6 nhân / 24 luồng / socket desktop / Turbo cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU016', N'AMD Ryzen 5 16', c.Mba_Name, N'AMD', N'CPU gaming mẫu 16', NULL, 15980000, 9, N'8 nhân / 12 luồng / socket desktop / Turbo cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU017', N'AMD Ryzen 7 17', c.Mba_Name, N'AMD', N'CPU gaming mẫu 17', NULL, 6060000, 16, N'10 nhân / 16 luồng / socket desktop / Turbo cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU018', N'AMD Ryzen 9 18', c.Mba_Name, N'AMD', N'CPU workstation mẫu 18', NULL, 11800000, 23, N'12 nhân / 20 luồng / socket desktop / Turbo cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU019', N'Intel Core i3 19', c.Mba_Name, N'Intel', N'CPU phổ thông mẫu 19', NULL, 17540000, 30, N'14 nhân / 24 luồng / socket desktop / Turbo cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CPU020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CPU020', N'Intel Core i5 20', c.Mba_Name, N'Intel', N'CPU desktop mẫu 20', NULL, 7620000, 37, N'6 nhân / 12 luồng / socket desktop / Turbo cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM003';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM001', N'Kingston Fury Beast 01', c.Mba_Name, N'Kingston', N'RAM DDR5 mẫu 01', NULL, 2660000, 12, N'DDR5 / 5800MHz / 16GB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM002', N'Corsair Vengeance 02', c.Mba_Name, N'Corsair', N'RAM DDR5 mẫu 02', NULL, 4620000, 19, N'DDR5 / 6000MHz / 24GB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM003', N'G.Skill Ripjaws 03', c.Mba_Name, N'G.Skill', N'RAM DDR4 mẫu 03', NULL, 1230000, 26, N'DDR4 / 3200MHz / 32GB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM004', N'TeamGroup T-Force 04', c.Mba_Name, N'TeamGroup', N'RAM gaming mẫu 04', NULL, 3190000, 33, N'DDR5 / 5800MHz / 8GB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM005', N'Kingston Fury Beast 05', c.Mba_Name, N'Kingston', N'RAM DDR5 mẫu 05', NULL, 5150000, 40, N'DDR5 / 6000MHz / 16GB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM006', N'Corsair Vengeance 06', c.Mba_Name, N'Corsair', N'RAM DDR5 mẫu 06', NULL, 1760000, 11, N'DDR4 / 3200MHz / 24GB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM007', N'G.Skill Ripjaws 07', c.Mba_Name, N'G.Skill', N'RAM DDR4 mẫu 07', NULL, 3720000, 18, N'DDR5 / 5800MHz / 32GB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM008', N'TeamGroup T-Force 08', c.Mba_Name, N'TeamGroup', N'RAM gaming mẫu 08', NULL, 5680000, 25, N'DDR5 / 6000MHz / 8GB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM009', N'Kingston Fury Beast 09', c.Mba_Name, N'Kingston', N'RAM DDR5 mẫu 09', NULL, 2290000, 32, N'DDR4 / 3200MHz / 16GB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM010', N'Corsair Vengeance 10', c.Mba_Name, N'Corsair', N'RAM DDR5 mẫu 10', NULL, 4250000, 39, N'DDR5 / 5800MHz / 24GB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM011', N'G.Skill Ripjaws 11', c.Mba_Name, N'G.Skill', N'RAM DDR4 mẫu 11', NULL, 860000, 10, N'DDR5 / 6000MHz / 32GB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM012', N'TeamGroup T-Force 12', c.Mba_Name, N'TeamGroup', N'RAM gaming mẫu 12', NULL, 2820000, 17, N'DDR4 / 3200MHz / 8GB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM013', N'Kingston Fury Beast 13', c.Mba_Name, N'Kingston', N'RAM DDR5 mẫu 13', NULL, 4780000, 24, N'DDR5 / 5800MHz / 16GB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM014', N'Corsair Vengeance 14', c.Mba_Name, N'Corsair', N'RAM DDR5 mẫu 14', NULL, 1390000, 31, N'DDR5 / 6000MHz / 24GB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM015', N'G.Skill Ripjaws 15', c.Mba_Name, N'G.Skill', N'RAM DDR4 mẫu 15', NULL, 3350000, 38, N'DDR4 / 3200MHz / 32GB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM016', N'TeamGroup T-Force 16', c.Mba_Name, N'TeamGroup', N'RAM gaming mẫu 16', NULL, 5310000, 9, N'DDR5 / 5800MHz / 8GB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM017', N'Kingston Fury Beast 17', c.Mba_Name, N'Kingston', N'RAM DDR5 mẫu 17', NULL, 1920000, 16, N'DDR5 / 6000MHz / 16GB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM018', N'Corsair Vengeance 18', c.Mba_Name, N'Corsair', N'RAM DDR5 mẫu 18', NULL, 3880000, 23, N'DDR4 / 3200MHz / 24GB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM019', N'G.Skill Ripjaws 19', c.Mba_Name, N'G.Skill', N'RAM DDR4 mẫu 19', NULL, 5840000, 30, N'DDR5 / 5800MHz / 32GB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'RAM020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'RAM020', N'TeamGroup T-Force 20', c.Mba_Name, N'TeamGroup', N'RAM gaming mẫu 20', NULL, 2450000, 37, N'DDR5 / 6000MHz / 8GB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM004';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA001', N'NVIDIA RTX 01', c.Mba_Name, N'NVIDIA', N'card đồ họa mẫu 01', NULL, 19800000, 12, N'8GB GDDR6 / bus 128-bit / GPU gaming', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA002', N'ASUS Dual RTX 02', c.Mba_Name, N'ASUS', N'card đồ họa mẫu 02', NULL, 34600000, 19, N'8GB GDDR6 / bus 192-bit / GPU gaming', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA003', N'MSI Ventus RTX 03', c.Mba_Name, N'MSI', N'card đồ họa mẫu 03', NULL, 9000000, 26, N'12GB GDDR6 / bus 128-bit / GPU gaming', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA004', N'AMD Radeon RX 04', c.Mba_Name, N'AMD', N'card đồ họa mẫu 04', NULL, 23800000, 33, N'8GB GDDR6 / bus 192-bit / GPU gaming', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA005', N'NVIDIA RTX 05', c.Mba_Name, N'NVIDIA', N'card đồ họa mẫu 05', NULL, 38600000, 40, N'8GB GDDR6 / bus 128-bit / GPU gaming', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA006', N'ASUS Dual RTX 06', c.Mba_Name, N'ASUS', N'card đồ họa mẫu 06', NULL, 13000000, 11, N'12GB GDDR6 / bus 192-bit / GPU gaming', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA007', N'MSI Ventus RTX 07', c.Mba_Name, N'MSI', N'card đồ họa mẫu 07', NULL, 27800000, 18, N'8GB GDDR6 / bus 128-bit / GPU gaming', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA008', N'AMD Radeon RX 08', c.Mba_Name, N'AMD', N'card đồ họa mẫu 08', NULL, 42600000, 25, N'8GB GDDR6 / bus 192-bit / GPU gaming', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA009', N'NVIDIA RTX 09', c.Mba_Name, N'NVIDIA', N'card đồ họa mẫu 09', NULL, 17000000, 32, N'12GB GDDR6 / bus 128-bit / GPU gaming', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA010', N'ASUS Dual RTX 10', c.Mba_Name, N'ASUS', N'card đồ họa mẫu 10', NULL, 31800000, 39, N'8GB GDDR6 / bus 192-bit / GPU gaming', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA011', N'MSI Ventus RTX 11', c.Mba_Name, N'MSI', N'card đồ họa mẫu 11', NULL, 6200000, 10, N'8GB GDDR6 / bus 128-bit / GPU gaming', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA012', N'AMD Radeon RX 12', c.Mba_Name, N'AMD', N'card đồ họa mẫu 12', NULL, 21000000, 17, N'12GB GDDR6 / bus 192-bit / GPU gaming', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA013', N'NVIDIA RTX 13', c.Mba_Name, N'NVIDIA', N'card đồ họa mẫu 13', NULL, 35800000, 24, N'8GB GDDR6 / bus 128-bit / GPU gaming', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA014', N'ASUS Dual RTX 14', c.Mba_Name, N'ASUS', N'card đồ họa mẫu 14', NULL, 10200000, 31, N'8GB GDDR6 / bus 192-bit / GPU gaming', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA015', N'MSI Ventus RTX 15', c.Mba_Name, N'MSI', N'card đồ họa mẫu 15', NULL, 25000000, 38, N'12GB GDDR6 / bus 128-bit / GPU gaming', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA016', N'AMD Radeon RX 16', c.Mba_Name, N'AMD', N'card đồ họa mẫu 16', NULL, 39800000, 9, N'8GB GDDR6 / bus 192-bit / GPU gaming', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA017', N'NVIDIA RTX 17', c.Mba_Name, N'NVIDIA', N'card đồ họa mẫu 17', NULL, 14200000, 16, N'8GB GDDR6 / bus 128-bit / GPU gaming', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA018', N'ASUS Dual RTX 18', c.Mba_Name, N'ASUS', N'card đồ họa mẫu 18', NULL, 29000000, 23, N'12GB GDDR6 / bus 192-bit / GPU gaming', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA019', N'MSI Ventus RTX 19', c.Mba_Name, N'MSI', N'card đồ họa mẫu 19', NULL, 43800000, 30, N'8GB GDDR6 / bus 128-bit / GPU gaming', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'VGA020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'VGA020', N'AMD Radeon RX 20', c.Mba_Name, N'AMD', N'card đồ họa mẫu 20', NULL, 18200000, 37, N'8GB GDDR6 / bus 192-bit / GPU gaming', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM005';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD001', N'Samsung 980 01', c.Mba_Name, N'Samsung', N'SSD NVMe mẫu 01', NULL, 3090000, 12, N'NVMe PCIe 4.0 / 512GB / đọc tốc độ cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD002', N'Samsung 990 EVO 02', c.Mba_Name, N'Samsung', N'SSD NVMe mẫu 02', NULL, 5390000, 19, N'NVMe PCIe 4.0 / 1024GB / đọc tốc độ cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD003', N'WD Black SN770 03', c.Mba_Name, N'Western Digital', N'SSD NVMe mẫu 03', NULL, 1420000, 26, N'NVMe PCIe 3.0 / 512GB / đọc tốc độ cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD004', N'Kingston NV2 04', c.Mba_Name, N'Kingston', N'SSD NVMe mẫu 04', NULL, 3710000, 33, N'NVMe PCIe 4.0 / 1024GB / đọc tốc độ cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD005', N'Crucial P3 Plus 05', c.Mba_Name, N'Crucial', N'SSD NVMe mẫu 05', NULL, 6010000, 40, N'NVMe PCIe 4.0 / 512GB / đọc tốc độ cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD006', N'Samsung 980 06', c.Mba_Name, N'Samsung', N'SSD NVMe mẫu 06', NULL, 2040000, 11, N'NVMe PCIe 3.0 / 1024GB / đọc tốc độ cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD007', N'Samsung 990 EVO 07', c.Mba_Name, N'Samsung', N'SSD NVMe mẫu 07', NULL, 4330000, 18, N'NVMe PCIe 4.0 / 512GB / đọc tốc độ cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD008', N'WD Black SN770 08', c.Mba_Name, N'Western Digital', N'SSD NVMe mẫu 08', NULL, 6630000, 25, N'NVMe PCIe 4.0 / 1024GB / đọc tốc độ cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD009', N'Kingston NV2 09', c.Mba_Name, N'Kingston', N'SSD NVMe mẫu 09', NULL, 2660000, 32, N'NVMe PCIe 3.0 / 512GB / đọc tốc độ cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD010', N'Crucial P3 Plus 10', c.Mba_Name, N'Crucial', N'SSD NVMe mẫu 10', NULL, 4950000, 39, N'NVMe PCIe 4.0 / 1024GB / đọc tốc độ cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD011', N'Samsung 980 11', c.Mba_Name, N'Samsung', N'SSD NVMe mẫu 11', NULL, 990000, 10, N'NVMe PCIe 4.0 / 512GB / đọc tốc độ cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD012', N'Samsung 990 EVO 12', c.Mba_Name, N'Samsung', N'SSD NVMe mẫu 12', NULL, 3280000, 17, N'NVMe PCIe 3.0 / 1024GB / đọc tốc độ cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD013', N'WD Black SN770 13', c.Mba_Name, N'Western Digital', N'SSD NVMe mẫu 13', NULL, 5570000, 24, N'NVMe PCIe 4.0 / 512GB / đọc tốc độ cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD014', N'Kingston NV2 14', c.Mba_Name, N'Kingston', N'SSD NVMe mẫu 14', NULL, 1610000, 31, N'NVMe PCIe 4.0 / 1024GB / đọc tốc độ cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD015', N'Crucial P3 Plus 15', c.Mba_Name, N'Crucial', N'SSD NVMe mẫu 15', NULL, 3900000, 38, N'NVMe PCIe 3.0 / 512GB / đọc tốc độ cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD016', N'Samsung 980 16', c.Mba_Name, N'Samsung', N'SSD NVMe mẫu 16', NULL, 6190000, 9, N'NVMe PCIe 4.0 / 1024GB / đọc tốc độ cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD017', N'Samsung 990 EVO 17', c.Mba_Name, N'Samsung', N'SSD NVMe mẫu 17', NULL, 2230000, 16, N'NVMe PCIe 4.0 / 512GB / đọc tốc độ cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD018', N'WD Black SN770 18', c.Mba_Name, N'Western Digital', N'SSD NVMe mẫu 18', NULL, 4520000, 23, N'NVMe PCIe 3.0 / 1024GB / đọc tốc độ cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD019', N'Kingston NV2 19', c.Mba_Name, N'Kingston', N'SSD NVMe mẫu 19', NULL, 6810000, 30, N'NVMe PCIe 4.0 / 512GB / đọc tốc độ cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'SSD020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'SSD020', N'Crucial P3 Plus 20', c.Mba_Name, N'Crucial', N'SSD NVMe mẫu 20', NULL, 2850000, 37, N'NVMe PCIe 4.0 / 1024GB / đọc tốc độ cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM006';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD001', N'Seagate BarraCuda 01', c.Mba_Name, N'Seagate', N'HDD mẫu 01', NULL, 2850000, 12, N'2000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD002', N'WD Blue 02', c.Mba_Name, N'Western Digital', N'HDD mẫu 02', NULL, 4700000, 19, N'3000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD003', N'Toshiba P300 03', c.Mba_Name, N'Toshiba', N'HDD mẫu 03', NULL, 1500000, 26, N'4000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD004', N'Seagate IronWolf 04', c.Mba_Name, N'Seagate', N'HDD NAS mẫu 04', NULL, 3350000, 33, N'1000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD005', N'Seagate BarraCuda 05', c.Mba_Name, N'Seagate', N'HDD mẫu 05', NULL, 5200000, 40, N'2000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD006', N'WD Blue 06', c.Mba_Name, N'Western Digital', N'HDD mẫu 06', NULL, 2000000, 11, N'3000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD007', N'Toshiba P300 07', c.Mba_Name, N'Toshiba', N'HDD mẫu 07', NULL, 3850000, 18, N'4000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD008', N'Seagate IronWolf 08', c.Mba_Name, N'Seagate', N'HDD NAS mẫu 08', NULL, 5700000, 25, N'1000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD009', N'Seagate BarraCuda 09', c.Mba_Name, N'Seagate', N'HDD mẫu 09', NULL, 2500000, 32, N'2000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD010', N'WD Blue 10', c.Mba_Name, N'Western Digital', N'HDD mẫu 10', NULL, 4350000, 39, N'3000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD011', N'Toshiba P300 11', c.Mba_Name, N'Toshiba', N'HDD mẫu 11', NULL, 1150000, 10, N'4000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD012', N'Seagate IronWolf 12', c.Mba_Name, N'Seagate', N'HDD NAS mẫu 12', NULL, 3000000, 17, N'1000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD013', N'Seagate BarraCuda 13', c.Mba_Name, N'Seagate', N'HDD mẫu 13', NULL, 4850000, 24, N'2000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD014', N'WD Blue 14', c.Mba_Name, N'Western Digital', N'HDD mẫu 14', NULL, 1650000, 31, N'3000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD015', N'Toshiba P300 15', c.Mba_Name, N'Toshiba', N'HDD mẫu 15', NULL, 3500000, 38, N'4000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD016', N'Seagate IronWolf 16', c.Mba_Name, N'Seagate', N'HDD NAS mẫu 16', NULL, 5350000, 9, N'1000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD017', N'Seagate BarraCuda 17', c.Mba_Name, N'Seagate', N'HDD mẫu 17', NULL, 2150000, 16, N'2000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD018', N'WD Blue 18', c.Mba_Name, N'Western Digital', N'HDD mẫu 18', NULL, 4000000, 23, N'3000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD019', N'Toshiba P300 19', c.Mba_Name, N'Toshiba', N'HDD mẫu 19', NULL, 5850000, 30, N'4000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HDD020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HDD020', N'Seagate IronWolf 20', c.Mba_Name, N'Seagate', N'HDD NAS mẫu 20', NULL, 2650000, 37, N'1000GB / SATA / 7200RPM / bộ nhớ đệm cao', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM007';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB001', N'MSI PRO 01', c.Mba_Name, N'MSI', N'mainboard mẫu 01', NULL, 5830000, 12, N'Socket AM5 / DDR5 / Wi-Fi / Micro-ATX', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB002', N'ASUS TUF Gaming 02', c.Mba_Name, N'ASUS', N'mainboard mẫu 02', NULL, 9450000, 19, N'Socket LGA1700 / DDR5 / Wi-Fi / Micro-ATX', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB003', N'Gigabyte B 03', c.Mba_Name, N'Gigabyte', N'mainboard mẫu 03', NULL, 3180000, 26, N'Socket AM5 / DDR5 / Wi-Fi / Micro-ATX', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB004', N'ASRock B 04', c.Mba_Name, N'ASRock', N'mainboard mẫu 04', NULL, 6810000, 33, N'Socket LGA1700 / DDR5 / Wi-Fi / Micro-ATX', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB005', N'MSI PRO 05', c.Mba_Name, N'MSI', N'mainboard mẫu 05', NULL, 10430000, 40, N'Socket AM5 / DDR5 / Wi-Fi / Micro-ATX', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB006', N'ASUS TUF Gaming 06', c.Mba_Name, N'ASUS', N'mainboard mẫu 06', NULL, 4160000, 11, N'Socket LGA1700 / DDR5 / Wi-Fi / Micro-ATX', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB007', N'Gigabyte B 07', c.Mba_Name, N'Gigabyte', N'mainboard mẫu 07', NULL, 7790000, 18, N'Socket AM5 / DDR5 / Wi-Fi / Micro-ATX', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB008', N'ASRock B 08', c.Mba_Name, N'ASRock', N'mainboard mẫu 08', NULL, 11410000, 25, N'Socket LGA1700 / DDR5 / Wi-Fi / Micro-ATX', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB009', N'MSI PRO 09', c.Mba_Name, N'MSI', N'mainboard mẫu 09', NULL, 5140000, 32, N'Socket AM5 / DDR5 / Wi-Fi / Micro-ATX', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB010', N'ASUS TUF Gaming 10', c.Mba_Name, N'ASUS', N'mainboard mẫu 10', NULL, 8770000, 39, N'Socket LGA1700 / DDR5 / Wi-Fi / Micro-ATX', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB011', N'Gigabyte B 11', c.Mba_Name, N'Gigabyte', N'mainboard mẫu 11', NULL, 2490000, 10, N'Socket AM5 / DDR5 / Wi-Fi / Micro-ATX', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB012', N'ASRock B 12', c.Mba_Name, N'ASRock', N'mainboard mẫu 12', NULL, 6120000, 17, N'Socket LGA1700 / DDR5 / Wi-Fi / Micro-ATX', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB013', N'MSI PRO 13', c.Mba_Name, N'MSI', N'mainboard mẫu 13', NULL, 9750000, 24, N'Socket AM5 / DDR5 / Wi-Fi / Micro-ATX', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB014', N'ASUS TUF Gaming 14', c.Mba_Name, N'ASUS', N'mainboard mẫu 14', NULL, 3470000, 31, N'Socket LGA1700 / DDR5 / Wi-Fi / Micro-ATX', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB015', N'Gigabyte B 15', c.Mba_Name, N'Gigabyte', N'mainboard mẫu 15', NULL, 7100000, 38, N'Socket AM5 / DDR5 / Wi-Fi / Micro-ATX', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB016', N'ASRock B 16', c.Mba_Name, N'ASRock', N'mainboard mẫu 16', NULL, 10730000, 9, N'Socket LGA1700 / DDR5 / Wi-Fi / Micro-ATX', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB017', N'MSI PRO 17', c.Mba_Name, N'MSI', N'mainboard mẫu 17', NULL, 4450000, 16, N'Socket AM5 / DDR5 / Wi-Fi / Micro-ATX', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB018', N'ASUS TUF Gaming 18', c.Mba_Name, N'ASUS', N'mainboard mẫu 18', NULL, 8080000, 23, N'Socket LGA1700 / DDR5 / Wi-Fi / Micro-ATX', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB019', N'Gigabyte B 19', c.Mba_Name, N'Gigabyte', N'mainboard mẫu 19', NULL, 11710000, 30, N'Socket AM5 / DDR5 / Wi-Fi / Micro-ATX', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MB020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MB020', N'ASRock B 20', c.Mba_Name, N'ASRock', N'mainboard mẫu 20', NULL, 5430000, 37, N'Socket LGA1700 / DDR5 / Wi-Fi / Micro-ATX', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM008';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU001', N'Corsair CV 01', c.Mba_Name, N'Corsair', N'nguồn máy tính mẫu 01', NULL, 2970000, 12, N'650W / 80 Plus Bronze / ATX', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU002', N'Cooler Master MWE 02', c.Mba_Name, N'Cooler Master', N'nguồn máy tính mẫu 02', NULL, 5040000, 19, N'750W / 80 Plus Gold / ATX', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU003', N'DeepCool PK 03', c.Mba_Name, N'DeepCool', N'nguồn máy tính mẫu 03', NULL, 1460000, 26, N'850W / 80 Plus Bronze / ATX', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU004', N'Seasonic Focus 04', c.Mba_Name, N'Seasonic', N'nguồn máy tính mẫu 04', NULL, 3530000, 33, N'950W / 80 Plus Gold / ATX', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU005', N'Corsair CV 05', c.Mba_Name, N'Corsair', N'nguồn máy tính mẫu 05', NULL, 5600000, 40, N'550W / 80 Plus Bronze / ATX', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU006', N'Cooler Master MWE 06', c.Mba_Name, N'Cooler Master', N'nguồn máy tính mẫu 06', NULL, 2020000, 11, N'650W / 80 Plus Gold / ATX', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU007', N'DeepCool PK 07', c.Mba_Name, N'DeepCool', N'nguồn máy tính mẫu 07', NULL, 4090000, 18, N'750W / 80 Plus Bronze / ATX', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU008', N'Seasonic Focus 08', c.Mba_Name, N'Seasonic', N'nguồn máy tính mẫu 08', NULL, 6160000, 25, N'850W / 80 Plus Gold / ATX', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU009', N'Corsair CV 09', c.Mba_Name, N'Corsair', N'nguồn máy tính mẫu 09', NULL, 2580000, 32, N'950W / 80 Plus Bronze / ATX', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU010', N'Cooler Master MWE 10', c.Mba_Name, N'Cooler Master', N'nguồn máy tính mẫu 10', NULL, 4650000, 39, N'550W / 80 Plus Gold / ATX', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU011', N'DeepCool PK 11', c.Mba_Name, N'DeepCool', N'nguồn máy tính mẫu 11', NULL, 1070000, 10, N'650W / 80 Plus Bronze / ATX', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU012', N'Seasonic Focus 12', c.Mba_Name, N'Seasonic', N'nguồn máy tính mẫu 12', NULL, 3140000, 17, N'750W / 80 Plus Gold / ATX', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU013', N'Corsair CV 13', c.Mba_Name, N'Corsair', N'nguồn máy tính mẫu 13', NULL, 5210000, 24, N'850W / 80 Plus Bronze / ATX', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU014', N'Cooler Master MWE 14', c.Mba_Name, N'Cooler Master', N'nguồn máy tính mẫu 14', NULL, 1630000, 31, N'950W / 80 Plus Gold / ATX', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU015', N'DeepCool PK 15', c.Mba_Name, N'DeepCool', N'nguồn máy tính mẫu 15', NULL, 3700000, 38, N'550W / 80 Plus Bronze / ATX', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU016', N'Seasonic Focus 16', c.Mba_Name, N'Seasonic', N'nguồn máy tính mẫu 16', NULL, 5770000, 9, N'650W / 80 Plus Gold / ATX', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU017', N'Corsair CV 17', c.Mba_Name, N'Corsair', N'nguồn máy tính mẫu 17', NULL, 2190000, 16, N'750W / 80 Plus Bronze / ATX', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU018', N'Cooler Master MWE 18', c.Mba_Name, N'Cooler Master', N'nguồn máy tính mẫu 18', NULL, 4260000, 23, N'850W / 80 Plus Gold / ATX', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU019', N'DeepCool PK 19', c.Mba_Name, N'DeepCool', N'nguồn máy tính mẫu 19', NULL, 6330000, 30, N'950W / 80 Plus Bronze / ATX', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'PSU020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'PSU020', N'Seasonic Focus 20', c.Mba_Name, N'Seasonic', N'nguồn máy tính mẫu 20', NULL, 2750000, 37, N'550W / 80 Plus Gold / ATX', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM009';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE001', N'Cooler Master 01', c.Mba_Name, N'Cooler Master', N'vỏ máy mẫu 01', NULL, 2290000, 12, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE002', N'Montech Air 02', c.Mba_Name, N'Montech', N'vỏ máy mẫu 02', NULL, 3880000, 19, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE003', N'NZXT H 03', c.Mba_Name, N'NZXT', N'vỏ máy mẫu 03', NULL, 1130000, 26, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE004', N'DeepCool CH 04', c.Mba_Name, N'DeepCool', N'vỏ máy mẫu 04', NULL, 2720000, 33, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE005', N'Cooler Master 05', c.Mba_Name, N'Cooler Master', N'vỏ máy mẫu 05', NULL, 4310000, 40, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE006', N'Montech Air 06', c.Mba_Name, N'Montech', N'vỏ máy mẫu 06', NULL, 1560000, 11, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE007', N'NZXT H 07', c.Mba_Name, N'NZXT', N'vỏ máy mẫu 07', NULL, 3150000, 18, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE008', N'DeepCool CH 08', c.Mba_Name, N'DeepCool', N'vỏ máy mẫu 08', NULL, 4740000, 25, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE009', N'Cooler Master 09', c.Mba_Name, N'Cooler Master', N'vỏ máy mẫu 09', NULL, 1990000, 32, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE010', N'Montech Air 10', c.Mba_Name, N'Montech', N'vỏ máy mẫu 10', NULL, 3580000, 39, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE011', N'NZXT H 11', c.Mba_Name, N'NZXT', N'vỏ máy mẫu 11', NULL, 830000, 10, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE012', N'DeepCool CH 12', c.Mba_Name, N'DeepCool', N'vỏ máy mẫu 12', NULL, 2420000, 17, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE013', N'Cooler Master 13', c.Mba_Name, N'Cooler Master', N'vỏ máy mẫu 13', NULL, 4010000, 24, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE014', N'Montech Air 14', c.Mba_Name, N'Montech', N'vỏ máy mẫu 14', NULL, 1260000, 31, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE015', N'NZXT H 15', c.Mba_Name, N'NZXT', N'vỏ máy mẫu 15', NULL, 2850000, 38, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE016', N'DeepCool CH 16', c.Mba_Name, N'DeepCool', N'vỏ máy mẫu 16', NULL, 4440000, 9, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE017', N'Cooler Master 17', c.Mba_Name, N'Cooler Master', N'vỏ máy mẫu 17', NULL, 1690000, 16, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE018', N'Montech Air 18', c.Mba_Name, N'Montech', N'vỏ máy mẫu 18', NULL, 3280000, 23, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE019', N'NZXT H 19', c.Mba_Name, N'NZXT', N'vỏ máy mẫu 19', NULL, 4870000, 30, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CASE020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CASE020', N'DeepCool CH 20', c.Mba_Name, N'DeepCool', N'vỏ máy mẫu 20', NULL, 2120000, 37, N'Mid Tower / hỗ trợ ATX / kính cường lực / nhiều vị trí quạt', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM010';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL001', N'DeepCool AK 01', c.Mba_Name, N'DeepCool', N'tản nhiệt khí mẫu 01', NULL, 2540000, 12, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL002', N'Thermalright Peerless Assassin 02', c.Mba_Name, N'Thermalright', N'tản nhiệt khí mẫu 02', NULL, 4570000, 19, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL003', N'Cooler Master Hyper 03', c.Mba_Name, N'Cooler Master', N'tản nhiệt khí mẫu 03', NULL, 1050000, 26, N'Tản nhiệt nước AIO / hỗ trợ CPU desktop / quạt PWM', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL004', N'DeepCool LS 04', c.Mba_Name, N'DeepCool', N'tản nhiệt nước AIO mẫu 04', NULL, 3080000, 33, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL005', N'DeepCool AK 05', c.Mba_Name, N'DeepCool', N'tản nhiệt khí mẫu 05', NULL, 5120000, 40, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL006', N'Thermalright Peerless Assassin 06', c.Mba_Name, N'Thermalright', N'tản nhiệt khí mẫu 06', NULL, 1600000, 11, N'Tản nhiệt nước AIO / hỗ trợ CPU desktop / quạt PWM', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL007', N'Cooler Master Hyper 07', c.Mba_Name, N'Cooler Master', N'tản nhiệt khí mẫu 07', NULL, 3640000, 18, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL008', N'DeepCool LS 08', c.Mba_Name, N'DeepCool', N'tản nhiệt nước AIO mẫu 08', NULL, 5670000, 25, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL009', N'DeepCool AK 09', c.Mba_Name, N'DeepCool', N'tản nhiệt khí mẫu 09', NULL, 2150000, 32, N'Tản nhiệt nước AIO / hỗ trợ CPU desktop / quạt PWM', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL010', N'Thermalright Peerless Assassin 10', c.Mba_Name, N'Thermalright', N'tản nhiệt khí mẫu 10', NULL, 4180000, 39, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL011', N'Cooler Master Hyper 11', c.Mba_Name, N'Cooler Master', N'tản nhiệt khí mẫu 11', NULL, 660000, 10, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL012', N'DeepCool LS 12', c.Mba_Name, N'DeepCool', N'tản nhiệt nước AIO mẫu 12', NULL, 2700000, 17, N'Tản nhiệt nước AIO / hỗ trợ CPU desktop / quạt PWM', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL013', N'DeepCool AK 13', c.Mba_Name, N'DeepCool', N'tản nhiệt khí mẫu 13', NULL, 4740000, 24, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL014', N'Thermalright Peerless Assassin 14', c.Mba_Name, N'Thermalright', N'tản nhiệt khí mẫu 14', NULL, 1220000, 31, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL015', N'Cooler Master Hyper 15', c.Mba_Name, N'Cooler Master', N'tản nhiệt khí mẫu 15', NULL, 3250000, 38, N'Tản nhiệt nước AIO / hỗ trợ CPU desktop / quạt PWM', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL016', N'DeepCool LS 16', c.Mba_Name, N'DeepCool', N'tản nhiệt nước AIO mẫu 16', NULL, 5280000, 9, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL017', N'DeepCool AK 17', c.Mba_Name, N'DeepCool', N'tản nhiệt khí mẫu 17', NULL, 1760000, 16, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL018', N'Thermalright Peerless Assassin 18', c.Mba_Name, N'Thermalright', N'tản nhiệt khí mẫu 18', NULL, 3800000, 23, N'Tản nhiệt nước AIO / hỗ trợ CPU desktop / quạt PWM', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL019', N'Cooler Master Hyper 19', c.Mba_Name, N'Cooler Master', N'tản nhiệt khí mẫu 19', NULL, 5840000, 30, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'COOL020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'COOL020', N'DeepCool LS 20', c.Mba_Name, N'DeepCool', N'tản nhiệt nước AIO mẫu 20', NULL, 2320000, 37, N'Tản nhiệt khí / hỗ trợ CPU desktop / quạt PWM', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM011';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON001', N'LG UltraGear 01', c.Mba_Name, N'LG', N'màn hình gaming mẫu 01', NULL, 9720000, 12, N'24 inch / FHD / IPS / 105Hz', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON002', N'ASUS TUF Gaming 02', c.Mba_Name, N'ASUS', N'màn hình gaming mẫu 02', NULL, 16930000, 19, N'24 inch / FHD / IPS / 135Hz', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON003', N'AOC Gaming 03', c.Mba_Name, N'AOC', N'màn hình gaming mẫu 03', NULL, 4450000, 26, N'27 inch / QHD / IPS / 165Hz', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON004', N'Dell UltraSharp 04', c.Mba_Name, N'Dell', N'màn hình đồ họa mẫu 04', NULL, 11660000, 33, N'24 inch / FHD / IPS / 75Hz', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON005', N'Samsung Odyssey 05', c.Mba_Name, N'Samsung', N'màn hình gaming mẫu 05', NULL, 18880000, 40, N'24 inch / FHD / IPS / 105Hz', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON006', N'LG UltraGear 06', c.Mba_Name, N'LG', N'màn hình gaming mẫu 06', NULL, 6400000, 11, N'27 inch / QHD / IPS / 135Hz', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON007', N'ASUS TUF Gaming 07', c.Mba_Name, N'ASUS', N'màn hình gaming mẫu 07', NULL, 13620000, 18, N'24 inch / FHD / IPS / 165Hz', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON008', N'AOC Gaming 08', c.Mba_Name, N'AOC', N'màn hình gaming mẫu 08', NULL, 20830000, 25, N'24 inch / FHD / IPS / 75Hz', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON009', N'Dell UltraSharp 09', c.Mba_Name, N'Dell', N'màn hình đồ họa mẫu 09', NULL, 8350000, 32, N'27 inch / QHD / IPS / 105Hz', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON010', N'Samsung Odyssey 10', c.Mba_Name, N'Samsung', N'màn hình gaming mẫu 10', NULL, 15560000, 39, N'24 inch / FHD / IPS / 135Hz', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON011', N'LG UltraGear 11', c.Mba_Name, N'LG', N'màn hình gaming mẫu 11', NULL, 3080000, 10, N'24 inch / FHD / IPS / 165Hz', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON012', N'ASUS TUF Gaming 12', c.Mba_Name, N'ASUS', N'màn hình gaming mẫu 12', NULL, 10300000, 17, N'27 inch / QHD / IPS / 75Hz', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON013', N'AOC Gaming 13', c.Mba_Name, N'AOC', N'màn hình gaming mẫu 13', NULL, 17520000, 24, N'24 inch / FHD / IPS / 105Hz', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON014', N'Dell UltraSharp 14', c.Mba_Name, N'Dell', N'màn hình đồ họa mẫu 14', NULL, 5040000, 31, N'24 inch / FHD / IPS / 135Hz', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON015', N'Samsung Odyssey 15', c.Mba_Name, N'Samsung', N'màn hình gaming mẫu 15', NULL, 12250000, 38, N'27 inch / QHD / IPS / 165Hz', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON016', N'LG UltraGear 16', c.Mba_Name, N'LG', N'màn hình gaming mẫu 16', NULL, 19460000, 9, N'24 inch / FHD / IPS / 75Hz', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON017', N'ASUS TUF Gaming 17', c.Mba_Name, N'ASUS', N'màn hình gaming mẫu 17', NULL, 6980000, 16, N'24 inch / FHD / IPS / 105Hz', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON018', N'AOC Gaming 18', c.Mba_Name, N'AOC', N'màn hình gaming mẫu 18', NULL, 14200000, 23, N'27 inch / QHD / IPS / 135Hz', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON019', N'Dell UltraSharp 19', c.Mba_Name, N'Dell', N'màn hình đồ họa mẫu 19', NULL, 21420000, 30, N'24 inch / FHD / IPS / 165Hz', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MON020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MON020', N'Samsung Odyssey 20', c.Mba_Name, N'Samsung', N'màn hình gaming mẫu 20', NULL, 8940000, 37, N'24 inch / FHD / IPS / 75Hz', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM012';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD001', N'Keychron K 01', c.Mba_Name, N'Keychron', N'bàn phím cơ mẫu 01', NULL, 2100000, 12, N'87 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD002', N'Logitech K 02', c.Mba_Name, N'Logitech', N'bàn phím wireless mẫu 02', NULL, 3800000, 19, N'104 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD003', N'Razer BlackWidow 03', c.Mba_Name, N'Razer', N'bàn phím gaming mẫu 03', NULL, 860000, 26, N'87 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD004', N'Akko 5075 04', c.Mba_Name, N'Akko', N'bàn phím cơ mẫu 04', NULL, 2560000, 33, N'104 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD005', N'Keychron K 05', c.Mba_Name, N'Keychron', N'bàn phím cơ mẫu 05', NULL, 4260000, 40, N'87 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD006', N'Logitech K 06', c.Mba_Name, N'Logitech', N'bàn phím wireless mẫu 06', NULL, 1320000, 11, N'104 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD007', N'Razer BlackWidow 07', c.Mba_Name, N'Razer', N'bàn phím gaming mẫu 07', NULL, 3020000, 18, N'87 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD008', N'Akko 5075 08', c.Mba_Name, N'Akko', N'bàn phím cơ mẫu 08', NULL, 4720000, 25, N'104 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD009', N'Keychron K 09', c.Mba_Name, N'Keychron', N'bàn phím cơ mẫu 09', NULL, 1780000, 32, N'87 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD010', N'Logitech K 10', c.Mba_Name, N'Logitech', N'bàn phím wireless mẫu 10', NULL, 3480000, 39, N'104 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD011', N'Razer BlackWidow 11', c.Mba_Name, N'Razer', N'bàn phím gaming mẫu 11', NULL, 540000, 10, N'87 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD012', N'Akko 5075 12', c.Mba_Name, N'Akko', N'bàn phím cơ mẫu 12', NULL, 2240000, 17, N'104 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD013', N'Keychron K 13', c.Mba_Name, N'Keychron', N'bàn phím cơ mẫu 13', NULL, 3940000, 24, N'87 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD014', N'Logitech K 14', c.Mba_Name, N'Logitech', N'bàn phím wireless mẫu 14', NULL, 1000000, 31, N'104 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD015', N'Razer BlackWidow 15', c.Mba_Name, N'Razer', N'bàn phím gaming mẫu 15', NULL, 2700000, 38, N'87 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD016', N'Akko 5075 16', c.Mba_Name, N'Akko', N'bàn phím cơ mẫu 16', NULL, 4400000, 9, N'104 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD017', N'Keychron K 17', c.Mba_Name, N'Keychron', N'bàn phím cơ mẫu 17', NULL, 1460000, 16, N'87 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD018', N'Logitech K 18', c.Mba_Name, N'Logitech', N'bàn phím wireless mẫu 18', NULL, 3160000, 23, N'104 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD019', N'Razer BlackWidow 19', c.Mba_Name, N'Razer', N'bàn phím gaming mẫu 19', NULL, 4860000, 30, N'87 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'KBD020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'KBD020', N'Akko 5075 20', c.Mba_Name, N'Akko', N'bàn phím cơ mẫu 20', NULL, 1920000, 37, N'104 phím / switch cơ / kết nối USB hoặc wireless / RGB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM013';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE001', N'Logitech G 01', c.Mba_Name, N'Logitech', N'chuột gaming mẫu 01', NULL, 1640000, 12, N'8 nút / DPI tối đa 12000 / USB hoặc wireless', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE002', N'Razer DeathAdder 02', c.Mba_Name, N'Razer', N'chuột gaming mẫu 02', NULL, 3020000, 19, N'10 nút / DPI tối đa 16000 / USB hoặc wireless', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE003', N'SteelSeries Rival 03', c.Mba_Name, N'SteelSeries', N'chuột gaming mẫu 03', NULL, 620000, 26, N'6 nút / DPI tối đa 20000 / USB hoặc wireless', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE004', N'Logitech MX Master 04', c.Mba_Name, N'Logitech', N'chuột văn phòng mẫu 04', NULL, 2010000, 33, N'8 nút / DPI tối đa 24000 / USB hoặc wireless', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE005', N'Logitech G 05', c.Mba_Name, N'Logitech', N'chuột gaming mẫu 05', NULL, 3400000, 40, N'10 nút / DPI tối đa 8000 / USB hoặc wireless', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE006', N'Razer DeathAdder 06', c.Mba_Name, N'Razer', N'chuột gaming mẫu 06', NULL, 1000000, 11, N'6 nút / DPI tối đa 12000 / USB hoặc wireless', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE007', N'SteelSeries Rival 07', c.Mba_Name, N'SteelSeries', N'chuột gaming mẫu 07', NULL, 2390000, 18, N'8 nút / DPI tối đa 16000 / USB hoặc wireless', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE008', N'Logitech MX Master 08', c.Mba_Name, N'Logitech', N'chuột văn phòng mẫu 08', NULL, 3780000, 25, N'10 nút / DPI tối đa 20000 / USB hoặc wireless', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE009', N'Logitech G 09', c.Mba_Name, N'Logitech', N'chuột gaming mẫu 09', NULL, 1380000, 32, N'6 nút / DPI tối đa 24000 / USB hoặc wireless', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE010', N'Razer DeathAdder 10', c.Mba_Name, N'Razer', N'chuột gaming mẫu 10', NULL, 2760000, 39, N'8 nút / DPI tối đa 8000 / USB hoặc wireless', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE011', N'SteelSeries Rival 11', c.Mba_Name, N'SteelSeries', N'chuột gaming mẫu 11', NULL, 360000, 10, N'10 nút / DPI tối đa 12000 / USB hoặc wireless', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE012', N'Logitech MX Master 12', c.Mba_Name, N'Logitech', N'chuột văn phòng mẫu 12', NULL, 1750000, 17, N'6 nút / DPI tối đa 16000 / USB hoặc wireless', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE013', N'Logitech G 13', c.Mba_Name, N'Logitech', N'chuột gaming mẫu 13', NULL, 3140000, 24, N'8 nút / DPI tối đa 20000 / USB hoặc wireless', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE014', N'Razer DeathAdder 14', c.Mba_Name, N'Razer', N'chuột gaming mẫu 14', NULL, 740000, 31, N'10 nút / DPI tối đa 24000 / USB hoặc wireless', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE015', N'SteelSeries Rival 15', c.Mba_Name, N'SteelSeries', N'chuột gaming mẫu 15', NULL, 2120000, 38, N'6 nút / DPI tối đa 8000 / USB hoặc wireless', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE016', N'Logitech MX Master 16', c.Mba_Name, N'Logitech', N'chuột văn phòng mẫu 16', NULL, 3510000, 9, N'8 nút / DPI tối đa 12000 / USB hoặc wireless', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE017', N'Logitech G 17', c.Mba_Name, N'Logitech', N'chuột gaming mẫu 17', NULL, 1110000, 16, N'10 nút / DPI tối đa 16000 / USB hoặc wireless', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE018', N'Razer DeathAdder 18', c.Mba_Name, N'Razer', N'chuột gaming mẫu 18', NULL, 2500000, 23, N'6 nút / DPI tối đa 20000 / USB hoặc wireless', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE019', N'SteelSeries Rival 19', c.Mba_Name, N'SteelSeries', N'chuột gaming mẫu 19', NULL, 3890000, 30, N'8 nút / DPI tối đa 24000 / USB hoặc wireless', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'MOUSE020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'MOUSE020', N'Logitech MX Master 20', c.Mba_Name, N'Logitech', N'chuột văn phòng mẫu 20', NULL, 1490000, 37, N'10 nút / DPI tối đa 8000 / USB hoặc wireless', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM014';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD001', N'HyperX Cloud 01', c.Mba_Name, N'HyperX', N'tai nghe gaming mẫu 01', NULL, 2540000, 12, N'Driver 50mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD002', N'Razer BlackShark 02', c.Mba_Name, N'Razer', N'tai nghe gaming mẫu 02', NULL, 4570000, 19, N'Driver 60mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD003', N'Logitech G 03', c.Mba_Name, N'Logitech', N'tai nghe gaming mẫu 03', NULL, 1050000, 26, N'Driver 40mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD004', N'Sony WH 04', c.Mba_Name, N'Sony', N'tai nghe không dây mẫu 04', NULL, 3080000, 33, N'Driver 50mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD005', N'HyperX Cloud 05', c.Mba_Name, N'HyperX', N'tai nghe gaming mẫu 05', NULL, 5120000, 40, N'Driver 60mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD006', N'Razer BlackShark 06', c.Mba_Name, N'Razer', N'tai nghe gaming mẫu 06', NULL, 1600000, 11, N'Driver 40mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD007', N'Logitech G 07', c.Mba_Name, N'Logitech', N'tai nghe gaming mẫu 07', NULL, 3640000, 18, N'Driver 50mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD008', N'Sony WH 08', c.Mba_Name, N'Sony', N'tai nghe không dây mẫu 08', NULL, 5670000, 25, N'Driver 60mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD009', N'HyperX Cloud 09', c.Mba_Name, N'HyperX', N'tai nghe gaming mẫu 09', NULL, 2150000, 32, N'Driver 40mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD010', N'Razer BlackShark 10', c.Mba_Name, N'Razer', N'tai nghe gaming mẫu 10', NULL, 4180000, 39, N'Driver 50mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD011', N'Logitech G 11', c.Mba_Name, N'Logitech', N'tai nghe gaming mẫu 11', NULL, 660000, 10, N'Driver 60mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD012', N'Sony WH 12', c.Mba_Name, N'Sony', N'tai nghe không dây mẫu 12', NULL, 2700000, 17, N'Driver 40mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD013', N'HyperX Cloud 13', c.Mba_Name, N'HyperX', N'tai nghe gaming mẫu 13', NULL, 4740000, 24, N'Driver 50mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD014', N'Razer BlackShark 14', c.Mba_Name, N'Razer', N'tai nghe gaming mẫu 14', NULL, 1220000, 31, N'Driver 60mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD015', N'Logitech G 15', c.Mba_Name, N'Logitech', N'tai nghe gaming mẫu 15', NULL, 3250000, 38, N'Driver 40mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD016', N'Sony WH 16', c.Mba_Name, N'Sony', N'tai nghe không dây mẫu 16', NULL, 5280000, 9, N'Driver 50mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD017', N'HyperX Cloud 17', c.Mba_Name, N'HyperX', N'tai nghe gaming mẫu 17', NULL, 1760000, 16, N'Driver 60mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD018', N'Razer BlackShark 18', c.Mba_Name, N'Razer', N'tai nghe gaming mẫu 18', NULL, 3800000, 23, N'Driver 40mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD019', N'Logitech G 19', c.Mba_Name, N'Logitech', N'tai nghe gaming mẫu 19', NULL, 5840000, 30, N'Driver 50mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'HEAD020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'HEAD020', N'Sony WH 20', c.Mba_Name, N'Sony', N'tai nghe không dây mẫu 20', NULL, 2320000, 37, N'Driver 60mm / microphone / USB hoặc 3.5mm / âm thanh stereo', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM015';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM001', N'Logitech C 01', c.Mba_Name, N'Logitech', N'webcam mẫu 01', NULL, 2160000, 12, N'1080p / 30FPS / microphone kép / USB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM002', N'Razer Kiyo 02', c.Mba_Name, N'Razer', N'webcam streaming mẫu 02', NULL, 3830000, 19, N'1080p / 60FPS / microphone kép / USB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM003', N'AverMedia PW 03', c.Mba_Name, N'AverMedia', N'webcam mẫu 03', NULL, 950000, 26, N'1080p / 30FPS / microphone kép / USB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM004', N'Rapoo C 04', c.Mba_Name, N'Rapoo', N'webcam mẫu 04', NULL, 2620000, 33, N'1080p / 60FPS / microphone kép / USB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM005', N'Logitech C 05', c.Mba_Name, N'Logitech', N'webcam mẫu 05', NULL, 4280000, 40, N'1080p / 30FPS / microphone kép / USB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM006', N'Razer Kiyo 06', c.Mba_Name, N'Razer', N'webcam streaming mẫu 06', NULL, 1400000, 11, N'1080p / 60FPS / microphone kép / USB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM007', N'AverMedia PW 07', c.Mba_Name, N'AverMedia', N'webcam mẫu 07', NULL, 3060000, 18, N'1080p / 30FPS / microphone kép / USB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM008', N'Rapoo C 08', c.Mba_Name, N'Rapoo', N'webcam mẫu 08', NULL, 4730000, 25, N'1080p / 60FPS / microphone kép / USB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM009', N'Logitech C 09', c.Mba_Name, N'Logitech', N'webcam mẫu 09', NULL, 1850000, 32, N'1080p / 30FPS / microphone kép / USB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM010', N'Razer Kiyo 10', c.Mba_Name, N'Razer', N'webcam streaming mẫu 10', NULL, 3520000, 39, N'1080p / 60FPS / microphone kép / USB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM011', N'AverMedia PW 11', c.Mba_Name, N'AverMedia', N'webcam mẫu 11', NULL, 640000, 10, N'1080p / 30FPS / microphone kép / USB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM012', N'Rapoo C 12', c.Mba_Name, N'Rapoo', N'webcam mẫu 12', NULL, 2300000, 17, N'1080p / 60FPS / microphone kép / USB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM013', N'Logitech C 13', c.Mba_Name, N'Logitech', N'webcam mẫu 13', NULL, 3960000, 24, N'1080p / 30FPS / microphone kép / USB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM014', N'Razer Kiyo 14', c.Mba_Name, N'Razer', N'webcam streaming mẫu 14', NULL, 1080000, 31, N'1080p / 60FPS / microphone kép / USB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM015', N'AverMedia PW 15', c.Mba_Name, N'AverMedia', N'webcam mẫu 15', NULL, 2750000, 38, N'1080p / 30FPS / microphone kép / USB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM016', N'Rapoo C 16', c.Mba_Name, N'Rapoo', N'webcam mẫu 16', NULL, 4420000, 9, N'1080p / 60FPS / microphone kép / USB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM017', N'Logitech C 17', c.Mba_Name, N'Logitech', N'webcam mẫu 17', NULL, 1540000, 16, N'1080p / 30FPS / microphone kép / USB', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM018', N'Razer Kiyo 18', c.Mba_Name, N'Razer', N'webcam streaming mẫu 18', NULL, 3200000, 23, N'1080p / 60FPS / microphone kép / USB', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM019', N'AverMedia PW 19', c.Mba_Name, N'AverMedia', N'webcam mẫu 19', NULL, 4860000, 30, N'1080p / 30FPS / microphone kép / USB', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'CAM020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'CAM020', N'Rapoo C 20', c.Mba_Name, N'Rapoo', N'webcam mẫu 20', NULL, 1980000, 37, N'1080p / 60FPS / microphone kép / USB', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM016';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET001')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET001', N'TP-Link Archer 01', c.Mba_Name, N'TP-Link', N'router Wi-Fi mẫu 01', NULL, 2810000, 12, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET002')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET002', N'ASUS RT 02', c.Mba_Name, N'ASUS', N'router Wi-Fi mẫu 02', NULL, 5270000, 19, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET003')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET003', N'Tenda AC 03', c.Mba_Name, N'Tenda', N'router Wi-Fi mẫu 03', NULL, 1020000, 26, N'Wi-Fi 5 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET004')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET004', N'TP-Link TL-SG 04', c.Mba_Name, N'TP-Link', N'switch mạng mẫu 04', NULL, 3480000, 33, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET005')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET005', N'Intel Wi-Fi 05', c.Mba_Name, N'Intel', N'card mạng Wi-Fi mẫu 05', NULL, 5940000, 40, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET006')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET006', N'TP-Link Archer 06', c.Mba_Name, N'TP-Link', N'router Wi-Fi mẫu 06', NULL, 1680000, 11, N'Wi-Fi 5 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET007')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET007', N'ASUS RT 07', c.Mba_Name, N'ASUS', N'router Wi-Fi mẫu 07', NULL, 4140000, 18, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET008')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET008', N'Tenda AC 08', c.Mba_Name, N'Tenda', N'router Wi-Fi mẫu 08', NULL, 6600000, 25, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET009')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET009', N'TP-Link TL-SG 09', c.Mba_Name, N'TP-Link', N'switch mạng mẫu 09', NULL, 2340000, 32, N'Wi-Fi 5 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET010')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET010', N'Intel Wi-Fi 10', c.Mba_Name, N'Intel', N'card mạng Wi-Fi mẫu 10', NULL, 4810000, 39, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET011')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET011', N'TP-Link Archer 11', c.Mba_Name, N'TP-Link', N'router Wi-Fi mẫu 11', NULL, 550000, 10, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET012')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET012', N'ASUS RT 12', c.Mba_Name, N'ASUS', N'router Wi-Fi mẫu 12', NULL, 3010000, 17, N'Wi-Fi 5 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET013')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET013', N'Tenda AC 13', c.Mba_Name, N'Tenda', N'router Wi-Fi mẫu 13', NULL, 5470000, 24, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET014')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET014', N'TP-Link TL-SG 14', c.Mba_Name, N'TP-Link', N'switch mạng mẫu 14', NULL, 1210000, 31, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET015')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET015', N'Intel Wi-Fi 15', c.Mba_Name, N'Intel', N'card mạng Wi-Fi mẫu 15', NULL, 3680000, 38, N'Wi-Fi 5 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET016')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET016', N'TP-Link Archer 16', c.Mba_Name, N'TP-Link', N'router Wi-Fi mẫu 16', NULL, 6140000, 9, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET017')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET017', N'ASUS RT 17', c.Mba_Name, N'ASUS', N'router Wi-Fi mẫu 17', NULL, 1880000, 16, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Chờ rà soát'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET018')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET018', N'Tenda AC 18', c.Mba_Name, N'Tenda', N'router Wi-Fi mẫu 18', NULL, 4340000, 23, N'Wi-Fi 5 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Đang xử lý'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET019')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET019', N'TP-Link TL-SG 19', c.Mba_Name, N'TP-Link', N'switch mạng mẫu 19', NULL, 6800000, 30, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Đã hoàn tất'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Products WHERE Mba_Code = N'NET020')
BEGIN
    INSERT INTO dbo.Mba_Products (Mba_CategoryId, Mba_Code, Mba_Name, Mba_Category, Mba_Brand, Mba_Description, Mba_ImageUrl, Mba_Price, Mba_Quantity, Mba_TechnicalInfo, Mba_DataStatus)
    SELECT c.Mba_Id, N'NET020', N'Intel Wi-Fi 20', c.Mba_Name, N'Intel', N'card mạng Wi-Fi mẫu 20', NULL, 2540000, 37, N'Wi-Fi 6 / Gigabit LAN / nhiều thiết bị / quản lý qua web', N'Cần báo lại'
    FROM dbo.Mba_Categories c WHERE c.Mba_Code = N'DM017';
END
GO
-- Đồng bộ Mba_CategoryId và tên danh mục theo mã sản phẩm
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'PC%' AND c.Mba_Code = N'DM001';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'LAP%' AND c.Mba_Code = N'DM002';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'CPU%' AND c.Mba_Code = N'DM003';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'RAM%' AND c.Mba_Code = N'DM004';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'VGA%' AND c.Mba_Code = N'DM005';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'SSD%' AND c.Mba_Code = N'DM006';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'HDD%' AND c.Mba_Code = N'DM007';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'MB%' AND c.Mba_Code = N'DM008';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'PSU%' AND c.Mba_Code = N'DM009';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'CASE%' AND c.Mba_Code = N'DM010';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'COOL%' AND c.Mba_Code = N'DM011';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'MON%' AND c.Mba_Code = N'DM012';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'KBD%' AND c.Mba_Code = N'DM013';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'MOUSE%' AND c.Mba_Code = N'DM014';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'HEAD%' AND c.Mba_Code = N'DM015';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'CAM%' AND c.Mba_Code = N'DM016';
GO
UPDATE p SET p.Mba_CategoryId = c.Mba_Id, p.Mba_Category = c.Mba_Name FROM dbo.Mba_Products p CROSS JOIN dbo.Mba_Categories c WHERE p.Mba_Code LIKE N'NET%' AND c.Mba_Code = N'DM017';
GO
-- Tạo phiếu rà soát cho toàn bộ sản phẩm chưa có
INSERT INTO dbo.Mba_Reviews (Mba_ProductId, Mba_Status, Mba_CheckedItems, Mba_TotalItems, Mba_SourceNote, Mba_ReviewNote)
SELECT p.Mba_Id, N'Chờ rà soát', 0, 5, N'Phiếu giấy do quản lý bàn giao', N''
FROM dbo.Mba_Products p
LEFT JOIN dbo.Mba_Reviews r ON r.Mba_ProductId = p.Mba_Id
WHERE r.Mba_Id IS NULL;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'phamduclong')
BEGIN
    INSERT INTO dbo.Mba_Accounts (Mba_Username, Mba_PasswordHash, Mba_Role, Mba_IsActive) VALUES (N'phamduclong', N'PBKDF2$100000$jypMbZ4RM1V3qiLMRN2ImQ==$T8taluTz6p3FrV2HpwivZ27xzD4tNPd/hGEB8ZaIF7c=', N'Employee', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Employees WHERE Mba_AccountId = (SELECT Mba_Id FROM dbo.Mba_Accounts WHERE Mba_Username = N'phamduclong'))
BEGIN
    INSERT INTO dbo.Mba_Employees (Mba_AccountId, Mba_FullName, Mba_Email, Mba_Phone, Mba_IsActive) SELECT Mba_Id, N'Phạm Đức Long', N'phamduclong@mba-pc.local', N'0901000004', 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'phamduclong';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'dominhkhang')
BEGIN
    INSERT INTO dbo.Mba_Accounts (Mba_Username, Mba_PasswordHash, Mba_Role, Mba_IsActive) VALUES (N'dominhkhang', N'PBKDF2$100000$jypMbZ4RM1V3qiLMRN2ImQ==$T8taluTz6p3FrV2HpwivZ27xzD4tNPd/hGEB8ZaIF7c=', N'Employee', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Employees WHERE Mba_AccountId = (SELECT Mba_Id FROM dbo.Mba_Accounts WHERE Mba_Username = N'dominhkhang'))
BEGIN
    INSERT INTO dbo.Mba_Employees (Mba_AccountId, Mba_FullName, Mba_Email, Mba_Phone, Mba_IsActive) SELECT Mba_Id, N'Đỗ Minh Khang', N'dominhkhang@mba-pc.local', N'0901000005', 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'dominhkhang';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'nguyenhoangphuc')
BEGIN
    INSERT INTO dbo.Mba_Accounts (Mba_Username, Mba_PasswordHash, Mba_Role, Mba_IsActive) VALUES (N'nguyenhoangphuc', N'PBKDF2$100000$jypMbZ4RM1V3qiLMRN2ImQ==$T8taluTz6p3FrV2HpwivZ27xzD4tNPd/hGEB8ZaIF7c=', N'Employee', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Employees WHERE Mba_AccountId = (SELECT Mba_Id FROM dbo.Mba_Accounts WHERE Mba_Username = N'nguyenhoangphuc'))
BEGIN
    INSERT INTO dbo.Mba_Employees (Mba_AccountId, Mba_FullName, Mba_Email, Mba_Phone, Mba_IsActive) SELECT Mba_Id, N'Nguyễn Hoàng Phúc', N'nguyenhoangphuc@mba-pc.local', N'0901000006', 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'nguyenhoangphuc';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'vuanhtuan')
BEGIN
    INSERT INTO dbo.Mba_Accounts (Mba_Username, Mba_PasswordHash, Mba_Role, Mba_IsActive) VALUES (N'vuanhtuan', N'PBKDF2$100000$jypMbZ4RM1V3qiLMRN2ImQ==$T8taluTz6p3FrV2HpwivZ27xzD4tNPd/hGEB8ZaIF7c=', N'Employee', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Employees WHERE Mba_AccountId = (SELECT Mba_Id FROM dbo.Mba_Accounts WHERE Mba_Username = N'vuanhtuan'))
BEGIN
    INSERT INTO dbo.Mba_Employees (Mba_AccountId, Mba_FullName, Mba_Email, Mba_Phone, Mba_IsActive) SELECT Mba_Id, N'Vũ Anh Tuấn', N'vuanhtuan@mba-pc.local', N'0901000007', 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'vuanhtuan';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'buigiahung')
BEGIN
    INSERT INTO dbo.Mba_Accounts (Mba_Username, Mba_PasswordHash, Mba_Role, Mba_IsActive) VALUES (N'buigiahung', N'PBKDF2$100000$jypMbZ4RM1V3qiLMRN2ImQ==$T8taluTz6p3FrV2HpwivZ27xzD4tNPd/hGEB8ZaIF7c=', N'Employee', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Employees WHERE Mba_AccountId = (SELECT Mba_Id FROM dbo.Mba_Accounts WHERE Mba_Username = N'buigiahung'))
BEGIN
    INSERT INTO dbo.Mba_Employees (Mba_AccountId, Mba_FullName, Mba_Email, Mba_Phone, Mba_IsActive) SELECT Mba_Id, N'Bùi Gia Hưng', N'buigiahung@mba-pc.local', N'0901000008', 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'buigiahung';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'phanminhduc')
BEGIN
    INSERT INTO dbo.Mba_Accounts (Mba_Username, Mba_PasswordHash, Mba_Role, Mba_IsActive) VALUES (N'phanminhduc', N'PBKDF2$100000$jypMbZ4RM1V3qiLMRN2ImQ==$T8taluTz6p3FrV2HpwivZ27xzD4tNPd/hGEB8ZaIF7c=', N'Employee', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Employees WHERE Mba_AccountId = (SELECT Mba_Id FROM dbo.Mba_Accounts WHERE Mba_Username = N'phanminhduc'))
BEGIN
    INSERT INTO dbo.Mba_Employees (Mba_AccountId, Mba_FullName, Mba_Email, Mba_Phone, Mba_IsActive) SELECT Mba_Id, N'Phan Minh Đức', N'phanminhduc@mba-pc.local', N'0901000009', 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'phanminhduc';
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'hoangquocviet')
BEGIN
    INSERT INTO dbo.Mba_Accounts (Mba_Username, Mba_PasswordHash, Mba_Role, Mba_IsActive) VALUES (N'hoangquocviet', N'PBKDF2$100000$jypMbZ4RM1V3qiLMRN2ImQ==$T8taluTz6p3FrV2HpwivZ27xzD4tNPd/hGEB8ZaIF7c=', N'Employee', 1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Mba_Employees WHERE Mba_AccountId = (SELECT Mba_Id FROM dbo.Mba_Accounts WHERE Mba_Username = N'hoangquocviet'))
BEGIN
    INSERT INTO dbo.Mba_Employees (Mba_AccountId, Mba_FullName, Mba_Email, Mba_Phone, Mba_IsActive) SELECT Mba_Id, N'Hoàng Quốc Việt', N'hoangquocviet@mba-pc.local', N'0901000010', 1 FROM dbo.Mba_Accounts WHERE Mba_Username = N'hoangquocviet';
END
GO
GO

-- Kiểm tra số lượng sau khi mở rộng
SELECT 'Mba_Categories' AS TableName, COUNT(*) AS TotalRows FROM dbo.Mba_Categories
UNION ALL SELECT 'Mba_Products', COUNT(*) FROM dbo.Mba_Products
UNION ALL SELECT 'Mba_Reviews', COUNT(*) FROM dbo.Mba_Reviews
UNION ALL SELECT 'Mba_Accounts', COUNT(*) FROM dbo.Mba_Accounts
UNION ALL SELECT 'Mba_Employees', COUNT(*) FROM dbo.Mba_Employees;
GO
SELECT c.Mba_Code, c.Mba_Name, COUNT(p.Mba_Id) AS ProductCount FROM dbo.Mba_Categories c LEFT JOIN dbo.Mba_Products p ON p.Mba_CategoryId=c.Mba_Id GROUP BY c.Mba_Code,c.Mba_Name ORDER BY c.Mba_Code;
GO
