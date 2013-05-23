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
  `name` varchar(30) NOT NULL,
  `description` varchar(255) NOT NULL,
  `command` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_command`
--

LOCK TABLES `aalarm_command` WRITE;
/*!40000 ALTER TABLE `aalarm_command` DISABLE KEYS */;
INSERT INTO `aalarm_command` VALUES (1,'Set Online','Set alarm to online state','setOnline'),(2,'Set Offline','Set alarm to offline state','setOffline');
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
  CONSTRAINT `state_id_refs_id_640460b8` FOREIGN KEY (`state_id`) REFERENCES `aalarm_refstate` (`id`),
  CONSTRAINT `sensor_id_refs_id_5cae8f76` FOREIGN KEY (`sensor_id`) REFERENCES `aalarm_sensor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_event`
--

LOCK TABLES `aalarm_event` WRITE;
/*!40000 ALTER TABLE `aalarm_event` DISABLE KEYS */;
INSERT INTO `aalarm_event` VALUES (1,'2013-05-23 21:10:05',1,1),(2,'2013-05-23 21:22:56',1,1),(3,'2013-05-23 21:23:35',1,1),(4,'2013-05-23 21:24:18',1,1),(5,'2013-05-23 21:24:18',2,8),(6,'2013-05-23 21:35:28',1,2),(7,'2013-05-23 21:35:42',1,3),(8,'2013-05-23 21:35:53',1,4),(9,'2013-05-23 21:36:03',1,5),(10,'2013-05-23 21:36:10',1,6),(11,'2013-05-23 21:36:42',2,8),(12,'2013-05-23 21:36:54',2,7);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_execute`
--

LOCK TABLES `aalarm_execute` WRITE;
/*!40000 ALTER TABLE `aalarm_execute` DISABLE KEYS */;
INSERT INTO `aalarm_execute` VALUES (1,1,'2013-05-23 18:29:28',1);
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
  `name` varchar(30) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `showInUI` smallint(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_parameter`
--

LOCK TABLES `aalarm_parameter` WRITE;
/*!40000 ALTER TABLE `aalarm_parameter` DISABLE KEYS */;
INSERT INTO `aalarm_parameter` VALUES (1,'pathLog','/home/kemkem/work/arduinoAlarm/log','',NULL,0),(2,'portBase','/dev/ttyACM','',NULL,0),(3,'portNumMin','0','',NULL,0),(4,'portNumMax','5','',NULL,0),(5,'reconnectTimeoutSecs','5','',NULL,0),(6,'pathStartPlaylist','/home/kemkem/work/arduinoAlarm/sh/startPlaylist.sh &','',NULL,0),(7,'pathStopPlaylist','/home/kemkem/work/arduinoAlarm/sh/stopPlaylist.sh &','',NULL,0),(8,'pathStartZM','/home/kemkem/work/arduinoAlarm/sh/startZM.sh &','',NULL,0),(9,'pathStopZM','/home/kemkem/work/arduinoAlarm/sh/stopZM.sh &','',NULL,0),(10,'pathZmLast','/home/kemkem/work/arduinoAlarm/sh/zmLast.sh &','',NULL,0),(11,'delayOnlineTimed','20','',NULL,0),(12,'delayIntrusionWarning','20','',NULL,0),(13,'delayIntrusionAlarm','40','',NULL,0),(14,'delayIntrusionWarningTimeout','5','',NULL,0),(15,'delayIntrusionAlarmTimeout','60','',NULL,0),(16,'rate','9600;','',NULL,0),(17,'refreshMs','200;','',NULL,0),(18,'passwd','4578','',NULL,0);
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
INSERT INTO `aalarm_refsensortype` VALUES (1,'Global'),(2,'Door Sensor');
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
  `state` varchar(20) NOT NULL,
  `displayName` varchar(30) NOT NULL,
  `css` varchar(30) NOT NULL,
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
INSERT INTO `aalarm_refstate` VALUES (1,1,'offline','Offline','colorYellow'),(2,1,'timed','Online Timed','colorLightGreen'),(3,1,'online','Online','colorGreen'),(4,1,'intrusion','Intrusion','colorOrange'),(5,1,'warning','Warning','colorOrangeRed'),(6,1,'alert','Alert','colorRed'),(7,2,'open','Open','colorRed'),(8,2,'closed','Closed','colorGreen');
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
  `displayName` varchar(30) NOT NULL,
  `pin` smallint(6) NOT NULL,
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
INSERT INTO `aalarm_sensor` VALUES (1,1,'Global','Global State',0),(2,2,'Door1','Main Door',1);
/*!40000 ALTER TABLE `aalarm_sensor` ENABLE KEYS */;
UNLOCK TABLES;

