-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: djaalarm
-- ------------------------------------------------------
-- Server version	5.5.31-0ubuntu0.12.10.1

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
-- Table structure for table `aalarm_command`
--

DROP TABLE IF EXISTS `aalarm_command`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_command` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_command`
--

LOCK TABLES `aalarm_command` WRITE;
/*!40000 ALTER TABLE `aalarm_command` DISABLE KEYS */;
INSERT INTO `aalarm_command` VALUES (1,'setOnline'),(2,'setOffline');
/*!40000 ALTER TABLE `aalarm_command` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aalarm_event`
--

DROP TABLE IF EXISTS `aalarm_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `sensor_id` int(11) NOT NULL,
  `state_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aalarm_event_c4997154` (`sensor_id`),
  KEY `aalarm_event_b9608dc2` (`state_id`),
  CONSTRAINT `sensor_id_refs_id_5cae8f76` FOREIGN KEY (`sensor_id`) REFERENCES `aalarm_sensor` (`id`),
  CONSTRAINT `state_id_refs_id_640460b8` FOREIGN KEY (`state_id`) REFERENCES `aalarm_refstate` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_event`
--

LOCK TABLES `aalarm_event` WRITE;
/*!40000 ALTER TABLE `aalarm_event` DISABLE KEYS */;
INSERT INTO `aalarm_event` VALUES (2,'2013-05-08 23:26:00',2,3),(3,'2013-05-08 23:26:06',2,4),(4,'2013-05-08 23:26:15',2,5),(5,'2013-05-08 23:26:20',1,1),(6,'2013-05-08 23:26:28',2,6),(7,'2013-05-08 23:26:37',2,7),(8,'2013-05-08 23:26:44',1,2),(9,'2013-05-08 23:27:27',2,8);
/*!40000 ALTER TABLE `aalarm_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aalarm_execute`
--

DROP TABLE IF EXISTS `aalarm_execute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_execute` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `command_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `completed` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aalarm_execute_5d7c4270` (`command_id`),
  CONSTRAINT `command_id_refs_id_c1d9343b` FOREIGN KEY (`command_id`) REFERENCES `aalarm_command` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_execute`
--

LOCK TABLES `aalarm_execute` WRITE;
/*!40000 ALTER TABLE `aalarm_execute` DISABLE KEYS */;
INSERT INTO `aalarm_execute` VALUES (59,1,'2013-05-11 16:27:52',0);
/*!40000 ALTER TABLE `aalarm_execute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aalarm_parameter`
--

DROP TABLE IF EXISTS `aalarm_parameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_parameter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(50) NOT NULL,
  `value` varchar(250) NOT NULL,
  `showInUI` smallint(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_parameter`
--

LOCK TABLES `aalarm_parameter` WRITE;
/*!40000 ALTER TABLE `aalarm_parameter` DISABLE KEYS */;
INSERT INTO `aalarm_parameter` VALUES (1,'pathLog','/home/kemkem/work/arduinoAlarm/log',0),(2,'portBase','/dev/ttyACM',0),(3,'portNumMin','0',0),(4,'portNumMax','5',0),(5,'reconnectTimeoutSecs','5',0),(6,'pathStartPlaylist','/home/kemkem/work/arduinoAlarm/sh/startPlaylist.sh &',0),(7,'pathStopPlaylist','/home/kemkem/work/arduinoAlarm/sh/stopPlaylist.sh &',0),(8,'pathStartZM','/home/kemkem/work/arduinoAlarm/sh/startZM.sh &',0),(9,'pathStopZM','/home/kemkem/work/arduinoAlarm/sh/stopZM.sh &',0),(10,'pathZmLast','/home/kemkem/work/arduinoAlarm/sh/zmLast.sh &',0),(11,'delayOnlineTimed','22',1),(12,'delayIntrusionWarning','20',1),(13,'delayIntrusionAlarm','40',1),(14,'delayIntrusionWarningTimeout','5',1),(15,'delayIntrusionAlarmTimeout','60',1),(16,'rate','9600;',0),(17,'refreshMs','200;',0),(18,'passwd','4578',0);
/*!40000 ALTER TABLE `aalarm_parameter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aalarm_refsensortype`
--

DROP TABLE IF EXISTS `aalarm_refsensortype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_refsensortype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sensorType` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_refsensortype`
--

LOCK TABLES `aalarm_refsensortype` WRITE;
/*!40000 ALTER TABLE `aalarm_refsensortype` DISABLE KEYS */;
INSERT INTO `aalarm_refsensortype` VALUES (1,'Door Sensor'),(2,'Global');
/*!40000 ALTER TABLE `aalarm_refsensortype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aalarm_refstate`
--

DROP TABLE IF EXISTS `aalarm_refstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_refstate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sensorType_id` int(11) NOT NULL,
  `state` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aalarm_refstate_4f732908` (`sensorType_id`),
  CONSTRAINT `sensorType_id_refs_id_7a5e78f` FOREIGN KEY (`sensorType_id`) REFERENCES `aalarm_refsensortype` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_refstate`
--

LOCK TABLES `aalarm_refstate` WRITE;
/*!40000 ALTER TABLE `aalarm_refstate` DISABLE KEYS */;
INSERT INTO `aalarm_refstate` VALUES (1,1,'Open'),(2,1,'Close'),(3,2,'Offline'),(4,2,'Online Timed'),(5,2,'Online'),(6,2,'Intrusion'),(7,2,'Warning'),(8,2,'Alert');
/*!40000 ALTER TABLE `aalarm_refstate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aalarm_sensor`
--

DROP TABLE IF EXISTS `aalarm_sensor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_sensor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sensorType_id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aalarm_sensor_4f732908` (`sensorType_id`),
  CONSTRAINT `sensorType_id_refs_id_b6e95ab1` FOREIGN KEY (`sensorType_id`) REFERENCES `aalarm_refsensortype` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_sensor`
--

LOCK TABLES `aalarm_sensor` WRITE;
/*!40000 ALTER TABLE `aalarm_sensor` DISABLE KEYS */;
INSERT INTO `aalarm_sensor` VALUES (1,1,'Door 1'),(2,2,'Global');
/*!40000 ALTER TABLE `aalarm_sensor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_bda51c3c` (`group_id`),
  KEY `auth_group_permissions_1e014c8f` (`permission_id`),
  CONSTRAINT `group_id_refs_id_3cea63fe` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `permission_id_refs_id_a7792de1` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  KEY `auth_permission_e4470c6e` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_728de91f` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add permission',1,'add_permission'),(2,'Can change permission',1,'change_permission'),(3,'Can delete permission',1,'delete_permission'),(4,'Can add group',2,'add_group'),(5,'Can change group',2,'change_group'),(6,'Can delete group',2,'delete_group'),(7,'Can add user',3,'add_user'),(8,'Can change user',3,'change_user'),(9,'Can delete user',3,'delete_user'),(10,'Can add content type',4,'add_contenttype'),(11,'Can change content type',4,'change_contenttype'),(12,'Can delete content type',4,'delete_contenttype'),(13,'Can add session',5,'add_session'),(14,'Can change session',5,'change_session'),(15,'Can delete session',5,'delete_session'),(16,'Can add site',6,'add_site'),(17,'Can change site',6,'change_site'),(18,'Can delete site',6,'delete_site'),(19,'Can add log entry',7,'add_logentry'),(20,'Can change log entry',7,'change_logentry'),(21,'Can delete log entry',7,'delete_logentry'),(22,'Can add command',8,'add_command'),(23,'Can change command',8,'change_command'),(24,'Can delete command',8,'delete_command'),(25,'Can add ref sensor type',9,'add_refsensortype'),(26,'Can change ref sensor type',9,'change_refsensortype'),(27,'Can delete ref sensor type',9,'delete_refsensortype'),(28,'Can add ref state',10,'add_refstate'),(29,'Can change ref state',10,'change_refstate'),(30,'Can delete ref state',10,'delete_refstate'),(31,'Can add sensor',11,'add_sensor'),(32,'Can change sensor',11,'change_sensor'),(33,'Can delete sensor',11,'delete_sensor'),(34,'Can add event',12,'add_event'),(35,'Can change event',12,'change_event'),(36,'Can delete event',12,'delete_event'),(37,'Can add parameter',13,'add_parameter'),(38,'Can change parameter',13,'change_parameter'),(39,'Can delete parameter',13,'delete_parameter'),(40,'Can add execute',14,'add_execute'),(41,'Can change execute',14,'change_execute'),(42,'Can delete execute',14,'delete_execute');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(75) NOT NULL,
  `password` varchar(128) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `last_login` datetime NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'admin','','','marc@kprod.net','pbkdf2_sha256$10000$3NOkqAOymii9$/nf80pBJKOpc51L3OUfj8gPSrfUzKKaQAER7p/2W5nA=',1,1,1,'2013-05-08 12:01:21','2013-05-08 12:00:34');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_fbfc09f1` (`user_id`),
  KEY `auth_user_groups_bda51c3c` (`group_id`),
  CONSTRAINT `group_id_refs_id_f0ee9890` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `user_id_refs_id_831107f1` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_fbfc09f1` (`user_id`),
  KEY `auth_user_user_permissions_1e014c8f` (`permission_id`),
  CONSTRAINT `permission_id_refs_id_67e79cb` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `user_id_refs_id_f2045483` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_fbfc09f1` (`user_id`),
  KEY `django_admin_log_e4470c6e` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_288599e6` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `user_id_refs_id_c8665aa` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2013-05-08 12:30:26',1,9,'1','Door Sensor',1,''),(2,'2013-05-08 12:30:38',1,9,'2','Global',1,''),(3,'2013-05-08 12:30:59',1,11,'1','Door 1',1,''),(4,'2013-05-08 12:31:16',1,11,'2','Global',1,''),(5,'2013-05-08 12:34:37',1,10,'1','Open',1,''),(6,'2013-05-08 12:34:43',1,10,'2','Close',1,''),(7,'2013-05-08 12:35:00',1,10,'3','Offline',1,''),(8,'2013-05-08 12:35:19',1,10,'4','Online Timed',1,''),(9,'2013-05-08 12:35:25',1,10,'5','Online',1,''),(10,'2013-05-08 12:35:37',1,10,'6','Intrusion',1,''),(11,'2013-05-08 12:35:43',1,10,'7','Warning',1,''),(12,'2013-05-08 12:35:50',1,10,'8','Alert',1,''),(13,'2013-05-08 16:25:34',1,12,'1','Door 1 Open',1,''),(14,'2013-05-08 16:25:57',1,12,'1','Door 1 Open',3,''),(15,'2013-05-08 16:26:05',1,12,'2','Global Offline',1,''),(16,'2013-05-08 16:26:13',1,12,'3','Global Online Timed',1,''),(17,'2013-05-08 16:26:19',1,12,'4','Global Online',1,''),(18,'2013-05-08 16:26:27',1,12,'5','Door 1 Open',1,''),(19,'2013-05-08 16:26:35',1,12,'6','Global Intrusion',1,''),(20,'2013-05-08 16:26:42',1,12,'7','Global Warning',1,''),(21,'2013-05-08 16:27:13',1,12,'8','Door 1 Close',1,''),(22,'2013-05-08 16:27:31',1,12,'9','Global Alert',1,''),(23,'2013-05-09 15:29:38',1,8,'1','setOnline',1,''),(24,'2013-05-09 15:29:46',1,8,'2','setOffline',1,''),(25,'2013-05-09 15:55:51',1,14,'9','setOffline',3,''),(26,'2013-05-09 15:55:51',1,14,'8','setOffline',3,''),(27,'2013-05-09 15:55:51',1,14,'7','setOffline',3,''),(28,'2013-05-09 15:55:51',1,14,'6','setOnline',3,''),(29,'2013-05-09 20:02:40',1,14,'15','setOnline',3,''),(30,'2013-05-09 20:02:40',1,14,'14','setOnline',3,''),(31,'2013-05-09 20:02:40',1,14,'13','setOnline',3,''),(32,'2013-05-09 20:02:40',1,14,'12','setOnline',3,''),(33,'2013-05-09 20:02:40',1,14,'11','setOnline',3,''),(34,'2013-05-09 20:02:40',1,14,'10','setOffline',3,''),(35,'2013-05-09 20:08:12',1,14,'18','setOnline',3,''),(36,'2013-05-09 20:08:12',1,14,'17','setOnline',3,''),(37,'2013-05-09 20:08:13',1,14,'16','setOnline',3,''),(38,'2013-05-09 20:08:18',1,14,'19','setOnline',3,''),(39,'2013-05-09 20:12:20',1,14,'27','setOffline',3,''),(40,'2013-05-09 20:12:20',1,14,'26','setOnline',3,''),(41,'2013-05-09 20:12:20',1,14,'25','setOnline',3,''),(42,'2013-05-09 20:12:20',1,14,'24','setOnline',3,''),(43,'2013-05-09 20:12:20',1,14,'23','setOnline',3,''),(44,'2013-05-09 20:12:20',1,14,'22','setOnline',3,''),(45,'2013-05-09 20:12:20',1,14,'21','setOnline',3,''),(46,'2013-05-09 20:12:20',1,14,'20','setOnline',3,''),(47,'2013-05-09 20:13:51',1,14,'29','setOffline',3,''),(48,'2013-05-09 20:13:51',1,14,'28','setOffline',3,''),(49,'2013-05-11 15:57:56',1,14,'36','setOnline',3,''),(50,'2013-05-11 15:57:56',1,14,'35','setOnline',3,''),(51,'2013-05-11 15:57:56',1,14,'34','setOffline',3,''),(52,'2013-05-11 15:57:56',1,14,'33','setOnline',3,''),(53,'2013-05-11 15:57:56',1,14,'32','setOnline',3,''),(54,'2013-05-11 15:57:56',1,14,'31','setOffline',3,''),(55,'2013-05-11 15:57:56',1,14,'30','setOnline',3,''),(56,'2013-05-11 16:07:08',1,14,'37','setOnline',3,''),(57,'2013-05-11 16:10:54',1,14,'41','setOnline',3,''),(58,'2013-05-11 16:10:54',1,14,'40','setOnline',3,''),(59,'2013-05-11 16:10:54',1,14,'39','setOnline',3,''),(60,'2013-05-11 16:10:54',1,14,'38','setOnline',3,''),(61,'2013-05-11 16:17:16',1,14,'49','setOffline',3,''),(62,'2013-05-11 16:17:16',1,14,'48','setOnline',3,''),(63,'2013-05-11 16:17:16',1,14,'47','setOffline',3,''),(64,'2013-05-11 16:17:16',1,14,'46','setOnline',3,''),(65,'2013-05-11 16:17:16',1,14,'45','setOffline',3,''),(66,'2013-05-11 16:17:16',1,14,'44','setOnline',3,''),(67,'2013-05-11 16:17:16',1,14,'43','setOnline',3,''),(68,'2013-05-11 16:17:16',1,14,'42','setOffline',3,''),(69,'2013-05-11 16:26:17',1,14,'57','setOffline',3,''),(70,'2013-05-11 16:26:17',1,14,'56','setOnline',3,''),(71,'2013-05-11 16:26:17',1,14,'55','setOnline',3,''),(72,'2013-05-11 16:26:17',1,14,'54','setOnline',3,''),(73,'2013-05-11 16:26:17',1,14,'53','setOffline',3,''),(74,'2013-05-11 16:26:17',1,14,'52','setOnline',3,''),(75,'2013-05-11 16:26:17',1,14,'51','setOnline',3,''),(76,'2013-05-11 16:26:17',1,14,'50','setOnline',3,''),(77,'2013-05-11 16:40:16',1,14,'58','setOffline',3,''),(78,'2013-05-11 17:51:38',1,13,'15','delayIntrusionAlarmTimeout',2,'Changed showInUI.'),(79,'2013-05-11 17:51:42',1,13,'14','delayIntrusionWarningTimeout',2,'Changed showInUI.'),(80,'2013-05-11 17:51:46',1,13,'13','delayIntrusionAlarm',2,'Changed showInUI.'),(81,'2013-05-11 17:51:50',1,13,'12','delayIntrusionWarning',2,'Changed showInUI.'),(82,'2013-05-11 17:51:54',1,13,'11','delayOnlineTimed',2,'Changed showInUI.');
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_label` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'permission','auth','permission'),(2,'group','auth','group'),(3,'user','auth','user'),(4,'content type','contenttypes','contenttype'),(5,'session','sessions','session'),(6,'site','sites','site'),(7,'log entry','admin','logentry'),(8,'command','aalarm','command'),(9,'ref sensor type','aalarm','refsensortype'),(10,'ref state','aalarm','refstate'),(11,'sensor','aalarm','sensor'),(12,'event','aalarm','event'),(13,'parameter','aalarm','parameter'),(14,'execute','aalarm','execute');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_c25c2c28` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('fe80d5b14dba61ae3b6b3b75fe505024','NmY2ZTdiOGI5NWY2ZjU1ZTFlOTkzMzNjNTg3ZmFmMDQ1M2M4ZDE5YjqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQF1Lg==\n','2013-05-22 12:01:21');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_site`
--

DROP TABLE IF EXISTS `django_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_site`
--

LOCK TABLES `django_site` WRITE;
/*!40000 ALTER TABLE `django_site` DISABLE KEYS */;
INSERT INTO `django_site` VALUES (1,'example.com','example.com');
/*!40000 ALTER TABLE `django_site` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-05-19 13:53:59
