DECLARE @dbName SYSNAME;
DECLARE @sql NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT name FROM sys.databases
WHERE name IN ('Unity_Collections', 'Unity_Proposal', 'Unity_DMS', 'Unity_S3CUSTDB', 'Unity_S3DB01');

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @dbName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = N'
    USE ' + QUOTENAME(@dbName) + ';

    -- Create user if not exists
    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = ''localuser'')
    BEGIN
        CREATE USER [localuser] FOR LOGIN [localuser];
    END

    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = ''sage200users'')
    BEGIN
        CREATE USER [sage200users] FOR LOGIN [sage200users];
    END

    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = ''datagateway'')
    BEGIN
        CREATE USER [datagateway] FOR LOGIN [datagateway];
    END

    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = ''dsgfs\it'')
    BEGIN
        CREATE USER [dsgfs\it] FOR LOGIN [dsgfs\it];
    END

    -- Add role memberships
    EXEC sp_addrolemember ''db_owner'', ''localuser'';
    EXEC sp_addrolemember ''db_datareader'', ''sage200users'';
    EXEC sp_addrolemember ''db_datareader'', ''datagateway'';
    EXEC sp_addrolemember ''db_datareader'', ''dsgfs\it'';
    ';

    EXEC sp_executesql @sql;

    FETCH NEXT FROM db_cursor INTO @dbName;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;
