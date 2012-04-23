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
  `sensor` tinyint(4) NOT NULL,
  `status` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `Event`
--

INSERT INTO `Event` (`id`, `date`, `sensor`, `status`) VALUES
(1, '2012-04-15 05:16:21', 1, 1),
(2, '2012-04-15 14:24:44', 1, 2),
(3, '2012-04-15 20:50:46', 2, 1),
(4, '2012-04-16 05:29:46', 2, 2),
(5, '2012-04-17 08:37:45', 2, 6),
(6, '2012-04-17 21:53:54', 1, 4),
(7, '2012-04-18 05:18:36', 2, 6),
(8, '2012-04-18 10:38:18', 1, 5);

-- --------------------------------------------------------

--
-- Table structure for table `RefSensor`
--

CREATE TABLE IF NOT EXISTS `RefSensor` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `sensor` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `RefSensor`
--

INSERT INTO `RefSensor` (`id`, `sensor`) VALUES
(1, 'UNKNOWN'),
(2, 'CLOSE'),
(3, 'OPEN');

-- --------------------------------------------------------

--
-- Table structure for table `RefStatus`
--

CREATE TABLE IF NOT EXISTS `RefStatus` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `status` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `RefStatus`
--

INSERT INTO `RefStatus` (`id`, `status`) VALUES
(1, 'UNKNOWN'),
(2, 'OFFLINE'),
(3, 'ONLINE'),
(4, 'ONLINE_INTRUSION'),
(5, 'ONLINE_INTRUSION_WARNING'),
(6, 'ONLINE_INTRUSION_ALARM'),
(7, 'ONLINE_TIMED');

CREATE TABLE IF NOT EXISTS `Commands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `command` varchar(20) NOT NULL,
  `completed` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
