USE Master;

-- COLLECTIONS
ALTER DATABASE [Unity_Collections] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [Unity_Collections] FROM  
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Collections__00.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Collections__01.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Collections__02.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Collections__03.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Collections__04.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Collections__05.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Collections__06.bak'
WITH FILE = 1,  
    MOVE N'Baseline_Collections' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Data\Unity_Collections_1.mdf',  
    MOVE N'Baseline_Collections_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Data\Unity_Collections_2.LDF',  
    NOUNLOAD, REPLACE, STATS = 5;  
ALTER DATABASE [Unity_Collections] SET MULTI_USER;
GO

-- PROPOSALS
ALTER DATABASE [Unity_Proposal] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [Unity_Proposal] FROM  
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Proposal__00.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Proposal__01.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Proposal__02.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Proposal__03.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Proposal__04.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Proposal__05.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_Proposal__06.bak'
WITH FILE = 1,  
    MOVE N'Baseline_Proposal' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Data\Unity_Proposal_1.mdf',  
    MOVE N'Baseline_Proposal_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Data\Unity_Proposal_2.LDF',  
    NOUNLOAD, REPLACE, STATS = 5;  
ALTER DATABASE [Unity_Proposal] SET MULTI_USER;
GO

-- DMS
ALTER DATABASE [Unity_DMS] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [Unity_DMS] FROM  
    DISK = N'$(BackupPath)\FULL_(local)_Unity_DMS__00.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_DMS__01.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_DMS__02.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_DMS__03.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_DMS__04.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_DMS__05.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_DMS__06.bak'
WITH FILE = 1,  
    MOVE N'Baseline_DMS' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Data\Unity_DMS_1.mdf',  
    MOVE N'Baseline_DMS_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Data\Unity_DMS_2.LDF',  
    NOUNLOAD, REPLACE, STATS = 5;  
ALTER DATABASE [Unity_DMS] SET MULTI_USER;
GO

-- S3CUSTDB
ALTER DATABASE [Unity_S3CUSTDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [Unity_S3CUSTDB] FROM  
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3CUSTDB__00.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3CUSTDB__01.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3CUSTDB__02.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3CUSTDB__03.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3CUSTDB__04.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3CUSTDB__05.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3CUSTDB__06.bak'
WITH FILE = 1,  
    MOVE N'Baseline_S3CUSTDB' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Data\Unity_S3CUSTDB_1.mdf',  
    MOVE N'Baseline_S3CUSTDB_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Data\Unity_S3CUSTDB_2.LDF',  
    NOUNLOAD, REPLACE, STATS = 5;  
ALTER DATABASE [Unity_S3CUSTDB] SET MULTI_USER;
GO

-- S3DB01
ALTER DATABASE [Unity_S3DB01] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [Unity_S3DB01] FROM  
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3DB01__00.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3DB01__01.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3DB01__02.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3DB01__03.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3DB01__04.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3DB01__05.bak',
    DISK = N'$(BackupPath)\FULL_(local)_Unity_S3DB01__06.bak'
WITH FILE = 1,  
    MOVE N'Baseline_S3DB01' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Data\Unity_S3DB01_1.mdf',  
    MOVE N'Baseline_S3DB01_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Data\Unity_S3DB01_2.LDF',  
    NOUNLOAD, REPLACE, STATS = 5;  
ALTER DATABASE [Unity_S3DB01] SET MULTI_USER;
GO
