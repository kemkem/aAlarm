-- MySQL dump 10.13  Distrib 5.5.40, for debian-linux-gnu (armv7l)
--
-- Host: localhost    Database: djaalarm
-- ------------------------------------------------------
-- Server version	5.5.40-0+wheezy1

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_command`
--

LOCK TABLES `aalarm_command` WRITE;
/*!40000 ALTER TABLE `aalarm_command` DISABLE KEYS */;
INSERT INTO `aalarm_command` VALUES (1,'Set Online','Set alarm to online state','setOnline'),(2,'Set Offline','Set alarm to offline state','setOffline'),(3,'start ZoneMinder','startZoneMinder','startZoneMinder'),(4,'stop ZoneMinder','stopZoneMinder','stopZoneMinder'),(5,'start Music Playlist','startMusicPlaylist','startMusicPlaylist'),(6,'stop Music Playlist','stopMusicPlaylist','stopMusicPlaylist');
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
  KEY `aalarm_event_3b668eac` (`sensor_id`),
  KEY `aalarm_event_469f723e` (`state_id`),
  CONSTRAINT `sensor_id_refs_id_5cae8f76` FOREIGN KEY (`sensor_id`) REFERENCES `aalarm_sensor` (`id`),
  CONSTRAINT `state_id_refs_id_640460b8` FOREIGN KEY (`state_id`) REFERENCES `aalarm_refstate` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=590 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  CONSTRAINT `command_id_refs_id_3e26cbc5` FOREIGN KEY (`command_id`) REFERENCES `aalarm_command` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `aalarm_motioneventpicture`
--

DROP TABLE IF EXISTS `aalarm_motioneventpicture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_motioneventpicture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `security_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aalarm_motioneventpicture_1647d06b` (`event_id`),
  KEY `aalarm_motioneventpicture_44501ebe` (`security_id`),
  CONSTRAINT `event_id_refs_id_15abe402` FOREIGN KEY (`event_id`) REFERENCES `aalarm_event` (`id`),
  CONSTRAINT `security_id_refs_id_6215dfbb` FOREIGN KEY (`security_id`) REFERENCES `aalarm_security` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=481 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `aalarm_motioneventpictures`
--

DROP TABLE IF EXISTS `aalarm_motioneventpictures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_motioneventpictures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `security_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aalarm_motioneventpictures_1647d06b` (`event_id`),
  KEY `aalarm_motioneventpictures_44501ebe` (`security_id`),
  CONSTRAINT `event_id_refs_id_466b3cb8` FOREIGN KEY (`event_id`) REFERENCES `aalarm_event` (`id`),
  CONSTRAINT `security_id_refs_id_1561ffb1` FOREIGN KEY (`security_id`) REFERENCES `aalarm_security` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `aalarm_parameter`
--

DROP TABLE IF EXISTS `aalarm_parameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_parameter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(50) NOT NULL,
  `group` varchar(50) NOT NULL,
  `value` varchar(250) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `showInUI` smallint(6) NOT NULL,
  `order` smallint(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=210 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_refsensortype`
--

LOCK TABLES `aalarm_refsensortype` WRITE;
/*!40000 ALTER TABLE `aalarm_refsensortype` DISABLE KEYS */;
INSERT INTO `aalarm_refsensortype` VALUES (1,'Global'),(2,'Door Sensor'),(3,'Service');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aalarm_refstate`
--

LOCK TABLES `aalarm_refstate` WRITE;
/*!40000 ALTER TABLE `aalarm_refstate` DISABLE KEYS */;
INSERT INTO `aalarm_refstate` VALUES (1,1,'offline','Offline','colorYellow'),(2,1,'timed','Online Timed','colorLightGreen'),(3,1,'online','Online','colorGreen'),(4,1,'intrusion','Intrusion','colorOrange'),(5,1,'warning','Warning','colorOrangeRed'),(6,1,'alert','Alert','colorRed'),(7,2,'open','Open','colorRed'),(8,2,'closed','Closed','colorGreen'),(9,3,'Running','Running','colorGreen'),(10,3,'Stopped','Stopped','colorRed');
/*!40000 ALTER TABLE `aalarm_refstate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aalarm_security`
--

DROP TABLE IF EXISTS `aalarm_security`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_security` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `camera` int(11) NOT NULL,
  `filename` varchar(80) NOT NULL,
  `frame` int(11) NOT NULL,
  `file_type` int(11) NOT NULL,
  `time_stamp` datetime NOT NULL,
  `text_event` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7679 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aalarm_secutiry`
--

DROP TABLE IF EXISTS `aalarm_secutiry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_secutiry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `camera` int(11) NOT NULL,
  `filename` varchar(80) NOT NULL,
  `frame` int(11) NOT NULL,
  `file_type` int(11) NOT NULL,
  `time_stamp` datetime NOT NULL,
  `text_event` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  CONSTRAINT `sensorType_id_refs_id_4916a54f` FOREIGN KEY (`sensorType_id`) REFERENCES `aalarm_refsensortype` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `aalarm_zmintrusion`
--

DROP TABLE IF EXISTS `aalarm_zmintrusion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_zmintrusion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `aalarm_zmintrusionpicture`
--

DROP TABLE IF EXISTS `aalarm_zmintrusionpicture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aalarm_zmintrusionpicture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zmIntrusion_id` int(11) NOT NULL,
  `path` varchar(250) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aalarm_zmintrusionpicture_1154e905` (`zmIntrusion_id`),
  CONSTRAINT `zmIntrusion_id_refs_id_28b2c332` FOREIGN KEY (`zmIntrusion_id`) REFERENCES `aalarm_zmintrusion` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;




UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-11-26 22:36:43
