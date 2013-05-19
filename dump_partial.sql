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
-- Dumping data for table `aalarm_command`
--

LOCK TABLES `aalarm_command` WRITE;
/*!40000 ALTER TABLE `aalarm_command` DISABLE KEYS */;
INSERT INTO `aalarm_command` VALUES (1,'setOnline'),(2,'setOffline');
/*!40000 ALTER TABLE `aalarm_command` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Dumping data for table `aalarm_event`
--

LOCK TABLES `aalarm_event` WRITE;
/*!40000 ALTER TABLE `aalarm_event` DISABLE KEYS */;
INSERT INTO `aalarm_event` VALUES (2,'2013-05-08 23:26:00',2,3),(3,'2013-05-08 23:26:06',2,4),(4,'2013-05-08 23:26:15',2,5),(5,'2013-05-08 23:26:20',1,1),(6,'2013-05-08 23:26:28',2,6),(7,'2013-05-08 23:26:37',2,7),(8,'2013-05-08 23:26:44',1,2),(9,'2013-05-08 23:27:27',2,8);
/*!40000 ALTER TABLE `aalarm_event` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Dumping data for table `aalarm_execute`
--

LOCK TABLES `aalarm_execute` WRITE;
/*!40000 ALTER TABLE `aalarm_execute` DISABLE KEYS */;
INSERT INTO `aalarm_execute` VALUES (59,1,'2013-05-11 16:27:52',0);
/*!40000 ALTER TABLE `aalarm_execute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `aalarm_parameter`
--

LOCK TABLES `aalarm_parameter` WRITE;
/*!40000 ALTER TABLE `aalarm_parameter` DISABLE KEYS */;
INSERT INTO `aalarm_parameter` VALUES (1,'pathLog','/home/kemkem/work/arduinoAlarm/log',0),(2,'portBase','/dev/ttyACM',0),(3,'portNumMin','0',0),(4,'portNumMax','5',0),(5,'reconnectTimeoutSecs','5',0),(6,'pathStartPlaylist','/home/kemkem/work/arduinoAlarm/sh/startPlaylist.sh &',0),(7,'pathStopPlaylist','/home/kemkem/work/arduinoAlarm/sh/stopPlaylist.sh &',0),(8,'pathStartZM','/home/kemkem/work/arduinoAlarm/sh/startZM.sh &',0),(9,'pathStopZM','/home/kemkem/work/arduinoAlarm/sh/stopZM.sh &',0),(10,'pathZmLast','/home/kemkem/work/arduinoAlarm/sh/zmLast.sh &',0),(11,'delayOnlineTimed','22',1),(12,'delayIntrusionWarning','20',1),(13,'delayIntrusionAlarm','40',1),(14,'delayIntrusionWarningTimeout','5',1),(15,'delayIntrusionAlarmTimeout','60',1),(16,'rate','9600;',0),(17,'refreshMs','200;',0),(18,'passwd','4578',0);
/*!40000 ALTER TABLE `aalarm_parameter` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Dumping data for table `aalarm_refsensortype`
--

LOCK TABLES `aalarm_refsensortype` WRITE;
/*!40000 ALTER TABLE `aalarm_refsensortype` DISABLE KEYS */;
INSERT INTO `aalarm_refsensortype` VALUES (1,'Door Sensor'),(2,'Global');
/*!40000 ALTER TABLE `aalarm_refsensortype` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Dumping data for table `aalarm_refstate`
--

LOCK TABLES `aalarm_refstate` WRITE;
/*!40000 ALTER TABLE `aalarm_refstate` DISABLE KEYS */;
INSERT INTO `aalarm_refstate` VALUES (1,1,'Open'),(2,1,'Close'),(3,2,'Offline'),(4,2,'Online Timed'),(5,2,'Online'),(6,2,'Intrusion'),(7,2,'Warning'),(8,2,'Alert');
/*!40000 ALTER TABLE `aalarm_refstate` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Dumping data for table `aalarm_sensor`
--

LOCK TABLES `aalarm_sensor` WRITE;
/*!40000 ALTER TABLE `aalarm_sensor` DISABLE KEYS */;
INSERT INTO `aalarm_sensor` VALUES (1,1,'Door 1'),(2,2,'Global');
/*!40000 ALTER TABLE `aalarm_sensor` ENABLE KEYS */;
UNLOCK TABLES;


