-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Gazdă: localhost
-- Timp de generare: apr. 30, 2021 la 11:03 AM
-- Versiune server: 5.7.29-0ubuntu0.18.04.1
-- Versiune PHP: 7.2.24-0ubuntu0.18.04.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Bază de date: `client106_samp`
--

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `panelactions2`
--

CREATE TABLE `panelactions2` (
  `id` int(11) NOT NULL,
  `actionid` int(11) NOT NULL,
  `actiontime` int(11) NOT NULL DEFAULT '0',
  `complaintid` int(11) NOT NULL DEFAULT '0',
  `playerid` int(11) NOT NULL,
  `giverid` int(11) NOT NULL,
  `playername` varchar(64) NOT NULL,
  `givername` varchar(64) NOT NULL,
  `reason` varchar(128) NOT NULL,
  `dm` int(3) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_bans`
--

CREATE TABLE `server_bans` (
  `ID` int(11) NOT NULL,
  `PlayerName` varchar(24) NOT NULL DEFAULT 'None',
  `PlayerID` int(11) NOT NULL DEFAULT '0',
  `AdminName` varchar(24) NOT NULL DEFAULT 'AdminName',
  `AdminID` int(11) NOT NULL DEFAULT '0',
  `Reason` varchar(64) NOT NULL DEFAULT 'None',
  `Days` int(11) NOT NULL DEFAULT '0',
  `Active` int(11) NOT NULL DEFAULT '1',
  `Date` varchar(32) NOT NULL DEFAULT 'None',
  `Permanent` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_bans_ip`
--

CREATE TABLE `server_bans_ip` (
  `ID` int(11) NOT NULL,
  `PlayerName` varchar(24) NOT NULL DEFAULT 'none',
  `PlayerID` int(11) NOT NULL DEFAULT '0',
  `PlayerIP` varchar(16) NOT NULL DEFAULT 'none',
  `AdminName` varchar(24) NOT NULL DEFAULT 'none',
  `AdminID` int(11) NOT NULL DEFAULT '0',
  `Reason` varchar(64) NOT NULL DEFAULT 'none',
  `Date` varchar(32) NOT NULL DEFAULT 'none',
  `Active` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_business`
--

CREATE TABLE `server_business` (
  `ID` int(11) NOT NULL,
  `Title` varchar(32) NOT NULL DEFAULT 'none',
  `Description` varchar(64) NOT NULL DEFAULT 'none',
  `Fee` int(11) NOT NULL,
  `Static` int(11) NOT NULL,
  `Type` int(11) NOT NULL,
  `X` float NOT NULL DEFAULT '0',
  `Y` float NOT NULL DEFAULT '0',
  `Z` float NOT NULL DEFAULT '0',
  `ExtX` float NOT NULL DEFAULT '0',
  `ExtY` float NOT NULL DEFAULT '0',
  `ExtZ` float NOT NULL DEFAULT '0',
  `Interior` int(11) NOT NULL,
  `VW` int(11) NOT NULL,
  `Owner` varchar(32) NOT NULL DEFAULT 'none',
  `Owned` int(11) NOT NULL DEFAULT '0',
  `Price` int(11) NOT NULL,
  `OwnerID` int(11) NOT NULL DEFAULT '-1',
  `Locked` int(11) NOT NULL,
  `Balance` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_business`
--

INSERT INTO `server_business` (`ID`, `Title`, `Description`, `Fee`, `Static`, `Type`, `X`, `Y`, `Z`, `ExtX`, `ExtY`, `ExtZ`, `Interior`, `VW`, `Owner`, `Owned`, `Price`, `OwnerID`, `Locked`, `Balance`) VALUES
(1, 'Bank Los Santos', 'The Bank Los Santos', 500, 0, 1, 2315.95, -1.61817, 26.7422, 1464.83, -1011.11, 26.8025, 0, 1, 'AdmBot', 1, 0, -1, 0, 10500),
(2, '24/7 Los Santos', 'The 24/7 Los Santos', 500, 0, 2, -25.8845, -185.869, 1003.55, 1154.09, -1771.65, 16.4356, 17, 2, 'AdmBot', 1, 0, -1, 0, 78500),
(3, 'CNN Los Santos', 'The CNN Los Santos', 0, 1, 3, 0, 0, 0, 1170.64, -1489.73, 22.7018, 0, 0, 'AdmBot', 1, 0, -1, 0, 0);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_chat_logs`
--

CREATE TABLE `server_chat_logs` (
  `ID` int(11) NOT NULL,
  `PlayerName` varchar(24) NOT NULL DEFAULT 'None',
  `PlayerID` int(11) NOT NULL DEFAULT '0',
  `ChatText` varchar(128) NOT NULL DEFAULT 'None',
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `server_chat_logs`
--

INSERT INTO `server_chat_logs` (`ID`, `PlayerName`, `PlayerID`, `ChatText`, `Time`) VALUES
(1, 'Vicentzo123', 1, 'asd', '2020-10-30 10:06:38'),
(2, 'Vicentzo123', 1, 'asd', '2020-10-30 10:06:38'),
(3, 'Vicentzo123', 1, 'asd', '2020-10-30 10:06:39'),
(4, 'Vicentzo123', 1, 'asd', '2020-10-30 10:06:39'),
(5, 'Vicentzo123', 1, 'asd', '2020-10-31 10:23:51'),
(6, 'Vicentzo123', 1, 'lol coaie', '2020-10-31 10:23:55'),
(7, 'Vicentzo123', 1, 'sugi pula', '2020-10-31 10:23:56'),
(8, 'Vicentzo123', 1, 'asd', '2020-10-31 10:30:14'),
(9, 'Vicentzo123', 1, 'asdkmaksdmkasmdkasmdsa', '2020-10-31 10:30:26'),
(10, 'Vicentzo123', 1, 'asjdnajsndjas', '2020-10-31 10:30:27'),
(11, 'Vicentzo123', 1, 'asd', '2020-10-31 10:57:40'),
(12, 'Vicentzo1234', 2, 'asd', '2020-10-31 13:54:01'),
(13, 'Vicentzo1234', 2, 'asd', '2020-10-31 13:54:01'),
(14, 'Vicentzo1234', 2, 'asd', '2020-10-31 13:54:02'),
(15, 'Vicentzo1234', 2, '/statsa', '2020-10-31 14:31:10'),
(16, 'Vicentzo123', 1, 'oh yes', '2020-11-14 13:02:56'),
(17, 'Vicentzo123', 1, 'asd', '2020-11-14 13:03:17'),
(18, 'Vicentzo123', 1, 'asd', '2020-11-14 13:09:14'),
(19, 'Vicentzo123', 1, 'asd', '2020-11-14 13:11:36'),
(20, 'Vicentzo123', 1, 'test', '2020-11-14 13:13:48'),
(21, 'Vicentzo123', 1, 'asd', '2020-11-22 15:26:31'),
(22, 'Vicentzo123', 1, 'fututmas pe mata', '2020-11-22 15:26:37'),
(23, 'Vicentzo123', 1, 'asd', '2020-11-22 15:56:22'),
(24, 'Vicentzo123', 1, 's', '2020-11-22 16:10:12'),
(25, 'Vicentzo123', 1, 'AM PULA MAD MASDASDASAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', '2020-11-22 16:20:57'),
(26, 'Vicentzo123', 1, 'sugi pula !', '2020-11-22 16:21:05'),
(27, 'Vicentzo123', 1, 'tas', '2020-11-22 16:26:37'),
(28, 'Vicentzo123', 1, '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890', '2020-11-22 16:26:57'),
(29, 'Vicentzo123', 1, '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678', '2020-11-22 16:26:59'),
(30, 'Vicentzo123', 1, '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678', '2020-11-22 16:27:14'),
(31, 'Vicentzo123', 1, '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678', '2020-11-22 16:27:15'),
(32, 'Vicentzo123', 1, '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678', '2020-11-22 16:27:26'),
(33, 'Vicentzo123', 1, '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678', '2020-11-22 16:27:26'),
(34, 'Vicentzo123', 1, '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678', '2020-11-22 16:27:26'),
(35, 'Vicentzo123', 1, '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678', '2020-11-22 16:27:27'),
(36, 'Vicentzo123', 1, '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678', '2020-11-22 16:27:28'),
(37, 'Vicentzo123', 1, 'Sta', '2020-11-22 16:31:17'),
(38, 'Vicentzo123', 1, 'asdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmask', '2020-11-22 16:31:45'),
(39, 'Vicentzo123', 1, 'asdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmask', '2020-11-22 16:31:49'),
(40, 'Vicentzo123', 1, 'asdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmaskdmasasdkmask', '2020-11-22 16:32:05'),
(41, 'Vicentzo123', 1, 'pizda', '2020-11-22 16:32:16'),
(42, 'Vicentzo123', 1, 'asd', '2020-11-23 16:39:13'),
(43, 'Vicentzo123', 1, 's-a dus pa pula uetheru', '2020-11-23 16:39:18'),
(44, 'Vicentzo123', 1, 'Vre', '2020-11-24 12:42:25'),
(45, 'Vicentzo123', 1, 'asd', '2020-11-24 16:52:42'),
(46, 'Vicentzo123', 1, 'e cv', '2020-11-24 19:54:30'),
(47, 'Vicentzo123', 1, '', '2020-11-26 11:47:58'),
(48, 'Vicentzo123', 1, 'asd', '2020-12-14 22:07:51'),
(49, 'Vicentzo123', 1, 'asd', '2020-12-14 22:17:47'),
(50, 'Vicentzo123', 1, 'asdasdsa', '2020-12-14 22:17:49'),
(51, 'Vicentzo123', 1, 'mumata', '2020-12-14 22:17:53'),
(52, 'Vicentzo123', 1, 'sa imi bag pola', '2020-12-14 22:17:57'),
(53, 'Vicentzo123', 1, 'in ma-ta', '2020-12-14 22:17:58'),
(54, 'Vicentzo123', 1, '/fl', '2020-12-15 13:49:26'),
(55, 'Vicentzo123', 1, 'asd', '2020-12-18 18:27:15'),
(56, 'Vicentzo123', 1, 'asd', '2020-12-19 20:14:17'),
(57, 'Vicentzo123', 1, 'fl', '2020-12-20 18:24:05'),
(58, 'Vicentzo123', 1, 'asd', '2020-12-25 15:56:01'),
(59, 'Vicentzo123', 1, 's/tats', '2020-12-29 20:51:17'),
(60, 'Vicentzo123', 1, '416 - ambulanta 489 - rancher', '2020-12-29 20:55:37'),
(61, 'Vicentzo123', 1, '416 - ambulanta 489 - rancher x', '2020-12-29 20:55:38'),
(62, 'Vicentzo123', 1, '416 - ambulanta 489 - rancher', '2020-12-29 21:30:14'),
(63, 'Vicentzo123', 1, '416 - ambulanta 489 - rancher x', '2020-12-29 21:30:15'),
(64, 'Vicentzo123', 1, 'f/spec', '2020-12-29 22:01:08'),
(65, 'Vicentzo123', 1, '416 - 489', '2021-01-01 23:09:53'),
(66, 'Vicentzo123', 1, '416 - 489', '2021-01-01 23:15:20'),
(67, 'Vicentzo123', 1, 'asd', '2021-02-20 15:10:20'),
(68, 'Vicentzo123', 1, 'yeeeeeeeeee', '2021-02-20 20:32:28'),
(69, 'qaim.exe', 4, 'Arata asta ', '2021-02-20 20:32:34'),
(70, 'qaim.exe', 4, 'Alb', '2021-02-20 20:32:36'),
(71, 'Vicentzo123', 1, 'ce alb', '2021-02-20 20:32:39'),
(72, 'qaim.exe', 4, 'Imi arata asta ca gen is in cer', '2021-02-20 20:32:45'),
(73, 'qaim.exe', 4, 'Wtf', '2021-02-20 20:32:46'),
(74, 'qaim.exe', 4, 'Revin cu al cont', '2021-02-20 20:32:50'),
(75, 'qaim.exe', 4, 'St', '2021-02-20 20:32:51'),
(76, 'qaim', 6, 'Coaie imi arata ca sunt in cer', '2021-02-20 20:38:02'),
(77, 'qaim', 6, 'Nu inteleg', '2021-02-20 20:38:04'),
(78, 'qaim', 6, '...', '2021-02-20 20:38:05'),
(79, 'Vicentzo123', 1, 'cum adika', '2021-02-20 20:38:08'),
(80, 'qaim', 6, 'Imi arata albastru', '2021-02-20 20:38:13'),
(81, 'Vicentzo123', 1, 'fa ss', '2021-02-20 20:38:14'),
(82, 'Vicentzo123', 1, 'sa vad', '2021-02-20 20:38:15'),
(83, 'qaim', 6, 'Nush cum sa iti explic', '2021-02-20 20:38:16'),
(84, 'qaim', 6, 'Ok', '2021-02-20 20:38:18'),
(85, 'qaim', 6, '.', '2021-02-20 20:40:30'),
(86, 'Vicentzo123', 1, 'asd', '2021-02-20 20:41:56'),
(87, 'qaim.exe', 4, 'ro', '2021-02-20 20:59:11'),
(88, 'Vicentzo123', 1, 'asd', '2021-02-20 21:05:22'),
(89, 'Vicentzo123', 1, 'pula', '2021-02-20 21:05:23'),
(90, 'Vicentzo123', 1, 'ba ideea e ca cand iti mai dai respawn', '2021-02-20 21:07:51'),
(91, 'Vicentzo123', 1, 'se freaca jocu', '2021-02-20 21:07:57'),
(92, 'Vicentzo123', 1, 'uite', '2021-02-20 21:08:05'),
(93, 'qaim.exe', 4, 'What', '2021-02-20 21:08:14'),
(94, 'Vicentzo123', 1, '=)))))))))))', '2021-02-20 21:08:15'),
(95, 'Vicentzo123', 1, 'esti civil', '2021-02-20 21:08:17'),
(96, 'qaim.exe', 4, 'Wtf =]]', '2021-02-20 21:08:17'),
(97, 'Vicentzo123', 1, 'si te scot', '2021-02-20 21:08:18'),
(98, 'Vicentzo123', 1, 'din civilian', '2021-02-20 21:08:19'),
(99, 'Vicentzo123', 1, 'mafia', '2021-02-20 21:08:20'),
(100, 'qaim.exe', 4, 'Dc iarasi ', '2021-02-20 21:08:22'),
(101, 'Vicentzo123', 1, 'hahahahah', '2021-02-20 21:08:22'),
(102, 'qaim.exe', 4, 'Aia', '2021-02-20 21:08:23'),
(103, 'qaim.exe', 4, 'Te dq', '2021-02-20 21:08:25'),
(104, 'Vicentzo123', 1, 'iar te-a dat asa', '2021-02-20 21:08:26'),
(105, 'Vicentzo123', 1, '?', '2021-02-20 21:08:27'),
(106, 'qaim.exe', 4, 'Da', '2021-02-20 21:08:31'),
(107, 'Vicentzo123', 1, 'ba am gasit un bug', '2021-02-20 21:08:35'),
(108, 'Vicentzo123', 1, 'macar =)))', '2021-02-20 21:08:36'),
(109, 'Vicentzo123', 1, 'stai sa-l fac', '2021-02-20 21:08:38'),
(110, 'Vicentzo123', 1, 'manet', '2021-02-20 21:10:24'),
(111, 'qaim.exe', 4, 'Ha ?', '2021-02-20 21:10:28'),
(112, 'Vicentzo123', 1, 'esti pregatit sa te scot din civil', '2021-02-20 21:10:28'),
(113, 'Vicentzo123', 1, 'daca esti civil', '2021-02-20 21:10:31'),
(114, 'qaim.exe', 4, 'DA', '2021-02-20 21:10:31'),
(115, 'Vicentzo123', 1, '=)))))))))))))', '2021-02-20 21:10:35'),
(116, 'qaim.exe', 4, ' /fpk me =]]', '2021-02-20 21:10:36'),
(117, 'qaim.exe', 4, ' /fk', '2021-02-20 21:10:39'),
(118, 'Vicentzo123', 1, 'MA CE', '2021-02-20 21:10:40'),
(119, 'qaim.exe', 4, 'Omg', '2021-02-20 21:10:41'),
(120, 'qaim.exe', 4, '=]]', '2021-02-20 21:10:42'),
(121, 'Vicentzo123', 1, 'CUM', '2021-02-20 21:10:42'),
(122, 'qaim.exe', 4, '=]]]', '2021-02-20 21:10:44'),
(123, 'Vicentzo123', 1, 'stai asa', '2021-02-20 21:10:44'),
(124, 'Vicentzo123', 1, 'BAGAMIAS', '2021-02-20 21:10:46'),
(125, 'qaim.exe', 4, '???', '2021-02-20 21:10:49'),
(126, 'Vicentzo123', 1, 'asd', '2021-02-20 21:15:04'),
(127, 'Vicentzo123', 1, 'AKUM O SA TE SKOT', '2021-02-20 21:15:20'),
(128, 'Vicentzo123', 1, 'DIN KIVILIAN', '2021-02-20 21:15:23'),
(129, 'Vicentzo123', 1, 'MAFIOA', '2021-02-20 21:15:24'),
(130, 'Vicentzo123', 1, 'esti', '2021-02-20 21:15:28'),
(131, 'qaim.exe', 4, 'Baa', '2021-02-20 21:15:32'),
(132, 'Vicentzo123', 1, 'stai we', '2021-02-20 21:15:35'),
(133, 'qaim.exe', 4, 'Aceiasi problema ca inainte', '2021-02-20 21:15:36'),
(134, 'Vicentzo123', 1, 'ma ke', '2021-02-20 21:15:40'),
(135, 'qaim.exe', 4, 'Skripter', '2021-02-20 21:15:42'),
(136, 'Vicentzo123', 1, 'esti intr-o factiune', '2021-02-20 21:15:43'),
(137, 'Vicentzo123', 1, 'ba', '2021-02-20 21:15:49'),
(138, 'qaim.exe', 4, '?', '2021-02-20 21:15:52'),
(139, 'Vicentzo123', 1, 'fa-ti in pula mea alt cont', '2021-02-20 21:15:54'),
(140, 'Vicentzo123', 1, 'ca ti s-a clocit', '2021-02-20 21:15:55'),
(141, 'Vicentzo123', 1, 'contu', '2021-02-20 21:15:56'),
(142, 'qaim.exe', 4, 'Pfft', '2021-02-20 21:15:58'),
(143, 'Vicentzo123', 1, '=)))))))))', '2021-02-20 21:15:58'),
(144, 'Vicentzo123', 1, '/duty', '2021-02-20 21:16:13'),
(145, 'qAim.dll', 7, '.', '2021-02-20 21:18:05'),
(146, 'qAim.dll', 7, 'csf', '2021-02-20 21:18:08'),
(147, 'qAim.dll', 7, 'cand ai pula mare', '2021-02-20 21:18:11'),
(148, 'qAim.dll', 7, ':DDD', '2021-02-20 21:18:13'),
(149, 'qAim.dll', 7, 'Cand ai o pula mare, ma ta o are mica', '2021-02-20 21:18:19'),
(150, 'qAim.dll', 7, 'tacpacmuie', '2021-02-20 21:18:21'),
(151, 'Vicentzo123', 1, 'r/respawn 0', '2021-02-21 10:21:39'),
(152, 'PicuEboss', 8, 'qa', '2021-02-21 15:01:59'),
(153, 'PicuEboss', 8, 'z', '2021-02-21 15:03:11'),
(154, 'PicuEboss', 8, 'picat', '2021-02-21 15:03:14'),
(155, 'PicuEboss', 8, 'dlall', '2021-02-21 15:03:21'),
(156, 'PicuEboss', 8, 'zlllkzlzlllllddddd', '2021-02-21 15:03:29'),
(157, 'Vicentzo123', 1, 'asd', '2021-02-23 15:35:12'),
(158, 'qaim.exe', 4, 'Coxu', '2021-02-23 15:39:34'),
(159, 'Vicentzo123', 1, 'sal coie', '2021-02-23 15:39:34'),
(160, 'qaim.exe', 4, 'Sal', '2021-02-23 15:39:37'),
(161, 'qaim.exe', 4, 'Cu neregeu', '2021-02-23 15:39:39'),
(162, 'qaim.exe', 4, 'Era de la host', '2021-02-23 15:39:42'),
(163, 'qaim.exe', 4, 'Bobitz', '2021-02-23 15:39:43'),
(164, 'Vicentzo123', 1, 'mam coxat incat am rezolvat bugu', '2021-02-23 15:39:50'),
(165, 'qaim.exe', 4, ':)))', '2021-02-23 15:39:53'),
(166, 'Vicentzo123', 1, 'atat de tare', '2021-02-23 15:39:54'),
(167, 'qaim.exe', 4, 'Cox', '2021-02-23 15:39:54'),
(168, 'qaim.exe', 4, 'Ba cox', '2021-02-23 15:39:57'),
(169, 'qaim.exe', 4, 'Ai dat sub ?', '2021-02-23 15:39:59'),
(170, 'Vicentzo123', 1, '?', '2021-02-23 15:39:59'),
(171, 'Vicentzo123', 1, 'nu', '2021-02-23 15:40:01'),
(172, 'qaim.exe', 4, 'Te om esti', '2021-02-23 15:40:05'),
(173, 'qaim.exe', 4, 'Smor', '2021-02-23 15:40:06'),
(174, 'Vicentzo123', 1, 'dak faki o muie da', '2021-02-23 15:40:07'),
(175, 'qaim.exe', 4, 'Coxatu puli', '2021-02-23 15:40:09'),
(176, 'qaim.exe', 4, 'Ba pulifric', '2021-02-23 15:40:14'),
(177, 'Vicentzo123', 1, 'faki o muie', '2021-02-23 15:40:16'),
(178, 'Vicentzo123', 1, '=)))))))', '2021-02-23 15:40:17'),
(179, 'qaim.exe', 4, 'Nu', '2021-02-23 15:40:17'),
(180, 'qaim.exe', 4, '=]', '2021-02-23 15:40:18'),
(181, 'Vicentzo123', 1, 'ba era de la hostu puli', '2021-02-23 15:40:23'),
(182, 'Vicentzo123', 1, 'bagamias pula peste aia in casa', '2021-02-23 15:40:26'),
(183, 'qaim.exe', 4, 'Stiu', '2021-02-23 15:40:28'),
(184, 'qaim.exe', 4, '=]]', '2021-02-23 15:40:29'),
(185, 'qaim.exe', 4, 'Ba coxatul', '2021-02-23 15:40:33'),
(186, 'qaim.exe', 4, 'Ba coxatule', '2021-02-23 15:40:34'),
(187, 'Vicentzo123', 1, 'da sa imi trag pula-n ei ca am stat 3 zile', '2021-02-23 15:40:36'),
(188, 'Vicentzo123', 1, 'anpulea', '2021-02-23 15:40:37'),
(189, 'qaim.exe', 4, 'Hai sa testam ', '2021-02-23 15:40:41'),
(190, 'Vicentzo123', 1, 'zi ', '2021-02-23 15:40:42'),
(191, 'qaim.exe', 4, 'Ca am trb', '2021-02-23 15:40:43'),
(192, 'qaim.exe', 4, 'Coxu puli', '2021-02-23 15:40:45'),
(193, 'Vicentzo123', 1, 'ba mai daten pula mea', '2021-02-23 15:40:47'),
(194, 'qaim.exe', 4, 'Si da-mi adm', '2021-02-23 15:40:48'),
(195, 'Vicentzo123', 1, 'ce treaba aai tu ma', '2021-02-23 15:40:50'),
(196, 'Vicentzo123', 1, 'ca infaara de supt pula si dat muie nu ai', '2021-02-23 15:40:55'),
(197, 'qaim.exe', 4, 'Am de editat video ma ', '2021-02-23 15:40:56'),
(198, 'qaim.exe', 4, 'Te n buric', '2021-02-23 15:40:58'),
(199, 'qaim.exe', 4, 'Eee sa nu ti fut o pula n trahee acum', '2021-02-23 15:41:03'),
(200, 'qaim.exe', 4, 'Si tie si lu ma ta', '2021-02-23 15:41:07'),
(201, 'Vicentzo123', 1, '=))', '2021-02-23 15:41:08'),
(202, 'qaim.exe', 4, 'Bulangiu puli', '2021-02-23 15:41:09'),
(203, 'Vicentzo123', 1, 'da sa-mi trag pula-n papilele tale', '2021-02-23 15:41:14'),
(204, 'qaim.exe', 4, 'Ba trageamia-si pula-n plamanii tai', '2021-02-23 15:41:24'),
(205, 'Vicentzo123', 1, 'te-am chemat sa vedem daca ti se fute tie jocu asa cum te fut eu  pe tine', '2021-02-23 15:41:34'),
(206, 'qaim.exe', 4, 'Na futute-as ', '2021-02-23 15:43:21'),
(207, 'Vicentzo123', 1, '', '2021-02-23 15:45:42'),
(208, 'qaim.exe', 4, 'sictir', '2021-02-23 15:47:09'),
(209, 'qaim.exe', 4, '=]]', '2021-02-23 15:47:10'),
(210, 'Vicentzo123', 1, 'na ai belit pula', '2021-02-23 15:47:10'),
(211, 'Vicentzo123', 1, 'nu ma omori', '2021-02-23 15:47:21'),
(212, 'Vicentzo123', 1, 'akuma', '2021-02-23 15:47:22'),
(213, 'Vicentzo123', 1, 'sugi pula', '2021-02-23 15:47:24'),
(214, 'Vicentzo123', 1, '=)))))))))))))', '2021-02-23 15:47:26'),
(215, 'qaim.exe', 4, '3/3', '2021-02-23 15:51:19'),
(216, 'Vicentzo123', 1, 'sugi pula', '2021-02-23 15:51:19'),
(217, 'qaim.exe', 4, '=]', '2021-02-23 15:51:20'),
(218, 'Vicentzo123', 1, 'te bane', '2021-02-23 15:51:21'),
(219, 'Vicentzo123', 1, 'ez', '2021-02-23 15:51:35'),
(220, 'qaim.exe', 4, 'Ba te n sorici', '2021-02-23 15:51:37'),
(221, 'qaim.exe', 4, '=]]', '2021-02-23 15:51:37'),
(222, 'qaim.exe', 4, 'a =]]]', '2021-02-23 15:53:14'),
(223, 'Vicentzo123', 1, 'AHAHAHAH]', '2021-02-23 15:53:30'),
(224, '.Victor', 10, 'fsdf', '2021-02-23 19:27:40'),
(225, '.Victor', 10, 'f', '2021-02-23 19:29:25'),
(226, 'Vicentzo123', 9, 'uite un prost', '2021-02-23 19:29:31'),
(227, 'qaim.exe', 11, 'Re bagami as pula n ma ta', '2021-02-23 19:29:33'),
(228, 'Vicentzo123', 9, 'hai sa ne pisam pe el', '2021-02-23 19:29:33'),
(229, 'qaim.exe', 11, 'Admin 7', '2021-02-23 19:29:42'),
(230, 'qaim.exe', 11, 'Rp', '2021-02-23 19:29:44'),
(231, 'qaim.exe', 11, 'd', '2021-02-23 19:29:45'),
(232, 'qaim.exe', 11, 'Ca bag scema ionel', '2021-02-23 19:29:48'),
(233, '.Victor', 10, 'aff', '2021-02-23 19:29:49'),
(234, 'Vicentzo123', 9, 'ia bago ma', '2021-02-23 19:29:51'),
(235, 'Vicentzo123', 9, 'ia', '2021-02-23 19:29:52'),
(236, 'Vicentzo123', 9, 'ca iti iei ban', '2021-02-23 19:29:54'),
(237, 'Vicentzo123', 9, 'ahahahah', '2021-02-23 19:29:55'),
(238, 'qaim.exe', 11, 'Nu merge e buguit =]]', '2021-02-23 19:30:00'),
(239, 'qaim.exe', 11, 'De frica mi ai dat admin', '2021-02-23 19:30:04'),
(240, 'Vicentzo123', 9, 'daaa', '2021-02-23 19:30:07'),
(241, 'Vicentzo123', 9, 'uite ca pe pantalon', '2021-02-23 19:30:10'),
(242, 'Vicentzo123', 9, 'am o pata de pisat', '2021-02-23 19:30:12'),
(243, 'Vicentzo123', 9, 'ba pizdo', '2021-02-23 19:30:23'),
(244, 'Vicentzo123', 9, 'qaim', '2021-02-23 19:30:26'),
(245, 'qaim.exe', 11, 'Ce vrei fa', '2021-02-23 19:30:27'),
(246, 'Vicentzo123', 9, 'stai aici', '2021-02-23 19:30:30'),
(247, 'qaim.exe', 11, 'Hai ca iau miniganu', '2021-02-23 19:30:32'),
(248, 'Vicentzo123', 9, 'ma ce pula mea', '2021-02-23 19:30:48'),
(249, 'Vicentzo123', 9, 'am gresit sintaxa', '2021-02-23 19:30:49'),
(250, 'Vicentzo123', 9, 'futuman ea', '2021-02-23 19:30:51'),
(251, 'qaim.exe', 11, '=]]]]]]]]]]]]]]', '2021-02-23 19:30:53'),
(252, 'qaim.exe', 11, 'Ce prost esti', '2021-02-23 19:30:55'),
(253, 'qaim.exe', 11, '1v1 ?', '2021-02-23 19:32:40'),
(254, 'qaim.exe', 11, 'st ma', '2021-02-23 19:32:50'),
(255, 'qaim.exe', 11, 'nab', '2021-02-23 19:33:56'),
(256, 'qaim.exe', 11, '=]', '2021-02-23 19:33:57'),
(257, '.Victor', 10, 'Zi id', '2021-02-23 19:34:22'),
(258, 'qaim.exe', 11, '2', '2021-02-23 19:34:25'),
(259, 'qaim.exe', 11, '24', '2021-02-23 19:34:27'),
(260, '.Victor', 10, '3', '2021-02-23 19:34:37'),
(261, '.Victor', 10, '2', '2021-02-23 19:34:38'),
(262, '.Victor', 10, '1', '2021-02-23 19:34:40'),
(263, '.Victor', 10, 'Ho', '2021-02-23 19:34:43'),
(264, 'qaim.exe', 11, '?', '2021-02-23 19:34:46'),
(265, '.Victor', 10, 'Tranquilo', '2021-02-23 19:34:46'),
(266, '.Victor', 10, 'la Go', '2021-02-23 19:34:48'),
(267, 'qaim.exe', 11, '=]', '2021-02-23 19:34:48'),
(268, 'qaim.exe', 11, '3', '2021-02-23 19:34:50'),
(269, 'qaim.exe', 11, '2', '2021-02-23 19:34:51'),
(270, 'qaim.exe', 11, '1', '2021-02-23 19:34:51'),
(271, 'qaim.exe', 11, 'go', '2021-02-23 19:34:52'),
(272, 'qaim.exe', 11, 'paleta is', '2021-02-23 19:35:01'),
(273, 'qaim.exe', 11, '=]]', '2021-02-23 19:35:01'),
(274, '.Victor', 10, 'jos', '2021-02-23 19:35:02'),
(275, 'qaim.exe', 11, 'go', '2021-02-23 19:35:13'),
(276, 'qaim.exe', 11, '3', '2021-02-23 19:35:16'),
(277, 'qaim.exe', 11, '3', '2021-02-23 19:35:25'),
(278, 'qaim.exe', 11, '2', '2021-02-23 19:35:26'),
(279, 'qaim.exe', 11, '1', '2021-02-23 19:35:26'),
(280, 'qaim.exe', 11, 'go', '2021-02-23 19:35:27'),
(281, 'qaim.exe', 11, 'jso', '2021-02-23 19:35:50'),
(282, 'Vicentzo123', 9, 'vino incoa', '2021-02-23 19:38:25'),
(283, 'qaim.exe', 11, 're futute n gura', '2021-02-23 19:38:28'),
(284, 'qaim.exe', 11, 'Nu imi arata tot', '2021-02-23 19:38:35'),
(285, 'qaim.exe', 11, 'Stai ma', '2021-02-23 19:38:36'),
(286, 'Vicentzo123', 9, 'stiu', '2021-02-23 19:38:39'),
(287, 'Vicentzo123', 9, 'nici mie', '2021-02-23 19:38:40'),
(288, 'qaim.exe', 11, 'Am intles', '2021-02-23 19:38:49'),
(289, 'Vicentzo123', 9, 'dai /accept invite 0', '2021-02-23 19:38:50'),
(290, 'qaim.exe', 11, 'Stai ma', '2021-02-23 19:38:53'),
(291, 'Vicentzo123', 9, 'vezi ciatu?', '2021-02-23 19:39:00'),
(292, 'Vicentzo123', 9, 'vino sa dai duty', '2021-02-23 19:39:03'),
(293, 'qaim.exe', 11, 'Da', '2021-02-23 19:39:03'),
(294, 'Vicentzo123', 9, 'baga duty', '2021-02-23 19:39:08'),
(295, 'Vicentzo123', 9, '=)))))))))', '2021-02-23 19:39:11'),
(296, 'qaim.exe', 11, 'Asta e ocei', '2021-02-23 19:39:15'),
(297, 'qaim.exe', 11, 'Bon', '2021-02-23 19:39:16'),
(298, 'Vicentzo123', 9, 'civilule', '2021-02-23 19:39:16'),
(299, 'Vicentzo123', 9, 'hah', '2021-02-23 19:39:18'),
(300, 'Vicentzo123', 9, 'skinu se ia dupa rank', '2021-02-23 19:39:22'),
(301, 'qaim.exe', 11, '=]', '2021-02-23 19:39:22'),
(302, 'qaim.exe', 11, 'Frumos', '2021-02-23 19:39:26'),
(303, 'qaim.exe', 11, 'Apr', '2021-02-23 19:39:27'),
(304, 'Vicentzo123', 9, 'si la unele', '2021-02-23 19:39:27'),
(305, 'Vicentzo123', 9, 'sunt 2 sloturi', '2021-02-23 19:39:29'),
(306, 'Vicentzo123', 9, 'tre sa mai fac aateva verificari', '2021-02-23 19:39:35'),
(307, 'Vicentzo123', 9, 'ca la unele rankuri', '2021-02-23 19:39:37'),
(308, 'Vicentzo123', 9, 'e doar un skin', '2021-02-23 19:39:40'),
(309, 'Vicentzo123', 9, 'si eu am facut sa fie un numar random de 2 numere', '2021-02-23 19:39:46'),
(310, 'qaim.exe', 11, 'Am inteles', '2021-02-23 19:39:50'),
(311, 'Vicentzo123', 9, 'gen 1 sau 2 sau 0, dar am pus daca e 0 sa fie 1', '2021-02-23 19:39:53'),
(312, 'qaim.exe', 11, 'O sa l faci tu deja plm sa scrie si rank uri', '2021-02-23 19:39:55'),
(313, 'qaim.exe', 11, 'D alea', '2021-02-23 19:39:57'),
(314, 'Vicentzo123', 9, 'dar daca e 2, la ranku 7 se fute', '2021-02-23 19:40:03'),
(315, 'qaim.exe', 11, 'Nu facusi /find ?', '2021-02-23 19:40:05'),
(316, 'Vicentzo123', 9, 'nup', '2021-02-23 19:40:08'),
(317, 'qaim.exe', 11, 'Stai ma', '2021-02-23 19:40:13'),
(318, 'Vicentzo123', 9, 'mai reglez asta, fac find si comenzile esentiale', '2021-02-23 19:40:15'),
(319, 'qaim.exe', 11, 'Tu faci lspd de la 0 ?', '2021-02-23 19:40:19'),
(320, 'Vicentzo123', 9, 'eventual voi, faceti joburile teste', '2021-02-23 19:40:20'),
(321, 'Vicentzo123', 9, 'evident', '2021-02-23 19:40:22'),
(322, 'qaim.exe', 11, '...', '2021-02-23 19:40:24'),
(323, 'qaim.exe', 11, 'Clar', '2021-02-23 19:40:26'),
(324, 'Vicentzo123', 9, 'totul from 0', '2021-02-23 19:40:26'),
(325, 'Vicentzo123', 9, 'de ce clar?', '2021-02-23 19:40:28'),
(326, 'qaim.exe', 11, 'Coaie ai prea mult timp liber', '2021-02-23 19:40:32'),
(327, 'qaim.exe', 11, 'Lvpd / sfpd e usor deja de facut', '2021-02-23 19:40:38'),
(328, 'qaim.exe', 11, 'Le copiezi doar schimbi id ul ', '2021-02-23 19:40:48'),
(329, 'Vicentzo123', 9, 'pai daca FACI COMENZILE LA LSPD', '2021-02-23 19:40:49'),
(330, 'qaim.exe', 11, 'Si numele alea', '2021-02-23 19:40:50'),
(331, 'Vicentzo123', 9, 'pai daca faci comenzile la lspd', '2021-02-23 19:40:55'),
(332, 'Vicentzo123', 9, 'faci practic la toate', '2021-02-23 19:41:01'),
(333, 'qaim.exe', 11, 'Mdea', '2021-02-23 19:41:06'),
(334, 'Vicentzo123', 9, 'eu tre sa le fac pe astea momentan', '2021-02-23 19:41:06'),
(335, 'Vicentzo123', 9, '...', '2021-02-23 19:41:07'),
(336, 'Vicentzo123', 9, 'am pierdut alea 3 zile', '2021-02-23 19:41:14'),
(337, 'Vicentzo123', 9, 'ca daca nu ', '2021-02-23 19:41:16'),
(338, 'qaim.exe', 11, 'Pff', '2021-02-23 19:41:22'),
(339, 'qaim.exe', 11, 'Sv deschidem la care paste ?', '2021-02-23 19:41:26'),
(340, 'Vicentzo123', 9, 'te spreiez', '2021-02-23 19:41:27'),
(341, 'Vicentzo123', 9, 'la pastele matii', '2021-02-23 19:41:34'),
(342, 'Vicentzo123', 9, '=))))))))))', '2021-02-23 19:41:36'),
(343, 'qaim.exe', 11, 'Fain ca faci de la 0 dar iti ia mult timp', '2021-02-23 19:41:37'),
(344, 'qaim.exe', 11, '..', '2021-02-23 19:41:39'),
(345, 'Vicentzo123', 9, 'pai da coaie', '2021-02-23 19:41:41'),
(346, 'Vicentzo123', 9, 'dar eu fac cv de calitate', '2021-02-23 19:41:44'),
(347, 'Vicentzo123', 9, 'de multi jucatori', '2021-02-23 19:41:46'),
(348, 'qaim.exe', 11, 'Asta zi', '2021-02-23 19:41:48'),
(349, 'qaim.exe', 11, 'c', '2021-02-23 19:41:49'),
(350, 'qaim.exe', 11, 'Iti dai seama', '2021-02-23 19:41:52'),
(351, 'Vicentzo123', 9, 'am 193 de ticks ca e host nu asa bun', '2021-02-23 19:41:53'),
(352, 'qaim.exe', 11, 'Daca tot faci ce faci', '2021-02-23 19:41:56'),
(353, 'Vicentzo123', 9, 'dar pe celalalt 197-198', '2021-02-23 19:41:59'),
(354, 'qaim.exe', 11, 'Macar sa cumparam promo', '2021-02-23 19:42:02'),
(355, 'Vicentzo123', 9, 'depinde ', '2021-02-23 19:42:05'),
(356, 'Vicentzo123', 9, 'shadow ma intreaba', '2021-02-23 19:42:07'),
(357, 'Vicentzo123', 9, 'ca ce facem', '2021-02-23 19:42:09'),
(358, 'Vicentzo123', 9, 'da il chem la test', '2021-02-23 19:42:11'),
(359, 'Vicentzo123', 9, 'plm', '2021-02-23 19:42:14'),
(360, 'qaim.exe', 11, ':))', '2021-02-23 19:42:16'),
(361, 'qaim.exe', 11, 'Eu vin doar dac am timp', '2021-02-23 19:42:20'),
(362, 'Vicentzo123', 9, 'nu da semne de viata', '2021-02-23 19:42:21'),
(363, 'Vicentzo123', 9, 'e activ pe codeup', '2021-02-23 19:42:23'),
(364, 'qaim.exe', 11, 'Daca n am timp, plm', '2021-02-23 19:42:24'),
(365, 'Vicentzo123', 9, 'mai mult', '2021-02-23 19:42:24'),
(366, 'qaim.exe', 11, 'Ata ete', '2021-02-23 19:42:28'),
(367, 'qaim.exe', 11, 'Are alte principii', '2021-02-23 19:42:31'),
(368, 'Vicentzo123', 9, 'ce sa-i fac aia e', '2021-02-23 19:42:32'),
(369, 'Vicentzo123', 9, 'militian andar cavar', '2021-02-23 19:42:38'),
(370, 'qaim.exe', 11, 'Ce factiuni mai faci /', '2021-02-23 19:42:39'),
(371, '.Victor', 10, 'Re colegii gabori', '2021-02-23 19:42:40'),
(372, 'Vicentzo123', 9, 'hah', '2021-02-23 19:42:49'),
(373, 'qaim.exe', 11, 'Ce factiuni mai faci de la 0 ?', '2021-02-23 19:42:54'),
(374, 'Vicentzo123', 9, 'hah', '2021-02-23 19:42:57'),
(375, 'qaim.exe', 11, 'Taxi e usor de facut', '2021-02-23 19:42:58'),
(376, 'Vicentzo123', 9, 'frumos', '2021-02-23 19:43:05'),
(377, 'Vicentzo123', 9, 'n-ai duty', '2021-02-23 19:43:06'),
(378, 'qaim.exe', 11, 'Taxi stiu cum il faci', '2021-02-23 19:43:08'),
(379, 'Vicentzo123', 9, 'merge bine', '2021-02-23 19:43:09'),
(380, 'Vicentzo123', 9, 'mai tre sa fac asa', '2021-02-23 19:43:15'),
(381, 'Vicentzo123', 9, 'acum tre sa fac', '2021-02-23 19:43:17'),
(382, 'Vicentzo123', 9, 'lspd, terminat, fbi, national guard', '2021-02-23 19:43:25'),
(383, 'Vicentzo123', 9, 'atat doar', '2021-02-23 19:43:28'),
(384, 'Vicentzo123', 9, 'si dupa', '2021-02-23 19:43:29'),
(385, 'qaim.exe', 11, 'Apropo', '2021-02-23 19:43:33'),
(386, 'Vicentzo123', 9, 'taxi, 2 ganguri', '2021-02-23 19:43:33'),
(387, 'Vicentzo123', 9, 'si un mixt', '2021-02-23 19:43:35'),
(388, 'Vicentzo123', 9, 'adika hitman', '2021-02-23 19:43:39'),
(389, '.Victor', 10, 'Poftim', '2021-02-23 19:43:42'),
(390, 'qaim.exe', 11, 'Sa nu bagi /frisk /ticket si astea la alea fbi', '2021-02-23 19:43:44'),
(391, 'Vicentzo123', 9, 'nee', '2021-02-23 19:43:48'),
(392, 'qaim.exe', 11, 'Ce skin ai /', '2021-02-23 19:43:49'),
(393, '.Victor', 10, 'ia fa florile', '2021-02-23 19:43:51'),
(394, 'Vicentzo123', 9, 'alea se ocupa cu alt cv', '2021-02-23 19:43:53'),
(395, 'Vicentzo123', 9, 'nu amenzi', '2021-02-23 19:43:54'),
(396, 'qaim.exe', 11, 'Aiazci', '2021-02-23 19:43:56'),
(397, 'qaim.exe', 11, 'Aiazic', '2021-02-23 19:43:58'),
(398, 'qaim.exe', 11, 'Ca cam pe 99# din sv e asa', '2021-02-23 19:44:07'),
(399, 'qaim.exe', 11, 'Stati in plm', '2021-02-23 19:44:09'),
(400, 'qaim.exe', 11, 'Ca pun mana pe minigan', '2021-02-23 19:44:12'),
(401, 'Vicentzo123', 9, '=)))))))))))', '2021-02-23 19:44:16'),
(402, 'Vicentzo123', 9, 'pui mana pe pula mea ', '2021-02-23 19:44:23'),
(403, 'qaim.exe', 11, 'Prostu puli', '2021-02-23 19:45:17'),
(404, 'qaim.exe', 11, 'Ba pula', '2021-02-23 19:45:49'),
(405, 'qaim.exe', 11, 'Pai dai /save, nu ?', '2021-02-23 19:45:53'),
(406, 'qaim.exe', 11, 'Nimic nu tine la tn', '2021-02-23 19:47:58'),
(407, 'qaim.exe', 11, 'Smor', '2021-02-23 19:48:00'),
(408, 'Vicentzo123', 9, 'e de la sqlid', '2021-02-23 19:48:07'),
(409, 'Vicentzo123', 9, 'ca am modificat eu cv', '2021-02-23 19:48:09'),
(410, 'qaim.exe', 11, 'zoinx', '2021-02-23 19:50:00'),
(411, 'qaim.exe', 11, 'Vezi ca e grele', '2021-02-23 19:51:26'),
(412, 'qaim.exe', 11, 'Hai ne auzim', '2021-02-23 19:51:39'),
(413, 'qaim.exe', 11, 'Bafta', '2021-02-23 19:51:41'),
(414, 'PCGamer', 12, ']', '2021-03-21 10:43:16'),
(415, 'qaim.exe', 11, 'Mai ai de facut kate kv', '2021-03-22 18:55:17'),
(416, 'qaim.exe', 11, 'Gen asta', '2021-03-22 18:55:24'),
(417, 'qaim.exe', 11, 'Gen', '2021-03-22 18:57:07'),
(418, 'Vicentzo123', 9, 'hah', '2021-03-22 19:07:50'),
(419, 'Vicentzo123', 9, 'motiv runner/robber', '2021-03-22 19:07:54'),
(420, 'Vicentzo123', 9, 'motiv automat /su', '2021-03-22 19:07:57'),
(421, 'qaim.exe', 11, 'Nice', '2021-03-22 19:08:01'),
(422, 'Vicentzo123', 9, 'ai uanted sasa', '2021-03-22 19:08:03'),
(423, 'Vicentzo123', 9, 'ai supt pula akum', '2021-03-22 19:08:07'),
(424, 'qaim.exe', 11, 'Nasol', '2021-03-22 19:08:08'),
(425, 'qaim.exe', 11, 'Nudacil', '2021-03-22 19:08:14'),
(426, 'Vicentzo123', 9, 'stai in pizda mati', '2021-03-22 19:09:14'),
(427, 'Vicentzo123', 9, 'stai in pizda mati', '2021-03-22 19:09:17'),
(428, 'Vicentzo123', 9, 'ma ce', '2021-03-22 19:09:36'),
(429, 'qaim.exe', 11, 'nasol', '2021-03-22 19:09:36'),
(430, 'qaim.exe', 11, '=]]]', '2021-03-22 19:09:38'),
(431, 'Vicentzo123', 9, 'l-a descatusat', '2021-03-22 19:09:47'),
(432, 'qaim.exe', 11, 'st ma', '2021-03-22 19:10:50'),
(433, 'Vicentzo123', 9, 'nu iti da', '2021-03-22 19:10:55'),
(434, 'Vicentzo123', 9, '....', '2021-03-22 19:10:56'),
(435, 'Vicentzo123', 9, 'nu e facut inca', '2021-03-22 19:11:00'),
(436, 'Vicentzo123', 9, 'ca testam daca era facut', '2021-03-22 19:11:03'),
(437, 'qaim.exe', 11, 'N ai bagat incisoarea', '2021-03-22 19:11:04'),
(438, 'Vicentzo123', 9, 'PAI NU E FACUT...', '2021-03-22 19:11:09'),
(439, 'qaim.exe', 11, 'mdc mere', '2021-03-22 19:11:10'),
(440, 'qaim.exe', 11, 'so mere', '2021-03-22 19:11:14'),
(441, 'qaim.exe', 11, 'Apr', '2021-03-22 19:11:23'),
(442, 'Vicentzo123', 9, 'iti pot da wanted tie', '2021-03-22 19:11:24'),
(443, 'Vicentzo123', 9, 'aparent intre politisti', '2021-03-22 19:11:28'),
(444, 'Vicentzo123', 9, '=)))))))))))))', '2021-03-22 19:11:30'),
(445, 'qaim.exe', 11, 'Sa bagi /clear daca esti in masina', '2021-03-22 19:11:31'),
(446, 'Vicentzo123', 9, 'pai da', '2021-03-22 19:11:33'),
(447, 'Vicentzo123', 9, 'nu ', '2021-03-22 19:11:36'),
(448, 'qaim.exe', 11, 'lol', '2021-03-22 19:11:36'),
(449, 'qaim.exe', 11, '=]]]]', '2021-03-22 19:11:37'),
(450, 'Vicentzo123', 9, 'defapt', '2021-03-22 19:11:37'),
(451, 'Vicentzo123', 9, 'doar in hq', '2021-03-22 19:11:41'),
(452, 'Vicentzo123', 9, 'am pus', '2021-03-22 19:11:42'),
(453, 'qaim.exe', 11, 'why', '2021-03-22 19:11:44'),
(454, 'Vicentzo123', 9, 'ca in hq sa zicem ca ai baza de date', '2021-03-22 19:11:46'),
(455, 'Vicentzo123', 9, 'a wanted listului', '2021-03-22 19:11:49'),
(456, 'Vicentzo123', 9, 'e mai logic', '2021-03-22 19:11:51'),
(457, 'qaim.exe', 11, 'Oc', '2021-03-22 19:11:52'),
(458, 'Vicentzo123', 9, 'haida sa testam ', '2021-03-22 19:11:58'),
(459, 'YkeerO', 14, 'numi arata stelutele', '2021-03-22 19:12:25'),
(460, 'Vicentzo123', 9, 'luativa amandoi masini', '2021-03-22 19:13:25'),
(461, 'Vicentzo123', 9, 'diferite', '2021-03-22 19:13:34'),
(462, 'Vicentzo123', 9, 'nu pe g', '2021-03-22 19:13:35'),
(463, 'Vicentzo123', 9, 'pok pok', '2021-03-22 19:13:45'),
(464, 'qaim.exe', 11, 'E brb 1 minut', '2021-03-22 19:13:48'),
(465, 'Vicentzo123', 9, 'ai luato pulentiu an gura', '2021-03-22 19:13:49'),
(466, 'qaim.exe', 11, 'Is cu el pe dis', '2021-03-22 19:13:53'),
(467, 'qaim.exe', 11, 'NU TRAGHE', '2021-03-22 19:13:56'),
(468, 'Vicentzo123', 9, 'hah', '2021-03-22 19:13:58'),
(469, 'qaim.exe', 11, 'fmm', '2021-03-22 19:13:59'),
(470, 'Vicentzo123', 9, 'ba qaim', '2021-03-22 19:14:11'),
(471, 'Vicentzo123', 9, 'sa iti trag la moe', '2021-03-22 19:14:13'),
(472, 'Vicentzo123', 9, 'vrei', '2021-03-22 19:14:14'),
(473, 'qaim.exe', 11, 'Coaie', '2021-03-22 19:14:21'),
(474, 'Vicentzo123', 9, 'baaa', '2021-03-22 19:14:25'),
(475, 'Vicentzo123', 9, 'vreau sa testam ceva', '2021-03-22 19:14:28'),
(476, 'qaim.exe', 11, 'Iti var o pula ntre coaste iti intrerup calea respiratorie', '2021-03-22 19:14:34'),
(477, 'Vicentzo123', 9, 'vehiculele svf, rank si daca merge', '2021-03-22 19:14:35'),
(478, 'Vicentzo123', 9, 'vino incoa', '2021-03-22 19:14:36'),
(479, 'qaim.exe', 11, 'Ni ce comenteaza el', '2021-03-22 19:14:37'),
(480, 'qaim.exe', 11, 'mars', '2021-03-22 19:14:51'),
(481, 'Vicentzo123', 9, 'pizdo', '2021-03-22 19:14:53'),
(482, 'Vicentzo123', 9, 'da accept', '2021-03-22 19:14:54'),
(483, 'qaim.exe', 11, 'ce acpet ?', '2021-03-22 19:14:58'),
(484, 'qaim.exe', 11, 'acept', '2021-03-22 19:15:00'),
(485, 'Vicentzo123', 9, 'invite', '2021-03-22 19:15:01'),
(486, 'Vicentzo123', 9, 'aaaaa', '2021-03-22 19:15:03'),
(487, 'qaim.exe', 11, 'Nu mi a aparut', '2021-03-22 19:15:06'),
(488, 'Vicentzo123', 9, 'MI-AM DAT TOT MIE MESAJ', '2021-03-22 19:15:08'),
(489, 'Vicentzo123', 9, 'dai /accept invite 1', '2021-03-22 19:15:11'),
(490, 'qaim.exe', 11, 'Sa bagi komanda', '2021-03-22 19:15:20'),
(491, 'Vicentzo123', 9, 'ba', '2021-03-22 19:15:27'),
(492, 'Vicentzo123', 9, 'pizdo', '2021-03-22 19:15:28'),
(493, 'Vicentzo123', 9, 'acum', '2021-03-22 19:15:30'),
(494, 'qaim.exe', 11, 'Jucatorul qaim.exe pe care l ai invitat in factiunea ta los santos police departament', '2021-03-22 19:15:32'),
(495, 'qaim.exe', 11, 'A acceptat', '2021-03-22 19:15:34'),
(496, 'Vicentzo123', 9, 'bun merge', '2021-03-22 19:15:42'),
(497, 'Vicentzo123', 9, 'acum asta e rank 2', '2021-03-22 19:15:44'),
(498, 'Vicentzo123', 9, 'ia dai tu f', '2021-03-22 19:15:45'),
(499, 'Vicentzo123', 9, 'ai supt pula', '2021-03-22 19:15:55'),
(500, 'Vicentzo123', 9, 'hah', '2021-03-22 19:15:56'),
(501, 'Vicentzo123', 9, 'deci', '2021-03-22 19:15:59'),
(502, 'Vicentzo123', 9, 'ce ti-a zis', '2021-03-22 19:16:01'),
(503, 'Vicentzo123', 9, 'ba cateva cacaturi mai sunt de facut', '2021-03-22 19:16:20'),
(504, 'Vicentzo123', 9, 'dar ca baza merge', '2021-03-22 19:16:24'),
(505, 'Vicentzo123', 9, 'bun', '2021-03-22 19:16:26'),
(506, 'Vicentzo123', 9, 'explodeaza', '2021-03-22 19:16:33'),
(507, 'Vicentzo123', 9, 'masina', '2021-03-22 19:16:34'),
(508, 'Vicentzo123', 9, 'asta', '2021-03-22 19:16:34'),
(509, 'Vicentzo123', 9, 'putin', '2021-03-22 19:16:35'),
(510, 'qaim.exe', 11, 'oc', '2021-03-22 19:16:36'),
(511, 'Vicentzo123', 9, 'asa', '2021-03-22 19:16:50'),
(512, 'Vicentzo123', 9, 'HO BAAA', '2021-03-22 19:17:02'),
(513, 'Vicentzo123', 9, 'HO BAA', '2021-03-22 19:17:12'),
(514, 'Vicentzo123', 9, 'HO BAA', '2021-03-22 19:17:15'),
(515, 'qaim.exe', 11, 'oc', '2021-03-22 19:17:15'),
(516, 'Vicentzo123', 9, 'luati-va amandoi', '2021-03-22 19:17:19'),
(517, 'Vicentzo123', 9, 'masinile', '2021-03-22 19:17:20'),
(518, 'Vicentzo123', 9, 'diferite', '2021-03-22 19:17:21'),
(519, 'qaim.exe', 11, 'wtf', '2021-03-22 19:17:28'),
(520, 'Vicentzo123', 9, '=))))))))))))', '2021-03-22 19:17:36'),
(521, 'Vicentzo123', 9, 'ASA', '2021-03-22 19:17:39'),
(522, 'Vicentzo123', 9, 'veniti dupa mine', '2021-03-22 19:17:42'),
(523, 'Vicentzo123', 9, 'aici tre sa avem necoliziune', '2021-03-22 19:18:05'),
(524, 'Vicentzo123', 9, 'ia', '2021-03-22 19:18:05'),
(525, 'Vicentzo123', 9, 'futesar lumea-n norocumati', '2021-03-22 19:19:09'),
(526, 'Vicentzo123', 1, 'stats', '2021-03-24 19:03:27'),
(527, 'Vicentzo123', 1, 'a', '2021-03-25 19:04:05'),
(528, 'qaim.exe', 3, 'admin rpd', '2021-03-26 17:53:57'),
(529, 'Vicentzo123', 1, 'civilu', '2021-03-26 17:53:59'),
(530, 'Vicentzo123', 1, 'hah', '2021-03-26 17:54:00'),
(531, 'qaim.exe', 3, 'Fmm', '2021-03-26 17:54:04'),
(532, 'qaim.exe', 3, 'ok', '2021-03-26 17:54:22'),
(533, 'Vicentzo123', 1, 'boon', '2021-03-26 17:54:32'),
(534, 'qaim.exe', 3, 'ba am o idee pt tn', '2021-03-26 17:54:32'),
(535, 'Vicentzo123', 1, 'ia vezi pentru prima data', '2021-03-26 17:54:35'),
(536, 'Vicentzo123', 1, './myraport iti merge tie', '2021-03-26 17:54:41'),
(537, 'Vicentzo123', 1, 'neavand nicio factiune', '2021-03-26 17:54:44'),
(538, 'qaim.exe', 3, '?myraport', '2021-03-26 17:54:45'),
(539, 'qaim.exe', 3, 'nu mere', '2021-03-26 17:54:49'),
(540, 'Vicentzo123', 1, 'okkk', '2021-03-26 17:54:51'),
(541, 'qaim.exe', 3, 'Apr', '2021-03-26 17:55:12'),
(542, 'Vicentzo123', 1, 'stiu ca aici e un bug la text', '2021-03-26 17:55:12'),
(543, 'Vicentzo123', 1, 'asta tre sa-l fac', '2021-03-26 17:55:15'),
(544, 'qaim.exe', 3, 'Sa refaci invite system', '2021-03-26 17:55:16'),
(545, 'Vicentzo123', 1, 'ca am observat', '2021-03-26 17:55:17'),
(546, 'Vicentzo123', 1, 'hai ca da', '2021-03-26 17:55:20'),
(547, 'Vicentzo123', 1, 'la tine textu inseamna tot sistemu', '2021-03-26 17:55:25'),
(548, 'qaim.exe', 3, 'pai e bug la test ma', '2021-03-26 17:55:26'),
(549, 'qaim.exe', 3, 'Dda ma', '2021-03-26 17:55:31'),
(550, 'qaim.exe', 3, 'Pai nu ti place tie asa', '2021-03-26 17:55:34'),
(551, 'Vicentzo123', 1, 'nice iq', '2021-03-26 17:55:34'),
(552, 'Vicentzo123', 1, 'in fine', '2021-03-26 17:55:47'),
(553, 'Vicentzo123', 1, 'ia vezi', '2021-03-26 17:55:48'),
(554, 'Vicentzo123', 1, 'acum', '2021-03-26 17:55:49'),
(555, 'Vicentzo123', 1, '.myraport', '2021-03-26 17:55:59'),
(556, 'Vicentzo123', 1, 'presupun ca iti arata terminat', '2021-03-26 17:56:04'),
(557, 'Vicentzo123', 1, '0/0', '2021-03-26 17:56:06'),
(558, 'qaim.exe', 3, 'Merminat', '2021-03-26 17:56:08'),
(559, 'qaim.exe', 3, 'Wtf', '2021-03-26 17:56:09'),
(560, 'Vicentzo123', 1, 'si la terminat am facut ', '2021-03-26 17:56:10'),
(561, 'qaim.exe', 3, '=]]', '2021-03-26 17:56:10'),
(562, 'Vicentzo123', 1, 'o greseala', '2021-03-26 17:56:11'),
(563, 'Vicentzo123', 1, 'de la tastatura in romana', '2021-03-26 17:56:14'),
(564, 'qaim.exe', 3, 'E oc', '2021-03-26 17:56:19'),
(565, 'Vicentzo123', 1, 'ia vezi acum', '2021-03-26 17:56:24'),
(566, 'Vicentzo123', 1, './raport', '2021-03-26 17:56:25'),
(567, 'Vicentzo123', 1, 'iti arata 0/30', '2021-03-26 17:56:27'),
(568, 'qaim.exe', 3, 'da', '2021-03-26 17:56:33'),
(569, 'Vicentzo123', 1, 'netermiant', '2021-03-26 17:56:36'),
(570, 'Vicentzo123', 1, 'asai', '2021-03-26 17:56:37'),
(571, 'qaim.exe', 3, 'nu', '2021-03-26 17:56:39'),
(572, 'qaim.exe', 3, 'meterminat', '2021-03-26 17:56:41'),
(573, 'Vicentzo123', 1, 'sugi pula atunci ', '2021-03-26 17:56:44'),
(574, 'qaim.exe', 3, 'Ma ta', '2021-03-26 17:56:47'),
(575, 'Vicentzo123', 1, 'iei rank down', '2021-03-26 17:56:47'),
(576, 'Vicentzo123', 1, 'ma ce', '2021-03-26 17:56:53'),
(577, 'Vicentzo123', 1, 'members nu apar nici io', '2021-03-26 17:56:59'),
(578, 'Vicentzo123', 1, 'nici tu', '2021-03-26 17:57:01'),
(579, 'Vicentzo123', 1, 'da apar 2/0', '2021-03-26 17:57:03'),
(580, 'Vicentzo123', 1, 'sus', '2021-03-26 17:57:03'),
(581, 'Vicentzo123', 1, 'like a boss', '2021-03-26 17:57:06'),
(582, 'Vicentzo123', 1, 'in fine', '2021-03-26 17:57:10'),
(583, 'Vicentzo123', 1, 'hai sa vedem arrest', '2021-03-26 17:57:13'),
(584, 'Vicentzo123', 1, 'stai aici', '2021-03-26 17:57:24'),
(585, 'Vicentzo123', 1, 'putin sa ma duc', '2021-03-26 17:57:26'),
(586, 'Vicentzo123', 1, 'ma ce pula mea', '2021-03-26 17:58:37'),
(587, 'qaim.exe', 3, ' svf : sa va fut', '2021-03-26 17:58:38'),
(588, 'Vicentzo123', 1, 'nici in /svf nu apar vehiculele la mine', '2021-03-26 17:58:44'),
(589, 'Vicentzo123', 1, 'ia stai', '2021-03-26 17:58:51'),
(590, 'Vicentzo123', 1, 'asa', '2021-03-26 17:59:28'),
(591, 'Vicentzo123', 1, 'dai /svf', '2021-03-26 17:59:31'),
(592, 'qaim.exe', 3, 'nu apar', '2021-03-26 17:59:33'),
(593, 'Vicentzo123', 1, 'iti arata vehicule?', '2021-03-26 17:59:35'),
(594, 'qaim.exe', 3, 'nu', '2021-03-26 17:59:37'),
(595, 'Vicentzo123', 1, '2 secunde te rog', '2021-03-26 17:59:39'),
(596, 'Vicentzo123', 1, 'ba', '2021-03-26 18:00:00'),
(597, 'Vicentzo123', 1, 'deci', '2021-03-26 18:00:01'),
(598, 'qaim.exe', 3, 'da bro', '2021-03-26 18:00:03'),
(599, 'Vicentzo123', 1, 'ce sa rezolv ca sa stiu', '2021-03-26 18:00:05'),
(600, 'Vicentzo123', 1, './members', '2021-03-26 18:00:08'),
(601, 'Vicentzo123', 1, './svf', '2021-03-26 18:00:09'),
(602, 'Vicentzo123', 1, 'si aia la set', '2021-03-26 18:00:11'),
(603, 'Vicentzo123', 1, 'si la invite', '2021-03-26 18:00:13'),
(604, 'qaim.exe', 3, 'exact', '2021-03-26 18:00:18'),
(605, 'qaim.exe', 3, 'Aceiasi cestie', '2021-03-26 18:03:59'),
(606, 'Ytz=]]', 4, 'marca adm 6', '2021-03-26 18:04:23'),
(607, 'Ytz=]]', 4, 'st 2m', '2021-03-26 18:06:45'),
(608, 'qaim.exe', 3, 'clar', '2021-03-26 18:07:41'),
(609, 'Vicentzo123', 1, 'invite', '2021-03-26 18:07:42'),
(610, 'qaim.exe', 3, 'A fost invitat de 113 ', '2021-03-26 18:08:00'),
(611, 'qaim.exe', 3, 'wtf ?', '2021-03-26 18:08:02'),
(612, 'Vicentzo123', 1, 'stiu si de aia ziceam', '2021-03-26 18:08:07'),
(613, 'qaim.exe', 3, 'Cum era aia #s sau cum dq', '2021-03-26 18:08:17'),
(614, 'Ytz=]]', 4, 'ba', '2021-03-26 18:08:27'),
(615, 'Ytz=]]', 4, 'unde e ds', '2021-03-26 18:08:32'),
(616, 'Ytz=]]', 4, 'luate as in plw', '2021-03-26 18:08:38'),
(617, 'qaim.exe', 3, 'Nu e facut inca', '2021-03-26 18:08:38'),
(618, 'Ytz=]]', 4, '....', '2021-03-26 18:08:43'),
(619, 'qaim.exe', 3, 'Coaie gm e d la 0 cplm vrei', '2021-03-26 18:08:49'),
(620, 'qaim.exe', 3, 'E si normal sa n aiba multe', '2021-03-26 18:08:53'),
(621, 'Ytz=]]', 4, ' /givevehicle 2 411 0', '2021-03-26 18:08:54'),
(622, 'qaim.exe', 3, 'Esti andi ?', '2021-03-26 18:08:56'),
(623, 'qaim.exe', 3, 'Nu e asa comenzi', '2021-03-26 18:09:06'),
(624, 'qaim.exe', 3, 'na', '2021-03-26 18:09:11'),
(625, 'Ytz=]]', 4, 'numa eu am a4 a ?', '2021-03-26 18:09:13'),
(626, 'Ytz=]]', 4, 'numa eu am a4 a ? ', '2021-03-26 18:09:17'),
(627, 'Ytz=]]', 4, 'fmm', '2021-03-26 18:09:20'),
(628, 'qaim.exe', 3, 'Nu ti convine cv ?', '2021-03-26 18:09:23'),
(629, 'qaim.exe', 3, 'w', '2021-03-26 18:10:18'),
(630, 'Vicentzo123', 1, 'hah', '2021-03-26 18:13:42'),
(631, 'qaim.exe', 3, 'fmm', '2021-03-26 18:20:40'),
(632, 'Heart1405', 2, 'ba muie ce vr', '2021-03-26 18:20:41'),
(633, 'qaim.exe', 3, 'fmm', '2021-03-26 18:21:19'),
(634, 'qaim.exe', 3, 'fmm', '2021-03-26 18:22:32'),
(635, 'qaim.exe', 3, 'st', '2021-03-26 18:25:45'),
(636, 'qaim.exe', 3, 'asa', '2021-03-26 18:25:59'),
(637, 'Heart1405', 2, 'da licienta de arme', '2021-03-26 18:26:14'),
(638, 'qaim.exe', 3, 'da mi ', '2021-03-26 18:26:55'),
(639, 'qaim.exe', 3, 'ma', '2021-03-26 18:27:11'),
(640, 'qaim.exe', 3, 'da mi invite', '2021-03-26 18:27:14'),
(641, 'qaim.exe', 3, 'sa vad', '2021-03-26 18:27:15'),
(642, 'qaim.exe', 3, 'da mi invite', '2021-03-26 18:27:42'),
(643, 'qaim.exe', 3, 'heart', '2021-03-26 18:27:56'),
(644, 'qaim.exe', 3, ' /invite 1 ', '2021-03-26 18:27:59'),
(645, 'qaim.exe', 3, ' /invite 1 d aia', '2021-03-26 18:28:00'),
(646, 'qaim.exe', 3, 'scrie asa', '2021-03-26 18:28:10'),
(647, 'qaim.exe', 3, 'baaa', '2021-03-26 18:28:22'),
(648, 'qaim.exe', 3, 'cu cn vb', '2021-03-26 18:28:23'),
(649, 'qaim.exe', 3, 'heaaaart', '2021-03-26 18:28:28'),
(650, 'Heart1405', 2, '?', '2021-03-26 18:28:32'),
(651, 'qaim.exe', 3, 'inimi as pula n ma ta', '2021-03-26 18:28:33'),
(652, 'Heart1405', 2, 'k', '2021-03-26 18:28:37'),
(653, 'qaim.exe', 3, ' /invite 1 d aia', '2021-03-26 18:28:38'),
(654, 'qaim.exe', 3, 'scrie asa', '2021-03-26 18:28:46'),
(655, 'qaim.exe', 3, 'asa', '2021-03-26 18:29:07'),
(656, 'qaim.exe', 3, 'frum', '2021-03-26 18:29:09'),
(657, 'qaim.exe', 3, 'pasarica', '2021-03-26 18:30:40'),
(658, 'qaim.exe', 3, 'te ajut', '2021-03-26 18:30:56'),
(659, 'qaim.exe', 3, '?', '2021-03-26 18:30:56'),
(660, 'qaim.exe', 3, 'asa', '2021-03-26 18:31:12'),
(661, 'qaim.exe', 3, ' sistemu e bun de /uinvite', '2021-03-26 18:31:19'),
(662, 'qaim.exe', 3, 'st ma', '2021-03-26 18:32:01'),
(663, 'qaim.exe', 3, 'ajunge dq', '2021-03-26 18:32:03'),
(664, 'Heart1405', 2, 'kw', '2021-03-26 18:32:07'),
(665, 'Heart1405', 2, 'mamam', '2021-03-26 18:34:18'),
(666, 'Heart1405', 2, 'ce bug', '2021-03-26 18:34:20'),
(667, 'Heart1405', 2, 'mama ce bug', '2021-03-26 18:34:34'),
(668, 'Heart1405', 2, 'deagle automata', '2021-03-26 18:34:39'),
(669, 'Heart1405', 2, 'ba muie', '2021-03-26 18:35:56'),
(670, 'qaim.exe', 3, '?', '2021-03-26 18:36:02'),
(671, 'Heart1405', 2, 'ni', '2021-03-26 18:36:06'),
(672, 'Heart1405', 2, 'de cand deagle e automata', '2021-03-26 18:36:15'),
(673, 'Vicentzo123', 1, 'e de la samp bugu ala', '2021-03-26 18:36:22'),
(674, 'Vicentzo123', 1, 'NU MAI TRAGE', '2021-03-26 18:36:24'),
(675, 'Heart1405', 2, ':))', '2021-03-26 18:36:27'),
(676, 'Vicentzo123', 1, 'daca mai tragi', '2021-03-26 18:36:33'),
(677, 'Vicentzo123', 1, 'imi bag pula ca zbori', '2021-03-26 18:36:35'),
(678, 'qaim.exe', 3, 'ad ?', '2021-03-26 18:36:52'),
(679, 'qaim.exe', 3, 'ad', '2021-03-26 18:36:53'),
(680, 'Vicentzo123', 1, 'ma ce', '2021-03-26 18:37:17'),
(681, 'qaim.exe', 3, 'nu poti acorda wanted unui coleg', '2021-03-26 18:37:18'),
(682, 'Vicentzo123', 1, 'dau su nu merge', '2021-03-26 18:37:19'),
(683, 'qaim.exe', 3, 'imi zice', '2021-03-26 18:37:21'),
(684, 'Vicentzo123', 1, 'aaaa tie iti zice', '2021-03-26 18:37:24'),
(685, 'Vicentzo123', 1, 'members', '2021-03-26 18:41:53'),
(686, 'Heart1405', 2, 'hai ca merge goto', '2021-03-26 18:42:37'),
(687, 'Vicentzo123', 1, 'bun', '2021-03-26 18:42:48'),
(688, 'Vicentzo123', 1, 'asd', '2021-03-26 18:42:58'),
(689, 'Vicentzo123', 1, 'stia asa', '2021-03-26 18:43:00'),
(690, 'Heart1405', 2, 'au', '2021-03-26 18:43:13'),
(691, 'Heart1405', 2, 'k', '2021-03-26 18:44:11'),
(692, 'Vicentzo123', 1, '.', '2021-03-26 18:44:12'),
(693, 'Vicentzo123', 1, 'stai ca dau restart', '2021-03-26 18:45:14'),
(694, 'Heart1405', 2, 'k', '2021-03-26 18:45:19'),
(695, 'Heart1405', 2, 'da', '2021-03-26 18:48:01'),
(696, 'Vicentzo123', 1, 'stai asa', '2021-03-26 18:48:02'),
(697, 'Heart1405', 2, 'e si handsup', '2021-03-26 18:48:13'),
(698, 'Vicentzo123', 1, 'dai g', '2021-03-26 18:48:17'),
(699, 'Heart1405', 2, 'f', '2021-03-26 18:51:35'),
(700, 'qaim.exe', 3, 'Nu poti controla un coleg', '2021-03-26 18:51:54'),
(701, 'Vicentzo123', 1, 'PAI E INTRE COLEGI', '2021-03-26 18:51:54'),
(702, 'Vicentzo123', 1, 'CUM PIZDA MATI', '2021-03-26 18:51:56'),
(703, 'Vicentzo123', 1, 'SA MEARGA', '2021-03-26 18:51:57'),
(704, 'qaim.exe', 3, 'Imi scrie cand tu imi dai /frisk', '2021-03-26 18:51:59'),
(705, 'Vicentzo123', 1, 'pai am dat eu mesaj gresit', '2021-03-26 18:52:05'),
(706, 'qaim.exe', 3, 'PAI IN PIZDA LUA TACTU CAND TU SCRII IMI APARE', '2021-03-26 18:52:11'),
(707, 'qaim.exe', 3, 'MORTU PULII CA MA SI ENERVEZI', '2021-03-26 18:52:16'),
(708, 'Heart1405', 2, 'iti plake asa i', '2021-03-26 18:52:59'),
(709, 'qaim.exe', 3, 'TACA', '2021-03-26 18:56:02'),
(710, 'qaim.exe', 3, 'prost esti', '2021-03-26 18:56:56'),
(711, 'qaim.exe', 3, 'fmm', '2021-03-26 18:59:42'),
(712, 'Heart1405', 2, 'lol', '2021-03-26 19:00:25'),
(713, 'Vicentzo123', 1, 'vino putin incoa', '2021-03-26 19:02:53'),
(714, 'Vicentzo123', 1, 'sugi', '2021-03-26 19:04:05'),
(715, 'Heart1405', 2, 'tf', '2021-03-26 19:04:06'),
(716, 'Heart1405', 2, 'tf', '2021-03-26 19:06:29'),
(717, 'Heart1405', 2, '3 gloante de minigun si mort', '2021-03-26 19:06:35'),
(718, 'Heart1405', 2, '3 gloante de minigun si mort', '2021-03-26 19:06:46'),
(719, 'Vicentzo123', 1, 'bagam un mc', '2021-03-26 19:07:18'),
(720, 'Vicentzo123', 1, '?', '2021-03-26 19:07:19'),
(721, 'Heart1405', 2, 'poate', '2021-03-26 19:07:22'),
(722, 'Vicentzo123', 1, 'ie la el', '2021-03-26 19:07:26'),
(723, 'Vicentzo123', 1, 'poate', '2021-03-26 19:07:27'),
(724, 'Heart1405', 2, 'ar mer eun mc', '2021-03-26 19:07:29'),
(725, 'Vicentzo123', 1, 'date-n pule me', '2021-03-26 19:07:30'),
(726, 'Vicentzo123', 1, 'sa imi sugi pulentiu', '2021-03-26 19:07:36'),
(727, 'Heart1405', 2, ')_)))', '2021-03-26 19:07:37'),
(728, 'Vicentzo123', 1, 'ba moe', '2021-03-26 19:07:45'),
(729, 'Vicentzo123', 1, 'sa mil molfai usor', '2021-03-26 19:07:48'),
(730, 'Vicentzo123', 1, 'hah', '2021-03-26 19:07:58'),
(731, 'Heart1405', 2, 'au?', '2021-03-26 19:08:01'),
(732, 'Vicentzo123', 1, 'ez', '2021-03-26 19:08:37'),
(733, 'Heart1405', 2, 'ez', '2021-03-26 19:08:45'),
(734, 'Vicentzo123', 1, 'ba', '2021-03-26 19:18:37'),
(735, 'Vicentzo123', 1, 'ma auzi?', '2021-03-26 19:18:40'),
(736, 'Vicentzo123', 1, 'halo', '2021-03-26 19:18:43'),
(737, 'Heart1405', 2, 'st ca vand un nitro boost', '2021-03-26 19:18:46'),
(738, 'Vicentzo123', 1, './accept invite 0', '2021-03-27 13:09:31'),
(739, 'Vicentzo123', 1, 'userID', '2021-03-27 13:14:43'),
(740, 'Vicentzo123', 2, '', '2021-03-27 13:24:08'),
(741, 'Vicentzo123', 2, 'asd', '2021-03-27 15:53:35'),
(742, 'Vicentzo123', 2, 'asd', '2021-04-01 12:36:08'),
(743, 'Vicentzo123', 2, 'asd', '2021-04-01 12:36:09'),
(744, 'Vicentzo123', 2, 'asd', '2021-04-01 12:36:09'),
(745, 'Vicentzo123', 2, 'asd', '2021-04-01 12:36:09'),
(746, 'Vicentzo123', 2, 'asd', '2021-04-01 12:36:10'),
(747, 'Vicentzo123', 2, 'asd', '2021-04-01 12:36:10'),
(748, 'Vicentzo123', 2, 'asd', '2021-04-01 12:36:10'),
(749, 'Vicentzo123', 2, 'asd', '2021-04-01 12:36:11'),
(750, 'Vicentzo123', 2, 'asdmajsdnj', '2021-04-01 12:36:12'),
(751, 'Vicentzo123', 2, 'asdmajsdnj', '2021-04-01 12:36:13'),
(752, 'Vicentzo123', 2, 'v', '2021-04-01 12:36:14'),
(753, 'Vicentzo123', 2, 'asdmajsdnj', '2021-04-01 12:36:14'),
(754, 'Vicentzo123', 2, 'asdmajsdnj', '2021-04-01 12:36:15'),
(755, 'Vicentzo123', 2, 'asdmajsdnj', '2021-04-01 12:36:15'),
(756, 'Vicentzo123', 2, 'asdmajsdnj', '2021-04-01 12:36:16'),
(757, 'Vicentzo123', 2, 'v', '2021-04-01 12:36:16'),
(758, 'Vicentzo123', 2, 'asdmajsdnj', '2021-04-01 12:36:16'),
(759, 'Vicentzo123', 2, 'asd', '2021-04-01 17:46:53'),
(760, 'Vicentzo123', 2, '/wt re', '2021-04-01 18:43:36'),
(761, 'Vicentzo123', 2, 'f', '2021-04-01 18:56:13'),
(762, 'Vicentzo', 3, '* (chat log): lantu pulii.', '2021-04-16 18:38:36'),
(763, 'Vicentzo', 3, '* (chat log): LANTU PULI.', '2021-04-16 18:38:38'),
(764, 'Vicentzo', 3, '* (chat log): SA NE BELESTI PULA.', '2021-04-16 18:38:43'),
(765, 'Vicentzo', 3, '* (chat log): SA IMI SUGI TOATA PULA.', '2021-04-16 18:38:46'),
(766, 'Vicentzo', 3, '* (chat log): DATIAS LA MOE.', '2021-04-16 18:38:49'),
(767, 'Vicentzo', 3, '* (chat log): MULTA MOEE.', '2021-04-16 18:39:03'),
(768, 'Vicentzo', 3, '* (chat log): MOE CU LOPATA.', '2021-04-16 18:39:05'),
(769, 'Vicentzo', 3, '* (chat log): much better.', '2021-04-16 18:41:07'),
(770, 'Vicentzo', 3, '* (chat log): nu cade fly.', '2021-04-16 18:41:09'),
(771, 'Vicentzo', 3, '* (chat log): merge extrem de bn.', '2021-04-16 18:41:12'),
(772, 'Vicentzo', 3, '* (chat log): v.', '2021-04-18 16:29:41'),
(773, 'mr.bunny', 2, '* (chat log): mr.bunny.', '2021-04-29 09:50:01'),
(774, 'Vicentzo', 1, '* (chat log): v.', '2021-04-29 09:56:46'),
(775, 'mr.bunny', 2, '* (chat log): w.', '2021-04-29 12:12:12'),
(776, 'mr.bunny', 2, '* (chat log): wA.', '2021-04-29 16:12:08'),
(777, 'Aditsu', 4, '* (chat log): lasã citu ratatule.', '2021-04-29 16:42:39'),
(778, 'Aditsu', 4, '* (chat log): ewaeaw.', '2021-04-29 16:42:46'),
(779, 'Vicentzo', 1, '* (chat log): asd.', '2021-04-29 16:42:47'),
(780, 'mr.bunny', 2, '* (chat log): dasd.', '2021-04-29 16:42:49'),
(781, 'Aditsu', 4, '* (chat log): ewaewaeaw.', '2021-04-29 16:42:49'),
(782, 'Aditsu', 4, '* (chat log): ewaewa.', '2021-04-29 16:43:02'),
(783, 'Quez]', 6, '* (chat log): cf.', '2021-04-29 18:54:51'),
(784, 'mr.bunny', 2, '* (chat log): cf chelie.', '2021-04-29 19:19:30'),
(785, 'ZeCo.F', 5, '* (chat log): asa.', '2021-04-29 19:19:56'),
(786, 'CORLEA', 8, '* (chat log): a.', '2021-04-29 19:30:51'),
(787, 'Aptiv', 11, '* (chat log): baaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.', '2021-04-29 20:21:52'),
(788, 'Vicentzo', 1, '* (chat log): r/jail.', '2021-04-29 21:11:46'),
(789, 'Vicentzo', 1, '* (chat log): asd.', '2021-04-29 21:30:39'),
(790, 'mr.bunny', 2, '* (chat log): da.', '2021-04-29 21:30:42');

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_clans`
--

CREATE TABLE `server_clans` (
  `ID` int(11) NOT NULL,
  `OwnerID` int(11) NOT NULL DEFAULT '-1',
  `Name` varchar(24) NOT NULL DEFAULT 'none',
  `Tag` varchar(16) NOT NULL DEFAULT 'none',
  `ClanColor` varchar(32) NOT NULL DEFAULT 'ffffff',
  `Motd` varchar(128) NOT NULL DEFAULT 'none',
  `Days` int(11) NOT NULL,
  `Slots` int(11) NOT NULL,
  `Rank` varchar(32) NOT NULL DEFAULT '%s|%s|%s|%s|%s|%s|%s',
  `Total` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `server_clans`
--

INSERT INTO `server_clans` (`ID`, `OwnerID`, `Name`, `Tag`, `ClanColor`, `Motd`, `Days`, `Slots`, `Rank`, `Total`) VALUES
(0, 1, 'Sintembosi', 'sntbos', 'ffffff', 'asd', 30, 100, 'sintbos|asd|231|sasd|sas|sda|12', 0);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_ds`
--

CREATE TABLE `server_ds` (
  `ID` int(10) NOT NULL,
  `Model` int(11) NOT NULL,
  `Price` int(11) NOT NULL DEFAULT '1',
  `MaxSpeed` int(4) NOT NULL DEFAULT '1',
  `Type` int(10) NOT NULL,
  `Premium` int(10) NOT NULL,
  `Gold` int(10) NOT NULL DEFAULT '500',
  `Stock` int(11) NOT NULL DEFAULT '30'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `server_ds`
--

INSERT INTO `server_ds` (`ID`, `Model`, `Price`, `MaxSpeed`, `Type`, `Premium`, `Gold`, `Stock`) VALUES
(1, 404, 170000, 133, 1, 0, 20, 3),
(2, 418, 190000, 115, 1, 0, 25, 25),
(3, 422, 230000, 140, 1, 0, 30, 24),
(4, 466, 350000, 140, 1, 0, 35, 27),
(5, 549, 310000, 153, 1, 0, 35, 25),
(6, 401, 290000, 147, 1, 0, 30, 27),
(7, 400, 520000, 158, 1, 0, 40, 26),
(8, 543, 325000, 151, 1, 0, 35, 28),
(9, 482, 490000, 156, 1, 0, 50, 30),
(10, 483, 520000, 129, 1, 0, 55, 30),
(11, 508, 570000, 108, 1, 0, 55, 30),
(12, 550, 410000, 130, 1, 0, 55, 21),
(13, 585, 325000, 150, 1, 0, 55, 27),
(14, 496, 500000, 162, 1, 0, 60, 16),
(15, 542, 520000, 164, 1, 0, 65, 26),
(16, 419, 410000, 149, 1, 0, 65, 30),
(17, 554, 530000, 144, 1, 0, 70, 28),
(18, 518, 390000, 164, 1, 0, 70, 26),
(19, 458, 460000, 157, 1, 0, 70, 27),
(20, 546, 310000, 149, 1, 0, 70, 30),
(21, 424, 620000, 135, 1, 0, 80, 27),
(22, 529, 380000, 149, 1, 0, 80, 29),
(23, 540, 400000, 149, 1, 0, 80, 27),
(24, 479, 420000, 140, 1, 0, 30, 29),
(25, 600, 510000, 151, 1, 0, 50, 30),
(26, 439, 670000, 168, 1, 0, 90, 25),
(27, 426, 800000, 173, 1, 0, 100, 17),
(28, 603, 910000, 171, 1, 0, 120, 0),
(29, 589, 1100000, 162, 1, 0, 120, 22),
(30, 421, 670000, 153, 1, 0, 110, 30),
(31, 492, 735000, 140, 1, 0, 100, 30),
(32, 517, 410000, 157, 1, 0, 90, 28),
(33, 566, 350000, 160, 1, 0, 90, 29),
(34, 580, 560000, 153, 1, 0, 90, 30),
(35, 526, 320000, 158, 1, 0, 90, 24),
(36, 500, 760000, 140, 1, 0, 90, 30),
(37, 545, 920000, 147, 1, 0, 100, 30),
(38, 445, 480000, 164, 1, 0, 60, 27),
(39, 507, 600000, 166, 1, 0, 60, 28),
(40, 555, 780000, 158, 1, 0, 90, 26),
(41, 412, 520000, 168, 1, 0, 50, 29),
(42, 575, 670000, 158, 1, 0, 100, 30),
(43, 533, 6200000, 167, 1, 0, 100, 30),
(44, 561, 9000000, 154, 1, 0, 100, 30),
(45, 558, 11200000, 156, 1, 0, 150, 30),
(46, 535, 9700000, 158, 1, 0, 130, 29),
(47, 579, 27000000, 158, 1, 0, 200, 30),
(48, 534, 5200000, 168, 1, 0, 150, 30),
(49, 587, 2100000, 165, 1, 0, 150, 24),
(50, 489, 5600000, 139, 1, 0, 150, 29),
(51, 567, 6000000, 173, 1, 0, 150, 29),
(52, 536, 12000000, 173, 1, 0, 160, 30),
(53, 495, 36000000, 176, 1, 0, 250, 29),
(54, 475, 32000000, 173, 1, 0, 200, 30),
(55, 565, 37000000, 165, 1, 0, 200, 30),
(56, 602, 9700000, 169, 1, 0, 150, 29),
(57, 405, 1200000, 164, 1, 0, 100, 29),
(58, 559, 40000000, 177, 1, 0, 250, 30),
(59, 434, 50000000, 177, 1, 0, 350, 30),
(60, 506, 55000000, 179, 1, 0, 350, 30),
(61, 477, 49000000, 186, 1, 0, 350, 30),
(62, 480, 38000000, 184, 1, 0, 250, 30),
(63, 562, 65000000, 178, 1, 0, 400, 30),
(64, 402, 70000000, 186, 1, 0, 400, 30),
(65, 560, 82000000, 169, 1, 0, 450, 30),
(66, 415, 61000000, 192, 1, 0, 450, 30),
(67, 451, 85000000, 193, 1, 0, 450, 30),
(68, 429, 52000000, 202, 1, 0, 450, 30),
(69, 541, 90000000, 203, 1, 0, 500, 29),
(70, 411, 100000000, 222, 1, 1, 550, 28),
(71, 494, 150000000, 214, 1, 1, 600, 30),
(72, 503, 150000000, 214, 1, 1, 600, 30),
(73, 502, 150000000, 214, 1, 1, 600, 30),
(74, 509, 80000, 83, 2, 0, 10, 28),
(75, 510, 90000, 90, 2, 0, 15, 26),
(76, 481, 100000, 90, 2, 0, 20, 26),
(77, 462, 210000, 122, 2, 0, 20, 30),
(78, 471, 270000, 110, 2, 0, 20, 26),
(79, 586, 2000000, 157, 2, 0, 25, 30),
(80, 581, 4000000, 59, 2, 0, 50, 30),
(81, 461, 4200000, 171, 2, 0, 70, 25),
(82, 468, 7200000, 157, 2, 0, 90, 29),
(83, 463, 6400000, 157, 2, 0, 100, 29),
(84, 521, 7600000, 176, 2, 0, 100, 29),
(85, 522, 45000000, 191, 2, 0, 200, 26),
(86, 473, 700000, 96, 3, 0, 20, 29),
(87, 493, 70000000, 174, 3, 0, 150, 28),
(88, 469, 100000000, 135, 4, 0, 700, 27),
(89, 487, 200000000, 180, 4, 0, 700, 29);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_exam_checkpoints`
--

CREATE TABLE `server_exam_checkpoints` (
  `ID` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_exam_checkpoints`
--

INSERT INTO `server_exam_checkpoints` (`ID`, `X`, `Y`, `Z`) VALUES
(7, 1156.99, -1742.78, 13.3984),
(8, 1181.97, -1731.07, 13.4),
(9, 1163.83, -1709.19, 13.7315),
(10, 1152.39, -1670.4, 13.7812),
(11, 1089.55, -1569.49, 13.375),
(12, 1033.63, -1714.27, 13.3828),
(13, 1165.18, -1713.84, 13.7302),
(14, 1111.41, -1739.05, 13.4717),
(15, 1499.82, -1680.55, 14.5469);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_factionlogs`
--

CREATE TABLE `server_factionlogs` (
  `Factionid` int(11) NOT NULL,
  `Player` varchar(32) NOT NULL,
  `Action` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_factions`
--

CREATE TABLE `server_factions` (
  `ID` int(11) NOT NULL,
  `Name` varchar(32) NOT NULL DEFAULT 'faction name',
  `Motd` varchar(128) NOT NULL DEFAULT 'faction motd',
  `MinLevel` int(11) NOT NULL DEFAULT '5',
  `MaxMembers` int(11) NOT NULL DEFAULT '10',
  `Interior` int(11) NOT NULL DEFAULT '0',
  `Type` int(11) NOT NULL DEFAULT '0',
  `MapIconType` int(11) NOT NULL DEFAULT '0',
  `Apps` int(11) NOT NULL DEFAULT '0',
  `Locked` int(11) NOT NULL DEFAULT '0',
  `X` float NOT NULL DEFAULT '0',
  `Y` float NOT NULL DEFAULT '0',
  `Z` float NOT NULL DEFAULT '0',
  `ExtX` float NOT NULL DEFAULT '0',
  `ExtY` float NOT NULL DEFAULT '0',
  `ExtZ` float NOT NULL DEFAULT '0',
  `SkinRank1` varchar(11) NOT NULL,
  `SkinRank2` int(11) NOT NULL,
  `SkinRank3` int(11) NOT NULL,
  `SkinRank4` int(11) NOT NULL,
  `SkinRank5` int(11) NOT NULL,
  `SkinRank6` int(11) NOT NULL,
  `SkinRank7` int(11) NOT NULL,
  `Commands1` int(10) NOT NULL,
  `Commands2` int(10) NOT NULL,
  `Commands3` int(10) NOT NULL,
  `Commands4` int(10) NOT NULL,
  `Commands5` int(10) NOT NULL,
  `Commands6` int(10) NOT NULL,
  `Commands7` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_factions`
--

INSERT INTO `server_factions` (`ID`, `Name`, `Motd`, `MinLevel`, `MaxMembers`, `Interior`, `Type`, `MapIconType`, `Apps`, `Locked`, `X`, `Y`, `Z`, `ExtX`, `ExtY`, `ExtZ`, `SkinRank1`, `SkinRank2`, `SkinRank3`, `SkinRank4`, `SkinRank5`, `SkinRank6`, `SkinRank7`, `Commands1`, `Commands2`, `Commands3`, `Commands4`, `Commands5`, `Commands6`, `Commands7`) VALUES
(1, 'Paramedic Department', 'Salutare !', 5, 10, 18, 4, 22, 0, 0, 1172.75, -1323.3, 15.4011, 1701.29, -1667.87, 20.2188, '274', 275, 276, 277, 308, 70, 227, 10, 20, 30, 40, 10, 3, 0),
(2, 'Los Santos Police Department', 'Salutare !', 7, 10, 6, 2, 30, 0, 0, 1554.56, -1675.56, 16.1953, 246.784, 63.9002, 1003.64, '280', 266, 283, 288, 307, 290, 295, 10, 20, 30, 40, 10, 3, 0),
(3, 'Federal Bureau of Investigation', 'Bun venit !', 7, 10, 10, 4, 30, 0, 0, 627.43, -571.792, 17.7155, 246.376, 109.246, 1003.22, '280', 266, 283, 288, 285, 286, 295, 10, 20, 30, 40, 10, 3, 0),
(4, 'National Guard', 'Bun venit !', 7, 10, 3, 4, 30, 0, 0, 2140.09, -1192.12, 23.9922, 288.746, 169.351, 1007.17, '283', 285, 286, 287, 288, 307, 295, 10, 20, 30, 40, 10, 3, 0),
(5, 'Taxi Company', 'Salutare !', 5, 10, 18, 4, 0, 0, 0, 1753.53, -1893.95, 13.5572, 1701.29, -1667.87, 20.2188, '253', 258, 255, 240, 227, 272, 228, 10, 20, 30, 40, 10, 3, 0),
(6, 'School Instructors', 'Salutare !', 5, 10, 12, 4, 0, 0, 0, 2155.75, -1814.7, 13.5469, 2324.42, -1145.57, 1050.71, '171', 189, 229, 240, 259, 290, 292, 10, 20, 30, 40, 10, 3, 0),
(7, 'News Reporters', 'Salutare !', 5, 10, 15, 4, 0, 0, 0, 979.737, -1296.46, 13.5469, 2215.45, -1147.48, 1025.8, '188', 189, 187, 234, 272, 268, 293, 10, 20, 30, 40, 10, 3, 0),
(8, 'Grove Street', 'Salutare !', 5, 10, 3, 5, 0, 0, 0, 2495.39, -1690.79, 14.7656, 2496.05, -1695.24, 1014.74, '105', 106, 107, 269, 270, 311, 271, 10, 20, 30, 40, 10, 3, 0),
(9, 'The Ballas', 'Salutare !', 5, 10, 3, 5, 0, 0, 0, 2233.32, -1333.31, 23.9816, 2640.76, 1406.68, 906.461, '102', 103, 104, 223, 299, 302, 296, 10, 20, 30, 40, 10, 3, 0),
(10, 'Hitman Agency', 'Salutare !', 5, 10, 3, 5, 0, 0, 0, 1523.98, -1113.39, 20.8594, 384.809, 173.805, 1008.38, '29', 59, 68, 111, 112, 120, 294, 10, 20, 30, 40, 10, 3, 0);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_faction_logs`
--

CREATE TABLE `server_faction_logs` (
  `ID` int(11) NOT NULL,
  `Text` varchar(256) NOT NULL DEFAULT 'none.',
  `Player` int(11) NOT NULL DEFAULT '-1',
  `Leader` int(11) NOT NULL DEFAULT '-1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_houses`
--

CREATE TABLE `server_houses` (
  `ID` int(11) NOT NULL,
  `Title` varchar(32) NOT NULL DEFAULT 'none',
  `Description` varchar(64) NOT NULL DEFAULT 'none',
  `ExtX` float NOT NULL DEFAULT '0',
  `ExtY` float NOT NULL DEFAULT '0',
  `ExtZ` float NOT NULL DEFAULT '0',
  `X` float NOT NULL DEFAULT '0',
  `Y` float NOT NULL DEFAULT '0',
  `Z` float NOT NULL DEFAULT '0',
  `Interior` int(11) NOT NULL,
  `VW` int(11) NOT NULL,
  `Locked` int(11) NOT NULL DEFAULT '0',
  `Price` int(11) NOT NULL,
  `Balance` int(11) NOT NULL DEFAULT '0',
  `Owner` varchar(32) NOT NULL,
  `OwnerID` int(11) NOT NULL,
  `Owned` int(11) NOT NULL,
  `Rentabil` int(11) NOT NULL,
  `Renters` int(11) NOT NULL DEFAULT '0',
  `Upgrade` int(11) NOT NULL DEFAULT '0',
  `RentPrice` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_jobs`
--

CREATE TABLE `server_jobs` (
  `ID` int(11) NOT NULL,
  `Name` varchar(32) NOT NULL DEFAULT 'none',
  `Level` int(11) NOT NULL DEFAULT '1',
  `PosX` float NOT NULL DEFAULT '0',
  `PosY` float NOT NULL DEFAULT '0',
  `PosZ` float NOT NULL DEFAULT '0',
  `Legal` int(11) NOT NULL,
  `Description` varchar(95) NOT NULL,
  `XST` float NOT NULL DEFAULT '0',
  `YST` float NOT NULL DEFAULT '0',
  `ZST` float NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_jobs`
--

INSERT INTO `server_jobs` (`ID`, `Name`, `Level`, `PosX`, `PosY`, `PosZ`, `Legal`, `Description`, `XST`, `YST`, `ZST`) VALUES
(1, 'Fisher', 1, 362.474, -2084.71, 7.8359, 1, 'Smekeriebos', 0, 0, 0),
(2, 'Trucker', 1, 883.191, -1799.8, 13.7926, 1, 'test123', 876.115, -1798.6, 13.8118),
(3, 'Drugs Dealer', 3, 1294.66, 175.032, 20.9106, 0, 'asda', 1291.82, 168.895, 20.4609),
(4, 'Arms Dealer', 3, 1690.25, -1494.89, 13.4724, 0, '', 1693.66, -1492.83, 13.4724),
(5, 'Carpenter', 2, 1035.12, -1456.75, 13.5988, 1, '', 1032.55, -1456.94, 13.5988);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_kick_logs`
--

CREATE TABLE `server_kick_logs` (
  `ID` int(11) NOT NULL,
  `PlayerName` varchar(24) NOT NULL DEFAULT 'none',
  `PlayerID` int(11) NOT NULL DEFAULT '0',
  `AdminName` varchar(24) NOT NULL DEFAULT 'AdmBot',
  `AdminID` int(11) NOT NULL DEFAULT '0',
  `Reason` varchar(64) NOT NULL DEFAULT 'none',
  `Date` varchar(32) NOT NULL DEFAULT 'none'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_labels`
--

CREATE TABLE `server_labels` (
  `ID` int(11) NOT NULL,
  `X` float NOT NULL DEFAULT '0',
  `Y` float NOT NULL DEFAULT '0',
  `Z` float NOT NULL DEFAULT '0',
  `Text` varchar(128) NOT NULL DEFAULT 'none',
  `WorldID` int(11) NOT NULL DEFAULT '-1',
  `Interior` int(11) NOT NULL DEFAULT '-1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_labels`
--

INSERT INTO `server_labels` (`ID`, `X`, `Y`, `Z`, `Text`, `WorldID`, `Interior`) VALUES
(1, 1111.01, -1795.67, 16.71, 'Scoala de Soferi\n Tasteaza comanda /exam', -1, -1),
(2, 1177.54, -1339.07, 13.6679, '{FF6347}SVF:{ffffff} Point to spawn a faction vehicle. Type /svf to spawn a faction vehicle.', -1, -1),
(3, 1162.5, -1358.63, 26.6525, '{FF6347}SVF:{ffffff} Point to spawn a faction helicopter. Type /svf to spawn a faction helicopter.', -1, -1),
(4, 1562.79, -1627.32, 13.1358, '{FF6347}SVF:{ffffff} Point to spawn a faction vehicle. Type /svf to spawn a faction vehicle.', -1, -1),
(5, 1566.95, -1658.17, 28.3956, '{FF6347}SVF:{ffffff} Point to spawn a faction helicopter. Type /svf to spawn a faction helicopter.', -1, -1),
(6, 631.542, -604.097, 16.3359, '{FF6347}SVF:{ffffff} Point to spawn a faction vehicle or a faction helicopter. Type /svf to spawn a faction vehicle or a faction', -1, -1),
(7, 1245.05, -1819.95, 13.4127, '{FF6347}SVF:{ffffff} Point to spawn a faction vehicle. Type /svf to spawn a faction vehicle.', -1, -1),
(8, 2152.31, -1189.33, 23.8278, '{FF6347}SVF:{ffffff} Point to spawn a faction vehicle. Type /svf to spawn a faction vehicle.', -1, -1),
(14, 1568.99, -1693.19, 5.89062, '{FF6347}Arrest Point: Los Santos Police Department\nType /arrest <id>.', -1, -1),
(15, 613.53, -588.552, 17.2266, '{FF6347}Arrest Point: Federal Bureau of Investigation\nType /arrest <id>.', -1, -1),
(16, 2142.04, -1199.73, 24.0543, '{FF6347}Arrest Point: National Guard\nType /arrest <id>.', -1, -1),
(17, 1140.15, 1256.44, 10.8203, '{FF6347}Job Jail:{ffffff} Informatician Tower\nTasteaza /informatician pentru a lucra la acest job.', -1, -1);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_logs`
--

CREATE TABLE `server_logs` (
  `ID` int(11) NOT NULL,
  `text` varchar(128) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `server_logs`
--

INSERT INTO `server_logs` (`ID`, `text`, `time`) VALUES
(1, '198 tickrate | 10 queries', '2020-05-01 14:01:19'),
(2, '197 tickrate | 21 queries', '2020-05-01 15:01:20'),
(3, '197 tickrate | 78 queries', '2020-05-01 16:00:36'),
(4, '190 tickrate | 588 queries', '2020-05-01 17:01:34'),
(5, 'buNNy used /setjobgoal', '2020-05-01 17:02:15'),
(6, '194 tickrate | 485 queries', '2020-05-01 18:00:53'),
(7, '192 tickrate | 456 queries', '2020-05-01 19:00:49'),
(8, 'buNNy used /setjobgoal', '2020-05-01 19:46:57'),
(9, '194 tickrate | 391 queries', '2020-05-01 20:00:43'),
(10, '195 tickrate | 219 queries', '2020-05-01 21:01:18'),
(11, '194 tickrate | 214 queries', '2020-05-01 22:00:40'),
(12, '196 tickrate | 231 queries', '2020-05-01 23:01:09'),
(13, '197 tickrate | 112 queries', '2020-05-02 00:01:20'),
(14, '197 tickrate | 75 queries', '2020-05-02 01:01:19'),
(15, '198 tickrate | 0 queries', '2020-05-02 02:01:12'),
(16, '197 tickrate | 22 queries', '2020-05-02 03:01:02'),
(17, '197 tickrate | 12 queries', '2020-05-02 04:00:54'),
(18, '197 tickrate | 35 queries', '2020-05-02 05:00:38'),
(19, 'buNNy used /setjobgoal', '2020-05-02 05:13:06'),
(20, '197 tickrate | 48 queries', '2020-05-02 06:00:33'),
(21, '197 tickrate | 69 queries', '2020-05-02 07:01:29'),
(22, '197 tickrate | 138 queries', '2020-05-02 08:00:33'),
(23, '193 tickrate | 320 queries', '2020-05-02 09:00:57'),
(24, '196 tickrate | 307 queries', '2020-05-02 10:01:33'),
(25, '190 tickrate | 370 queries', '2020-05-02 11:01:14'),
(26, '194 tickrate | 313 queries', '2020-05-02 12:00:45'),
(27, '195 tickrate | 323 queries', '2020-05-02 13:01:24'),
(28, '195 tickrate | 287 queries', '2020-05-02 14:01:08'),
(29, '195 tickrate | 342 queries', '2020-05-02 15:00:45'),
(30, '191 tickrate | 431 queries', '2020-05-02 16:01:19'),
(31, '194 tickrate | 373 queries', '2020-05-02 16:07:47'),
(32, '192 tickrate | 684 queries', '2020-05-02 17:00:41'),
(33, '188 tickrate | 612 queries', '2020-05-02 18:01:26'),
(34, '184 tickrate | 827 queries', '2020-05-02 19:00:59'),
(35, '191 tickrate | 553 queries', '2020-05-02 20:01:29'),
(36, '192 tickrate | 566 queries', '2020-05-02 21:00:42'),
(37, '193 tickrate | 263 queries', '2020-05-02 22:01:38'),
(38, '196 tickrate | 136 queries', '2020-05-02 23:01:00'),
(39, '196 tickrate | 106 queries', '2020-05-03 00:01:21'),
(40, '196 tickrate | 68 queries', '2020-05-03 01:01:31'),
(41, '197 tickrate | 62 queries', '2020-05-03 02:00:38'),
(42, '197 tickrate | 52 queries', '2020-05-03 03:00:47'),
(43, '196 tickrate | 26 queries', '2020-05-03 04:00:54'),
(44, '197 tickrate | 0 queries', '2020-05-03 05:00:56'),
(45, '196 tickrate | 62 queries', '2020-05-03 06:01:01'),
(46, '196 tickrate | 97 queries', '2020-05-03 07:01:19'),
(47, '196 tickrate | 162 queries', '2020-05-03 08:00:39'),
(48, '194 tickrate | 337 queries', '2020-05-03 09:01:13'),
(49, '190 tickrate | 485 queries', '2020-05-03 10:01:04'),
(50, '191 tickrate | 697 queries', '2020-05-03 11:01:34'),
(51, '185 tickrate | 820 queries', '2020-05-03 12:01:25'),
(52, '185 tickrate | 736 queries', '2020-05-03 13:01:05'),
(53, '188 tickrate | 702 queries', '2020-05-03 14:00:44'),
(54, 'buNNy used /manageserver', '2020-05-03 15:12:38'),
(55, 'buNNy used /manageserver', '2020-05-03 15:12:47'),
(56, 'buNNy used /manageserver', '2020-05-03 15:12:48'),
(57, 'buNNy used /manageserver', '2020-05-03 15:12:53'),
(58, 'buNNy used /manageserver', '2020-05-03 15:12:54'),
(59, '167 tickrate | 13 queries', '2020-05-03 16:00:02'),
(60, '174 tickrate | 0 queries', '2020-05-03 18:00:07'),
(61, '169 tickrate | 0 queries', '2020-05-03 19:00:13'),
(62, '167 tickrate | 12 queries', '2020-05-04 05:00:06'),
(63, '167 tickrate | 0 queries', '2020-05-04 06:00:24'),
(64, 'buNNy used /systems', '2020-05-04 07:24:23'),
(65, 'buNNy used /systems', '2020-05-04 07:24:27'),
(66, 'buNNy used /systems', '2020-05-04 07:24:33'),
(67, '167 tickrate | 11 queries', '2020-05-04 08:00:06'),
(68, '167 tickrate | 11 queries', '2020-05-04 09:00:13'),
(69, '182 tickrate | 0 queries', '2020-05-04 10:00:08'),
(70, '167 tickrate | 0 queries', '2020-05-04 11:01:02'),
(71, '164 tickrate | 0 queries', '2020-05-04 12:00:40'),
(72, '170 tickrate | 0 queries', '2020-05-04 13:00:03'),
(73, '167 tickrate | 0 queries', '2020-05-04 14:00:10'),
(74, '167 tickrate | 11 queries', '2020-05-04 14:11:33'),
(75, '167 tickrate | 11 queries', '2020-05-04 14:17:30'),
(76, '167 tickrate | 11 queries', '2020-05-04 14:17:40'),
(77, '163 tickrate | 12 queries', '2020-05-04 15:00:25'),
(78, '123 tickrate | 0 queries', '2020-05-04 16:00:30'),
(79, '176 tickrate | 0 queries', '2020-05-04 17:00:45'),
(80, '166 tickrate | 19 queries', '2020-05-04 18:00:19'),
(81, '166 tickrate | 13 queries', '2020-05-04 18:11:46'),
(82, '178 tickrate | 0 queries', '2020-05-04 19:00:31'),
(83, 'buNNy used /systems', '2020-05-04 19:13:41'),
(84, 'buNNy used /systems', '2020-05-04 19:13:51'),
(85, 'buNNy used /systems', '2020-05-04 19:13:58'),
(86, 'buNNy used /systems', '2020-05-04 19:37:02'),
(87, 'buNNy used /systems', '2020-05-04 19:39:14'),
(88, 'buNNy used /systems', '2020-05-04 19:39:16'),
(89, 'buNNy used /systems', '2020-05-04 19:39:59'),
(90, 'buNNy used /systems', '2020-05-04 19:43:25'),
(91, '167 tickrate | 12 queries', '2020-05-04 20:00:27'),
(92, '166 tickrate | 0 queries', '2020-05-04 21:01:02'),
(93, '167 tickrate | 0 queries', '2020-05-05 12:00:58'),
(94, '172 tickrate | 0 queries', '2020-05-05 13:00:00'),
(95, '57 tickrate | 0 queries', '2020-05-05 14:59:37'),
(96, '184 tickrate | 0 queries', '2020-05-05 15:00:42'),
(97, '167 tickrate | 0 queries', '2020-05-05 16:00:09'),
(98, '169 tickrate | 0 queries', '2020-05-05 17:00:15'),
(99, '167 tickrate | 0 queries', '2020-05-05 18:00:55'),
(100, '166 tickrate | 12 queries', '2020-05-06 07:01:01'),
(101, '167 tickrate | 12 queries', '2020-05-06 08:00:33'),
(102, '166 tickrate | 12 queries', '2020-05-06 09:01:03'),
(103, '167 tickrate | 12 queries', '2020-05-06 10:00:04'),
(104, '167 tickrate | 12 queries', '2020-05-06 11:00:39'),
(105, '167 tickrate | 12 queries', '2020-05-06 12:00:14'),
(106, '167 tickrate | 12 queries', '2020-05-06 13:00:09'),
(107, '166 tickrate | 0 queries', '2020-05-06 14:00:41'),
(108, '167 tickrate | 0 queries', '2020-05-06 15:00:16'),
(109, '167 tickrate | 0 queries', '2020-05-06 16:00:04'),
(110, '169 tickrate | 0 queries', '2020-05-06 17:00:30'),
(111, '164 tickrate | 0 queries', '2020-05-06 18:00:35'),
(112, '169 tickrate | 0 queries', '2020-05-06 19:00:47'),
(113, '166 tickrate | 12 queries', '2020-05-06 20:00:47'),
(114, '167 tickrate | 12 queries', '2020-05-06 21:00:57'),
(115, '167 tickrate | 0 queries', '2020-05-07 15:00:07'),
(116, '167 tickrate | 0 queries', '2020-05-07 16:00:26'),
(117, '164 tickrate | 0 queries', '2020-05-07 17:00:17'),
(118, '168 tickrate | 12 queries', '2020-05-07 18:00:42'),
(119, '167 tickrate | 12 queries', '2020-05-07 19:00:09'),
(120, '167 tickrate | 11 queries', '2020-05-10 07:00:13'),
(121, '166 tickrate | 18 queries', '2020-05-10 08:00:25'),
(122, '167 tickrate | 0 queries', '2020-05-10 09:00:12'),
(123, '166 tickrate | 0 queries', '2020-05-10 10:00:55'),
(124, '166 tickrate | 0 queries', '2020-05-10 11:00:48'),
(125, '1 tickrate | 0 queries', '2020-05-10 12:39:27'),
(126, '169 tickrate | 0 queries', '2020-05-10 13:00:15'),
(127, '167 tickrate | 0 queries', '2020-05-10 14:00:23'),
(128, '42 tickrate | 0 queries', '2020-05-10 16:00:48'),
(129, '166 tickrate | 0 queries', '2020-05-10 17:00:49'),
(130, '166 tickrate | 0 queries', '2020-05-10 18:00:12'),
(131, '173 tickrate | 0 queries', '2020-05-10 19:00:39');

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_mute_logs`
--

CREATE TABLE `server_mute_logs` (
  `ID` int(11) NOT NULL,
  `PlayerName` varchar(24) NOT NULL DEFAULT 'None',
  `PlayerID` int(11) NOT NULL DEFAULT '0',
  `AdminName` varchar(24) NOT NULL DEFAULT 'AdmBot',
  `AdminID` int(11) NOT NULL DEFAULT '0',
  `MuteReason` varchar(64) NOT NULL DEFAULT 'None',
  `MuteMinutes` int(11) NOT NULL DEFAULT '1',
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_personal_vehicles`
--

CREATE TABLE `server_personal_vehicles` (
  `ID` int(11) NOT NULL,
  `ModelID` int(11) NOT NULL DEFAULT '400',
  `OwnerID` int(11) NOT NULL DEFAULT '0',
  `ColorOne` int(11) NOT NULL DEFAULT '0',
  `ColorTwo` int(11) NOT NULL DEFAULT '0',
  `X` float NOT NULL DEFAULT '0',
  `Y` float NOT NULL DEFAULT '0',
  `Z` float NOT NULL DEFAULT '0',
  `Angle` float NOT NULL DEFAULT '0',
  `Odometer` float NOT NULL DEFAULT '0',
  `Fuel` float NOT NULL DEFAULT '100',
  `Age` int(11) NOT NULL,
  `CarPlate` varchar(12) NOT NULL DEFAULT 'New Car',
  `Components` varchar(64) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `InsurancePoints` int(11) NOT NULL DEFAULT '5',
  `LockStatus` int(11) NOT NULL DEFAULT '0',
  `VirtualWorld` int(11) NOT NULL DEFAULT '0',
  `Interior` int(11) NOT NULL DEFAULT '0',
  `Health` float NOT NULL DEFAULT '1000',
  `DamagePanels` int(11) NOT NULL DEFAULT '0',
  `DamageDoors` int(11) NOT NULL DEFAULT '0',
  `DamageLights` int(11) NOT NULL DEFAULT '0',
  `DamageTires` int(11) NOT NULL DEFAULT '0',
  `PaintJob` int(11) NOT NULL DEFAULT '-1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_personal_vehicles`
--

INSERT INTO `server_personal_vehicles` (`ID`, `ModelID`, `OwnerID`, `ColorOne`, `ColorTwo`, `X`, `Y`, `Z`, `Angle`, `Odometer`, `Fuel`, `Age`, `CarPlate`, `Components`, `InsurancePoints`, `LockStatus`, `VirtualWorld`, `Interior`, `Health`, `DamagePanels`, `DamageDoors`, `DamageLights`, `DamageTires`, `PaintJob`) VALUES
(1, 543, 1, 1, 1, 1411.3, -2241.7, 13.274, 179.814, 0, 100, 1261, 'DS Car', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 10, 0, 0, 0, 1000, 0, 0, 0, 0, -1),
(2, 542, 2, 1, 1, 1408.04, -2241.74, 13.2739, 180.753, 0, 100, 1261, 'DS Car', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 10, 0, 0, 0, 1000, 0, 0, 0, 0, -1);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_pickups`
--

CREATE TABLE `server_pickups` (
  `ID` int(11) NOT NULL,
  `Model` int(11) NOT NULL DEFAULT '1239',
  `X` float NOT NULL DEFAULT '0',
  `Y` float NOT NULL DEFAULT '0',
  `Z` float NOT NULL DEFAULT '0',
  `WorldID` int(11) NOT NULL DEFAULT '0',
  `Interior` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_pickups`
--

INSERT INTO `server_pickups` (`ID`, `Model`, `X`, `Y`, `Z`, `WorldID`, `Interior`) VALUES
(1, 1239, 1111.01, -1795.67, 16.71, -1, -1);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_safes`
--

CREATE TABLE `server_safes` (
  `ID` int(11) NOT NULL,
  `Faction` int(11) NOT NULL DEFAULT '0',
  `Money` int(11) NOT NULL DEFAULT '0',
  `Drugs` int(11) NOT NULL DEFAULT '0',
  `Materials` int(11) NOT NULL DEFAULT '0',
  `VirtualWorld` int(11) NOT NULL DEFAULT '-1',
  `X` float NOT NULL DEFAULT '0',
  `Y` float NOT NULL DEFAULT '0',
  `Z` float NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_turfs`
--

CREATE TABLE `server_turfs` (
  `ID` int(11) NOT NULL,
  `Owned` int(11) NOT NULL DEFAULT '0',
  `MinX` float NOT NULL DEFAULT '0',
  `MaxX` float NOT NULL DEFAULT '0',
  `MinY` float NOT NULL DEFAULT '0',
  `MaxY` float NOT NULL DEFAULT '0',
  `Time` int(11) NOT NULL DEFAULT '-1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_turfs`
--

INSERT INTO `server_turfs` (`ID`, `Owned`, `MinX`, `MaxX`, `MinY`, `MaxY`, `Time`) VALUES
(1, 8, 601.95, 1119.95, -1259.35, -891.35, -1),
(2, 9, 85.9498, 603.95, -1420.37, -1052.37, -1),
(3, 8, 84.9499, 601.95, -1787.36, -1419.36, 15),
(4, 8, 600.95, 1118.95, -1626.34, -1258.34, -1),
(5, 8, 601.937, 1119, -1993.33, -1625.33, -1),
(6, 9, 1117.95, 1635.95, -1259.34, -891.337, 15),
(7, 9, 1117.95, 1635.95, -1626.34, -1258.34, 15),
(8, 9, 1117.94, 1635.94, -1993.33, -1625.33, -1),
(9, 8, 957.931, 1475.93, -2360.32, -1992.32, -1),
(10, 8, 1217.89, 1735.89, -2727.32, -2359.32, -1),
(11, 8, 1474.92, 1992.92, -2360.32, -1992.32, -1),
(12, 8, 1735.89, 2253.89, -2727.31, -2359.31, -1),
(13, 8, 1992.91, 2510.91, -2359.32, -1991.32, -1),
(14, 8, 1633.95, 2151.95, -1992.33, -1624.33, -1),
(15, 8, 2149.95, 2667.95, -1992.31, -1624.31, -1),
(16, 8, 1633.95, 2151.95, -1626.34, -1258.34, -1),
(17, 8, 2149.95, 2667.95, -1625.33, -1257.33, -1),
(18, 8, 1632.9, 2150.9, -1259.3, -891.3, -1),
(19, 8, 2149.95, 2667.95, -1258.33, -890.331, -1),
(20, 8, 2217.94, 2735.94, 575.688, 943.688, -1),
(21, 8, 2216.94, 2734.94, 942.688, 1310.69, -1),
(22, 8, 2216.92, 2734.92, 1309.7, 1677.7, -1),
(23, 8, 2216.92, 2734.92, 1677.71, 2045.71, -1),
(24, 8, 2216.92, 2734.92, 2045.72, 2413.72, -1),
(25, 8, 2216.92, 2734.92, 2411.73, 2779.73, -1),
(26, 8, 1698.92, 2216.92, 2547.74, 2915.74, -1),
(27, 8, 1181.92, 1699.92, 2548.76, 2916.76, -1),
(28, 8, 663.906, 1181.91, 2180.77, 2548.77, -1),
(29, 8, 1180.92, 1698.92, 2180.76, 2548.76, -1),
(30, 8, 1698.92, 2216.92, 2180.76, 2548.76, -1),
(31, 8, 1700.92, 2218.92, 1812.76, 2180.76, -1),
(32, 8, 666.925, 1184.92, 1812.78, 2180.78, -1),
(33, 8, 1700.92, 2218.92, 1445.78, 1813.78, -1),
(34, 8, 1184.92, 1700.92, 1813.76, 2180.76, -1),
(35, 8, 1184.92, 1702.92, 1445.78, 1813.78, -1),
(36, 8, 665.918, 1183.92, 1445.79, 1813.79, -1),
(37, 8, 666.925, 1184.92, 1079.78, 1447.78, -1),
(38, 8, 1182.92, 1700.92, 1079.78, 1447.78, -1),
(39, 8, 1699.92, 2217.92, 1079.78, 1447.78, -1),
(40, 8, 666.918, 1184.92, 713.781, 1081.78, -1),
(41, 8, 1183.92, 1701.92, 713.781, 1081.78, -1),
(42, 8, 1699.92, 2217.92, 713.781, 1081.78, -1),
(43, 8, -2464.4, -2364.4, 1726.4, 1826.4, -1);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_users`
--

CREATE TABLE `server_users` (
  `ID` int(11) NOT NULL,
  `Name` varchar(24) NOT NULL DEFAULT 'None',
  `Password` varchar(65) NOT NULL DEFAULT 'None',
  `EMail` varchar(128) NOT NULL DEFAULT 'None',
  `LastLogin` varchar(32) NOT NULL DEFAULT 'None',
  `RegisterDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Skin` int(11) NOT NULL DEFAULT '250',
  `Admin` int(11) NOT NULL DEFAULT '0',
  `Helper` int(11) NOT NULL DEFAULT '0',
  `Level` int(11) NOT NULL DEFAULT '1',
  `RespectPoints` int(11) NOT NULL DEFAULT '0',
  `Money` int(11) NOT NULL DEFAULT '2500',
  `Bank` int(11) NOT NULL DEFAULT '5000',
  `Hours` int(11) NOT NULL DEFAULT '0',
  `Seconds` int(11) NOT NULL DEFAULT '0',
  `Mute` int(11) NOT NULL DEFAULT '0',
  `Gender` int(11) NOT NULL DEFAULT '1',
  `Tutorial` tinyint(1) NOT NULL DEFAULT '0',
  `Licenses` varchar(48) NOT NULL DEFAULT '0|0|0|0|0|0|0|0',
  `Warn` int(11) NOT NULL DEFAULT '0',
  `ReportMute` int(11) NOT NULL DEFAULT '0',
  `Status` int(11) NOT NULL,
  `PremiumPoints` int(11) NOT NULL,
  `Job` int(11) NOT NULL DEFAULT '0',
  `Business` int(11) NOT NULL,
  `BusinessID` int(11) NOT NULL,
  `IP` varchar(16) NOT NULL,
  `House` int(11) NOT NULL,
  `HouseID` int(11) NOT NULL,
  `FRank` int(11) NOT NULL DEFAULT '0',
  `SpawnChange` int(11) NOT NULL DEFAULT '1',
  `Rent` int(11) NOT NULL DEFAULT '0',
  `VehicleSlots` int(11) NOT NULL DEFAULT '2',
  `FishSkill` int(11) NOT NULL DEFAULT '1',
  `FishTimes` int(11) NOT NULL DEFAULT '0',
  `TruckTimes` int(11) NOT NULL DEFAULT '0',
  `TruckSkill` int(11) NOT NULL DEFAULT '1',
  `ArmsSkill` int(11) NOT NULL DEFAULT '1',
  `ArmsTimes` int(11) NOT NULL DEFAULT '0',
  `DrugsSkill` int(11) NOT NULL DEFAULT '1',
  `DrugsTimes` int(11) NOT NULL DEFAULT '0',
  `Tickets` int(11) NOT NULL DEFAULT '0',
  `Unbans` int(11) NOT NULL,
  `Complaints` int(11) NOT NULL,
  `Drugs` int(11) NOT NULL,
  `VIP` int(11) NOT NULL,
  `Premium` int(11) NOT NULL,
  `FWarns` int(11) NOT NULL DEFAULT '0',
  `FPunish` int(11) NOT NULL DEFAULT '0',
  `Beta` int(11) NOT NULL,
  `LastIP` varchar(16) NOT NULL,
  `StaffWarns` int(11) NOT NULL,
  `Note` varchar(250) NOT NULL,
  `Mats` int(11) NOT NULL,
  `Faction` int(11) NOT NULL DEFAULT '0',
  `CarpenterTimes` int(11) NOT NULL DEFAULT '0',
  `CarpenterSkill` int(11) NOT NULL DEFAULT '1',
  `Phone` int(11) NOT NULL,
  `FAge` int(11) NOT NULL DEFAULT '0',
  `PhoneBook` int(11) NOT NULL,
  `MBank` int(11) NOT NULL,
  `MStore` int(100) NOT NULL,
  `JailTime` int(11) NOT NULL DEFAULT '0',
  `Jailed` int(11) NOT NULL DEFAULT '0',
  `Arrested` int(11) NOT NULL DEFAULT '0',
  `WantedDeaths` int(11) NOT NULL DEFAULT '0',
  `Commands` int(11) NOT NULL,
  `WantedLevel` int(11) NOT NULL DEFAULT '0',
  `DailyMission` int(11) NOT NULL DEFAULT '-1',
  `DailyMission2` int(11) NOT NULL DEFAULT '-1',
  `Progress` int(11) NOT NULL,
  `Progress2` int(11) NOT NULL,
  `NeedProgress1` int(10) NOT NULL,
  `NeedProgress2` int(10) NOT NULL,
  `WTChannel` int(11) NOT NULL DEFAULT '0',
  `WTalkie` int(11) NOT NULL,
  `WToggle` int(11) NOT NULL,
  `WantedTime` int(11) NOT NULL DEFAULT '0',
  `LiveToggle` int(11) NOT NULL,
  `Guns` varchar(35) NOT NULL DEFAULT '0|0|0|0|0',
  `Clan` int(11) NOT NULL DEFAULT '0',
  `ClanRank` int(11) NOT NULL DEFAULT '1',
  `ClanAge` int(11) NOT NULL DEFAULT '0',
  `ClanWarns` int(11) NOT NULL DEFAULT '0',
  `ClanTag` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `server_users`
--

INSERT INTO `server_users` (`ID`, `Name`, `Password`, `EMail`, `LastLogin`, `RegisterDate`, `Skin`, `Admin`, `Helper`, `Level`, `RespectPoints`, `Money`, `Bank`, `Hours`, `Seconds`, `Mute`, `Gender`, `Tutorial`, `Licenses`, `Warn`, `ReportMute`, `Status`, `PremiumPoints`, `Job`, `Business`, `BusinessID`, `IP`, `House`, `HouseID`, `FRank`, `SpawnChange`, `Rent`, `VehicleSlots`, `FishSkill`, `FishTimes`, `TruckTimes`, `TruckSkill`, `ArmsSkill`, `ArmsTimes`, `DrugsSkill`, `DrugsTimes`, `Tickets`, `Unbans`, `Complaints`, `Drugs`, `VIP`, `Premium`, `FWarns`, `FPunish`, `Beta`, `LastIP`, `StaffWarns`, `Note`, `Mats`, `Faction`, `CarpenterTimes`, `CarpenterSkill`, `Phone`, `FAge`, `PhoneBook`, `MBank`, `MStore`, `JailTime`, `Jailed`, `Arrested`, `WantedDeaths`, `Commands`, `WantedLevel`, `DailyMission`, `DailyMission2`, `Progress`, `Progress2`, `NeedProgress1`, `NeedProgress2`, `WTChannel`, `WTalkie`, `WToggle`, `WantedTime`, `LiveToggle`, `Guns`, `Clan`, `ClanRank`, `ClanAge`, `ClanWarns`, `ClanTag`) VALUES
(1, 'Vicentzo', '3D35EFB6BAFB1213ECF5120FEDACD36859475ACAFA4EDC7762A98C50059E202F', 'asd@Gmail.com', ' Bine ai venit, Vicentzo.', '2021-04-29 09:34:07', 293, 6, 0, 2, 3, 195670, 5000, 3, 0, 0, 1, 1, '98|0|98|0|98|0|98|0', 0, 0, 0, 0, 0, 0, 0, '86.120.191.35', 0, 0, 7, 4, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '86.120.191.35', 0, '', 0, 7, 0, 1, 0, 0, 0, 0, 100, 300, 1, 0, 0, 0, 0, 1, 3, 0, 0, 10, 1, 0, 0, 0, 0, 0, '0|0|0|0|0', 1, 7, 123, 0, 0),
(2, 'mr.bunny', '65A134209A6CF777E2E9415709DB14EAC16FAB3F50A02DB56C1981D856128FE4', 'nuam@gmail.com', ' Bine ai venit, mr.bunny.', '2021-04-29 09:34:56', 12, 6, 0, 1, 0, 0, 5000, 0, 0, 0, 0, 1, '100|0|100|0|100|0|100|0', 0, 0, 0, 0, 0, 0, 0, '185.53.197.16', 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '185.53.197.16', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 100, 600, 1, 0, 0, 0, 0, 3, 1, 0, 0, 1, 5, 0, 0, 0, 0, 0, '0|0|0|0|0', 1, 0, 0, 0, 0),
(3, 'rafi71', 'B28532892AB9AB26623727DEE3250688DEFBDCABC66BBE90E9DA603F98F127DA', 'dsad@Gmail.com', '18:32 - 29/04/2021', '2021-04-29 12:07:37', 12, 6, 0, 1, 0, 2000, 5000, 0, 978, 0, 0, 1, '100|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '212.93.128.154', 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '212.93.128.154', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(4, 'Aditsu', 'B9CA3E2B5179DE65CBF5D2E7FF768F4BEB7C22B5E116F3E0298E7FFC7E886459', 'nam@yahoo.com', '00:08 - 30/04/2021', '2021-04-29 16:41:38', 250, 6, 0, 1, 1, 2625, 5000, 0, 36, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '89.123.227.199', 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '89.123.227.199', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(5, 'ZeCo.F', '620E25D5198936CB184942B3284FCC04C5B30D58C578E87BB2FB376A29945EB3', 'f_zeco@yahoo.com', '22:15 - 29/04/2021', '2021-04-29 18:51:51', 227, 6, 0, 1, 0, 275, 5000, 0, 1342, 0, 1, 1, '100|0|100|0|100|0|100|0', 0, 0, 0, 0, 1, 0, 0, '82.20.32.76', 0, 0, 7, 4, 0, 2, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '82.20.32.76', 0, '', 0, 1, 0, 1, 11233, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(6, 'Quez]', '8A03F46B8F177B02CDF6279B08DBD180B5F4E6BEDA65EA86798F01386D2A52A8', 'dsadisad@gmail.com', '21:54 - 29/04/2021', '2021-04-29 18:54:36', 12, 0, 0, 1, 0, 2500, 5000, 0, 40, 0, 0, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '82.79.152.25', 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(7, '.FLORiN46', 'EE5F7A1A06CFB3DB984F6B440C2EDEA18DC8B27BB4EC375CE74D243E6775F1B7', 'flirinflansf@gmail.com', '22:16 - 29/04/2021', '2021-04-29 19:17:09', 12, 0, 0, 1, 0, 2500, 5000, 0, 113, 0, 0, 1, '0|0|0|0|0|0|0|0', 0, 76, 0, 0, 0, 0, 0, '88.120.18.103', 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(8, 'CORLEA', 'C14CE81DC43CAC61A96B6818095A7AE09B0E0ABA177196DCCCD40136EA283249', 'darius@gmail.com', '22:29 - 29/04/2021', '2021-04-29 19:29:29', 12, 0, 0, 1, 0, 2500, 5000, 0, 110, 0, 0, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '46.97.168.202', 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(9, 'mr.bunny2', '65A134209A6CF777E2E9415709DB14EAC16FAB3F50A02DB56C1981D856128FE4', 'asdasdas@dasdac.dsd', '22:59 - 29/04/2021', '2021-04-29 19:59:25', 12, 0, 0, 1, 1, 2625, 5000, 0, 14, 0, 0, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '185.53.197.16', 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(10, 'HPQ123', 'B28532892AB9AB26623727DEE3250688DEFBDCABC66BBE90E9DA603F98F127DA', 'mafia@gmail.com', ' Bine ai venit, HPQ123.', '2021-04-29 20:10:29', 12, 0, 0, 1, 1, 2625, 5000, 0, 347, 0, 0, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 1, 0, 0, '109.97.72.241', 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '109.97.72.241', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1, 7, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(11, 'Aptiv', 'D2BC755012551E1541FF9BA90F972B335BD95A5E33FA8DFDFCF88315DAE9B12A', 'kkkafaa@gmail.com', '23:19 - 29/04/2021', '2021-04-29 20:16:50', 250, 0, 0, 1, 0, 2500, 5000, 0, 269, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '185.69.145.37', 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '185.69.145.37', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(12, 'RaKneT', 'D2BC755012551E1541FF9BA90F972B335BD95A5E33FA8DFDFCF88315DAE9B12A', 'None', 'None', '2021-04-29 20:19:17', 250, 0, 0, 1, 0, 2500, 5000, 0, 0, 0, 1, 0, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_vars`
--

CREATE TABLE `server_vars` (
  `ID` int(11) NOT NULL,
  `Name` varchar(32) NOT NULL,
  `Value` int(11) NOT NULL,
  `TypeVar` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_vars`
--

INSERT INTO `server_vars` (`ID`, `Name`, `Value`, `TypeVar`) VALUES
(1, 'DatabaseCon', 1, 0),
(2, 'Bonus', 1, 0);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_vehicles`
--

CREATE TABLE `server_vehicles` (
  `ID` int(11) NOT NULL,
  `Model` int(11) NOT NULL DEFAULT '400',
  `X` float NOT NULL DEFAULT '0',
  `Y` float NOT NULL DEFAULT '0',
  `Z` float NOT NULL DEFAULT '0',
  `Angle` float NOT NULL DEFAULT '0',
  `Faction` int(11) NOT NULL DEFAULT '0',
  `ColorOne` int(11) NOT NULL DEFAULT '1',
  `ColorTwo` int(11) NOT NULL DEFAULT '1',
  `VirtualWorld` int(11) NOT NULL,
  `Rank` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_vehicles`
--

INSERT INTO `server_vehicles` (`ID`, `Model`, `X`, `Y`, `Z`, `Angle`, `Faction`, `ColorOne`, `ColorTwo`, `VirtualWorld`, `Rank`) VALUES
(1, 416, 1177.83, -1308.61, 14.002, 269.184, 1, 1, 3, 0, 1),
(2, 416, 1179.11, -1338.93, 13.9894, 270.234, 1, 1, 3, 0, 1),
(3, 416, 1187.64, -1332.21, 13.7109, 0.95781, 1, 1, 3, 0, 1),
(4, 416, 1187.86, -1315.45, 13.7137, 180.839, 1, 1, 3, 0, 1),
(5, 411, 1566.75, -1633.09, 13.1957, 89.7751, 2, 1, 1, 0, 1),
(6, 411, 1554.33, -1633.06, 13.1893, 88.7537, 2, 1, 1, 0, 1),
(7, 411, 1554.55, -1623.06, 13.193, 90.6093, 2, 1, 1, 0, 2),
(8, 411, 1567.01, -1623.21, 13.189, 89.0626, 2, 1, 1, 0, 2);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_warn_logs`
--

CREATE TABLE `server_warn_logs` (
  `ID` int(11) NOT NULL,
  `PlayerName` varchar(24) NOT NULL DEFAULT 'None',
  `PlayerID` int(11) NOT NULL DEFAULT '0',
  `AdminName` varchar(24) NOT NULL DEFAULT 'AdmBot',
  `AdminID` int(11) NOT NULL DEFAULT '0',
  `WarnReason` varchar(64) NOT NULL DEFAULT 'None',
  `WarnTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_applications`
--

CREATE TABLE `wcode_applications` (
  `id` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `UserName` varchar(32) NOT NULL,
  `FactionID` int(11) NOT NULL,
  `Answers` text NOT NULL,
  `Questions` int(11) NOT NULL,
  `Status` int(11) NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ActionBy` varchar(24) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_clan_topics`
--

CREATE TABLE `wcode_clan_topics` (
  `id` int(11) NOT NULL,
  `title` varchar(128) NOT NULL,
  `description` text NOT NULL,
  `username` varchar(32) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` int(11) NOT NULL,
  `pinned` int(11) NOT NULL,
  `clanid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_commentaries`
--

CREATE TABLE `wcode_commentaries` (
  `ID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `UserName` varchar(32) NOT NULL,
  `Skin` int(11) NOT NULL,
  `Text` text NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Section` varchar(32) NOT NULL,
  `TopicID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_complaints`
--

CREATE TABLE `wcode_complaints` (
  `ID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `UserName` varchar(32) NOT NULL,
  `AccusedID` int(11) NOT NULL,
  `AccusedName` varchar(32) NOT NULL,
  `Text` text NOT NULL,
  `Category` int(11) NOT NULL,
  `Faction` int(11) NOT NULL,
  `Status` int(11) NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ActionBy` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_editables`
--

CREATE TABLE `wcode_editables` (
  `ID` int(11) NOT NULL,
  `Text` text NOT NULL,
  `By` varchar(32) NOT NULL,
  `Form` varchar(32) NOT NULL,
  `Updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_email_change`
--

CREATE TABLE `wcode_email_change` (
  `id` int(11) NOT NULL,
  `username` varchar(32) NOT NULL,
  `old_email` varchar(64) NOT NULL,
  `new_email` varchar(64) NOT NULL,
  `token` varchar(32) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `time` int(11) NOT NULL,
  `user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_functions`
--

CREATE TABLE `wcode_functions` (
  `ID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `UserName` varchar(32) NOT NULL,
  `Tag` varchar(64) NOT NULL,
  `Color` varchar(32) NOT NULL,
  `Icon` varchar(64) NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_logs`
--

CREATE TABLE `wcode_logs` (
  `ID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `UserName` varchar(32) NOT NULL,
  `Log` text NOT NULL,
  `VictimID` int(11) NOT NULL,
  `VictimName` varchar(32) NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Structure` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_notifications`
--

CREATE TABLE `wcode_notifications` (
  `ID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `UserName` varchar(32) NOT NULL,
  `Notification` text NOT NULL,
  `FromID` int(11) NOT NULL,
  `FromName` varchar(32) NOT NULL,
  `Seen` int(11) NOT NULL,
  `Link` text NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `wcode_notifications`
--

INSERT INTO `wcode_notifications` (`ID`, `UserID`, `UserName`, `Notification`, `FromID`, `FromName`, `Seen`, `Link`, `Date`) VALUES
(1, 1, 'Vicentzo123', 'You have no more FWarns points thanks to Vicentzo123.', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 12:56:09'),
(2, 1, 'Vicentzo123', 'You received +1 WarnPoint from Vicentzo123 for Scripter/Web Dev Remix Alex e aici.', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 12:56:43'),
(3, 1, 'Vicentzo123', 'You have no more FPunish points thanks to Vicentzo123.', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 12:58:01'),
(4, 1, 'Vicentzo123', 'You have no more FWarns points thanks to Vicentzo123.', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 13:01:12'),
(5, 1, 'Vicentzo123', 'You have one WarnPoint less from Vicentzo123 for Esti praf adv, remix alex pe fb scripter/web developer.', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 13:01:38'),
(6, 1, 'Vicentzo123', 'You\'ve been muted for 1 minutes!', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 13:04:43'),
(7, 1, 'Vicentzo123', 'You\'ve been unmuted by Vicentzo123!', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 13:08:40'),
(8, 1, 'Vicentzo123', 'You\'ve been muted for 1 minutes!', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 13:08:49'),
(9, 1, 'Vicentzo123', 'You\'ve been unmuted by Vicentzo123!', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 13:09:27'),
(10, 1, 'Vicentzo123', 'You\'ve been muted for 1 minutes!', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 13:09:43'),
(11, 1, 'Vicentzo123', 'You\'ve been unmuted by Vicentzo123!', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 13:11:04'),
(12, 1, 'Vicentzo123', 'You\'ve been muted for 1 minutes!', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 13:11:17'),
(13, 1, 'Vicentzo123', 'You\'ve been unmuted by Vicentzo123!', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 13:13:30'),
(14, 1, 'Vicentzo123', 'You\'ve been muted for 1 minutes!', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 13:13:36'),
(15, 1, 'Vicentzo123', 'You\'ve been muted for 1 minutes!', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 13:16:47'),
(16, 1, 'Vicentzo123', 'You\'ve been muted for 5 minutes!', 1, 'Vicentzo123', 0, 'http://localhost/dark/profile/Vicentzo123', '2020-11-14 13:18:24');

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_questions`
--

CREATE TABLE `wcode_questions` (
  `id` int(11) NOT NULL,
  `question` text NOT NULL,
  `factionid` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `wcode_questions`
--

INSERT INTO `wcode_questions` (`id`, `question`, `factionid`, `date`) VALUES
(11, 'Cum te numesti, cati ani ai si de unde esti ?', 15, '2019-04-09 08:58:26'),
(14, 'Cate ore petreci pe server, fara a sta AFK?', 15, '2019-04-09 08:58:37'),
(15, 'Spune-ne cateva informatii despre tine:', 15, '2019-04-09 08:58:40'),
(40, 'De ce doresti sa faci parte din Tow Car Company?', 15, '2019-04-09 10:16:51'),
(41, 'Cu ce crezi ca poti ajuta aceasta factiune?', 15, '2019-04-09 10:17:23'),
(44, 'Cat timp doresti sa petreci in aceasta factiune?:', 15, '2019-04-09 10:33:19'),
(192, 'Cum te numesti si ce varsta ai?', 9, '2019-04-20 12:22:55'),
(193, 'Prezentare (minim 20 de cuvinte)', 9, '2019-04-20 12:23:20'),
(194, 'De ce doriti sa intrati in aceasta factiune?', 9, '2019-04-20 12:23:36'),
(195, 'Cate ore poti fi activ pe server?(Fara [/sleep])', 9, '2019-04-20 12:23:51'),
(198, 'Cu ce crezi ca poti ajuta aceasta factiune?', 9, '2019-04-20 12:25:14'),
(199, 'Cat ti-ai propus sa stai in aceasta Factiune?', 9, '2019-04-20 12:25:46'),
(200, 'Esti de acord ca trebuie sa respecti cuvantul liderului / co-liderului sau a unui rank mai mare?', 9, '2019-04-20 12:26:11'),
(201, 'Esti de acord ca pentru un comportament ne-adecvat fata de cei care conduc factiunea poate fi pedepsita cu Uninvite? ', 9, '2019-04-20 12:26:43'),
(202, 'Stii sa scrii corect gramatical?', 9, '2019-04-20 12:26:51'),
(624, 'Cum te numesti si ce varsta ai?', 13, '2019-05-01 05:50:09'),
(625, 'De ce crezi ca esti potrivit factiunii Taxi Las Venturas?', 13, '2019-05-01 05:50:15'),
(626, 'Cu ce esti diferit fata de ceilalti aplicanti, de ce ar trebuii sa te alegem pe tine?', 13, '2019-05-01 05:50:20'),
(627, 'Descriere personala (minim 20 de cuvinte).', 13, '2019-05-01 05:50:23'),
(628, 'Vei respecta Leader-ul/Co-Leader-ul si membrii din factiune?', 13, '2019-05-01 05:50:27'),
(629, 'Cate zile ti-ai propus sa stai in aceasta factiune?', 13, '2019-05-01 05:50:31'),
(632, 'Cum te numesti si ce varsta ai?', 11, '2019-05-03 05:24:44'),
(633, 'De ce ai ales aceasta factiune?', 11, '2019-05-03 05:25:32'),
(634, 'Link cont forum(obligatoriu):', 11, '2019-05-03 05:25:34'),
(635, 'Cu ce crezi ca se ocupa membrii agentiei?', 11, '2019-05-03 05:25:45'),
(636, 'Ai fost vreodata sanctionat? Daca da, de ce?', 11, '2019-05-03 05:25:46'),
(637, 'Cate ore acorzi jocului zilnic?', 11, '2019-05-03 05:25:46'),
(638, 'Esti constient ca stresarea liderului cat si a co-liderului duce automat la respingerea aplicatiei voastre?', 11, '2019-05-03 05:25:47'),
(641, 'De ce doresti sa te alaturi mafiei Ballas Family?', 10, '2019-05-04 16:12:40'),
(642, 'Ce face mai exact factiunea noastra?:', 10, '2019-05-04 16:12:44'),
(643, 'Cum te-ai descrie in cateva cuvinte? (minim 25 de cuvinte):', 10, '2019-05-04 16:12:47'),
(644, 'Cat de bine crezi ca tragi cu arma?(low/medium/high)', 10, '2019-05-04 16:12:50'),
(645, 'Ne poti prezenta un videoclip de la paintball/war in care tragi?:', 10, '2019-05-04 16:12:54'),
(646, 'Ai fost vreodata sanctionat daca da de ce?:', 10, '2019-05-04 16:12:57'),
(648, 'Alte Precizari?', 13, '2019-05-08 04:00:54'),
(660, '1.Cum te numesti si ce varsta ai ? ', 4, '2019-05-13 08:41:05'),
(661, '2.Descriete in minim 20 de cuvinte.', 4, '2019-05-13 08:41:22'),
(662, '3.Cat de bine tragi ? (Low,Medium,High)', 4, '2019-05-13 08:41:57'),
(663, '4.Esti constient ca daca nu vei sta 14 zile in factiune vei fi scos cu 20 FP ? ', 4, '2019-05-13 08:42:26'),
(664, '5.Te poti prezenta in fiecare zi la war ?', 4, '2019-05-13 08:43:02'),
(666, '6.Cunosti regulamentul acestei mafii ? ', 4, '2019-05-13 08:43:58'),
(667, '7.Alte precizari ai ?', 4, '2019-05-13 08:44:24'),
(672, 'Ai sa respecti lider-ul, atat cat si co-liderul?', 10, '2019-05-23 15:00:51'),
(693, 'Cum te numesti si cati ani ai?', 6, '2019-05-28 14:24:52'),
(694, 'Cum consideri ca tragi cu M4 / Deagle?', 6, '2019-05-28 14:24:58'),
(695, 'De ce ai ales acesta mafie?', 6, '2019-05-28 14:25:07'),
(696, 'Poti fi la war-uri?', 6, '2019-05-28 14:25:25'),
(697, 'Poti sa trimiti un videoclip in care se vede cum tragi?', 6, '2019-05-28 14:25:33'),
(698, 'Vei respecta liderul si co-liderul dupa intrarea in factiune?', 6, '2019-05-28 14:25:40'),
(699, 'Alte precizari in cazul in care sunt necesare.', 6, '2019-05-28 14:26:06'),
(700, 'Link catre profilul de forum:', 15, '2019-05-30 08:58:08'),
(719, 'Ce reprezinta Grove Street si cu ce se ocupa?', 5, '2019-06-09 09:47:41'),
(720, 'Descriere personala de minim 20 de cuvinte.', 5, '2019-06-09 09:47:44'),
(722, 'De ce doresti sa te alaturi mafiei Grove Street?', 5, '2019-06-09 09:47:58'),
(723, 'Cum consideri ca tragi?', 5, '2019-06-09 09:48:02'),
(726, 'Cat de serios esti?', 9, '2019-06-09 11:28:28'),
(735, 'Esti constient ca vei sustine un test?', 10, '2019-10-12 14:36:20'),
(736, 'Alte precizari?', 10, '2019-10-12 14:36:36'),
(755, 'Poti fi prezent la war-uri in intervalul 20:00-22:00?', 5, '2020-01-15 09:51:20'),
(757, 'Ai mai facut parte dintr-o factiune de acest tip? Daca da, de ce ai parasit-o?', 5, '2020-01-15 09:54:13'),
(759, 'Link cont forum(obligatoriu):', 5, '2020-01-15 09:54:53'),
(760, 'Cum te numesti, de unde esti si ce varsta ai?:', 16, '2020-01-20 03:25:30'),
(762, 'Ce ne poti spune despre tine:', 16, '2020-01-20 03:26:27'),
(764, 'De ce ai parasit factiunea anterioara?:', 16, '2020-01-20 03:27:39'),
(765, 'Cu ce crezi ca se ocupa factiunea Taxi Company?', 16, '2020-01-20 03:28:27'),
(766, 'De ce ai aplicat la aceasta factiune?: ', 16, '2020-01-20 03:28:56'),
(767, 'Esti constient ca daca nu respecti liderul/co-liderii vei fi sanctionat?:', 16, '2020-01-20 03:28:58'),
(769, 'Link catre contul de forum:', 16, '2020-01-20 03:29:08'),
(775, 'Numele, varsta reala si localitatea de domiciliu:', 2, '2020-01-26 05:18:18'),
(776, 'O scurta autocaracterizare:', 2, '2020-01-26 05:18:56'),
(779, 'Ai posibilitatea de a filma fiecare actiune la o rezolutie de minim 720p?:', 2, '2020-01-26 06:34:59'),
(780, 'De ce doresti sa te alaturi departamentului Federal Bureau of Investigation?:', 2, '2020-01-26 06:35:15'),
(781, 'De ce consideri ca te vei descurca in acest tip de departament?:', 2, '2020-01-26 06:35:38'),
(782, 'Care consideri ca sunt cele mai importante trasaturi de personalitate pe care un agent FBI ar trebui sa le aiba?:', 2, '2020-01-26 06:36:02'),
(783, 'Care sunt planurile tale de viitor ca jucator in aceasta comunitate?:', 2, '2020-01-26 06:36:22'),
(784, 'Esti constient ca daca stresezi liderul sau co-liderul o sa fi respins automat?:', 2, '2020-01-26 06:36:40'),
(785, 'Alte informatii folositoare pentru conducerea departamentului:', 2, '2020-01-26 06:37:00'),
(787, 'Cum te numesti si ce varsta ai?', 1, '2020-04-17 16:31:06'),
(788, 'De ce ai ales Los Santos Police Departament?', 1, '2020-04-17 16:31:20'),
(789, 'Spune-ne cateva detalii despre tine.', 1, '2020-04-17 16:31:23'),
(790, 'De ce te-am alege ca si candidat?', 1, '2020-04-17 16:31:24'),
(791, 'Ai citit regulamentul departamentelor?', 1, '2020-04-17 16:31:24'),
(792, 'Poti filma la o calitate 720p (minim) pentru a avea dovezi?', 1, '2020-04-17 16:31:27'),
(793, 'Poti juca minim 5 ore pe saptamana?', 1, '2020-04-17 16:31:29'),
(794, 'De ce ai ales aceasta factiune?', 5, '2020-04-17 16:40:17'),
(795, 'Link cont forum(obligatoriu):', 1, '2020-04-17 16:41:56'),
(797, 'Link cont forum(obligatoriu):', 6, '2020-04-17 16:42:45'),
(798, 'De ce ai ales Hitman Agency si nu alta factiune?', 11, '2020-04-17 16:44:34'),
(808, 'Numele si varsta reala:', 14, '2020-04-20 10:40:47'),
(809, 'Descrie-te in cateva cuvinte:', 14, '2020-04-20 10:40:58'),
(810, 'Ce face mai exact factiunea noastra?:', 14, '2020-04-20 10:41:17'),
(811, 'De ce iti doresti sa intri in Paramedic Departament?:', 14, '2020-04-20 10:41:42'),
(812, 'Cu ce poti ajuta aceasta factiune?:', 14, '2020-04-20 10:41:58'),
(813, 'Cate ore petreci in joc pe zi, fara AFK?:', 14, '2020-04-20 10:42:08'),
(814, 'Cat doresti sa stai in aceasta factiune?:', 14, '2020-04-20 10:42:28'),
(815, 'Esti constient ca daca stresezi liderul / co-liderul iti vei pierde sansa de a fi acceptat?:', 14, '2020-04-20 10:42:41'),
(816, 'Alte precizari:', 14, '2020-04-20 10:42:50'),
(11, 'Cum te numesti, cati ani ai si de unde esti ?', 15, '2019-04-09 08:58:26'),
(14, 'Cate ore petreci pe server, fara a sta AFK?', 15, '2019-04-09 08:58:37'),
(15, 'Spune-ne cateva informatii despre tine:', 15, '2019-04-09 08:58:40'),
(40, 'De ce doresti sa faci parte din Tow Car Company?', 15, '2019-04-09 10:16:51'),
(41, 'Cu ce crezi ca poti ajuta aceasta factiune?', 15, '2019-04-09 10:17:23'),
(44, 'Cat timp doresti sa petreci in aceasta factiune?:', 15, '2019-04-09 10:33:19'),
(192, 'Cum te numesti si ce varsta ai?', 9, '2019-04-20 12:22:55'),
(193, 'Prezentare (minim 20 de cuvinte)', 9, '2019-04-20 12:23:20'),
(194, 'De ce doriti sa intrati in aceasta factiune?', 9, '2019-04-20 12:23:36'),
(195, 'Cate ore poti fi activ pe server?(Fara [/sleep])', 9, '2019-04-20 12:23:51'),
(198, 'Cu ce crezi ca poti ajuta aceasta factiune?', 9, '2019-04-20 12:25:14'),
(199, 'Cat ti-ai propus sa stai in aceasta Factiune?', 9, '2019-04-20 12:25:46'),
(200, 'Esti de acord ca trebuie sa respecti cuvantul liderului / co-liderului sau a unui rank mai mare?', 9, '2019-04-20 12:26:11'),
(201, 'Esti de acord ca pentru un comportament ne-adecvat fata de cei care conduc factiunea poate fi pedepsita cu Uninvite? ', 9, '2019-04-20 12:26:43'),
(202, 'Stii sa scrii corect gramatical?', 9, '2019-04-20 12:26:51'),
(624, 'Cum te numesti si ce varsta ai?', 13, '2019-05-01 05:50:09'),
(625, 'De ce crezi ca esti potrivit factiunii Taxi Las Venturas?', 13, '2019-05-01 05:50:15'),
(626, 'Cu ce esti diferit fata de ceilalti aplicanti, de ce ar trebuii sa te alegem pe tine?', 13, '2019-05-01 05:50:20'),
(627, 'Descriere personala (minim 20 de cuvinte).', 13, '2019-05-01 05:50:23'),
(628, 'Vei respecta Leader-ul/Co-Leader-ul si membrii din factiune?', 13, '2019-05-01 05:50:27'),
(629, 'Cate zile ti-ai propus sa stai in aceasta factiune?', 13, '2019-05-01 05:50:31'),
(632, 'Cum te numesti si ce varsta ai?', 11, '2019-05-03 05:24:44'),
(633, 'De ce ai ales aceasta factiune?', 11, '2019-05-03 05:25:32'),
(634, 'Link cont forum(obligatoriu):', 11, '2019-05-03 05:25:34'),
(635, 'Cu ce crezi ca se ocupa membrii agentiei?', 11, '2019-05-03 05:25:45'),
(636, 'Ai fost vreodata sanctionat? Daca da, de ce?', 11, '2019-05-03 05:25:46'),
(637, 'Cate ore acorzi jocului zilnic?', 11, '2019-05-03 05:25:46'),
(638, 'Esti constient ca stresarea liderului cat si a co-liderului duce automat la respingerea aplicatiei voastre?', 11, '2019-05-03 05:25:47'),
(641, 'De ce doresti sa te alaturi mafiei Ballas Family?', 10, '2019-05-04 16:12:40'),
(642, 'Ce face mai exact factiunea noastra?:', 10, '2019-05-04 16:12:44'),
(643, 'Cum te-ai descrie in cateva cuvinte? (minim 25 de cuvinte):', 10, '2019-05-04 16:12:47'),
(644, 'Cat de bine crezi ca tragi cu arma?(low/medium/high)', 10, '2019-05-04 16:12:50'),
(645, 'Ne poti prezenta un videoclip de la paintball/war in care tragi?:', 10, '2019-05-04 16:12:54'),
(646, 'Ai fost vreodata sanctionat daca da de ce?:', 10, '2019-05-04 16:12:57'),
(648, 'Alte Precizari?', 13, '2019-05-08 04:00:54'),
(660, '1.Cum te numesti si ce varsta ai ? ', 4, '2019-05-13 08:41:05'),
(661, '2.Descriete in minim 20 de cuvinte.', 4, '2019-05-13 08:41:22'),
(662, '3.Cat de bine tragi ? (Low,Medium,High)', 4, '2019-05-13 08:41:57'),
(663, '4.Esti constient ca daca nu vei sta 14 zile in factiune vei fi scos cu 20 FP ? ', 4, '2019-05-13 08:42:26'),
(664, '5.Te poti prezenta in fiecare zi la war ?', 4, '2019-05-13 08:43:02'),
(666, '6.Cunosti regulamentul acestei mafii ? ', 4, '2019-05-13 08:43:58'),
(667, '7.Alte precizari ai ?', 4, '2019-05-13 08:44:24'),
(672, 'Ai sa respecti lider-ul, atat cat si co-liderul?', 10, '2019-05-23 15:00:51'),
(693, 'Cum te numesti si cati ani ai?', 6, '2019-05-28 14:24:52'),
(694, 'Cum consideri ca tragi cu M4 / Deagle?', 6, '2019-05-28 14:24:58'),
(695, 'De ce ai ales acesta mafie?', 6, '2019-05-28 14:25:07'),
(696, 'Poti fi la war-uri?', 6, '2019-05-28 14:25:25'),
(697, 'Poti sa trimiti un videoclip in care se vede cum tragi?', 6, '2019-05-28 14:25:33'),
(698, 'Vei respecta liderul si co-liderul dupa intrarea in factiune?', 6, '2019-05-28 14:25:40'),
(699, 'Alte precizari in cazul in care sunt necesare.', 6, '2019-05-28 14:26:06'),
(700, 'Link catre profilul de forum:', 15, '2019-05-30 08:58:08'),
(719, 'Ce reprezinta Grove Street si cu ce se ocupa?', 5, '2019-06-09 09:47:41'),
(720, 'Descriere personala de minim 20 de cuvinte.', 5, '2019-06-09 09:47:44'),
(722, 'De ce doresti sa te alaturi mafiei Grove Street?', 5, '2019-06-09 09:47:58'),
(723, 'Cum consideri ca tragi?', 5, '2019-06-09 09:48:02'),
(726, 'Cat de serios esti?', 9, '2019-06-09 11:28:28'),
(735, 'Esti constient ca vei sustine un test?', 10, '2019-10-12 14:36:20'),
(736, 'Alte precizari?', 10, '2019-10-12 14:36:36'),
(755, 'Poti fi prezent la war-uri in intervalul 20:00-22:00?', 5, '2020-01-15 09:51:20'),
(757, 'Ai mai facut parte dintr-o factiune de acest tip? Daca da, de ce ai parasit-o?', 5, '2020-01-15 09:54:13'),
(759, 'Link cont forum(obligatoriu):', 5, '2020-01-15 09:54:53'),
(760, 'Cum te numesti, de unde esti si ce varsta ai?:', 16, '2020-01-20 03:25:30'),
(762, 'Ce ne poti spune despre tine:', 16, '2020-01-20 03:26:27'),
(764, 'De ce ai parasit factiunea anterioara?:', 16, '2020-01-20 03:27:39'),
(765, 'Cu ce crezi ca se ocupa factiunea Taxi Company?', 16, '2020-01-20 03:28:27'),
(766, 'De ce ai aplicat la aceasta factiune?: ', 16, '2020-01-20 03:28:56'),
(767, 'Esti constient ca daca nu respecti liderul/co-liderii vei fi sanctionat?:', 16, '2020-01-20 03:28:58'),
(769, 'Link catre contul de forum:', 16, '2020-01-20 03:29:08'),
(775, 'Numele, varsta reala si localitatea de domiciliu:', 2, '2020-01-26 05:18:18'),
(776, 'O scurta autocaracterizare:', 2, '2020-01-26 05:18:56'),
(779, 'Ai posibilitatea de a filma fiecare actiune la o rezolutie de minim 720p?:', 2, '2020-01-26 06:34:59'),
(780, 'De ce doresti sa te alaturi departamentului Federal Bureau of Investigation?:', 2, '2020-01-26 06:35:15'),
(781, 'De ce consideri ca te vei descurca in acest tip de departament?:', 2, '2020-01-26 06:35:38'),
(782, 'Care consideri ca sunt cele mai importante trasaturi de personalitate pe care un agent FBI ar trebui sa le aiba?:', 2, '2020-01-26 06:36:02'),
(783, 'Care sunt planurile tale de viitor ca jucator in aceasta comunitate?:', 2, '2020-01-26 06:36:22'),
(784, 'Esti constient ca daca stresezi liderul sau co-liderul o sa fi respins automat?:', 2, '2020-01-26 06:36:40'),
(785, 'Alte informatii folositoare pentru conducerea departamentului:', 2, '2020-01-26 06:37:00'),
(787, 'Cum te numesti si ce varsta ai?', 1, '2020-04-17 16:31:06'),
(788, 'De ce ai ales Los Santos Police Departament?', 1, '2020-04-17 16:31:20'),
(789, 'Spune-ne cateva detalii despre tine.', 1, '2020-04-17 16:31:23'),
(790, 'De ce te-am alege ca si candidat?', 1, '2020-04-17 16:31:24'),
(791, 'Ai citit regulamentul departamentelor?', 1, '2020-04-17 16:31:24'),
(792, 'Poti filma la o calitate 720p (minim) pentru a avea dovezi?', 1, '2020-04-17 16:31:27'),
(793, 'Poti juca minim 5 ore pe saptamana?', 1, '2020-04-17 16:31:29'),
(794, 'De ce ai ales aceasta factiune?', 5, '2020-04-17 16:40:17'),
(795, 'Link cont forum(obligatoriu):', 1, '2020-04-17 16:41:56'),
(797, 'Link cont forum(obligatoriu):', 6, '2020-04-17 16:42:45'),
(798, 'De ce ai ales Hitman Agency si nu alta factiune?', 11, '2020-04-17 16:44:34'),
(808, 'Numele si varsta reala:', 14, '2020-04-20 10:40:47'),
(809, 'Descrie-te in cateva cuvinte:', 14, '2020-04-20 10:40:58'),
(810, 'Ce face mai exact factiunea noastra?:', 14, '2020-04-20 10:41:17'),
(811, 'De ce iti doresti sa intri in Paramedic Departament?:', 14, '2020-04-20 10:41:42'),
(812, 'Cu ce poti ajuta aceasta factiune?:', 14, '2020-04-20 10:41:58'),
(813, 'Cate ore petreci in joc pe zi, fara AFK?:', 14, '2020-04-20 10:42:08'),
(814, 'Cat doresti sa stai in aceasta factiune?:', 14, '2020-04-20 10:42:28'),
(815, 'Esti constient ca daca stresezi liderul / co-liderul iti vei pierde sansa de a fi acceptat?:', 14, '2020-04-20 10:42:41'),
(816, 'Alte precizari:', 14, '2020-04-20 10:42:50');

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_recover`
--

CREATE TABLE `wcode_recover` (
  `id` int(11) NOT NULL,
  `user` int(11) NOT NULL,
  `username` varchar(64) NOT NULL,
  `email` varchar(128) NOT NULL,
  `token` varchar(64) NOT NULL,
  `time` int(11) NOT NULL,
  `autotime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_suspend`
--

CREATE TABLE `wcode_suspend` (
  `ID` int(11) NOT NULL,
  `User` varchar(32) NOT NULL,
  `Userid` int(11) NOT NULL,
  `Admin` varchar(32) NOT NULL,
  `Adminid` int(11) NOT NULL,
  `Days` int(11) NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Date_unix` int(11) NOT NULL,
  `Expire_unix` int(11) NOT NULL,
  `Expire` varchar(32) NOT NULL,
  `Reason` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_tickets`
--

CREATE TABLE `wcode_tickets` (
  `ID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `UserName` varchar(32) NOT NULL,
  `Category` int(11) NOT NULL,
  `Text` text NOT NULL,
  `Status` int(11) NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ActionBy` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `wcode_unban`
--

CREATE TABLE `wcode_unban` (
  `ID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `UserName` varchar(32) NOT NULL,
  `BanDetails` text NOT NULL,
  `Title` varchar(32) NOT NULL,
  `Details` text NOT NULL,
  `Status` int(11) NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ActionBy` varchar(32) NOT NULL DEFAULT 'Banned'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexuri pentru tabele eliminate
--

--
-- Indexuri pentru tabele `panelactions2`
--
ALTER TABLE `panelactions2`
  ADD PRIMARY KEY (`id`);

--
-- Indexuri pentru tabele `server_bans`
--
ALTER TABLE `server_bans`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_bans_ip`
--
ALTER TABLE `server_bans_ip`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_business`
--
ALTER TABLE `server_business`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_chat_logs`
--
ALTER TABLE `server_chat_logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_ds`
--
ALTER TABLE `server_ds`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_exam_checkpoints`
--
ALTER TABLE `server_exam_checkpoints`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_factions`
--
ALTER TABLE `server_factions`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_faction_logs`
--
ALTER TABLE `server_faction_logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_houses`
--
ALTER TABLE `server_houses`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_jobs`
--
ALTER TABLE `server_jobs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_kick_logs`
--
ALTER TABLE `server_kick_logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_labels`
--
ALTER TABLE `server_labels`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_logs`
--
ALTER TABLE `server_logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_mute_logs`
--
ALTER TABLE `server_mute_logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_personal_vehicles`
--
ALTER TABLE `server_personal_vehicles`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_pickups`
--
ALTER TABLE `server_pickups`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_safes`
--
ALTER TABLE `server_safes`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_turfs`
--
ALTER TABLE `server_turfs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_users`
--
ALTER TABLE `server_users`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_vars`
--
ALTER TABLE `server_vars`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_vehicles`
--
ALTER TABLE `server_vehicles`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `server_warn_logs`
--
ALTER TABLE `server_warn_logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `wcode_complaints`
--
ALTER TABLE `wcode_complaints`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `wcode_functions`
--
ALTER TABLE `wcode_functions`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `wcode_notifications`
--
ALTER TABLE `wcode_notifications`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `wcode_tickets`
--
ALTER TABLE `wcode_tickets`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `wcode_unban`
--
ALTER TABLE `wcode_unban`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT pentru tabele eliminate
--

--
-- AUTO_INCREMENT pentru tabele `panelactions2`
--
ALTER TABLE `panelactions2`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pentru tabele `server_bans`
--
ALTER TABLE `server_bans`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `server_bans_ip`
--
ALTER TABLE `server_bans_ip`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `server_business`
--
ALTER TABLE `server_business`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pentru tabele `server_chat_logs`
--
ALTER TABLE `server_chat_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=791;

--
-- AUTO_INCREMENT pentru tabele `server_ds`
--
ALTER TABLE `server_ds`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT pentru tabele `server_exam_checkpoints`
--
ALTER TABLE `server_exam_checkpoints`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT pentru tabele `server_factions`
--
ALTER TABLE `server_factions`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pentru tabele `server_faction_logs`
--
ALTER TABLE `server_faction_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `server_houses`
--
ALTER TABLE `server_houses`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pentru tabele `server_jobs`
--
ALTER TABLE `server_jobs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pentru tabele `server_kick_logs`
--
ALTER TABLE `server_kick_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `server_labels`
--
ALTER TABLE `server_labels`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT pentru tabele `server_logs`
--
ALTER TABLE `server_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=132;

--
-- AUTO_INCREMENT pentru tabele `server_mute_logs`
--
ALTER TABLE `server_mute_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `server_personal_vehicles`
--
ALTER TABLE `server_personal_vehicles`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pentru tabele `server_pickups`
--
ALTER TABLE `server_pickups`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT pentru tabele `server_safes`
--
ALTER TABLE `server_safes`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `server_turfs`
--
ALTER TABLE `server_turfs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT pentru tabele `server_users`
--
ALTER TABLE `server_users`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pentru tabele `server_vars`
--
ALTER TABLE `server_vars`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pentru tabele `server_vehicles`
--
ALTER TABLE `server_vehicles`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pentru tabele `server_warn_logs`
--
ALTER TABLE `server_warn_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `wcode_complaints`
--
ALTER TABLE `wcode_complaints`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `wcode_functions`
--
ALTER TABLE `wcode_functions`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pentru tabele `wcode_notifications`
--
ALTER TABLE `wcode_notifications`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT pentru tabele `wcode_tickets`
--
ALTER TABLE `wcode_tickets`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `wcode_unban`
--
ALTER TABLE `wcode_unban`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
