

-- Crear SigemAdmin
CREATE DATABASE db_sigemadmin COLLATE Modern_Spanish_CI_AS;
GO

USE db_sigemadmin;
GO

CREATE LOGIN sigemadmin WITH PASSWORD='passw0rd', DEFAULT_DATABASE=db_sigemadmin, CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;
GO

CREATE USER sigemadmin FOR LOGIN sigemadmin;
GO

GRANT ALTER To sigemadmin;
GO

GRANT CONTROL To sigemadmin;
GO



-- Crear fwktd_dir3
CREATE DATABASE db_fwktd_dir3  COLLATE Modern_Spanish_CI_AS;
GO

USE db_fwktd_dir3;
GO

CREATE LOGIN fwktd_dir3  WITH PASSWORD='passw0rd', DEFAULT_DATABASE=db_fwktd_dir3, CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;
GO

CREATE USER fwktd_dir3  FOR LOGIN fwktd_dir3 ;
GO

GRANT ALTER To fwktd_dir3 ;
GO

GRANT CONTROL To fwktd_dir3 ;
GO



quit


