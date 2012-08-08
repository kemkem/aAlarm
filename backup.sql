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

CREATE TABLE IF NOT EXISTS `Event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `sensorState` tinyint(4) NOT NULL,
  `sensorId` tinyint(4) NOT NULL,
  `globalState` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;


-- --------------------------------------------------------

--
-- Table structure for table `RefSensor`
--

CREATE TABLE IF NOT EXISTS `RefSensorState` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `state` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `RefSensor`
--

INSERT INTO `RefSensorState` (`id`, `state`) VALUES
(0, 'CLOSE'),
(1, 'OPEN');

-- --------------------------------------------------------

--
-- Table structure for table `RefStatus`
--

CREATE TABLE IF NOT EXISTS `RefGlobalState` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `state` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `RefStatus`
--

INSERT INTO `RefGlobalState` (`id`, `state`) VALUES
(0, 'OFFLINE'),
(1, 'ONLINE_TIMED'),
(2, 'ONLINE'),
(3, 'ONLINE_INTRUSION'),
(4, 'ONLINE_INTRUSION_WARNING'),
(5, 'ONLINE_INTRUSION_ALARM');

CREATE TABLE IF NOT EXISTS `Commands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `command` varchar(20) NOT NULL,
  `completed` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
