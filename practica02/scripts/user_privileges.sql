/* Creasion de usuarios remotos */
CREATE USER IF NOT EXISTS 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
CREATE USER IF NOT EXISTS 'dorian.barrios'@'%' IDENTIFIED BY '240065';
CREATE USER IF NOT EXISTS 'angel.hernandez'@'%' IDENTIFIED BY '240492';
CREATE USER IF NOT EXISTS 'luis.hernandez'@'%' IDENTIFIED BY '240492';
CREATE USER IF NOT EXISTS 'jorge.eloy'@'%' IDENTIFIED BY '240456';
CREATE USER IF NOT EXISTS 'yaneth.garrido'@'%' IDENTIFIED BY '240629';


/* Asignar los privilegios de super usuario */
GRANT ALL PRIVILEGES ON *.* TO 'dorian.barrios'@'%';

/* Asignar los privilegios de SELECCION, INCERSION, ACTUALIZACION Y ELIMINACION */
GRANT SELECT, INSERT, UPDATE, DELETE ON db_test_7b.* TO 'luis.hernandez'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_test_7b.* TO 'yaneth.garrido'@'%';
/*(creada por maestro) Asignar privilegios a un usuario sin rol*/
GRANT SELECT, INSERT, UPDATE, DELETE ON db_test_7b.tb_users TO 'maestro'@'%';

/* CREACION DE ROLES PARA EL SISTEMA DE ECOMMERCE */
CREATE ROLE IF NOT EXISTS 'superadmin';
CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'support';
CREATE ROLE IF NOT EXISTS 'common';
CREATE ROLE IF NOT EXISTS 'user_not_registered';

/* ASIGNAR PRIVILEGIOS A LOS ROLES CREADOS */
GRANT ALL PRIVILEGES ON *.* TO 'superadmin';

GRANT ALL PRIVILEGES ON db_test_7b.* TO 'admin';

-- SUPPORT
GRANT SELECT, INSERT, UPDATE 
ON db_test_7b.tb_users
TO 'support';

GRANT SELECT, INSERT, UPDATE 
ON db_test_7b.tb_products
TO 'support';

/*seller*/
GRANT SELECT, INSERT, UPDATE, DELETE 
ON db_test_7b.tb_products 
TO 'seller';

/* ASIGNAR ROLES A LOS USUARIOS CREADOS */

/*este soy yo*/
grant 'superadmin' TO 'dorian.barrios'@'%';
/*este es el profe marco*/
GRANT 'admin' TO 'marco.ramirez'@'%';
/*este es el de la izquierda*/
GRANT 'support' TO 'angel.hernandez'@'%';
/*este es el de la derecha*/
GRANT 'seller' TO 'luis.hernandez'@'%';
/*este es mi segundo cliente*/
GRANT 'seller' TO 'jorge.eloy'@'%';

/*Esto permite que el rol se active automaticamente cuando el usuario inicia sesion
*/
SET DEFAULT ROLE 'admin' TO 'marco.ramirez'@'%';
SET DEFAULT ROLE 'support' TO 'angel.hernandez'@'%';
SET DEFAULT ROLE 'seller' TO 'luis.hernandez'@'%';
SET DEFAULT ROLE 'seller' TO 'jorge.eloy'@'%';

/*Mostrar usuarios remotos creados*/
SELECT "los usuarios y privilegios han sido creados correctamente" AS mensaje;

/* Aplicar cambios */
FLUSH PRIVILEGES;