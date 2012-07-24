-- MySQL dump 10.13  Distrib 5.5.23, for Linux (i686)
--
-- Host: localhost    Database: lutreola
-- ------------------------------------------------------
-- Server version	5.5.23-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `collection`
--

DROP TABLE IF EXISTS `collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `en` text,
  `ee` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection`
--

LOCK TABLES `collection` WRITE;
/*!40000 ALTER TABLE `collection` DISABLE KEYS */;
INSERT INTO `collection` VALUES (3,'Mink One','Many minks!',''),(4,'mink three','More minks!',''),(5,'mink seven','A few of the more popular minks.','');
/*!40000 ALTER TABLE `collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_photo`
--

DROP TABLE IF EXISTS `collection_photo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection_photo` (
  `ordr` int(11) DEFAULT '1',
  `photo_id` int(10) unsigned NOT NULL,
  `collection_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`photo_id`,`collection_id`),
  KEY `index_collection_photo_photo` (`photo_id`),
  KEY `index_collection_photo_collection` (`collection_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_photo`
--

LOCK TABLES `collection_photo` WRITE;
/*!40000 ALTER TABLE `collection_photo` DISABLE KEYS */;
INSERT INTO `collection_photo` VALUES (1,10,3),(1,11,3),(1,12,5),(1,13,5),(1,14,4),(1,15,4);
/*!40000 ALTER TABLE `collection_photo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entry`
--

DROP TABLE IF EXISTS `entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entry` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `role` varchar(20) DEFAULT NULL,
  `url` varchar(50) DEFAULT NULL,
  `en` text,
  `ee` text,
  `main_menu` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entry`
--

LOCK TABLES `entry` WRITE;
/*!40000 ALTER TABLE `entry` DISABLE KEYS */;
INSERT INTO `entry` VALUES (2,'Intro Page','Page',NULL,'','### English Section\r\n\r\nWelcome to the English pages.','Tervist!',4),(3,'Who We Are','Page',NULL,'','### Who we are\r\n                  \r\n                  Overview of employees/volunteers.','Yus!',9),(4,'gallery','Link',NULL,'/gallery','','',4),(5,'Sissejuhatav Leht','Page',NULL,'','### Mission','Minu naarits on must.',7),(6,'Projektid','Page',NULL,'','Projects','Projektid',6),(7,'Meedia Kajastused','Page',NULL,'','Media','Media',6),(8,'home','Page',NULL,'','This is Foundation Lutreola!','Yup.',3),(9,'partners','Page',NULL,'','### Partners\r\n\r\nOur partners...','\r\n',4),(10,'conservation','Page',NULL,'','### Conservation of the European Mink\r\n                  \r\nOverview.','',8),(11,'tiit maran','Page',NULL,'','### Tiit Maran','',9),(12,'madis põdra','Page',NULL,'','### Madis Põdra','',9),(13,'selve pitsal','Page',NULL,'','### Selve Pitsal','',9),(14,'riina lillemäe','Page',NULL,'','### Riina Lillemäe','',9),(15,'gennadi kotsur','Page',NULL,'','### Gennadi Kotsur','',9),(16,'ex situ','Page',NULL,'','### Ex situ','',8),(17,'emink elsewhere','Page',NULL,'','### The European Mink on Other Websites\r\n','',8),(18,'emink status','Page',NULL,'','### Status of the European Mink','',8),(19,'in situ','Page',NULL,'','### In Situ','',8),(20,'research topics','Page',NULL,'','### Research Topics','',4),(21,'supporters','Page',NULL,'','### Supporters','',4),(22,'webcams','Page',NULL,'','### Webcams','',4),(23,'news','Link',NULL,'/news','','',3),(24,'old site','Link',NULL,'http://www.lutreola.ee/','','',3),(25,'estionian','Page',NULL,'','### Estonian site','',6),(26,'goals','Page',NULL,'','### Goals','',7),(27,'history','Page',NULL,'','### History (estonian)','',7);
/*!40000 ALTER TABLE `entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entry_menu`
--

DROP TABLE IF EXISTS `entry_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entry_menu` (
  `ordr` int(11) DEFAULT '1',
  `menu_id` int(10) unsigned NOT NULL,
  `entry_id` int(10) unsigned NOT NULL,
  `title` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`menu_id`,`entry_id`),
  KEY `index_entry_menu_menu` (`menu_id`),
  KEY `index_entry_menu_entry` (`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entry_menu`
--

LOCK TABLES `entry_menu` WRITE;
/*!40000 ALTER TABLE `entry_menu` DISABLE KEYS */;
INSERT INTO `entry_menu` VALUES (2,3,2,'english'),(4,3,4,'gallery'),(1,3,8,'Home'),(5,3,23,'news'),(6,3,24,'old site'),(1,3,25,'estonian'),(1,4,2,'intro'),(1,4,3,'who we are'),(1,4,9,'partners'),(1,4,10,'conservation'),(1,4,20,'research topics'),(1,4,21,'supporters'),(1,4,22,'webcams'),(1,6,5,'Sissejuhatav Leht'),(3,6,6,'projektid'),(4,6,7,'Meedia Kajastused'),(1,6,25,'intro'),(1,7,5,'mission'),(1,7,26,'goals'),(1,7,27,'history'),(1,8,10,'conservation'),(1,8,16,'ex situ'),(1,8,17,'emink elsewhere'),(1,8,18,'emink status'),(1,8,19,'in situ'),(1,9,3,'who we are'),(2,9,11,'tiit maran'),(3,9,12,'madis põdra'),(1,9,13,'selve pitsal'),(1,9,14,'riina lillemäe'),(1,9,15,'gennadi kotsur');
/*!40000 ALTER TABLE `entry_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `email` varchar(40) NOT NULL,
  `encrypted_password` varchar(255) DEFAULT NULL,
  `salt` varchar(255) DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `auth_token` varchar(25) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '0',
  `last_action` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_member_username` (`username`),
  UNIQUE KEY `unique_member_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (5,'lemur','lemur@lemur.net','9439232acc08d139df3d0cf36a6a1126e94d8e7ce51d574eb025e12ccb75ee36','9804aefaaf1ad0b0d66c520453f10942d78f98053a4db9f8a7818bb8654c6aa2','Member','kQ91LmgTPUjQefoJ7lg',0,NULL,'2012-06-11 02:37:21'),(6,'inhortte','inhortte@gmail.com','a930800a5202ad31c49aacddccf1c6213316a809a6276c26b1f2d3abe9315ca8','f20a997fd324202990abeb58126fe7e394e88e4017def883486b9faac7350507','Admin','uvazmYCcoJmggr9Xbhc',0,NULL,'2012-06-11 17:54:08');
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_info`
--

DROP TABLE IF EXISTS `member_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_info` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(20) DEFAULT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `other_names` varchar(100) DEFAULT NULL,
  `title` varchar(20) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  `province` varchar(30) DEFAULT NULL,
  `country` varchar(3) DEFAULT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `member_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_member_info_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_info`
--

LOCK TABLES `member_info` WRITE;
/*!40000 ALTER TABLE `member_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `default_page_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_menu_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES (3,'home',8,NULL),(4,'english',2,3),(6,'estonian',25,3),(7,'Sissejuhatav Leht',5,6),(8,'conservation',10,4),(9,'who we are',11,4);
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photo`
--

DROP TABLE IF EXISTS `photo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `photo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `ee` text,
  `en` text,
  `taken` datetime DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `photographer_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_photo_photographer` (`photographer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photo`
--

LOCK TABLES `photo` WRITE;
/*!40000 ALTER TABLE `photo` DISABLE KEYS */;
INSERT INTO `photo` VALUES (10,'honza','','A mink in a cage! Imagine that.',NULL,'04.jpg',1),(11,'travelling','','This mink is hanging.',NULL,'21.jpg',1),(12,'freedom','','A mink contemplating the great outdoors.',NULL,'29.jpg',1),(13,'curious','','Here we go....',NULL,'38.jpg',1),(14,'collared','','He likes this.',NULL,'22.jpg',1),(15,'swimming','','naarits ujub.',NULL,'28.jpg',1);
/*!40000 ALTER TABLE `photo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photographer`
--

DROP TABLE IF EXISTS `photographer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `photographer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `en` text,
  `member_id` int(10) unsigned DEFAULT NULL,
  `ee` text,
  PRIMARY KEY (`id`),
  KEY `index_photographer_member` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photographer`
--

LOCK TABLES `photographer` WRITE;
/*!40000 ALTER TABLE `photographer` DISABLE KEYS */;
INSERT INTO `photographer` VALUES (1,'Mr Lutreola','I photograph minks!',NULL,NULL);
/*!40000 ALTER TABLE `photographer` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-07-24 14:18:57
