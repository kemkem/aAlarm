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
INSERT INTO `aalarm_command` VALUES (1,'Set Online','Set alarm to online state','setOnline'),(2,'Set Offline','Set alarm to offline state','setOffline'),(3,'start ZoneMinder','startZoneMinder','startZoneMinder'),(4,'stop ZoneMinder','stopZoneMinder','stopZoneMinder'),(5,'start Music Playlist','startMusicPlaylist','startMusicPlaylist'),(6,'stop Music Playlist','stopMusicPlaylist','stopMusicPlaylist');
/*!40000 ALTER TABLE `aalarm_command` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `aalarm_refsensortype`
--

LOCK TABLES `aalarm_refsensortype` WRITE;
/*!40000 ALTER TABLE `aalarm_refsensortype` DISABLE KEYS */;
INSERT INTO `aalarm_refsensortype` VALUES (1,'Global'),(2,'Door Sensor'),(3,'Service');
/*!40000 ALTER TABLE `aalarm_refsensortype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `aalarm_refstate`
--

LOCK TABLES `aalarm_refstate` WRITE;
/*!40000 ALTER TABLE `aalarm_refstate` DISABLE KEYS */;
INSERT INTO `aalarm_refstate` VALUES (1,1,'offline','Offline','colorYellow'),(2,1,'timed','Online Timed','colorLightGreen'),(3,1,'online','Online','colorGreen'),(4,1,'intrusion','Intrusion','colorOrange'),(5,1,'warning','Warning','colorOrangeRed'),(6,1,'alert','Alert','colorRed'),(7,2,'open','Open','colorRed'),(8,2,'closed','Closed','colorGreen'),(9,3,'Running','Running','colorGreen'),(10,3,'Stopped','Stopped','colorRed');
/*!40000 ALTER TABLE `aalarm_refstate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `aalarm_sensor`
--

LOCK TABLES `aalarm_sensor` WRITE;
/*!40000 ALTER TABLE `aalarm_sensor` DISABLE KEYS */;
INSERT INTO `aalarm_sensor` VALUES (1,1,'Global','Global',0),(2,2,'Door1','Main Door',1),(3,3,'ZoneMinder','ZoneMinder',0),(4,3,'MusicPlaylist','Music Playlist',0);
/*!40000 ALTER TABLE `aalarm_sensor` ENABLE KEYS */;
UNLOCK TABLES;

