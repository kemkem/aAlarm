-- phpMyAdmin SQL Dump
-- version 3.4.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 18, 2012 at 05:04 PM
-- Server version: 5.5.16
-- PHP Version: 5.3.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `aalarm`
--

-- --------------------------------------------------------

--
-- Table structure for table `LevelStatus`
--

CREATE TABLE IF NOT EXISTS `LevelStatus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `idRefLevelStatus` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `RefLevelStatus`
--

CREATE TABLE IF NOT EXISTS `RefLevelStatus` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `status` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `RefLevelStatus`
--

INSERT INTO `RefLevelStatus` (`id`, `status`) VALUES
(1, 'UNKNOWN'),
(2, 'OFFLINE'),
(3, 'ONLINE'),
(4, 'ONLINE_INTRUSION'),
(5, 'ONLINE_INTRUSION_WARNING'),
(6, 'ONLINE_INTRUSION_ALARM');

-- --------------------------------------------------------

--
-- Table structure for table `RefSensorState`
--

CREATE TABLE IF NOT EXISTS `RefSensorState` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `state` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `RefSensorState`
--

INSERT INTO `RefSensorState` (`id`, `state`) VALUES
(1, 'UNKNOWN'),
(2, 'CLOSE'),
(3, 'OPEN');

-- --------------------------------------------------------

--
-- Table structure for table `SensorState`
--

CREATE TABLE IF NOT EXISTS `SensorState` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `idRefSensorState` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
