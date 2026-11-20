/* 1. CREACIÓN OBLIGATORIA DE LOS USUARIOS */
CREATE USER IF NOT EXISTS 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
CREATE USER IF NOT EXISTS 'dorian.barrios'@'%' IDENTIFIED BY '240065';
CREATE USER IF NOT EXISTS 'angel.hernandez'@'%' IDENTIFIED BY '240492';
CREATE USER IF NOT EXISTS 'luis.hernandez'@'%' IDENTIFIED BY '240492';
CREATE USER IF NOT EXISTS 'jorge.eloy'@'%' IDENTIFIED BY '240456';
CREATE USER IF NOT EXISTS 'yaneth.garrido'@'%' IDENTIFIED BY '240629';
CREATE USER IF NOT EXISTS 'maestro'@'%' IDENTIFIED BY 'Password123!';

/* USUARIOS MIDDLEWARE */
CREATE USER IF NOT EXISTS 'app_web'@'%' IDENTIFIED BY 'Web123';
CREATE USER IF NOT EXISTS 'app_mobile'@'%' IDENTIFIED BY 'Mobile123';

/* 2. ASIGNACIÓN DE PRIVILEGIOS DIRECTOS A USUARIOS */
GRANT ALL PRIVILEGES ON *.* TO 'dorian.barrios'@'%';

USE db_test_7b;

GRANT SELECT, INSERT, UPDATE, DELETE ON db_test_7b.* TO 'luis.hernandez'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_test_7b.* TO 'yaneth.garrido'@'%';

/* 3. CREACION DE ROLES PARA EL SISTEMA DE ECOMMERCE */
CREATE ROLE IF NOT EXISTS 'superadmin';
CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'support';
CREATE ROLE IF NOT EXISTS 'common';
CREATE ROLE IF NOT EXISTS 'user_not_registered';

/* 4. ASIGNAR PRIVILEGIOS A LOS ROLES CREADOS */
GRANT ALL PRIVILEGES ON *.* TO 'superadmin';
GRANT ALL PRIVILEGES ON db_test_7b.* TO 'admin';

GRANT SELECT, INSERT, UPDATE, DELETE ON db_test_7b.* TO 'support';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_test_7b.* TO 'seller';

/* NOT REGISTERED (Asignación correcta de permisos al ROL) */
GRANT USAGE ON *.* TO 'user_not_registered'; -- Permite al rol ver la estructura en la barra lateral
GRANT INSERT ON db_test_7b.tb_users TO 'user_not_registered';
GRANT INSERT ON db_test_7b.tb_people TO 'user_not_registered';
GRANT EXECUTE ON PROCEDURE db_test_7b.sp_register_new_user TO 'user_not_registered';

-- SOLUCIÓN COMPAÑERO: Permiso directo de ejecución a los usuarios para evitar error de rutina bloqueada
GRANT EXECUTE ON PROCEDURE db_test_7b.sp_register_new_user TO 'app_web'@'%';
GRANT EXECUTE ON PROCEDURE db_test_7b.sp_register_new_user TO 'app_mobile'@'%';

/* 5. ASIGNAR ROLES A LOS USUARIOS CREADOS */
GRANT 'superadmin' TO 'dorian.barrios'@'%';
GRANT 'admin' TO 'marco.ramirez'@'%';
GRANT 'support' TO 'angel.hernandez'@'%';
GRANT 'seller' TO 'luis.hernandez'@'%';
GRANT 'seller' TO 'jorge.eloy'@'%';
GRANT 'user_not_registered' TO 'app_web'@'%';
GRANT 'user_not_registered' TO 'app_mobile'@'%';

/* 6. ACTIVACIÓN AUTOMÁTICA DE ROLES AL INICIAR SESIÓN */
SET DEFAULT ROLE 'admin' TO 'marco.ramirez'@'%';
SET DEFAULT ROLE 'support' TO 'angel.hernandez'@'%';
SET DEFAULT ROLE 'seller' TO 'luis.hernandez'@'%';
SET DEFAULT ROLE 'seller' TO 'jorge.eloy'@'%';
SET DEFAULT ROLE 'user_not_registered' TO 'app_web'@'%';
SET DEFAULT ROLE 'user_not_registered' TO 'app_mobile'@'%';

/* Mostrar mensaje de éxito */
SELECT "Los usuarios, roles y privilegios han sido creados correctamente" AS mensaje;

/* Aplicar cambios */
FLUSH PRIVILEGES;