-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: db_test_7b
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tb_logs`
--

DROP TABLE IF EXISTS `tb_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_logs` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(80) NOT NULL,
  `table_operation` enum('Create','Read','Update','Delate') DEFAULT NULL,
  `db_user` varchar(80) NOT NULL,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_description` text NOT NULL,
  `operation_status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_logs`
--

LOCK TABLES `tb_logs` WRITE;
/*!40000 ALTER TABLE `tb_logs` DISABLE KEYS */;
INSERT INTO `tb_logs` VALUES (1,'tb_users','Create','root@localhost','2026-09-10 10:42:59','Usuario creado. ID=4, emil=240065@utxicotepec.edu.mx, nick=MTI-DorianBF, creation_date=2026-09-10 10:42:59, status=',_binary ''),(2,'tb_users','Create','root@localhost','2026-09-10 11:40:26','Usuario creado. ID=5, emil=24006@utxicotepec.edu.mx, nick=AlexTI, creation_date=2026-09-10 11:40:26, status=',_binary ''),(3,'tb_users','Create','root@localhost','2026-09-10 11:41:18','Usuario creado. ID=6, emil=240067@utxicotepec.edu.mx, nick=Gaby, creation_date=2026-09-10 11:41:18, status=',_binary ''),(4,'tb_users','Create','yaneth.garrido@DESKTOP-978SUTP','2026-09-10 12:21:05','Usuario creado. ID=7, emil=240001@utxicotepec.edu.mx, nick=juan, creation_date=2026-09-10 12:21:05, status=',_binary ''),(5,'tb_users','Create','yaneth.garrido@DESKTOP-978SUTP','2026-09-10 12:22:07','Usuario creado. ID=8, emil=240002@utxicotepec.edu.mx, nick=pedro, creation_date=2026-09-10 12:22:07, status=',_binary ''),(6,'tb_users','Create','yaneth.garrido@DESKTOP-978SUTP','2026-09-10 12:22:22','Usuario creado. ID=9, emil=240003@utxicotepec.edu.mx, nick=maria, creation_date=2026-09-10 12:22:22, status=',_binary '');
/*!40000 ALTER TABLE `tb_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_users`
--

DROP TABLE IF EXISTS `tb_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_users` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `emil` varchar(100) NOT NULL,
  `nick` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL,
  `status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `emil` (`emil`),
  UNIQUE KEY `nick` (`nick`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_users`
--

LOCK TABLES `tb_users` WRITE;
/*!40000 ALTER TABLE `tb_users` DISABLE KEYS */;
INSERT INTO `tb_users` VALUES (4,'240065@utxicotepec.edu.mx','MTI-DorianBF','871534c2971fceb021437786bc940bd2','2026-09-10 10:42:59',NULL,NULL,_binary ''),(5,'24006@utxicotepec.edu.mx','AlexTI','871534c2971fceb021437786bc940bd2','2026-09-10 11:40:26',NULL,NULL,_binary ''),(6,'240067@utxicotepec.edu.mx','Gaby','202cb962ac59075b964b07152d234b70','2026-09-10 11:41:18',NULL,NULL,_binary ''),(7,'240001@utxicotepec.edu.mx','juan','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 12:21:05',NULL,NULL,_binary ''),(8,'240002@utxicotepec.edu.mx','pedro','674f3c2c1a8a6f90461e8a66fb5550ba','2026-09-10 12:22:07',NULL,NULL,_binary ''),(9,'240003@utxicotepec.edu.mx','maria','c5c53759e4dd1bfe8b3dcfec37d0ea72','2026-09-10 12:22:22',NULL,NULL,_binary '');
/*!40000 ALTER TABLE `tb_users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_users_after_insert` AFTER INSERT ON `tb_users` FOR EACH ROW BEGIN
INSERT INTO tb_logs (
table_name,
table_operation,
db_user,
operation_date,
operation_description,
operation_status
)
VALUES (
'tb_users',
'Create',
USER(),
CURRENT_TIMESTAMP,
CONCAT(
'Usuario creado. ID=', NEW.ID,
', emil=', NEW.emil,
', nick=', NEW.nick,
', creation_date=', NEW.creation_date,
', status=', NEW.status
),
b'1'
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_users_after_update` AFTER UPDATE ON `tb_users` FOR EACH ROW BEGIN
INSERT INTO tb_logs (
table_name,
table_operation,
db_user,
operation_date,
operation_description,
operation_status
)
VALUES (
'tb_users',
'Update',
USER(),
CONCAT(
'Usuario modificado. ID=', NEW.ID,
' | Anterior Nick=', OLD.nick, ' -> Nuevo Nick=', NEW.nick,
' | Anterior Emil=', OLD.emil, ' -> Nuevo Emil=', NEW.emil
),
CURRENT_TIMESTAMP,
b'1'
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_users_after_delete` AFTER DELETE ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        table_operation,
        db_user,
        operation_date,        
        operation_description, 
        operation_status       
    )
    VALUES (
        'tb_users',
        'Delete',
        USER(),
        CURRENT_TIMESTAMP,     
        CONCAT(                
            'Usuario eliminado. ID=', OLD.ID,
            ' | Nick era=', OLD.nick,
            ' | Emil era=', OLD.emil
        ),
        b'1'                   
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-10 13:22:58
