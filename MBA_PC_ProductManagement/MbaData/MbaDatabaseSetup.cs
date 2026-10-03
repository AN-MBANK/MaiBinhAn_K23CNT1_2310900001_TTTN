using Microsoft.EntityFrameworkCore;

namespace MBA_PC_ProductManagement.MbaData
{
    public static class MbaDatabaseSetup
    {
        public static void MbaEnsureWorkflowColumns(MbaAppDbContext db)
        {
            var sql = @"
IF OBJECT_ID(N'dbo.Categories', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Categories', N'U') IS NULL EXEC sp_rename N'dbo.Categories', N'Mba_Categories';
IF OBJECT_ID(N'dbo.Products', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Products', N'U') IS NULL EXEC sp_rename N'dbo.Products', N'Mba_Products';
IF OBJECT_ID(N'dbo.Reviews', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Reviews', N'U') IS NULL EXEC sp_rename N'dbo.Reviews', N'Mba_Reviews';
IF OBJECT_ID(N'dbo.Accounts', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Accounts', N'U') IS NULL EXEC sp_rename N'dbo.Accounts', N'Mba_Accounts';
IF OBJECT_ID(N'dbo.Admins', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Admins', N'U') IS NULL EXEC sp_rename N'dbo.Admins', N'Mba_Admins';
IF OBJECT_ID(N'dbo.Employees', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Employees', N'U') IS NULL EXEC sp_rename N'dbo.Employees', N'Mba_Employees';
IF OBJECT_ID(N'dbo.MbaCategories', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Categories', N'U') IS NULL EXEC sp_rename N'dbo.MbaCategories', N'Mba_Categories';
IF OBJECT_ID(N'dbo.MbaProducts', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Products', N'U') IS NULL EXEC sp_rename N'dbo.MbaProducts', N'Mba_Products';
IF OBJECT_ID(N'dbo.MbaReviews', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Reviews', N'U') IS NULL EXEC sp_rename N'dbo.MbaReviews', N'Mba_Reviews';
IF OBJECT_ID(N'dbo.MbaAccounts', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Accounts', N'U') IS NULL EXEC sp_rename N'dbo.MbaAccounts', N'Mba_Accounts';
IF OBJECT_ID(N'dbo.MbaAdmins', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Admins', N'U') IS NULL EXEC sp_rename N'dbo.MbaAdmins', N'Mba_Admins';
IF OBJECT_ID(N'dbo.MbaEmployees', N'U') IS NOT NULL AND OBJECT_ID(N'dbo.Mba_Employees', N'U') IS NULL EXEC sp_rename N'dbo.MbaEmployees', N'Mba_Employees';

DECLARE @R TABLE(T sysname,O sysname,N sysname);
INSERT INTO @R VALUES
(N'Mba_Categories',N'Id',N'Mba_Id'),(N'Mba_Categories',N'Code',N'Mba_Code'),(N'Mba_Categories',N'Name',N'Mba_Name'),(N'Mba_Categories',N'Description',N'Mba_Description'),(N'Mba_Categories',N'IsActive',N'Mba_IsActive'),
(N'Mba_Products',N'Id',N'Mba_Id'),(N'Mba_Products',N'CategoryId',N'Mba_CategoryId'),(N'Mba_Products',N'Code',N'Mba_Code'),(N'Mba_Products',N'Name',N'Mba_Name'),(N'Mba_Products',N'Category',N'Mba_Category'),(N'Mba_Products',N'Brand',N'Mba_Brand'),(N'Mba_Products',N'Description',N'Mba_Description'),(N'Mba_Products',N'ImageUrl',N'Mba_ImageUrl'),(N'Mba_Products',N'Price',N'Mba_Price'),(N'Mba_Products',N'Quantity',N'Mba_Quantity'),(N'Mba_Products',N'TechnicalInfo',N'Mba_TechnicalInfo'),(N'Mba_Products',N'DataStatus',N'Mba_DataStatus'),
(N'Mba_Accounts',N'Id',N'Mba_Id'),(N'Mba_Accounts',N'Username',N'Mba_Username'),(N'Mba_Accounts',N'PasswordHash',N'Mba_PasswordHash'),(N'Mba_Accounts',N'Role',N'Mba_Role'),(N'Mba_Accounts',N'IsActive',N'Mba_IsActive'),(N'Mba_Accounts',N'CreatedAt',N'Mba_CreatedAt'),
(N'Mba_Admins',N'Id',N'Mba_Id'),(N'Mba_Admins',N'AccountId',N'Mba_AccountId'),(N'Mba_Admins',N'FullName',N'Mba_FullName'),(N'Mba_Admins',N'Email',N'Mba_Email'),(N'Mba_Admins',N'Phone',N'Mba_Phone'),(N'Mba_Admins',N'AvatarUrl',N'Mba_AvatarUrl'),
(N'Mba_Employees',N'Id',N'Mba_Id'),(N'Mba_Employees',N'AccountId',N'Mba_AccountId'),(N'Mba_Employees',N'FullName',N'Mba_FullName'),(N'Mba_Employees',N'Email',N'Mba_Email'),(N'Mba_Employees',N'Phone',N'Mba_Phone'),(N'Mba_Employees',N'AvatarUrl',N'Mba_AvatarUrl'),(N'Mba_Employees',N'IsActive',N'Mba_IsActive'),
(N'Mba_Reviews',N'Id',N'Mba_Id'),(N'Mba_Reviews',N'ProductId',N'Mba_ProductId'),(N'Mba_Reviews',N'Status',N'Mba_Status'),(N'Mba_Reviews',N'CheckedItems',N'Mba_CheckedItems'),(N'Mba_Reviews',N'TotalItems',N'Mba_TotalItems'),(N'Mba_Reviews',N'SourceNote',N'Mba_SourceNote'),(N'Mba_Reviews',N'ReviewNote',N'Mba_ReviewNote'),(N'Mba_Reviews',N'EmployeeId',N'Mba_EmployeeId'),(N'Mba_Reviews',N'AssignedAt',N'Mba_AssignedAt'),(N'Mba_Reviews',N'Deadline',N'Mba_Deadline'),(N'Mba_Reviews',N'ClosedAt',N'Mba_ClosedAt'),(N'Mba_Reviews',N'IsLocked',N'Mba_IsLocked'),(N'Mba_Reviews',N'IsOverdue',N'Mba_IsOverdue');
DECLARE @T sysname,@O sysname,@N sysname,@S nvarchar(4000);
DECLARE C CURSOR LOCAL FAST_FORWARD FOR SELECT T,O,N FROM @R; OPEN C; FETCH NEXT FROM C INTO @T,@O,@N;
WHILE @@FETCH_STATUS=0 BEGIN
 IF OBJECT_ID(N'dbo.'+@T,N'U') IS NOT NULL AND COL_LENGTH(N'dbo.'+@T,@O) IS NOT NULL AND COL_LENGTH(N'dbo.'+@T,@N) IS NULL BEGIN
  SET @S=N'EXEC sp_rename N''dbo.'+@T+N'.'+@O+N''', N'''+@N+N''', N''COLUMN'';'; EXEC sp_executesql @S;
 END
 FETCH NEXT FROM C INTO @T,@O,@N;
END
CLOSE C; DEALLOCATE C;

IF OBJECT_ID(N'dbo.Mba_Reviews', N'U') IS NOT NULL
BEGIN
    IF COL_LENGTH('dbo.Mba_Reviews', 'Mba_AssignedAt') IS NULL ALTER TABLE dbo.Mba_Reviews ADD Mba_AssignedAt datetime2 NULL;
    IF COL_LENGTH('dbo.Mba_Reviews', 'Mba_Deadline') IS NULL ALTER TABLE dbo.Mba_Reviews ADD Mba_Deadline datetime2 NULL;
    IF COL_LENGTH('dbo.Mba_Reviews', 'Mba_ClosedAt') IS NULL ALTER TABLE dbo.Mba_Reviews ADD Mba_ClosedAt datetime2 NULL;
    IF COL_LENGTH('dbo.Mba_Reviews', 'Mba_IsLocked') IS NULL ALTER TABLE dbo.Mba_Reviews ADD Mba_IsLocked bit NOT NULL CONSTRAINT DF_Mba_Reviews_Mba_IsLocked DEFAULT (0);
    IF COL_LENGTH('dbo.Mba_Reviews', 'Mba_IsOverdue') IS NULL ALTER TABLE dbo.Mba_Reviews ADD Mba_IsOverdue bit NOT NULL CONSTRAINT DF_Mba_Reviews_Mba_IsOverdue DEFAULT (0);
    UPDATE dbo.Mba_Reviews SET Mba_AssignedAt = ISNULL(Mba_AssignedAt, GETDATE()), Mba_Deadline = ISNULL(Mba_Deadline, DATEADD(day, 1, GETDATE())) WHERE Mba_EmployeeId IS NOT NULL AND Mba_IsLocked = 0;
END
";
            db.Database.ExecuteSqlRaw(sql);
        }
    }
}
