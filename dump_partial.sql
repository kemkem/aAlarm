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


--
-- Table structure for table `aalarm_event`
--




--
-- Dumping data for table `aalarm_refstate`
--

LOCK TABLES `aalarm_refstate` WRITE;
/*!40000 ALTER TABLE `aalarm_refstate` DISABLE KEYS */;
INSERT INTO `aalarm_refstate` VALUES (1,1,'Open',''),(2,1,'Close',''),(3,2,'Offline',''),(4,2,'Online Timed',''),(5,2,'Online',''),(6,2,'Intrusion',''),(7,2,'Warning',''),(8,2,'Alert','');
/*!40000 ALTER TABLE `aalarm_refstate` ENABLE KEYS */;
UNLOCK TABLES;

