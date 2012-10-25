-- phpMyAdmin SQL Dump
-- version 3.4.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 23, 2012 at 06:44 PM
-- Server version: 5.5.16
-- PHP Version: 5.3.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `aalarm`
--

-- --------------------------------------------------------

--
-- Table structure for table `Event`
--

drop table IF EXISTS Event;
drop table IF EXISTS Commands;
drop table IF EXISTS RefState;
drop table IF EXISTS Sensor;

CREATE TABLE IF NOT EXISTS `Event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `stateType` tinyint(4) NOT NULL,
  `sensorId` tinyint(4) NOT NULL,
  `state` tinyint(4) NOT NULL,
  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Sensor` (
	`id` tinyint(11) NOT NULL,
	`name` varchar(25) NOT NULL,
	
	PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Table structure for table `RefSensor`
--

CREATE TABLE IF NOT EXISTS `RefState` (
  `id` tinyint(4) NOT NULL ,
  `stateType` tinyint(4) NOT NULL,
  `state` varchar(20) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

--
-- Dumping data for table `RefSensor`
--

INSERT INTO `RefState` (`stateType`,`id`, `state`) VALUES
(1, 101, 'UNKNOWN'),
(1, 0, 'CLOSE'),
(1, 1, 'OPEN'),
(0, 101, 'DISCONNECTED'),
(0, 0, 'OFFLINE'),
(0, 1, 'ONLINE_TIMED'),
(0, 2, 'ONLINE'),
(0, 3, 'ONLINE_INTRUSION'),
(0, 4, 'ONLINE_INTRUSION_WARNING'),
(0, 5, 'ONLINE_INTRUSION_ALARM');

--
-- Table structure for table `Command`
--
CREATE TABLE IF NOT EXISTS `Command` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `command` varchar(20) NOT NULL,
  `completed` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `User`
--

CREATE TABLE IF NOT EXISTS `User` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL
  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

--
-- Table structure for table `Config`
--

CREATE TABLE IF NOT EXISTS `Config` (
  `ckey` varchar(50) NOT NULL,
  `cvalue` varchar(50) NOT NULL
  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

--
-- Table structure for table `Alert`
--

CREATE TABLE IF NOT EXISTS `Alert` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `sensorId` int(11) NOT NULL,
  `state` tinyint(4) NOT NULL,
  `active` tinyint(1) NOT NULL
  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;