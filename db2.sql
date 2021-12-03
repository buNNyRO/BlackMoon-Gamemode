-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Gazdă: 127.0.0.1
-- Timp de generare: nov. 21, 2021 la 01:29 PM
-- Versiune server: 10.4.17-MariaDB
-- Versiune PHP: 8.0.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Bază de date: `from0`
--

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `2fa_connect`
--

CREATE TABLE `2fa_connect` (
  `ID` int(11) NOT NULL,
  `Account` int(11) DEFAULT NULL,
  `Token` text DEFAULT NULL,
  `Email` varchar(64) DEFAULT NULL,
  `Date` varchar(111) NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `2fa_connect`
--

INSERT INTO `2fa_connect` (`ID`, `Account`, `Token`, `Email`, `Date`) VALUES
(17, 3, '7195177ad90dc37ea45b9431ca55364e', '@gamsda.scs', '1622317056'),
(18, 3, 'c02a822db3a596894cbbfc64b17c3395', '@gamsda.scs', '1622317352'),
(19, 3, 'd05352c0598a53af49bdc5ad98008e9a', '@gamsda.scs', '1622317365'),
(20, 3, '87cd997e13e036e92e6dcb4fb195045e', '@gamsda.scs', '1622317375'),
(21, 3, '1f3eb73c3babd20f9028ba8c60ee0be3', '@gamsda.scs', '1622317395'),
(22, 3, '3056465e39e0b4fc5e7d5ad6fbfd60e7', '@gamsda.scs', '1622317401'),
(23, 3, '725e3ddea7e61362e56ed41276b500fb', '@gamsda.scs', '1622317459'),
(24, 3, '02216bfe5145771362ee2f573fdb2279', '@gamsda.scs', '1622317477');

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `panelactions2`
--

CREATE TABLE `panelactions2` (
  `id` int(11) NOT NULL,
  `actionid` int(11) NOT NULL,
  `actiontime` int(11) NOT NULL DEFAULT 0,
  `complaintid` int(11) NOT NULL DEFAULT 0,
  `playerid` int(11) NOT NULL,
  `giverid` int(11) NOT NULL,
  `playername` varchar(64) NOT NULL,
  `givername` varchar(64) NOT NULL,
  `reason` varchar(128) NOT NULL,
  `dm` int(3) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `panel_notifications`
--

CREATE TABLE `panel_notifications` (
  `ID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `Text` text NOT NULL,
  `From` varchar(11) NOT NULL DEFAULT 'AdmBot',
  `Seen` int(11) NOT NULL DEFAULT 0,
  `Link` text NOT NULL,
  `Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `Type` int(11) NOT NULL,
  `Read` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `panel_notifications`
--

INSERT INTO `panel_notifications` (`ID`, `UserID`, `Text`, `From`, `Seen`, `Link`, `Date`, `Type`, `Read`) VALUES
(10, 4, 'sintbos', 'Vicentzo', 0, '', '2021-05-08 08:23:51', 0, 0);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_bans`
--

CREATE TABLE `server_bans` (
  `ID` int(11) NOT NULL,
  `PlayerName` varchar(24) NOT NULL DEFAULT 'None',
  `PlayerID` int(11) NOT NULL DEFAULT 0,
  `AdminName` varchar(24) NOT NULL DEFAULT 'AdminName',
  `AdminID` int(11) NOT NULL DEFAULT 0,
  `Reason` varchar(64) NOT NULL DEFAULT 'None',
  `Days` int(11) NOT NULL DEFAULT 0,
  `Active` int(11) NOT NULL DEFAULT 1,
  `Date` varchar(32) NOT NULL DEFAULT 'None',
  `Permanent` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `server_bans`
--

INSERT INTO `server_bans` (`ID`, `PlayerName`, `PlayerID`, `AdminName`, `AdminID`, `Reason`, `Days`, `Active`, `Date`, `Permanent`) VALUES
(1, 'RoLEX', 7, 'Aditsu', 32, 'Abuz dã functie', 0, 0, '20:04 - 12/05/2021', 1),
(2, 'RoLEX', 7, 'Aditsu', 32, 'cheats', 0, 0, '20:05 - 12/05/2021', 1);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_bans_ip`
--

CREATE TABLE `server_bans_ip` (
  `ID` int(11) NOT NULL,
  `PlayerName` varchar(24) NOT NULL DEFAULT 'none',
  `PlayerID` int(11) NOT NULL DEFAULT 0,
  `PlayerIP` varchar(16) NOT NULL DEFAULT 'none',
  `AdminName` varchar(24) NOT NULL DEFAULT 'none',
  `AdminID` int(11) NOT NULL DEFAULT 0,
  `Reason` varchar(64) NOT NULL DEFAULT 'none',
  `Date` varchar(32) NOT NULL DEFAULT 'none',
  `Active` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_business`
--

CREATE TABLE `server_business` (
  `ID` int(11) NOT NULL,
  `Title` varchar(32) NOT NULL DEFAULT 'none',
  `Description` varchar(64) NOT NULL DEFAULT 'none',
  `Fee` int(11) NOT NULL DEFAULT 500,
  `Static` int(11) NOT NULL,
  `Type` int(11) NOT NULL,
  `X` float NOT NULL DEFAULT 0,
  `Y` float NOT NULL DEFAULT 0,
  `Z` float NOT NULL DEFAULT 0,
  `ExtX` float NOT NULL DEFAULT 0,
  `ExtY` float NOT NULL DEFAULT 0,
  `ExtZ` float NOT NULL DEFAULT 0,
  `Interior` int(11) NOT NULL,
  `VW` int(11) NOT NULL,
  `Owner` varchar(32) NOT NULL DEFAULT 'Admbot',
  `Owned` int(11) NOT NULL DEFAULT 1,
  `Price` int(11) NOT NULL,
  `OwnerID` int(11) NOT NULL DEFAULT -1,
  `Locked` int(11) NOT NULL DEFAULT 0,
  `Balance` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_business`
--

INSERT INTO `server_business` (`ID`, `Title`, `Description`, `Fee`, `Static`, `Type`, `X`, `Y`, `Z`, `ExtX`, `ExtY`, `ExtZ`, `Interior`, `VW`, `Owner`, `Owned`, `Price`, `OwnerID`, `Locked`, `Balance`) VALUES
(1, 'A new business bank', 'A new business', 500, 0, 1, 2315.95, -1.61, 26.74, -176.6, 1111.9, 19.74, 0, 0, 'Admbot', 1, 100000000, -1, 0, 136479),
(2, 'A new business shop', 'A new business', 500, 0, 2, -25.88, -185.86, 1003.54, -179.63, 1133.08, 19.74, 17, 0, 'Admbot', 1, 100000000, -1, 0, 50500),
(3, 'A new business cnn', 'A new business', 500, 1, 4, 0, 0, 0, -187.6, 1210.37, 19.7, 0, 0, 'Admbot', 1, 100000000, -1, 0, 14000),
(4, 'A new business bar', 'A new business', 500, 0, 3, 501.98, -69.15, 998.75, -206.52, 1087.06, 19.74, 11, 0, 'Admbot', 1, 100000000, -1, 0, 1500),
(5, 'A new business club', 'A new business', 500, 0, 5, 493.39, -22.72, 1000.67, -181.11, 1034.85, 19.74, 17, 0, 'Admbot', 1, 100000000, -1, 0, 1000),
(6, 'A new business sexshop', 'A new business', 500, 0, 6, -100.245, -24.3473, 1000.72, -205.59, 1062.1, 19.74, 3, 0, 'Admbot', 1, 100000000, -1, 0, 500),
(7, 'A new business barber', 'A new business', 500, 0, 8, 411.62, -21.43, 1001.8, -205.5, 1144.16, 19.74, 2, 0, 'Admbot', 1, 100000000, -1, 0, 2000),
(8, 'A new business tatoo', 'A new business', 500, 0, 9, -204.43, -26.45, 1002.27, -205.54, 1171.96, 19.74, 16, 0, 'Admbot', 1, 100000000, -1, 0, 1000),
(9, 'A new business gym', 'A new business', 500, 0, 10, 773.57, -77.09, 1000.65, -181.07, 1163.29, 19.74, 7, 0, 'Admbot', 1, 100000000, -1, 0, 500),
(10, 'A new business binco', 'A new business', 500, 0, 11, 207.73, -109.01, 1005.13, -180.05, 1177.47, 19.89, 15, 0, 'Admbot', 1, 100000000, -1, 0, 2000),
(11, 'A new business gunshop', 'A new business', 500, 0, 12, 286.8, -82.54, 1001.51, -181.11, 1186.58, 19.74, 4, 0, 'Admbot', 1, 100000000, -1, 0, 5500),
(12, 'A new business cnn', 'A new business', 500, 1, 3, 0, 0, 0, 59.12, 1214.22, 18.84, 0, 0, 'Admbot', 1, 1, -1, 0, 0);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_chat_logs`
--

CREATE TABLE `server_chat_logs` (
  `ID` int(11) NOT NULL,
  `PlayerName` varchar(24) NOT NULL DEFAULT 'None',
  `PlayerID` int(11) NOT NULL DEFAULT 0,
  `ChatText` varchar(128) NOT NULL DEFAULT 'None',
  `Time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `server_chat_logs`
--

INSERT INTO `server_chat_logs` (`ID`, `PlayerName`, `PlayerID`, `ChatText`, `Time`) VALUES
(1, 'Comorasu', 33, '* (chat log): skip.', '2021-05-08 07:30:41'),
(2, 'Vicentzo', 4, '* (chat log): .', '2021-05-08 08:17:20'),
(3, 'Vicentzo', 4, '* (chat log): ..', '2021-05-08 08:23:45'),
(4, 'mr.bunny', 2, '* (chat log): adfsad.', '2021-05-08 10:44:19'),
(5, 'mr.bunny', 2, '* (chat log): adfsads.', '2021-05-08 10:44:21'),
(6, 'mr.bunny', 2, '* (chat log): adfsadsss.', '2021-05-08 10:44:23'),
(7, 'mr.bunny', 2, '* (chat log): te-a dat al 0 0 0?.', '2021-05-08 10:45:20'),
(8, 'RaresGabriel99', 18, '* (chat log): da.', '2021-05-08 10:45:23'),
(9, 'mr.bunny', 2, '* (chat log): hmm...', '2021-05-08 10:45:27'),
(10, 'mr.bunny', 2, '* (chat log): stii care iti e ip u?.', '2021-05-08 10:45:48'),
(11, 'RaresGabriel99', 18, '* (chat log): hmm.', '2021-05-08 10:45:54'),
(12, 'RaresGabriel99', 18, '* (chat log): stai ca caut.', '2021-05-08 10:45:57'),
(13, 'RaresGabriel99', 18, '* (chat log): 82.77.126.69.', '2021-05-08 10:46:12'),
(14, 'mr.bunny', 2, '* (chat log): da l pe disc.', '2021-05-08 10:46:17'),
(15, 'mr.bunny', 2, '* (chat log): hmm.', '2021-05-08 10:53:03'),
(16, 'RaresGabriel99', 18, '* (chat log): hmm.', '2021-05-08 10:53:05'),
(17, 'mr.bunny', 2, '* (chat log): anti vpn merge.', '2021-05-08 10:53:20'),
(18, 'mr.bunny', 2, '* (chat log): cred.', '2021-05-08 10:53:23'),
(19, 'mr.bunny', 2, '* (chat log): tre sa rezolv si bugu asta cu 0 0 0 .', '2021-05-08 10:53:31'),
(20, 'mr.bunny', 2, '* (chat log): ....', '2021-05-08 10:53:31'),
(21, 'mr.bunny', 2, '* (chat log): stii care e cehstia.', '2021-05-08 11:26:02'),
(22, 'Vicentzo', 4, '* (chat log): ce.', '2021-05-08 11:26:04'),
(23, 'mr.bunny', 2, '* (chat log): daca intri primu pe sv.', '2021-05-08 11:26:10'),
(24, 'mr.bunny', 2, '* (chat log): chiar dp restart.', '2021-05-08 11:26:13'),
(25, 'mr.bunny', 2, '* (chat log): te da bn.', '2021-05-08 11:26:14'),
(26, 'Vicentzo', 4, '* (chat log): asa.', '2021-05-08 11:26:15'),
(27, 'mr.bunny', 2, '* (chat log): dar dp te da aiurea.', '2021-05-08 11:26:17'),
(28, 'Vicentzo', 4, '* (chat log): wtf.', '2021-05-08 11:26:19'),
(29, 'mr.bunny', 2, '* (chat log): dau rr sa vezi?.', '2021-05-08 11:26:21'),
(30, 'Vicentzo', 4, '* (chat log): se fute ceva.', '2021-05-08 11:26:22'),
(31, 'Vicentzo', 4, '* (chat log): nu .', '2021-05-08 11:26:24'),
(32, 'Vicentzo', 4, '* (chat log): ca n-are rost.', '2021-05-08 11:26:26'),
(33, 'mr.bunny', 2, '* (chat log): intra cu vpn.', '2021-05-08 11:26:28'),
(34, 'Vicentzo', 4, '* (chat log): uite.', '2021-05-08 11:26:29'),
(35, 'Vicentzo', 4, '* (chat log): fi atent.', '2021-05-08 11:26:30'),
(36, 'Vicentzo', 4, '* (chat log): baa.', '2021-05-08 11:26:33'),
(37, 'Vicentzo', 4, '* (chat log): mi-am dat seama.', '2021-05-08 11:26:34'),
(38, 'Vicentzo', 4, '* (chat log): la login se fute.', '2021-05-08 11:26:37'),
(39, 'mr.bunny', 2, '* (chat log): nj.', '2021-05-08 11:26:40'),
(40, 'Vicentzo', 4, '* (chat log): nu ne da skin.', '2021-05-08 11:26:41'),
(41, 'Vicentzo', 4, '* (chat log): ne pune culoarea an pulea.', '2021-05-08 11:26:46'),
(42, 'mr.bunny', 2, '* (chat log): si culoarea.', '2021-05-08 11:26:47'),
(43, 'Vicentzo', 4, '* (chat log): dar .', '2021-05-08 11:26:47'),
(44, 'Vicentzo', 4, '* (chat log): ideea e ca.', '2021-05-08 11:26:49'),
(45, 'Vicentzo', 4, '* (chat log): culoarea si skin.', '2021-05-08 11:26:54'),
(46, 'Vicentzo', 4, '* (chat log): se apeleaza.', '2021-05-08 11:26:55'),
(47, 'Vicentzo', 4, '* (chat log): la onplayerspawn.', '2021-05-08 11:26:57'),
(48, 'mr.bunny', 2, '* (chat log): si pozitia?.', '2021-05-08 11:26:57'),
(49, 'Vicentzo', 4, '* (chat log): onplayerspawn.', '2021-05-08 11:27:01'),
(50, 'Vicentzo', 4, '* (chat log): nu se apeleaza.', '2021-05-08 11:27:03'),
(51, 'Vicentzo', 4, '* (chat log): si pozitia.', '2021-05-08 11:27:04'),
(52, 'Vicentzo', 4, '* (chat log): si skin.', '2021-05-08 11:27:06'),
(53, 'mr.bunny', 2, '* (chat log): o sa testez.', '2021-05-08 11:27:06'),
(54, 'Vicentzo', 4, '* (chat log): si culoare.', '2021-05-08 11:27:07'),
(55, 'Vicentzo', 4, '* (chat log): tot acolo.', '2021-05-08 11:27:08'),
(56, 'mr.bunny', 2, '* (chat log): tu vezi cu vpn.', '2021-05-08 11:27:09'),
(57, 'Vicentzo', 4, '* (chat log): stai asa.', '2021-05-08 11:27:12'),
(58, 'mr.bunny', 2, '* (chat log): sa dai ss.', '2021-05-08 11:27:12'),
(59, 'mr.bunny', 2, '* (chat log): pe disc.', '2021-05-08 11:27:13'),
(60, 'Vicentzo', 4, '* (chat log): hai sa-ti arat ceva.', '2021-05-08 11:27:14'),
(61, 'mr.bunny', 2, '* (chat log): mna.', '2021-05-08 11:48:57'),
(62, 'mr.bunny', 2, '* (chat log): muist.', '2021-05-08 11:48:58'),
(63, 'Vicentzo', 4, '* (chat log): TRAG PULA-N MOBILU LOR.', '2021-05-08 11:49:01'),
(64, 'Vicentzo', 4, '* (chat log): SI RAKNETU LOR.', '2021-05-08 11:49:03'),
(65, 'Vicentzo', 4, '* (chat log): SA IMI PUN COAIELE-N EI.', '2021-05-08 11:49:06'),
(66, 'mr.bunny', 2, '* (chat log): =)))).', '2021-05-08 11:49:07'),
(67, 'Vicentzo', 4, '* (chat log): BA.', '2021-05-08 11:49:07'),
(68, 'Vicentzo', 4, '* (chat log): vino acia.', '2021-05-08 11:49:10'),
(69, 'Vicentzo', 4, '* (chat log): intra.', '2021-05-08 11:49:13'),
(70, 'Vicentzo', 4, '* (chat log): sa vezi.', '2021-05-08 11:49:17'),
(71, 'Vicentzo', 4, '* (chat log): ma ce.', '2021-05-08 11:49:22'),
(72, 'Vicentzo', 4, '* (chat log): sunt 2 biz-uri.', '2021-05-08 11:49:26'),
(73, 'mr.bunny', 2, '* (chat log): ?.', '2021-05-08 11:49:26'),
(74, 'Vicentzo', 4, '* (chat log): ce pula mea.', '2021-05-08 11:49:27'),
(75, 'Vicentzo', 4, '* (chat log): aa.', '2021-05-08 11:49:33'),
(76, 'Vicentzo', 4, '* (chat log): sunt multe.', '2021-05-08 11:49:34'),
(77, 'mr.bunny', 2, '* (chat log): ce plm.', '2021-05-08 11:49:34'),
(78, 'Vicentzo', 4, '* (chat log): dar iconitele.', '2021-05-08 11:49:36'),
(79, 'mr.bunny', 2, '* (chat log): =))).', '2021-05-08 11:49:39'),
(80, 'Vicentzo', 4, '* (chat log): ca e versiunea ta.', '2021-05-08 11:49:43'),
(81, 'Vicentzo', 4, '* (chat log): si nu ai pus ce am pus eu.', '2021-05-08 11:49:47'),
(82, 'Vicentzo', 4, '* (chat log): sa dai download.', '2021-05-08 11:49:50'),
(83, 'mr.bunny', 2, '* (chat log): nu am descarcat.', '2021-05-08 11:49:51'),
(84, 'Vicentzo', 4, '* (chat log): ca am modificat.', '2021-05-08 11:49:52'),
(85, 'mr.bunny', 2, '* (chat log): vers ta.', '2021-05-08 11:49:55'),
(86, 'Vicentzo', 4, '* (chat log): ca erau uite.', '2021-05-08 11:49:58'),
(87, 'Vicentzo', 4, '* (chat log): club.', '2021-05-08 11:49:58'),
(88, 'Vicentzo', 4, '* (chat log): tatoo.', '2021-05-08 11:50:00'),
(89, 'Vicentzo', 4, '* (chat log): d-astea.', '2021-05-08 11:50:02'),
(90, 'mr.bunny', 2, '* (chat log): tato?.', '2021-05-08 11:50:04'),
(91, 'Vicentzo', 4, '* (chat log): da.', '2021-05-08 11:50:05'),
(92, 'Vicentzo', 4, '* (chat log): vino incoa.', '2021-05-08 11:50:07'),
(93, 'Vicentzo', 4, '* (chat log): ala e lcub.', '2021-05-08 11:50:09'),
(94, 'mr.bunny', 2, '* (chat log): dai msjh dic.', '2021-05-08 11:51:50'),
(95, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-08 12:50:38'),
(96, 'Vicentzo', 4, '* (chat log): asjbdjasbdasbdas.', '2021-05-08 12:50:41'),
(97, 'Vicentzo', 4, '* (chat log): NASJDNAJSNKJ31N2KJNADS.', '2021-05-08 12:50:44'),
(98, 'Vicentzo', 4, '* (chat log): ASDJ AWDA.', '2021-05-08 12:50:45'),
(99, 'Vicentzo', 4, '* (chat log): JABSDJN1K23KABSDJABS.', '2021-05-08 12:50:49'),
(100, 'Vicentzo', 4, '* (chat log): ASDJNASJDNASJNJN213321321.', '2021-05-08 12:51:02'),
(101, 'Vicentzo', 4, '* (chat log): ASDAJSNKJN1K2JN3KJ1N23K.', '2021-05-08 12:51:07'),
(102, 'Vicentzo', 4, '* (chat log): -729.276000,503.086944,1371.971801.', '2021-05-08 13:02:27'),
(103, 'Vicentzo', 4, '* (chat log): .', '2021-05-08 13:32:18'),
(104, 'Vicentzo', 4, '* (chat log): w.', '2021-05-08 14:47:46'),
(105, 'Vicentzo', 4, '* (chat log): createhouse medium 0 .', '2021-05-08 14:55:07'),
(106, 'SebyP4', 23, '* (chat log): a.', '2021-05-08 15:04:29'),
(107, 'SebyP4', 23, '* (chat log): sd /fly.', '2021-05-08 15:07:36'),
(108, 'Vicentzo', 4, '* (chat log): nu exista comanda?.', '2021-05-08 15:17:34'),
(109, 'SebyP4', 23, '* (chat log): si nu mai pot sa ies.', '2021-05-08 15:17:37'),
(110, 'Vicentzo', 4, '* (chat log): stai asa.', '2021-05-08 15:17:41'),
(111, 'Vicentzo', 4, '* (chat log): uite de aicit.', '2021-05-08 15:17:53'),
(112, 'Vicentzo', 4, '* (chat log): tre sa dai f.', '2021-05-08 15:17:55'),
(113, 'Vicentzo', 4, '* (chat log): dar o sa repar.', '2021-05-08 15:17:57'),
(114, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-08 15:24:17'),
(115, 'RaresGabriel99', 18, '* (chat log): 86 on.', '2021-05-08 15:32:59'),
(116, 'Vicentzo', 4, '* (chat log): 91.', '2021-05-08 15:33:09'),
(117, 'RaresGabriel99', 18, '* (chat log): 95.', '2021-05-08 15:33:27'),
(118, 'RaresGabriel99', 18, '* (chat log): 103.', '2021-05-08 15:33:51'),
(119, 'RaresGabriel99', 18, '* (chat log): intra aici.', '2021-05-08 15:42:59'),
(120, 'RaresGabriel99', 18, '* (chat log): si.', '2021-05-08 15:43:11'),
(121, 'Vicentzo', 4, '* (chat log): =)))))))))))))).', '2021-05-08 15:43:12'),
(122, 'RaresGabriel99', 18, '* (chat log): nu poti da rent.', '2021-05-08 15:43:14'),
(123, 'RaresGabriel99', 18, '* (chat log): la unele case.', '2021-05-08 15:43:18'),
(124, 'mr.bunny', 2, '* (chat log):  /spawncar 41.', '2021-05-08 15:51:38'),
(125, 'mr.bunny', 2, '* (chat log):  /spawncar 411 3 3.', '2021-05-08 15:51:41'),
(126, 'mr.bunny', 2, '* (chat log): g.', '2021-05-08 15:51:52'),
(127, 'RaresGabriel99', 18, '* (chat log): imi arata un speedometer in dreapta .', '2021-05-08 15:52:28'),
(128, 'mr.bunny', 2, '* (chat log): iti arata L galben?.', '2021-05-08 15:52:29'),
(129, 'RaresGabriel99', 18, '* (chat log): da nu merge.', '2021-05-08 15:52:30'),
(130, 'mr.bunny', 2, '* (chat log): f.', '2021-05-08 15:52:39'),
(131, 'RaresGabriel99', 18, '* (chat log): nu .', '2021-05-08 15:52:39'),
(132, 'RaresGabriel99', 18, '* (chat log): asa e si pe f.', '2021-05-08 15:52:51'),
(133, 'mr.bunny', 2, '* (chat log): ce nu merge ma?.', '2021-05-08 15:53:01'),
(134, 'RaresGabriel99', 18, '* (chat log): st ca iti dau poza pe dis.', '2021-05-08 15:53:08'),
(135, 'mr.bunny', 2, '* (chat log): k.', '2021-05-08 15:53:11'),
(136, 'RaresGabriel99', 18, '* (chat log): gata.', '2021-05-08 15:53:36'),
(137, 'RaresGabriel99', 18, '* (chat log): a gata.', '2021-05-08 15:53:53'),
(138, 'mr.bunny', 2, '* (chat log): merge?.', '2021-05-08 15:53:55'),
(139, 'RaresGabriel99', 18, '* (chat log): da.', '2021-05-08 15:53:57'),
(140, 'mr.bunny', 2, '* (chat log): ia dai engine off.', '2021-05-08 15:54:15'),
(141, 'mr.bunny', 2, '* (chat log): si mie mi le sterge.', '2021-05-08 15:54:21'),
(142, 'mr.bunny', 2, '* (chat log): ia dai start.', '2021-05-08 15:54:25'),
(143, 'mr.bunny', 2, '* (chat log): si dai cu spatele.', '2021-05-08 15:54:27'),
(144, 'mr.bunny', 2, '* (chat log): dai cu fata.', '2021-05-08 15:54:34'),
(145, 'mr.bunny', 2, '* (chat log): nu merge schimbatoru.', '2021-05-08 15:54:44'),
(146, 'mr.bunny', 2, '* (chat log): atat tot.', '2021-05-08 15:54:45'),
(147, 'mr.bunny', 2, '* (chat log): arata okey?.', '2021-05-08 15:54:52'),
(148, 'RaresGabriel99', 18, '* (chat log): da .', '2021-05-08 15:55:03'),
(149, 'mr.bunny', 2, '* (chat log): aia rosu.', '2021-05-08 15:55:07'),
(150, 'mr.bunny', 2, '* (chat log): e pt health.', '2021-05-08 15:55:11'),
(151, 'RaresGabriel99', 18, '* (chat log): e smek.', '2021-05-08 15:55:16'),
(152, 'RaresGabriel99', 18, '* (chat log): cu astea ce sunt ?.', '2021-05-08 15:55:24'),
(153, 'mr.bunny', 2, '* (chat log): nu ai voie in ls..', '2021-05-08 15:55:29'),
(154, 'RaresGabriel99', 18, '* (chat log): a.', '2021-05-08 15:55:36'),
(155, 'mr.bunny', 2, '* (chat log): =)).', '2021-05-08 15:55:41'),
(156, 'mr.bunny', 2, '* (chat log): ia vezi cat prinde max.', '2021-05-08 15:55:56'),
(157, 'mr.bunny', 2, '* (chat log): 999.', '2021-05-08 15:56:01'),
(158, 'RaresGabriel99', 18, '* (chat log): 999.', '2021-05-08 15:56:01'),
(159, 'mr.bunny', 2, '* (chat log): nu ai masina?.', '2021-05-08 15:56:30'),
(160, 'RaresGabriel99', 18, '* (chat log): nu.', '2021-05-08 15:56:32'),
(161, 'mr.bunny', 2, '* (chat log): e grii?.', '2021-05-08 15:57:41'),
(162, 'RaresGabriel99', 18, '* (chat log): da.', '2021-05-08 15:57:43'),
(163, 'mr.bunny', 2, '* (chat log): .', '2021-05-08 15:57:43'),
(164, 'mr.bunny', 2, '* (chat log): acu?.', '2021-05-08 15:57:46'),
(165, 'RaresGabriel99', 18, '* (chat log): tot asa.', '2021-05-08 15:57:49'),
(166, 'mr.bunny', 2, '* (chat log): gryy?.', '2021-05-08 15:57:54'),
(167, 'RaresGabriel99', 18, '* (chat log): dap.', '2021-05-08 15:57:57'),
(168, 'mr.bunny', 2, '* (chat log): cum plm.', '2021-05-08 15:58:00'),
(169, 'mr.bunny', 2, '* (chat log): acu.', '2021-05-08 15:58:07'),
(170, 'RaresGabriel99', 18, '* (chat log): tot asa e.', '2021-05-08 15:58:09'),
(171, 'mr.bunny', 2, '* (chat log): dai f.', '2021-05-08 15:58:15'),
(172, 'RaresGabriel99', 18, '* (chat log): acum apare.', '2021-05-08 15:58:31'),
(173, 'mr.bunny', 2, '* (chat log): mie imi arata.', '2021-05-08 15:58:32'),
(174, 'mr.bunny', 2, '* (chat log): color/....', '2021-05-08 15:58:35'),
(175, 'mr.bunny', 2, '* (chat log): lasa ma f.', '2021-05-08 15:58:39'),
(176, 'mr.bunny', 2, '* (chat log): acu e color.', '2021-05-08 15:58:52'),
(177, 'RaresGabriel99', 18, '* (chat log): nup.', '2021-05-08 15:58:56'),
(178, 'RaresGabriel99', 18, '* (chat log): la mine imi arata cu gri.', '2021-05-08 15:59:03'),
(179, 'RaresGabriel99', 18, '* (chat log): poate e de la modpack.', '2021-05-08 15:59:13'),
(180, 'RaresGabriel99', 18, '* (chat log): stai ca il schimb.', '2021-05-08 15:59:22'),
(181, 'mr.bunny', 2, '* (chat log): nare cum, pt ca ti-l arata si color cand esti al volan.', '2021-05-08 15:59:34'),
(182, 'RaresGabriel99', 18, '* (chat log): gata .', '2021-05-08 16:00:27'),
(183, 'RaresGabriel99', 18, '* (chat log): am schimbat.', '2021-05-08 16:00:29'),
(184, 'mr.bunny', 2, '* (chat log): r/ac.', '2021-05-08 16:00:32'),
(185, 'RaresGabriel99', 18, '* (chat log): nup.', '2021-05-08 16:00:49'),
(186, 'RaresGabriel99', 18, '* (chat log): tot asa.', '2021-05-08 16:00:51'),
(187, 'mr.bunny', 2, '* (chat log): cand esti la volan.', '2021-05-08 16:00:59'),
(188, 'mr.bunny', 2, '* (chat log): e color?.', '2021-05-08 16:01:01'),
(189, 'RaresGabriel99', 18, '* (chat log): da.', '2021-05-08 16:01:03'),
(190, 'mr.bunny', 2, '* (chat log): tre sa fac eu inca verificarile.', '2021-05-08 16:01:10'),
(191, 'RaresGabriel99', 18, '* (chat log): ok.', '2021-05-08 16:01:20'),
(192, 'RoLEX', 7, '* (chat log): a ajuta ma cu cv.', '2021-05-08 16:35:40'),
(193, 'RaresGabriel99', 18, '* (chat log): zi.', '2021-05-08 16:35:51'),
(194, 'RoLEX', 7, '* (chat log): off.', '2021-05-08 16:36:26'),
(195, 'RoLEX', 7, '* (chat log): ok.', '2021-05-08 16:36:27'),
(196, 'RoLEX', 7, '* (chat log): rares.', '2021-05-08 16:39:31'),
(197, 'RaresGabriel99', 18, '* (chat log): da.', '2021-05-08 16:39:32'),
(198, 'RoLEX', 7, '* (chat log): ajuta ma cu cv.', '2021-05-08 16:39:35'),
(199, 'RaresGabriel99', 18, '* (chat log): cu ?.', '2021-05-08 16:39:41'),
(200, 'RoLEX', 7, '* (chat log): intra.', '2021-05-08 16:40:08'),
(201, 'RoLEX', 7, '* (chat log): defapt st.', '2021-05-08 16:40:15'),
(202, 'RoLEX', 7, '* (chat log): iesi.', '2021-05-08 16:40:16'),
(203, 'RoLEX', 7, '* (chat log): intra.', '2021-05-08 16:40:30'),
(204, 'RaresGabriel99', 18, '* (chat log): nu am wanted.', '2021-05-08 16:40:35'),
(205, 'RoLEX', 7, '* (chat log): n ai?.', '2021-05-08 16:40:40'),
(206, 'RaresGabriel99', 18, '* (chat log): nu am.', '2021-05-08 16:40:42'),
(207, 'RaresGabriel99', 18, '* (chat log): politistii ti-au pierdut urmele.', '2021-05-08 16:40:54'),
(208, 'RoLEX', 7, '* (chat log): ... st.', '2021-05-08 16:40:54'),
(209, 'RaresGabriel99', 18, '* (chat log): cand mi-ai dat.', '2021-05-08 16:41:02'),
(210, 'RaresGabriel99', 18, '* (chat log): mai da o data.', '2021-05-08 16:42:11'),
(211, 'RaresGabriel99', 18, '* (chat log): nup.', '2021-05-08 16:42:18'),
(212, 'RaresGabriel99', 18, '* (chat log): imi da .', '2021-05-08 16:42:23'),
(213, 'RaresGabriel99', 18, '* (chat log): si dupa nu mai am.', '2021-05-08 16:42:26'),
(214, 'RoLEX', 7, '* (chat log): pai si apari in /wanteds ;)).', '2021-05-08 16:42:28'),
(215, 'RaresGabriel99', 18, '* (chat log): :).', '2021-05-08 16:42:35'),
(216, 'RoLEX', 7, '* (chat log): t/fv.', '2021-05-08 16:44:39'),
(217, 'RoLEX', 7, '* (chat log): glip.', '2021-05-08 16:44:45'),
(218, 'RoLEX', 7, '* (chat log): g.', '2021-05-08 16:45:08'),
(219, 'RaresGabriel99', 18, '* (chat log): nu esti in masina.', '2021-05-08 16:45:13'),
(220, 'RaresGabriel99', 18, '* (chat log): :).', '2021-05-08 16:45:16'),
(221, 'RoLEX', 7, '* (chat log): ce?.', '2021-05-08 16:45:21'),
(222, 'RaresGabriel99', 18, '* (chat log): te vad in aer.', '2021-05-08 16:45:21'),
(223, 'RoLEX', 7, '* (chat log): acum?.', '2021-05-08 16:45:34'),
(224, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-08 16:45:35'),
(225, 'RaresGabriel99', 18, '* (chat log): nup tot asa.', '2021-05-08 16:45:47'),
(226, 'RaresGabriel99', 18, '* (chat log): a gata.', '2021-05-08 16:45:50'),
(227, 'RoLEX', 7, '* (chat log): .', '2021-05-08 16:45:52'),
(228, 'RoLEX', 7, '* (chat log): ceva bug de la joc.', '2021-05-08 16:45:56'),
(229, 'RoLEX', 7, '* (chat log): idk.', '2021-05-08 16:45:58'),
(230, 'RoLEX', 7, '* (chat log): rpg.daulafete.ro.', '2021-05-08 16:46:20'),
(231, 'RaresGabriel99', 18, '* (chat log): :))).', '2021-05-08 16:46:29'),
(232, 'RoLEX', 7, '* (chat log): testeaza.', '2021-05-08 16:46:33'),
(233, 'RoLEX', 7, '* (chat log): antireclama.', '2021-05-08 16:46:37'),
(234, 'RoLEX', 7, '* (chat log): rpg.daulafete.ro.', '2021-05-08 16:46:39'),
(235, 'RoLEX', 7, '* (chat log): rpg.b-ban.ro.', '2021-05-08 16:46:56'),
(236, 'RoLEX', 7, '* (chat log): f.', '2021-05-08 16:47:03'),
(237, 'mr.bunny', 2, '* (chat log): coaie.', '2021-05-08 16:47:25'),
(238, 'RaresGabriel99', 18, '* (chat log): ?.', '2021-05-08 16:47:30'),
(239, 'mr.bunny', 2, '* (chat log): cand pui ip u.', '2021-05-08 16:47:30'),
(240, 'mr.bunny', 2, '* (chat log): ila rata global.', '2021-05-08 16:47:33'),
(241, 'RoLEX', 7, '* (chat log): e al nosteru.', '2021-05-08 16:47:34'),
(242, 'RoLEX', 7, '* (chat log): testez.', '2021-05-08 16:47:46'),
(243, 'RoLEX', 7, '* (chat log): sistem antireclama.', '2021-05-08 16:47:49'),
(244, 'RoLEX', 7, '* (chat log): ca nu merge.', '2021-05-08 16:47:51'),
(245, 'RoLEX', 7, '* (chat log): si daca pun ip imi face numele albastru.', '2021-05-08 16:47:58'),
(246, 'RoLEX', 7, '* (chat log): wtf.', '2021-05-08 16:48:00'),
(247, 'RoLEX', 7, '* (chat log): ca si la pd.', '2021-05-08 16:48:07'),
(248, 'mr.bunny', 2, '* (chat log): dsa.', '2021-05-08 16:48:09'),
(249, 'RoLEX', 7, '* (chat log): asa nu are culoare.', '2021-05-08 16:48:11'),
(250, 'mr.bunny', 2, '* (chat log): dasdsa.', '2021-05-08 16:48:35'),
(251, 'mr.bunny', 2, '* (chat log): joci the forest/.', '2021-05-08 16:49:24'),
(252, 'RaresGabriel99', 18, '* (chat log): nu.', '2021-05-08 16:49:27'),
(253, 'mr.bunny', 2, '* (chat log): dice?.', '2021-05-08 16:49:30'),
(254, 'RaresGabriel99', 18, '* (chat log): wee nu ai f8 ?.', '2021-05-08 16:51:16'),
(255, 'RaresGabriel99', 18, '* (chat log): de faci poza cu tel.', '2021-05-08 16:51:19'),
(256, 'RoLEX', 7, '* (chat log): .', '2021-05-08 16:51:20'),
(257, 'RaresGabriel99', 18, '* (chat log): :)).', '2021-05-08 16:51:22'),
(258, 'RoLEX', 7, '* (chat log): pai mi e lene sa dau copy paste.', '2021-05-08 16:51:27'),
(259, 'RoLEX', 7, '* (chat log): imi e mai ez asa.', '2021-05-08 16:51:37'),
(260, 'RoLEX', 7, '* (chat log): da mi si mie.', '2021-05-08 16:53:50'),
(261, 'RoLEX', 7, '* (chat log): :).', '2021-05-08 16:53:51'),
(262, 'RoLEX', 7, '* (chat log): mda.', '2021-05-08 16:54:11'),
(263, 'RoLEX', 7, '* (chat log): fly fly gly.', '2021-05-08 16:54:16'),
(264, 'RaresGabriel99', 18, '* (chat log): revin.', '2021-05-08 16:56:31'),
(265, 'RoLEX', 7, '* (chat log): eu ies ne auzim.', '2021-05-08 16:57:31'),
(266, 'silviu1STARK', 37, '* (chat log): da.', '2021-05-08 22:09:16'),
(267, 'RaresGabriel99', 18, '* (chat log): sall.', '2021-05-08 22:09:21'),
(268, 'silviu1STARK', 37, '* (chat log): sall.', '2021-05-08 22:09:23'),
(269, 'RaresGabriel99', 18, '* (chat log): tu esti AnDreeW?.', '2021-05-08 22:09:34'),
(270, 'silviu1STARK', 37, '* (chat log): nu.', '2021-05-08 22:09:37'),
(271, 'RaresGabriel99', 18, '* (chat log): a ok.', '2021-05-08 22:09:39'),
(272, 'silviu1STARK', 37, '* (chat log): cautati adm helperi sau lideri.', '2021-05-08 22:10:05'),
(273, 'RaresGabriel99', 18, '* (chat log): deocamdata nu.', '2021-05-08 22:10:12'),
(274, 'silviu1STARK', 37, '* (chat log): ok.', '2021-05-08 22:10:16'),
(275, 'RaresGabriel99', 18, '* (chat log): e server in beta.', '2021-05-08 22:10:18'),
(276, 'RaresGabriel99', 18, '* (chat log): se lucreaza.', '2021-05-08 22:10:22'),
(277, 'RaresGabriel99', 18, '* (chat log): la el.', '2021-05-08 22:10:23'),
(278, 'silviu1STARK', 37, '* (chat log): poti sa imi dai licente.', '2021-05-08 22:10:29'),
(279, 'silviu1STARK', 37, '* (chat log): pai stiu la sv beta sa da adm pana se face official.', '2021-05-08 22:11:03'),
(280, 'RaresGabriel99', 18, '* (chat log): pai au acces doar beta testerii.', '2021-05-08 22:11:17'),
(281, 'RaresGabriel99', 18, '* (chat log): dar .', '2021-05-08 22:11:25'),
(282, 'RaresGabriel99', 18, '* (chat log): a uitat sa puna parola.', '2021-05-08 22:11:28'),
(283, 'RaresGabriel99', 18, '* (chat log): la server.', '2021-05-08 22:11:30'),
(284, 'RaresGabriel99', 18, '* (chat log): poti aplica pe discord.', '2021-05-08 22:12:18'),
(285, 'RaresGabriel99', 18, '* (chat log): daca vrei.', '2021-05-08 22:12:21'),
(286, 'silviu1STARK', 37, '* (chat log): cati ani ai?.', '2021-05-08 22:12:24'),
(287, 'RaresGabriel99', 18, '* (chat log): 13.', '2021-05-08 22:12:27'),
(288, 'silviu1STARK', 37, '* (chat log): crd ca tot staful sunt numai copii.', '2021-05-08 22:12:47'),
(289, 'RaresGabriel99', 18, '* (chat log): eu sunt doar beta tester.', '2021-05-08 22:12:58'),
(290, 'RaresGabriel99', 18, '* (chat log): la deschidere nu o sa fiu admin.', '2021-05-08 22:13:03'),
(291, 'RaresGabriel99', 18, '* (chat log): eu doar testez.', '2021-05-08 22:13:06'),
(292, 'RaresGabriel99', 18, '* (chat log): si nu sunt copii in staff.', '2021-05-08 22:13:18'),
(293, 'silviu1STARK', 37, '* (chat log): ok e bn .', '2021-05-08 22:13:27'),
(294, 'silviu1STARK', 37, '* (chat log): ca nu suport pici de 11 ani dand ordine la unu de 18.', '2021-05-08 22:13:44'),
(295, 'RaresGabriel99', 18, '* (chat log): te mai pot ajuta cu cv ?.', '2021-05-08 22:14:37'),
(296, 'silviu1STARK', 37, '* (chat log): ./etskin 0 105.', '2021-05-08 22:14:50'),
(297, 'silviu1STARK', 37, '* (chat log): ./setskin.', '2021-05-08 22:14:58'),
(298, 'RaresGabriel99', 18, '* (chat log): deocamdata nu e inca comanda.', '2021-05-08 22:15:05'),
(299, 'RaresGabriel99', 18, '* (chat log): e gm de la 0.', '2021-05-08 22:15:07'),
(300, 'RaresGabriel99', 18, '* (chat log): se lucreaz.', '2021-05-08 22:15:10'),
(301, 'RaresGabriel99', 18, '* (chat log): lucreaza.', '2021-05-08 22:15:13'),
(302, 'RaresGabriel99', 18, '* (chat log): la gm.', '2021-05-08 22:15:15'),
(303, 'RaresGabriel99', 18, '* (chat log): am dat set.', '2021-05-08 22:15:36'),
(304, 'SebyP4', 23, '* (chat log): s.', '2021-05-09 09:32:21'),
(305, 'SebyP4', 23, '* (chat log): nu ar trb sa aiba sirene?.', '2021-05-09 09:33:26'),
(306, 'SebyP4', 23, '* (chat log): ??.', '2021-05-09 09:33:44'),
(307, 'RoLEX', 7, '* (chat log): trb adaugate obiecte cred, stiu ca pe alte sv nu sunt.', '2021-05-09 09:33:45'),
(308, 'RoLEX', 7, '* (chat log): pe astea.', '2021-05-09 09:33:49'),
(309, 'SebyP4', 23, '* (chat log): a.', '2021-05-09 09:33:51'),
(310, 'RoLEX', 7, '* (chat log): decat pe infernus.', '2021-05-09 09:33:54'),
(311, 'RoLEX', 7, '* (chat log): da.', '2021-05-09 09:34:37'),
(312, 'RoLEX', 7, '* (chat log): nu ti place?.', '2021-05-09 09:34:39'),
(313, 'SebyP4', 23, '* (chat log): bda.', '2021-05-09 09:34:42'),
(314, 'RoLEX', 7, '* (chat log): eu zic ca i mai misto decat alat.', '2021-05-09 09:34:52'),
(315, 'RoLEX', 7, '* (chat log): vechi.', '2021-05-09 09:34:54'),
(316, 'SebyP4', 23, '* (chat log): sare direct in viteza a 3 a.', '2021-05-09 09:35:32'),
(317, 'SebyP4', 23, '* (chat log): lasa ca i bun =)).', '2021-05-09 09:35:40'),
(318, 'SebyP4', 23, '* (chat log): a.', '2021-05-09 09:36:19'),
(319, 'SebyP4', 23, '* (chat log): urca la volan.', '2021-05-09 09:36:31'),
(320, 'RoLEX', 7, '* (chat log): .', '2021-05-09 09:36:33'),
(321, 'SebyP4', 23, '* (chat log): sa vad.', '2021-05-09 09:36:33'),
(322, 'SebyP4', 23, '* (chat log): upos.', '2021-05-09 09:36:44'),
(323, 'SebyP4', 23, '* (chat log): am uitat ca e g pe samp.', '2021-05-09 09:36:53'),
(324, 'SebyP4', 23, '* (chat log): =)).', '2021-05-09 09:36:58'),
(325, 'SebyP4', 23, '* (chat log): ok.', '2021-05-09 09:38:17'),
(326, 'Vicentzo', 4, '* (chat log): d.', '2021-05-09 09:43:01'),
(327, 'RoLEX', 7, '* (chat log): .', '2021-05-09 09:43:57'),
(328, 'Vicentzo', 4, '* (chat log): ..', '2021-05-09 09:48:04'),
(329, 'RoLEX', 7, '* (chat log): da mi su.', '2021-05-09 09:50:23'),
(330, 'RoLEX', 7, '* (chat log): si wanted.', '2021-05-09 09:50:24'),
(331, 'SebyP4', 23, '* (chat log): nu.', '2021-05-09 09:52:26'),
(332, 'SebyP4', 23, '* (chat log): nu am avut.', '2021-05-09 09:52:28'),
(333, 'mr.bunny', 2, '* (chat log): T.', '2021-05-09 09:54:40'),
(334, 'RoLEX', 7, '* (chat log): tot la fel.', '2021-05-09 09:55:51'),
(335, 'RoLEX', 7, '* (chat log): cu spam.', '2021-05-09 09:55:53'),
(336, 'SebyP4', 23, '* (chat log): CE SCARTOAFA.', '2021-05-09 09:56:20'),
(337, 'Vicentzo', 4, '* (chat log): stiu de ce.', '2021-05-09 09:56:28'),
(338, 'RoLEX', 7, '* (chat log): ma spaneaza.', '2021-05-09 09:56:29'),
(339, 'Vicentzo', 4, '* (chat log): n-apare jailu.', '2021-05-09 09:56:31'),
(340, 'RoLEX', 7, '* (chat log): Deoarece aora a ajuns.', '2021-05-09 09:56:33'),
(341, 'RoLEX', 7, '* (chat log): la 12.', '2021-05-09 09:56:35'),
(342, 'Vicentzo', 4, '* (chat log): stiu.', '2021-05-09 09:56:35'),
(343, 'RoLEX', 7, '* (chat log): pun la bugs.', '2021-05-09 09:56:39'),
(344, 'Vicentzo', 4, '* (chat log): nu-s obiectele aici.', '2021-05-09 09:56:41'),
(345, 'Vicentzo', 4, '* (chat log): da priveste partea buna.', '2021-05-09 09:56:52'),
(346, 'Vicentzo', 4, '* (chat log): sint bos.', '2021-05-09 09:56:55'),
(347, 'SebyP4', 23, '* (chat log): .', '2021-05-09 09:58:37'),
(348, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-09 09:58:47'),
(349, 'RoLEX', 7, '* (chat log): e ip de la sv.', '2021-05-09 09:58:54'),
(350, 'RoLEX', 7, '* (chat log): poti.', '2021-05-09 09:58:56'),
(351, 'RoLEX', 7, '* (chat log): si tot iti pune nickname blue.', '2021-05-09 09:59:02'),
(352, 'SebyP4', 23, '* (chat log): scz.', '2021-05-09 09:59:31'),
(353, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-09 10:00:04'),
(354, 'Vicentzo', 4, '* (chat log): ajsndjasnda.', '2021-05-09 10:00:07'),
(355, 'Vicentzo', 4, '* (chat log): intrea iar.', '2021-05-09 10:02:53'),
(356, 'Vicentzo', 4, '* (chat log): ahahahaha.', '2021-05-09 10:03:01'),
(357, 'Vicentzo', 4, '* (chat log): ai platit 5k.', '2021-05-09 10:03:03'),
(358, 'Vicentzo', 4, '* (chat log): ez.', '2021-05-09 10:03:04'),
(359, 'Vicentzo', 4, '* (chat log): iesi.', '2021-05-09 10:03:12'),
(360, 'RoLEX', 7, '* (chat log): ia st.', '2021-05-09 10:03:16'),
(361, 'Vicentzo', 4, '* (chat log): POC.', '2021-05-09 10:03:19'),
(362, 'Vicentzo', 4, '* (chat log): INCA 15K.', '2021-05-09 10:03:20'),
(363, 'RoLEX', 7, '* (chat log): ia fi atenta.', '2021-05-09 10:03:26'),
(364, 'RoLEX', 7, '* (chat log): cand dau service taxi.', '2021-05-09 10:03:32'),
(365, 'RoLEX', 7, '* (chat log): zice ca am deja un apel la taxi dar eu am intrat la tn in masina.', '2021-05-09 10:03:42'),
(366, 'RoLEX', 7, '* (chat log): ar trb sa se stearga.', '2021-05-09 10:03:47'),
(367, 'Vicentzo', 4, '* (chat log): pai daca intri in masina.', '2021-05-09 10:03:49'),
(368, 'Vicentzo', 4, '* (chat log): nu are rost.', '2021-05-09 10:03:52'),
(369, 'Vicentzo', 4, '* (chat log): ca eu trebuia.', '2021-05-09 10:03:53'),
(370, 'Vicentzo', 4, '* (chat log): sa dau /accept taxi.', '2021-05-09 10:03:55'),
(371, 'RoLEX', 7, '* (chat log): a k.', '2021-05-09 10:03:59'),
(372, 'Vicentzo', 4, '* (chat log): SINT BOS.', '2021-05-09 10:04:45'),
(373, 'RoLEX', 7, '* (chat log): ia st.', '2021-05-09 10:04:53'),
(374, 'RoLEX', 7, '* (chat log): sa testez cv.', '2021-05-09 10:04:56'),
(375, 'RoLEX', 7, '* (chat log): ;a taxi.', '2021-05-09 10:04:57'),
(376, 'Vicentzo', 4, '* (chat log): da-mi mute rolexe.', '2021-05-09 10:05:05'),
(377, 'RoLEX', 7, '* (chat log): zi cv.', '2021-05-09 10:05:19'),
(378, 'RoLEX', 7, '* (chat log): am primit notificare.', '2021-05-09 10:05:32'),
(379, 'RoLEX', 7, '* (chat log): ma baga aici la puscarie mereu la /respawn.', '2021-05-09 10:07:36'),
(380, 'Vicentzo', 4, '* (chat log): w.', '2021-05-09 10:10:39'),
(381, 'mr.bunny', 2, '* (chat log): sdasdsa.', '2021-05-09 10:12:39'),
(382, 'mr.bunny', 2, '* (chat log): dsada.', '2021-05-09 10:12:41'),
(383, 'mr.bunny', 2, '* (chat log): saluitare.', '2021-05-09 10:13:38'),
(384, 'Vicentzo', 4, '* (chat log): ba.', '2021-05-09 10:13:50'),
(385, 'Vicentzo', 4, '* (chat log): rilex.', '2021-05-09 10:13:51'),
(386, 'SureSpoT', 38, '* (chat log): nu se mai opreste alearga non stop .', '2021-05-09 10:14:02'),
(387, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-09 10:14:03'),
(388, 'mr.bunny', 2, '* (chat log): ce?.', '2021-05-09 10:14:10'),
(389, 'SureSpoT', 38, '* (chat log): sall.', '2021-05-09 10:14:32'),
(390, 'RoLEX', 7, '* (chat log): ce faci.', '2021-05-09 10:14:37'),
(391, 'SureSpoT', 38, '* (chat log): ba ce are.', '2021-05-09 10:14:48'),
(392, 'SureSpoT', 38, '* (chat log): bine.', '2021-05-09 10:14:54'),
(393, 'RoLEX', 7, '* (chat log): ce?.', '2021-05-09 10:14:56'),
(394, 'RoLEX', 7, '* (chat log): ce am.', '2021-05-09 10:14:58'),
(395, 'mr.bunny', 2, '* (chat log): fuge singur.', '2021-05-09 10:15:03'),
(396, 'SureSpoT', 38, '* (chat log): de ce nu se mai opreste alearga non stop 4.', '2021-05-09 10:15:04'),
(397, 'SureSpoT', 38, '* (chat log): da.', '2021-05-09 10:15:08'),
(398, 'RoLEX', 7, '* (chat log): idk.', '2021-05-09 10:15:10'),
(399, 'RoLEX', 7, '* (chat log): n am stare.', '2021-05-09 10:15:11'),
(400, 'mr.bunny', 2, '* (chat log): da mi disc u.', '2021-05-09 10:16:12'),
(401, 'mr.bunny', 2, '* (chat log): tau.', '2021-05-09 10:16:15'),
(402, 'mr.bunny', 2, '* (chat log): buNNy#1804.', '2021-05-09 10:16:24'),
(403, 'Vicentzo', 4, '* (chat log): sal.', '2021-05-09 10:22:42'),
(404, 'RaresGabriel99', 18, '* (chat log): sal.', '2021-05-09 10:22:44'),
(405, 'Vicentzo', 4, '* (chat log): aia uzit de mn ca sint bos.', '2021-05-09 10:22:50'),
(406, 'RaresGabriel99', 18, '* (chat log): dada.', '2021-05-09 10:23:00'),
(407, 'Vicentzo', 4, '* (chat log): suie.', '2021-05-09 10:23:14'),
(408, 'Vicentzo', 4, '* (chat log): suie ma.', '2021-05-09 10:23:21'),
(409, 'Vicentzo', 4, '* (chat log): SUIE IN PULA ME.', '2021-05-09 10:23:24'),
(410, 'RoLEX', 7, '* (chat log): ho ca n am vazut ca i rares aici.', '2021-05-09 10:23:37'),
(411, 'Vicentzo', 4, '* (chat log): zi-mi un id de masina tare.', '2021-05-09 10:23:51'),
(412, 'RaresGabriel99', 18, '* (chat log): 556.', '2021-05-09 10:23:55'),
(413, 'Vicentzo', 4, '* (chat log): ooo.', '2021-05-09 10:23:59'),
(414, 'Vicentzo', 4, '* (chat log): ce smek e din .', '2021-05-09 10:24:02'),
(415, 'Vicentzo', 4, '* (chat log): first person.', '2021-05-09 10:24:04'),
(416, 'Vicentzo', 4, '* (chat log): acum sint bos adev.', '2021-05-09 10:24:07'),
(417, 'Vicentzo', 4, '* (chat log): cand o vad pe dana budeanu.', '2021-05-09 10:25:35'),
(418, 'Vicentzo', 4, '* (chat log): imi vine o erectie.', '2021-05-09 10:25:37'),
(419, 'Vicentzo', 4, '* (chat log): in pantaloni.', '2021-05-09 10:25:38'),
(420, 'RaresGabriel99', 18, '* (chat log): :)))).', '2021-05-09 10:25:43'),
(421, 'RaresGabriel99', 18, '* (chat log): dai /spawncar 449 0 0.', '2021-05-09 10:26:24'),
(422, 'RoLEX', 7, '* (chat log): oo.', '2021-05-09 10:26:50'),
(423, 'Vicentzo', 4, '* (chat log): SUIE.', '2021-05-09 10:26:51'),
(424, 'RoLEX', 7, '* (chat log): :)).', '2021-05-09 10:26:51'),
(425, 'Vicentzo', 4, '* (chat log): haidaaa.', '2021-05-09 10:26:52'),
(426, 'Vicentzo', 4, '* (chat log): bravo bos.', '2021-05-09 10:26:56'),
(427, 'RaresGabriel99', 18, '* (chat log): da g.', '2021-05-09 10:26:57'),
(428, 'Vicentzo', 4, '* (chat log): in ce aprte mergem?.', '2021-05-09 10:26:58'),
(429, 'Vicentzo', 4, '* (chat log): spre sf.', '2021-05-09 10:27:01'),
(430, 'Vicentzo', 4, '* (chat log): sau udne.', '2021-05-09 10:27:02'),
(431, 'RaresGabriel99', 18, '* (chat log): nu merge ?.', '2021-05-09 10:27:09'),
(432, 'RoLEX', 7, '* (chat log): nop.', '2021-05-09 10:27:12'),
(433, 'Vicentzo', 4, '* (chat log): mai in spate.', '2021-05-09 10:27:13'),
(434, 'Vicentzo', 4, '* (chat log): incearca.', '2021-05-09 10:27:14'),
(435, 'RoLEX', 7, '* (chat log): mda.', '2021-05-09 10:27:24'),
(436, 'Vicentzo', 4, '* (chat log): merem in fata sau in spate.', '2021-05-09 10:27:24'),
(437, 'RoLEX', 7, '* (chat log): nu pot.', '2021-05-09 10:27:29'),
(438, 'Vicentzo', 4, '* (chat log): urca sus.', '2021-05-09 10:27:32'),
(439, 'RoLEX', 7, '* (chat log): imi schimba pozitia.', '2021-05-09 10:27:33'),
(440, 'RoLEX', 7, '* (chat log): la camera.', '2021-05-09 10:27:35'),
(441, 'Vicentzo', 4, '* (chat log): in fata sau an spate?.', '2021-05-09 10:27:39'),
(442, 'RoLEX', 7, '* (chat log): la fel.', '2021-05-09 10:27:42'),
(443, 'RaresGabriel99', 18, '* (chat log): an fata.', '2021-05-09 10:27:43'),
(444, 'Vicentzo', 4, '* (chat log): acum cum e camear.', '2021-05-09 10:27:52'),
(445, 'RoLEX', 7, '* (chat log): imi schhimba.', '2021-05-09 10:27:56'),
(446, 'RoLEX', 7, '* (chat log): camera.', '2021-05-09 10:27:58'),
(447, 'Vicentzo', 4, '* (chat log): urcate sus.', '2021-05-09 10:28:01'),
(448, 'RaresGabriel99', 18, '* (chat log): hai aici .', '2021-05-09 10:28:05'),
(449, 'RaresGabriel99', 18, '* (chat log): si da g.', '2021-05-09 10:28:08'),
(450, 'RoLEX', 7, '* (chat log): gata.', '2021-05-09 10:28:19'),
(451, 'Vicentzo', 4, '* (chat log): merem an fata sau an spate?.', '2021-05-09 10:28:22'),
(452, 'Vicentzo', 4, '* (chat log): ?.', '2021-05-09 10:28:32'),
(453, 'RaresGabriel99', 18, '* (chat log): an fata.', '2021-05-09 10:28:36'),
(454, 'Vicentzo', 4, '* (chat log): merem an fata sau an spate?.', '2021-05-09 10:28:37'),
(455, 'Vicentzo', 4, '* (chat log): TINETI-VA.', '2021-05-09 10:28:41'),
(456, 'RoLEX', 7, '* (chat log): ba.', '2021-05-09 10:28:44'),
(457, 'Vicentzo', 4, '* (chat log): dau cu spid.', '2021-05-09 10:28:44'),
(458, 'RoLEX', 7, '* (chat log): vic.', '2021-05-09 10:28:45'),
(459, 'Vicentzo', 4, '* (chat log): ce.', '2021-05-09 10:28:49'),
(460, 'RoLEX', 7, '* (chat log): tie iti merge /spawnchange?.', '2021-05-09 10:28:52'),
(461, 'RaresGabriel99', 18, '* (chat log): nu merge cu spid.', '2021-05-09 10:28:53'),
(462, 'Vicentzo', 4, '* (chat log): nu mere spid bust.', '2021-05-09 10:28:54'),
(463, 'RoLEX', 7, '* (chat log): ca mie nu mi se incarca harta.', '2021-05-09 10:28:57'),
(464, 'RoLEX', 7, '* (chat log): oriunde as da.', '2021-05-09 10:29:01'),
(465, 'RoLEX', 7, '* (chat log): spawnchange.', '2021-05-09 10:29:03'),
(466, 'Vicentzo', 4, '* (chat log): ce sa mearga.', '2021-05-09 10:29:03'),
(467, 'RoLEX', 7, '* (chat log): ./spawnchange.', '2021-05-09 10:29:09'),
(468, 'Vicentzo', 4, '* (chat log): nu te inteleg coaie.', '2021-05-09 10:29:10'),
(469, 'Vicentzo', 4, '* (chat log): CIU CIU.', '2021-05-09 10:29:23'),
(470, 'RoLEX', 7, '* (chat log): cand dau /spawnchange sa ma dea la house sau oriunde nu mi se incarca harta.', '2021-05-09 10:29:29'),
(471, 'RoLEX', 7, '* (chat log): adica.', '2021-05-09 10:29:30'),
(472, 'RoLEX', 7, '* (chat log): ma da intr un loc.', '2021-05-09 10:29:33'),
(473, 'RoLEX', 7, '* (chat log): unde nu vad nimic.', '2021-05-09 10:29:36'),
(474, 'RoLEX', 7, '* (chat log): nu se incarca harta.', '2021-05-09 10:29:41'),
(475, 'RoLEX', 7, '* (chat log): nici dupa 1 ora.', '2021-05-09 10:29:43'),
(476, 'Vicentzo', 4, '* (chat log): nush.', '2021-05-09 10:29:44'),
(477, 'RoLEX', 7, '* (chat log): :)).', '2021-05-09 10:29:55'),
(478, 'Vicentzo', 4, '* (chat log): chemati-l si pe bunny.', '2021-05-09 10:29:56'),
(479, 'RoLEX', 7, '* (chat log): hai k merge.', '2021-05-09 10:29:58'),
(480, 'Vicentzo', 4, '* (chat log): ok pornim atunci.', '2021-05-09 10:30:30'),
(481, 'RoLEX', 7, '* (chat log): k.', '2021-05-09 10:30:36'),
(482, 'Vicentzo', 4, '* (chat log): tineti-va bine ca aici o sa dam in stanga-n si-n dreapta.', '2021-05-09 10:30:41'),
(483, 'Vicentzo', 4, '* (chat log): o sa facem schimbare de linie.', '2021-05-09 10:30:44'),
(484, 'Vicentzo', 4, '* (chat log): pornim.', '2021-05-09 10:30:45'),
(485, 'RoLEX', 7, '* (chat log): dd.', '2021-05-09 10:30:54'),
(486, 'RoLEX', 7, '* (chat log): k.', '2021-05-09 10:30:55'),
(487, 'Vicentzo', 4, '* (chat log): lol.', '2021-05-09 10:31:00'),
(488, 'Vicentzo', 4, '* (chat log): s-au inchis barierele.', '2021-05-09 10:31:03'),
(489, 'Vicentzo', 4, '* (chat log): =)))))))).', '2021-05-09 10:31:05'),
(490, 'RaresGabriel99', 18, '* (chat log): dap.', '2021-05-09 10:31:06'),
(491, 'RoLEX', 7, '* (chat log): cu viteza nu mere?.', '2021-05-09 10:31:06'),
(492, 'RaresGabriel99', 18, '* (chat log): :))).', '2021-05-09 10:31:08'),
(493, 'RoLEX', 7, '* (chat log): lol.', '2021-05-09 10:31:13'),
(494, 'RoLEX', 7, '* (chat log): ar fi misto vicentzo sa facem un sistem de genu.', '2021-05-09 10:31:24'),
(495, 'RoLEX', 7, '* (chat log): sa te plimbi cu treni.', '2021-05-09 10:31:29'),
(496, 'RoLEX', 7, '* (chat log): trenu.', '2021-05-09 10:31:31'),
(497, 'Vicentzo', 4, '* (chat log): BAAAA.', '2021-05-09 10:31:32'),
(498, 'Vicentzo', 4, '* (chat log): O IA RAZNA.', '2021-05-09 10:31:34'),
(499, 'RoLEX', 7, '* (chat log): baaa.', '2021-05-09 10:31:36'),
(500, 'Vicentzo', 4, '* (chat log): MI SE CUTREUMRA.', '2021-05-09 10:31:36'),
(501, 'Vicentzo', 4, '* (chat log): IMAGINEA.', '2021-05-09 10:31:38'),
(502, 'RoLEX', 7, '* (chat log): =))))))))))).', '2021-05-09 10:31:39'),
(503, 'RaresGabriel99', 18, '* (chat log): :)))))))).', '2021-05-09 10:31:39'),
(504, 'Vicentzo', 4, '* (chat log): MI SE CUTREMURA.', '2021-05-09 10:31:39'),
(505, 'RoLEX', 7, '* (chat log): si miee.', '2021-05-09 10:31:41'),
(506, 'RoLEX', 7, '* (chat log): :)))))).', '2021-05-09 10:31:43'),
(507, 'RoLEX', 7, '* (chat log): morr.', '2021-05-09 10:31:48'),
(508, 'Vicentzo', 4, '* (chat log): rares.', '2021-05-09 10:31:56'),
(509, 'RaresGabriel99', 18, '* (chat log): da.', '2021-05-09 10:31:58'),
(510, 'Vicentzo', 4, '* (chat log): nu stii id de la tren d-ala mare?.', '2021-05-09 10:31:59'),
(511, 'Vicentzo', 4, '* (chat log): cu vagoane cu d-alea.', '2021-05-09 10:32:04'),
(512, 'RaresGabriel99', 18, '* (chat log): nup.', '2021-05-09 10:32:04'),
(513, 'Vicentzo', 4, '* (chat log): ca asta nu mere tare.', '2021-05-09 10:32:07'),
(514, 'Vicentzo', 4, '* (chat log): in schimb.', '2021-05-09 10:32:08'),
(515, 'Vicentzo', 4, '* (chat log): daca mergeam cu ala.', '2021-05-09 10:32:10'),
(516, 'Vicentzo', 4, '* (chat log): ez am trecut.', '2021-05-09 10:32:15'),
(517, 'RoLEX', 7, '* (chat log): :))).', '2021-05-09 10:32:16'),
(518, 'RaresGabriel99', 18, '* (chat log): :)))).', '2021-05-09 10:32:18'),
(519, 'Vicentzo', 4, '* (chat log): daca mergeam cu ala.', '2021-05-09 10:32:20'),
(520, 'Vicentzo', 4, '* (chat log): ala putea deraia.', '2021-05-09 10:32:22'),
(521, 'Vicentzo', 4, '* (chat log): de pe sine.', '2021-05-09 10:32:24'),
(522, 'RaresGabriel99', 18, '* (chat log): stai ca caut.', '2021-05-09 10:32:27'),
(523, 'RoLEX', 7, '* (chat log): vicentzo.', '2021-05-09 10:32:31'),
(524, 'Vicentzo', 4, '* (chat log): ?.', '2021-05-09 10:32:36'),
(525, 'RoLEX', 7, '* (chat log): n ar fi misto sa facem un sistem de genu sa ne plimbam cu trenu?.', '2021-05-09 10:32:42'),
(526, 'Vicentzo', 4, '* (chat log): ba da.', '2021-05-09 10:32:45'),
(527, 'RoLEX', 7, '* (chat log): sa se plimbe playerii.', '2021-05-09 10:32:47'),
(528, 'Vicentzo', 4, '* (chat log): sa ati cumperi tren.', '2021-05-09 10:32:48'),
(529, 'Vicentzo', 4, '* (chat log): sau dintr-un oras an altu.', '2021-05-09 10:32:52'),
(530, 'RoLEX', 7, '* (chat log): pun la idei?.', '2021-05-09 10:32:56'),
(531, 'RaresGabriel99', 18, '* (chat log): 	538.', '2021-05-09 10:33:01'),
(532, 'RoLEX', 7, '* (chat log): mda.', '2021-05-09 10:33:07'),
(533, 'Vicentzo', 4, '* (chat log): .', '2021-05-09 10:33:10'),
(534, 'RaresGabriel99', 18, '* (chat log): 537.', '2021-05-09 10:33:29'),
(535, 'Vicentzo', 4, '* (chat log): altu n-ai gasit.', '2021-05-09 10:33:29'),
(536, 'RaresGabriel99', 18, '* (chat log): vezi asta.', '2021-05-09 10:33:32'),
(537, 'RoLEX', 7, '* (chat log): baa.', '2021-05-09 10:33:41'),
(538, 'RoLEX', 7, '* (chat log): mda.', '2021-05-09 10:33:47'),
(539, 'RoLEX', 7, '* (chat log): stop.', '2021-05-09 10:34:02'),
(540, 'RoLEX', 7, '* (chat log): ba in pnm.', '2021-05-09 10:34:16'),
(541, 'Vicentzo', 4, '* (chat log): lasale.', '2021-05-09 10:34:17'),
(542, 'Vicentzo', 4, '* (chat log): ca vrea sa teteze.', '2021-05-09 10:34:19'),
(543, 'Vicentzo', 4, '* (chat log): citurile.', '2021-05-09 10:34:20'),
(544, 'RoLEX', 7, '* (chat log): aa.', '2021-05-09 10:34:20'),
(545, 'RoLEX', 7, '* (chat log): anticheat.', '2021-05-09 10:34:21'),
(546, 'mr.bunny', 2, '* (chat log): vic intra voice.', '2021-05-09 10:34:34'),
(547, 'Vicentzo', 4, '* (chat log): unde.', '2021-05-09 10:34:38'),
(548, 'RoLEX', 7, '* (chat log): gg.', '2021-05-09 10:34:48'),
(549, 'RoLEX', 7, '* (chat log): nu se spawneaza.', '2021-05-09 10:34:55'),
(550, 'Vicentzo', 4, '* (chat log): altu n-ati gasit.', '2021-05-09 10:35:08'),
(551, 'RaresGabriel99', 18, '* (chat log): cu tiru asta s-ar putea face un job.', '2021-05-09 10:36:59'),
(552, 'Vicentzo', 4, '* (chat log): da, s-ar putea.', '2021-05-09 10:37:16'),
(553, 'Vicentzo', 4, '* (chat log): face si cu asta.', '2021-05-09 10:37:18'),
(554, 'Vicentzo', 4, '* (chat log): dar ce job.', '2021-05-09 10:37:20'),
(555, 'Vicentzo', 4, '* (chat log): la constructor.', '2021-05-09 10:37:31'),
(556, 'Vicentzo', 4, '* (chat log): sa punem fundatia sau cimentu.', '2021-05-09 10:37:35'),
(557, 'Vicentzo', 4, '* (chat log): cu asta.', '2021-05-09 10:37:36'),
(558, 'Vicentzo', 4, '* (chat log): house constructor.', '2021-05-09 10:37:44'),
(559, 'RaresGabriel99', 18, '* (chat log): da .', '2021-05-09 10:37:47'),
(560, 'RaresGabriel99', 18, '* (chat log): nu prea are frane.', '2021-05-09 10:39:39'),
(561, 'Vicentzo', 4, '* (chat log): ba.', '2021-05-09 10:39:47'),
(562, 'RaresGabriel99', 18, '* (chat log): da.', '2021-05-09 10:39:49'),
(563, 'Vicentzo', 4, '* (chat log): hai sa facem convoi de tiruri.', '2021-05-09 10:39:49'),
(564, 'Vicentzo', 4, '* (chat log): ia id-u de la un tir d-ala mare.', '2021-05-09 10:39:54'),
(565, 'Vicentzo', 4, '* (chat log): ala mai mare.', '2021-05-09 10:39:56'),
(566, 'Vicentzo', 4, '* (chat log): roda train ala.', '2021-05-09 10:39:58'),
(567, 'Vicentzo', 4, '* (chat log): si o remorca.', '2021-05-09 10:39:59'),
(568, 'RaresGabriel99', 18, '* (chat log): 515.', '2021-05-09 10:40:13'),
(569, 'Vicentzo', 4, '* (chat log): si o remorca?.', '2021-05-09 10:40:20'),
(570, 'RaresGabriel99', 18, '* (chat log): 450.', '2021-05-09 10:40:23'),
(571, 'RaresGabriel99', 18, '* (chat log): dai in fata.', '2021-05-09 10:41:04'),
(572, 'Vicentzo', 4, '* (chat log): conduc din fp colegu.', '2021-05-09 10:41:43'),
(573, 'Vicentzo', 4, '* (chat log): sint bos.', '2021-05-09 10:41:44'),
(574, 'Vicentzo', 4, '* (chat log): Ioi colegu.', '2021-05-09 10:42:43'),
(575, 'Vicentzo', 4, '* (chat log): so dus pe pula.', '2021-05-09 10:42:45'),
(576, 'Vicentzo', 4, '* (chat log): tinete.', '2021-05-09 10:45:17'),
(577, 'Vicentzo', 4, '* (chat log): dupa tn bos.', '2021-05-09 10:46:35'),
(578, 'Vicentzo', 4, '* (chat log): AUU.', '2021-05-09 10:48:40'),
(579, 'RaresGabriel99', 18, '* (chat log): :).', '2021-05-09 10:48:41'),
(580, 'RaresGabriel99', 18, '* (chat log): vrei un hotdog ?.', '2021-05-09 10:51:50'),
(581, 'Vicentzo', 4, '* (chat log): nu bos.', '2021-05-09 10:51:54'),
(582, 'Vicentzo', 4, '* (chat log): v.', '2021-05-09 10:52:45'),
(583, 'RoLEX', 7, '* (chat log): ce faci?.', '2021-05-09 17:40:49'),
(584, 'Adrian_Valentin', 41, '* (chat log): imi apa re icon de la casa pe sus.', '2021-05-09 17:41:15'),
(585, 'Adrian_Valentin', 41, '* (chat log): imi apare icon de la casa pe sus.', '2021-05-09 17:41:29'),
(586, 'RoLEX', 7, '* (chat log): perfect.', '2021-05-09 17:55:49'),
(587, 'Adrian_Valentin', 41, '* (chat log): este ok.', '2021-05-09 17:55:53'),
(588, 'RoLEX', 7, '* (chat log): ai moduri praf.', '2021-05-09 17:55:54'),
(589, 'RoLEX', 7, '* (chat log): prea \"realistice\".', '2021-05-09 17:56:04'),
(590, 'RoLEX', 7, '* (chat log): sau cv.', '2021-05-09 17:56:06'),
(591, 'RoLEX', 7, '* (chat log): nu stiu.', '2021-05-09 17:56:11'),
(592, 'Adrian_Valentin', 41, '* (chat log): etse de la lolecs de pe og .', '2021-05-09 17:56:13'),
(593, 'RoLEX', 7, '* (chat log): eu nu folosesc moduri si nici n am in plan chiar daca am un pc fff bun.', '2021-05-09 17:56:30'),
(594, 'RoLEX', 7, '* (chat log): fiindca nu vr sa am probleme.', '2021-05-09 17:56:34'),
(595, 'RoLEX', 7, '* (chat log): ca sunt probleme.', '2021-05-09 17:56:36'),
(596, 'RoLEX', 7, '* (chat log): ba nu vezi aia.', '2021-05-09 17:56:40'),
(597, 'RoLEX', 7, '* (chat log): ba nu stiu ce.', '2021-05-09 17:56:43'),
(598, 'Adrian_Valentin', 41, '* (chat log): ok.', '2021-05-09 17:56:45'),
(599, 'RoLEX', 7, '* (chat log): ba iti da crash.', '2021-05-09 17:56:46'),
(600, 'RoLEX', 7, '* (chat log): ma rog.', '2021-05-09 17:56:48'),
(601, 'RoLEX', 7, '* (chat log): e ok?.', '2021-05-09 17:56:50'),
(602, 'Adrian_Valentin', 41, '* (chat log): caut buguri acm.', '2021-05-09 17:57:05'),
(603, 'RoLEX', 7, '* (chat log): da.', '2021-05-09 17:57:08'),
(604, 'RoLEX', 7, '* (chat log): testezi la factiuni.', '2021-05-09 17:57:13'),
(605, 'RoLEX', 7, '* (chat log): alea alea.', '2021-05-09 17:57:16'),
(606, 'Adrian_Valentin', 41, '* (chat log): ok.', '2021-05-09 17:57:19'),
(607, 'RoLEX', 7, '* (chat log): te uiti si tu ca mai sunt raportate.', '2021-05-09 17:57:21'),
(608, 'RoLEX', 7, '* (chat log): unele.', '2021-05-09 17:57:23'),
(609, 'RoLEX', 7, '* (chat log): sa nu le scrii de 2 ori.', '2021-05-09 17:57:27'),
(610, 'Adrian_Valentin', 41, '* (chat log): da.', '2021-05-09 17:57:28'),
(611, 'RoLEX', 7, '* (chat log): Eu ies, bafta..', '2021-05-09 17:57:34'),
(612, 'Adrian_Valentin', 41, '* (chat log): ok.', '2021-05-09 17:57:37'),
(613, 'Adrian_Valentin', 41, '* (chat log): nu o vad.', '2021-05-09 18:30:21'),
(614, 'SebyP4', 23, '* (chat log): intra intr o masina .', '2021-05-09 18:31:19'),
(615, 'SebyP4', 23, '* (chat log): spawneaza  o masina.', '2021-05-09 18:31:53'),
(616, 'SebyP4', 23, '* (chat log): nu auzi.', '2021-05-09 18:31:55'),
(617, 'SebyP4', 23, '* (chat log): rolex.', '2021-05-09 18:33:10'),
(618, 'SebyP4', 23, '* (chat log): a.', '2021-05-09 18:33:28'),
(619, 'SebyP4', 23, '* (chat log): as.', '2021-05-09 18:33:29'),
(620, 'RoLEX', 7, '* (chat log): ce?.', '2021-05-09 18:33:40'),
(621, 'SebyP4', 23, '* (chat log): vreau sa testez cv.', '2021-05-09 18:33:51'),
(622, 'RoLEX', 7, '* (chat log): ce.', '2021-05-09 18:34:00'),
(623, 'SebyP4', 23, '* (chat log): iesi din masina.', '2021-05-09 18:34:02'),
(624, 'SebyP4', 23, '* (chat log): am gasit bug.', '2021-05-09 18:34:10'),
(625, 'RoLEX', 7, '* (chat log): ce bug.', '2021-05-09 18:34:15'),
(626, 'SebyP4', 23, '* (chat log): il postez acum.', '2021-05-09 18:34:29'),
(627, 'SebyP4', 23, '* (chat log): rolex intra intr o masina iar.', '2021-05-09 18:35:28'),
(628, 'SebyP4', 23, '* (chat log): te rog.', '2021-05-09 18:35:29'),
(629, 'SebyP4', 23, '* (chat log): iesi din ea rolex.', '2021-05-09 18:35:43'),
(630, 'RoLEX', 7, '* (chat log): care i bugu ma.', '2021-05-09 18:35:53'),
(631, 'RoLEX', 7, '* (chat log): nu inteleg.', '2021-05-09 18:35:55'),
(632, 'Adrian_Valentin', 41, '* (chat log): ce.', '2021-05-09 18:36:00'),
(633, 'RoLEX', 7, '* (chat log): vb cu sebi .', '2021-05-09 18:36:05'),
(634, 'RoLEX', 7, '* (chat log): ca cica a gasit un bug.', '2021-05-09 18:36:11'),
(635, 'SebyP4', 23, '* (chat log): am pus pe bugs.', '2021-05-09 18:36:14'),
(636, 'SebyP4', 23, '* (chat log): cand dai /goto si playerul este intr un vehicul nu te teleporteaza la el.', '2021-05-09 18:36:35'),
(637, 'SebyP4', 23, '* (chat log): dai goto.', '2021-05-09 18:37:02'),
(638, 'SebyP4', 23, '* (chat log): la mn.', '2021-05-09 18:37:04'),
(639, 'SebyP4', 23, '* (chat log): s.', '2021-05-09 18:37:14'),
(640, 'Adrian_Valentin', 41, '* (chat log): mie nu mise intampla.', '2021-05-09 18:37:15'),
(641, 'SebyP4', 23, '* (chat log): dai goto la mn.', '2021-05-09 18:37:20'),
(642, 'SebyP4', 23, '* (chat log): goto 0.', '2021-05-09 18:37:24'),
(643, 'Adrian_Valentin', 41, '* (chat log): ba da .', '2021-05-09 18:37:38'),
(644, 'Adrian_Valentin', 41, '* (chat log): poate tei buguit tu.', '2021-05-09 18:37:50'),
(645, 'Adrian_Valentin', 41, '* (chat log): sca.', '2021-05-09 18:39:57'),
(646, 'Adrian_Valentin', 41, '* (chat log): scz.', '2021-05-09 18:40:01'),
(647, 'SebyP4', 23, '* (chat log): pai nu e mapping facut de voi?.', '2021-05-09 18:40:43'),
(648, 'Vicentzo', 4, '* (chat log): 50/200.', '2021-05-09 18:40:45'),
(649, 'Vicentzo', 4, '* (chat log): pai ce mapping sa fie facut de noi.', '2021-05-09 18:40:55'),
(650, 'Vicentzo', 4, '* (chat log): acela este un sat de la samp.', '2021-05-09 18:40:58'),
(651, 'SebyP4', 23, '* (chat log): gen stalpurile.', '2021-05-09 18:41:09'),
(652, 'RoLEX', 7, '* (chat log): nop.', '2021-05-09 18:41:17'),
(653, 'SebyP4', 23, '* (chat log): ca nu tin minte sa fie pe acolo asa.', '2021-05-09 18:41:17'),
(654, 'Vicentzo', 4, '* (chat log): alea sunt de la samp.', '2021-05-09 18:41:18'),
(655, 'SebyP4', 23, '* (chat log): aaa.', '2021-05-09 18:41:25'),
(656, 'Vicentzo', 4, '* (chat log): nu stiu poate a pus bunny.', '2021-05-09 18:41:39'),
(657, 'SebyP4', 23, '* (chat log): vreau sa iti arat cv vicentzo.', '2021-05-09 18:42:09'),
(658, 'Vicentzo', 4, '* (chat log): ce.', '2021-05-09 18:42:11'),
(659, 'Adrian_Valentin', 41, '* (chat log): eu ma duc sa mai testez.', '2021-05-09 18:45:24'),
(660, 'Adrian_Valentin', 41, '* (chat log): mai vb?.', '2021-05-09 18:45:38'),
(661, 'Vicentzo', 4, '* (chat log): gata.', '2021-05-09 18:47:28'),
(662, 'SebyP4', 23, '* (chat log): am si modpack high ultra.', '2021-05-09 18:47:30'),
(663, 'SebyP4', 23, '* (chat log): dar dai.', '2021-05-09 18:47:31'),
(664, 'Vicentzo', 4, '* (chat log): tin sa te anunt ca poate iei cres.', '2021-05-09 18:47:32'),
(665, 'Adrian_Valentin', 41, '* (chat log): a daca vreti.', '2021-05-09 18:50:36'),
(666, 'Vicentzo', 4, '* (chat log): rãg..', '2021-05-09 18:51:54'),
(667, 'RoLEX', 7, '* (chat log): ff.', '2021-05-09 19:02:32'),
(668, 'RoLEX', 7, '* (chat log): rpg.pornhub.com.', '2021-05-09 19:02:37'),
(669, 'RoLEX', 7, '* (chat log): f.', '2021-05-09 19:02:38'),
(670, 'RoLEX', 7, '* (chat log): fff.', '2021-05-09 19:02:40'),
(671, 'AnDreeW', 36, '* (chat log): rpg..', '2021-05-09 19:02:41'),
(672, 'RoLEX', 7, '* (chat log): .', '2021-05-09 19:03:00');
INSERT INTO `server_chat_logs` (`ID`, `PlayerName`, `PlayerID`, `ChatText`, `Time`) VALUES
(673, 'AnDreeW', 36, '* (chat log): hai paint.', '2021-05-09 19:04:13'),
(674, 'RoLEX', 7, '* (chat log): NU MAI SCRIE PE CHAT 2 min.', '2021-05-09 19:04:19'),
(675, 'AnDreeW', 36, '* (chat log): k.', '2021-05-09 19:04:22'),
(676, 'RoLEX', 7, '* (chat log): si nu exista paint cred.', '2021-05-09 19:04:23'),
(677, 'RoLEX', 7, '* (chat log): inca.', '2021-05-09 19:04:26'),
(678, 'AnDreeW', 36, '* (chat log): fv.', '2021-05-09 19:05:10'),
(679, 'RoLEX', 7, '* (chat log): dau eu cand e.', '2021-05-09 19:05:20'),
(680, 'mr.bunny', 2, '* (chat log): ba.', '2021-05-09 19:06:26'),
(681, 'AnDreeW', 36, '* (chat log): da.', '2021-05-09 19:06:28'),
(682, 'mr.bunny', 2, '* (chat log): ia du te cu w.', '2021-05-09 19:06:30'),
(683, 'mr.bunny', 2, '* (chat log): nu se fute animatia?.', '2021-05-09 19:06:37'),
(684, 'RoLEX', 7, '* (chat log): cu ?.', '2021-05-09 19:06:39'),
(685, 'mr.bunny', 2, '* (chat log): doar cu w in ainte.', '2021-05-09 19:06:44'),
(686, 'mr.bunny', 2, '* (chat log): doar cu w inainte.', '2021-05-09 19:06:46'),
(687, 'AnDreeW', 36, '* (chat log): aa.', '2021-05-09 19:07:38'),
(688, 'AnDreeW', 36, '* (chat log): daca faci asa.', '2021-05-09 19:07:40'),
(689, 'AnDreeW', 36, '* (chat log): da.', '2021-05-09 19:07:40'),
(690, 'mr.bunny', 2, '* (chat log): eu nu fac.', '2021-05-09 19:07:46'),
(691, 'mr.bunny', 2, '* (chat log): doar W.', '2021-05-09 19:07:50'),
(692, 'mr.bunny', 2, '* (chat log): apas.', '2021-05-09 19:07:51'),
(693, 'AnDreeW', 36, '* (chat log): dac apesi rpd.', '2021-05-09 19:07:51'),
(694, 'AnDreeW', 36, '* (chat log): w.', '2021-05-09 19:07:51'),
(695, 'AnDreeW', 36, '* (chat log): face asa.', '2021-05-09 19:07:53'),
(696, 'AnDreeW', 36, '* (chat log): dai relog.', '2021-05-09 19:07:54'),
(697, 'mr.bunny', 2, '* (chat log): tin apasat.', '2021-05-09 19:07:57'),
(698, 'mr.bunny', 2, '* (chat log): asa imi face .', '2021-05-09 19:08:04'),
(699, 'AnDreeW', 36, '* (chat log): uite ca ii mere.', '2021-05-09 19:08:24'),
(700, 'AnDreeW', 36, '* (chat log): ai mers.', '2021-05-09 19:08:27'),
(701, 'mr.bunny', 2, '* (chat log): e de la modpack oare?.', '2021-05-09 19:08:31'),
(702, 'AnDreeW', 36, '* (chat log): nu are cum sa fie.', '2021-05-09 19:08:35'),
(703, 'AnDreeW', 36, '* (chat log): de la gm.', '2021-05-09 19:08:36'),
(704, 'mr.bunny', 2, '* (chat log): apasa w.', '2021-05-09 19:08:37'),
(705, 'AnDreeW', 36, '* (chat log): apesi tu.', '2021-05-09 19:08:42'),
(706, 'mr.bunny', 2, '* (chat log): doar W.', '2021-05-09 19:08:42'),
(707, 'AnDreeW', 36, '* (chat log): w rpd.', '2021-05-09 19:08:43'),
(708, 'mr.bunny', 2, '* (chat log): fara shift.', '2021-05-09 19:08:45'),
(709, 'AnDreeW', 36, '* (chat log): apas .', '2021-05-09 19:08:45'),
(710, 'AnDreeW', 36, '* (chat log): w.', '2021-05-09 19:08:46'),
(711, 'AnDreeW', 36, '* (chat log): daca apas W repede face asa uite.', '2021-05-09 19:08:57'),
(712, 'RoLEX', 7, '* (chat log): unde e.', '2021-05-09 19:09:18'),
(713, 'Adrian_Valentin', 41, '* (chat log): da.', '2021-05-09 19:09:44'),
(714, 'AnDreeW', 36, '* (chat log): sus.', '2021-05-09 19:09:52'),
(715, 'Adrian_Valentin', 41, '* (chat log): am inteles.', '2021-05-09 19:10:00'),
(716, 'Adrian_Valentin', 41, '* (chat log): CE FACI BRO.', '2021-05-09 19:11:37'),
(717, 'AnDreeW', 36, '* (chat log): cbug.', '2021-05-09 19:11:40'),
(718, 'Adrian_Valentin', 41, '* (chat log): de unde ai arma/.', '2021-05-09 19:12:00'),
(719, 'AnDreeW', 36, '* (chat log): de la factiune.', '2021-05-09 19:12:24'),
(720, 'AnDreeW', 36, '* (chat log): de unde sa am.', '2021-05-09 19:12:25'),
(721, 'AnDreeW', 36, '* (chat log): hai sa te iau la un test.', '2021-05-09 19:12:42'),
(722, 'AnDreeW', 36, '* (chat log): de helper.', '2021-05-09 19:12:43'),
(723, 'AnDreeW', 36, '* (chat log): dai /sit.', '2021-05-09 19:12:44'),
(724, 'Adrian_Valentin', 41, '* (chat log): am inteles.', '2021-05-09 19:12:44'),
(725, 'AnDreeW', 36, '* (chat log): Te invat de unde iau arme ok?.', '2021-05-09 19:12:51'),
(726, 'AnDreeW', 36, '* (chat log): Deci.', '2021-05-09 19:12:53'),
(727, 'AnDreeW', 36, '* (chat log): iti dau respawn.', '2021-05-09 19:12:55'),
(728, 'AnDreeW', 36, '* (chat log): iti dau respawn..', '2021-05-09 19:13:00'),
(729, 'AnDreeW', 36, '* (chat log): si dai /duty.', '2021-05-09 19:13:02'),
(730, 'AnDreeW', 36, '* (chat log): in hq.', '2021-05-09 19:13:03'),
(731, 'AnDreeW', 36, '* (chat log): klar.', '2021-05-09 19:13:24'),
(732, 'AnDreeW', 36, '* (chat log): =]]]].', '2021-05-09 19:14:10'),
(733, 'AnDreeW', 36, '* (chat log): pa.', '2021-05-09 19:14:38'),
(734, 'Adrian_Valentin', 41, '* (chat log): oooo.', '2021-05-09 19:14:39'),
(735, 'RoLEX', 7, '* (chat log): ce id are minigun?.', '2021-05-09 19:15:15'),
(736, 'AnDreeW', 36, '* (chat log): 38.', '2021-05-09 19:15:17'),
(737, 'RoLEX', 7, '* (chat log): ok.', '2021-05-09 19:15:19'),
(738, 'RoLEX', 7, '* (chat log): ms.', '2021-05-09 19:15:20'),
(739, 'Adrian_Valentin', 41, '* (chat log): vreu.', '2021-05-09 19:15:49'),
(740, 'RoLEX', 7, '* (chat log): bnaa \").', '2021-05-09 19:16:09'),
(741, 'Adrian_Valentin', 41, '* (chat log): stai.', '2021-05-09 19:16:25'),
(742, 'RoLEX', 7, '* (chat log): :)).', '2021-05-09 19:16:26'),
(743, 'AnDreeW', 36, '* (chat log): ce id are.', '2021-05-09 19:17:46'),
(744, 'AnDreeW', 36, '* (chat log): rocket.', '2021-05-09 19:17:46'),
(745, 'RoLEX', 7, '* (chat log): 35.', '2021-05-09 19:17:49'),
(746, 'RoLEX', 7, '* (chat log): ,mm,.', '2021-05-09 19:18:00'),
(747, 'gab1', 5, '* (chat log): haolo.', '2021-05-09 19:19:21'),
(748, 'gab1', 5, '* (chat log): dc imi dai bully.', '2021-05-09 19:19:27'),
(749, 'gab1', 5, '* (chat log): st.', '2021-05-09 19:19:44'),
(750, 'Adrian_Valentin', 41, '* (chat log): nu te rog.', '2021-05-09 19:20:15'),
(751, 'RoLEX', 7, '* (chat log): fucc.', '2021-05-09 19:20:46'),
(752, 'RoLEX', 7, '* (chat log): :))).', '2021-05-09 19:20:54'),
(753, 'RoLEX', 7, '* (chat log): gabor parlit.', '2021-05-09 19:21:03'),
(754, 'RoLEX', 7, '* (chat log): de andreq.', '2021-05-09 19:21:09'),
(755, 'RoLEX', 7, '* (chat log): baaa.', '2021-05-09 19:21:10'),
(756, 'RoLEX', 7, '* (chat log): :)).', '2021-05-09 19:21:11'),
(757, 'AnDreeW', 36, '* (chat log): cu ce ocazie.', '2021-05-09 19:21:33'),
(758, 'AnDreeW', 36, '* (chat log): aici sus?.', '2021-05-09 19:21:34'),
(759, 'RoLEX', 7, '* (chat log): baa.', '2021-05-09 19:21:44'),
(760, 'AnDreeW', 36, '* (chat log): =]].', '2021-05-09 19:21:44'),
(761, 'RoLEX', 7, '* (chat log): bon seara.', '2021-05-09 19:22:07'),
(762, 'RoLEX', 7, '* (chat log): b aaa.', '2021-05-09 19:22:12'),
(763, 'AnDreeW', 36, '* (chat log): tu st.', '2021-05-09 19:24:13'),
(764, 'AnDreeW', 36, '* (chat log): ma.', '2021-05-09 19:24:15'),
(765, 'RoLEX', 7, '* (chat log): mda.', '2021-05-09 19:24:15'),
(766, 'RoLEX', 7, '* (chat log): :).', '2021-05-09 19:24:16'),
(767, 'AnDreeW', 36, '* (chat log): culkat.', '2021-05-09 19:27:00'),
(768, 'AnDreeW', 36, '* (chat log): dai g.', '2021-05-09 19:27:51'),
(769, 'AnDreeW', 36, '* (chat log): hai.', '2021-05-09 19:27:54'),
(770, 'AnDreeW', 36, '* (chat log): sus.', '2021-05-09 19:30:27'),
(771, 'Adrian_Valentin', 41, '* (chat log): dami si mie admin 5.', '2021-05-09 19:32:11'),
(772, 'AnDreeW', 36, '* (chat log): ce faci cu el?.', '2021-05-09 19:32:19'),
(773, 'Adrian_Valentin', 41, '* (chat log): imi dau si eu bani.', '2021-05-09 19:32:27'),
(774, 'Adrian_Valentin', 41, '* (chat log): si vip.', '2021-05-09 19:32:36'),
(775, 'AnDreeW', 36, '* (chat log): gata ti am dat eu.', '2021-05-09 19:32:38'),
(776, 'AnDreeW', 36, '* (chat log): te las.', '2021-05-09 19:33:30'),
(777, 'Adrian_Valentin', 41, '* (chat log): cum ma faceam leader.', '2021-05-09 19:35:08'),
(778, 'AnDreeW', 36, '* (chat log): re.', '2021-05-09 19:35:54'),
(779, 'AnDreeW', 36, '* (chat log): ai fost acceptat? ca tester?.', '2021-05-09 19:36:00'),
(780, 'Sebastian.Gaming2010', 42, '* (chat log): ree.', '2021-05-09 19:36:02'),
(781, 'Adrian_Valentin', 41, '* (chat log): este frt meu.', '2021-05-09 19:36:03'),
(782, 'Adrian_Valentin', 41, '* (chat log): da.', '2021-05-09 19:36:07'),
(783, 'Sebastian.Gaming2010', 42, '* (chat log): vreau admin ca sunt tester.', '2021-05-09 19:36:21'),
(784, 'AnDreeW', 36, '* (chat log): ai dovada?.', '2021-05-09 19:36:32'),
(785, 'AnDreeW', 36, '* (chat log): ca esti tester.', '2021-05-09 19:36:34'),
(786, 'AnDreeW', 36, '* (chat log): dami mesaj pe discord.', '2021-05-09 19:36:38'),
(787, 'Sebastian.Gaming2010', 42, '* (chat log): da pe discord.', '2021-05-09 19:36:44'),
(788, 'AnDreeW', 36, '* (chat log): cum esti pe discord.', '2021-05-09 19:36:50'),
(789, 'Sebastian.Gaming2010', 42, '* (chat log): ma cheama s3b1.gmg.', '2021-05-09 19:36:56'),
(790, 'Sebastian.Gaming2010', 42, '* (chat log): cu litere mari.', '2021-05-09 19:37:16'),
(791, 'AnDreeW', 36, '* (chat log): g.', '2021-05-09 19:38:12'),
(792, 'AnDreeW', 36, '* (chat log): urca sus.', '2021-05-09 19:38:14'),
(793, 'Adrian_Valentin', 41, '* (chat log): area admin mai mare ca mn.', '2021-05-09 19:38:21'),
(794, 'Adrian_Valentin', 41, '* (chat log): g.', '2021-05-09 19:40:05'),
(795, 'Vicentzo', 4, '* (chat log):  .', '2021-05-09 20:17:28'),
(796, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-10 14:43:51'),
(797, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-10 16:36:41'),
(798, 'Vicentzo', 4, '* (chat log): .fv.', '2021-05-10 16:55:41'),
(799, 'RaresGabriel99', 18, '* (chat log): am dat si respawn.', '2021-05-10 17:07:53'),
(800, 'RaresGabriel99', 18, '* (chat log): pun pe bugs ?.', '2021-05-10 17:10:06'),
(801, 'RaresGabriel99', 18, '* (chat log): stai .', '2021-05-10 17:13:21'),
(802, 'RoLEX', 7, '* (chat log): cf mane.', '2021-05-10 17:13:43'),
(803, 'RoLEX', 7, '* (chat log): dai 1kk?.', '2021-05-10 17:13:45'),
(804, 'RoLEX', 7, '* (chat log): la saraci.', '2021-05-10 17:13:48'),
(805, 'Vicentzo', 4, '* (chat log):  /unjail 0 sint bos.', '2021-05-10 17:37:48'),
(806, 'RoLEX', 7, '* (chat log): sunt in inchisoare.', '2021-05-10 17:37:48'),
(807, 'Vicentzo', 4, '* (chat log): urcate in masina.', '2021-05-10 17:38:02'),
(808, 'Vicentzo', 4, '* (chat log): callback 3!.', '2021-05-10 17:38:13'),
(809, 'Vicentzo', 4, '* (chat log): ma ce pula me.', '2021-05-10 17:38:15'),
(810, 'Vicentzo', 4, '* (chat log): ia dai tu goto la mine cand sunt in masina.', '2021-05-10 17:38:21'),
(811, 'RoLEX', 7, '* (chat log): k.', '2021-05-10 17:38:24'),
(812, 'Vicentzo', 4, '* (chat log): sa imi spui ce numere.', '2021-05-10 17:38:24'),
(813, 'Vicentzo', 4, '* (chat log): iti apar.', '2021-05-10 17:38:25'),
(814, 'Vicentzo', 4, '* (chat log): doar #1?.', '2021-05-10 17:38:34'),
(815, 'RoLEX', 7, '* (chat log): da.', '2021-05-10 17:38:36'),
(816, 'RoLEX', 7, '* (chat log): #1.', '2021-05-10 17:38:38'),
(817, 'Vicentzo', 4, '* (chat log): oki.', '2021-05-10 17:38:39'),
(818, 'RoLEX', 7, '* (chat log): e bn?.', '2021-05-10 17:38:42'),
(819, 'Vicentzo', 4, '* (chat log): nu.', '2021-05-10 17:38:45'),
(820, 'Vicentzo', 4, '* (chat log): ca am pus mai multe.', '2021-05-10 17:38:48'),
(821, 'RoLEX', 7, '* (chat log): ....', '2021-05-10 17:38:51'),
(822, 'RoLEX', 7, '* (chat log): ok.', '2021-05-10 17:38:52'),
(823, 'Vicentzo', 4, '* (chat log): hai sa vedemt.', '2021-05-10 17:38:54'),
(824, 'Vicentzo', 4, '* (chat log): ala cu taxi.', '2021-05-10 17:38:56'),
(825, 'RoLEX', 7, '* (chat log): da.', '2021-05-10 17:38:58'),
(826, 'RoLEX', 7, '* (chat log): gt.', '2021-05-10 17:39:50'),
(827, 'RoLEX', 7, '* (chat log): .', '2021-05-10 17:40:02'),
(828, 'Vicentzo', 4, '* (chat log): ce harta.', '2021-05-10 17:40:24'),
(829, 'RoLEX', 7, '* (chat log): ba.', '2021-05-10 17:41:09'),
(830, 'Vicentzo', 4, '* (chat log): ce.', '2021-05-10 17:41:11'),
(831, 'RoLEX', 7, '* (chat log): chem politia.', '2021-05-10 17:41:12'),
(832, 'RoLEX', 7, '* (chat log): faci dm.', '2021-05-10 17:41:13'),
(833, 'Vicentzo', 4, '* (chat log): da.', '2021-05-10 17:41:15'),
(834, 'RoLEX', 7, '* (chat log): hai k dm.', '2021-05-10 17:41:24'),
(835, 'RoLEX', 7, '* (chat log): vezi ca iei LW.', '2021-05-10 17:41:44'),
(836, 'Vicentzo', 4, '* (chat log): eZ.', '2021-05-10 17:41:47'),
(837, 'RoLEX', 7, '* (chat log): daca oimi da.', '2021-05-10 17:41:48'),
(838, 'RoLEX', 7, '* (chat log): st.', '2021-05-10 17:42:25'),
(839, 'RoLEX', 7, '* (chat log): da mi jail.', '2021-05-10 17:42:32'),
(840, 'Vicentzo', 4, '* (chat log): hhihihi.', '2021-05-10 17:42:54'),
(841, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-10 17:44:45'),
(842, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-10 17:51:45'),
(843, 'RoLEX', 7, '* (chat log): ./his.', '2021-05-10 17:51:48'),
(844, 'RoLEX', 7, '* (chat log): ./hi..hud.', '2021-05-10 17:51:50'),
(845, 'RoLEX', 7, '* (chat log): ./hud.', '2021-05-10 17:51:54'),
(846, 'RoLEX', 7, '* (chat log): ./duty.', '2021-05-10 17:54:11'),
(847, 'RaresGabriel99', 18, '* (chat log): ba.', '2021-05-10 19:45:27'),
(848, 'mr.bunny', 2, '* (chat log): da.', '2021-05-10 19:45:30'),
(849, 'RaresGabriel99', 18, '* (chat log): urca-te intr o masina.', '2021-05-10 19:45:35'),
(850, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-10 19:45:41'),
(851, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-10 19:45:56'),
(852, 'RaresGabriel99', 18, '* (chat log): urca-te intr o masina .', '2021-05-10 19:46:00'),
(853, 'RoLEX', 7, '* (chat log): blackmoon.ro.', '2021-05-10 19:46:07'),
(854, 'RoLEX', 7, '* (chat log): bzonw.', '2021-05-10 19:46:15'),
(855, 'RoLEX', 7, '* (chat log): bzone.', '2021-05-10 19:46:16'),
(856, 'RaresGabriel99', 18, '* (chat log): da goto la mn.', '2021-05-10 19:46:29'),
(857, 'RoLEX', 7, '* (chat log): xD.', '2021-05-10 19:48:36'),
(858, 'RoLEX', 7, '* (chat log): fututi.', '2021-05-10 19:49:28'),
(859, 'RaresGabriel99', 18, '* (chat log): si eu sunt bos.', '2021-05-10 19:50:35'),
(860, 'RaresGabriel99', 18, '* (chat log): :).', '2021-05-10 19:50:37'),
(861, 'RaresGabriel99', 18, '* (chat log): dada.', '2021-05-10 19:50:57'),
(862, 'AnDreeW', 36, '* (chat log): cum faci ma.', '2021-05-10 19:51:05'),
(863, 'AnDreeW', 36, '* (chat log): de nu mori.', '2021-05-10 19:51:07'),
(864, 'RaresGabriel99', 18, '* (chat log): am cit.', '2021-05-10 19:51:09'),
(865, 'AnDreeW', 36, '* (chat log): cum zbor.', '2021-05-10 19:52:12'),
(866, 'AnDreeW', 36, '* (chat log): ma si o.', '2021-05-10 19:52:13'),
(867, 'AnDreeW', 36, '* (chat log): lasa ma ma.', '2021-05-10 19:53:47'),
(868, 'AnDreeW', 36, '* (chat log): g.', '2021-05-10 19:55:06'),
(869, 'AnDreeW', 36, '* (chat log): sus.', '2021-05-10 19:55:33'),
(870, 'RaresGabriel99', 18, '* (chat log): da ba adm.', '2021-05-10 19:56:10'),
(871, 'AnDreeW', 36, '* (chat log): rpg.pornhub.com.', '2021-05-10 20:00:38'),
(872, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-10 20:02:03'),
(873, 'AnDreeW', 36, '* (chat log): ba.', '2021-05-10 20:05:03'),
(874, 'AnDreeW', 36, '* (chat log): baa.', '2021-05-10 20:05:19'),
(875, 'AnDreeW', 36, '* (chat log): asd.', '2021-05-10 20:05:24'),
(876, 'AnDreeW', 36, '* (chat log): termina.', '2021-05-10 20:12:46'),
(877, 'AnDreeW', 36, '* (chat log): ca te bat.', '2021-05-10 20:12:49'),
(878, 'AnDreeW', 36, '* (chat log): pizda proasta.', '2021-05-10 20:12:53'),
(879, 'RaresGabriel99', 18, '* (chat log): :))).', '2021-05-10 20:12:54'),
(880, 'Vicentzo', 4, '* (chat log): acuma.', '2021-05-10 20:13:41'),
(881, 'AnDreeW', 36, '* (chat log): gt.', '2021-05-10 20:13:44'),
(882, 'AnDreeW', 36, '* (chat log): acu.', '2021-05-10 20:13:45'),
(883, 'AnDreeW', 36, '* (chat log): ai lag.', '2021-05-10 20:13:46'),
(884, 'Vicentzo', 4, '* (chat log): st.', '2021-05-10 20:13:48'),
(885, 'AnDreeW', 36, '* (chat log): fugi repede.', '2021-05-10 20:13:49'),
(886, 'Vicentzo', 4, '* (chat log): ca e fake lag.', '2021-05-10 20:13:50'),
(887, 'Vicentzo', 4, '* (chat log): =))).', '2021-05-10 20:13:51'),
(888, 'Vicentzo', 4, '* (chat log): am scos tot.', '2021-05-10 20:14:09'),
(889, 'Vicentzo', 4, '* (chat log): am invurnerabilitate.', '2021-05-10 20:14:11'),
(890, 'Vicentzo', 4, '* (chat log): stai.', '2021-05-10 20:14:11'),
(891, 'AnDreeW', 36, '* (chat log): hp.', '2021-05-10 20:14:13'),
(892, 'AnDreeW', 36, '* (chat log): nu scade.', '2021-05-10 20:14:15'),
(893, 'Vicentzo', 4, '* (chat log): done.', '2021-05-10 20:14:26'),
(894, 'Vicentzo', 4, '* (chat log): EZ.', '2021-05-10 20:14:42'),
(895, 'Vicentzo', 4, '* (chat log): t/fv.', '2021-05-10 20:16:18'),
(896, 'RaresGabriel99', 18, '* (chat log): st.', '2021-05-10 20:16:23'),
(897, 'Vicentzo', 4, '* (chat log): urca-n barca.', '2021-05-10 20:16:27'),
(898, 'Vicentzo', 4, '* (chat log): stai ma sa vin pe sol.', '2021-05-10 20:16:37'),
(899, 'RaresGabriel99', 18, '* (chat log): gata.', '2021-05-10 20:17:04'),
(900, 'Vicentzo', 4, '* (chat log): gata.', '2021-05-10 20:17:04'),
(901, 'Vicentzo', 4, '* (chat log): tinete bn.', '2021-05-10 20:17:20'),
(902, 'Vicentzo', 4, '* (chat log): ba.', '2021-05-10 20:18:23'),
(903, 'Vicentzo', 4, '* (chat log): cauta vortex pe net putin.', '2021-05-10 20:18:27'),
(904, 'RaresGabriel99', 18, '* (chat log): ?.', '2021-05-10 20:18:27'),
(905, 'Vicentzo', 4, '* (chat log): ca asa il conduc io.', '2021-05-10 20:18:32'),
(906, 'Vicentzo', 4, '* (chat log): si voi va suiti.', '2021-05-10 20:18:34'),
(907, 'RaresGabriel99', 18, '* (chat log): 539.', '2021-05-10 20:18:46'),
(908, 'Vicentzo', 4, '* (chat log): suiete.', '2021-05-10 20:18:57'),
(909, 'Vicentzo', 4, '* (chat log): punete pa mijloc.', '2021-05-10 20:19:03'),
(910, 'Vicentzo', 4, '* (chat log): si fal.', '2021-05-10 20:19:04'),
(911, 'RaresGabriel99', 18, '* (chat log): scz.', '2021-05-10 20:19:05'),
(912, 'Vicentzo', 4, '* (chat log): cu fal.', '2021-05-10 20:19:06'),
(913, 'RaresGabriel99', 18, '* (chat log): nu merge g.', '2021-05-10 20:19:14'),
(914, 'SebyP4', 23, '* (chat log): zi boss.', '2021-05-10 20:19:40'),
(915, 'Vicentzo', 4, '* (chat log): hmm.', '2021-05-10 20:19:52'),
(916, 'Vicentzo', 4, '* (chat log): mere si prin aer.', '2021-05-10 20:20:17'),
(917, 'Vicentzo', 4, '* (chat log): fara hack.', '2021-05-10 20:20:19'),
(918, 'RaresGabriel99', 18, '* (chat log): stiu.', '2021-05-10 20:20:29'),
(919, 'AnDreeW', 36, '* (chat log): vaicantzo.', '2021-05-10 20:20:33'),
(920, 'AnDreeW', 36, '* (chat log): dai cu 10000km.', '2021-05-10 20:20:41'),
(921, 'Vicentzo', 4, '* (chat log): tineti-va bn.', '2021-05-10 20:20:42'),
(922, 'AnDreeW', 36, '* (chat log): br .', '2021-05-10 20:21:34'),
(923, 'AnDreeW', 36, '* (chat log): bv.', '2021-05-10 20:21:36'),
(924, 'AnDreeW', 36, '* (chat log): sus.', '2021-05-10 20:21:53'),
(925, 'AnDreeW', 36, '* (chat log): iti arat eu teroare.', '2021-05-10 20:21:56'),
(926, 'AnDreeW', 36, '* (chat log): ok.', '2021-05-10 20:22:11'),
(927, 'AnDreeW', 36, '* (chat log): sus.', '2021-05-10 20:22:27'),
(928, 'AnDreeW', 36, '* (chat log): hai fa.', '2021-05-10 20:23:03'),
(929, 'AnDreeW', 36, '* (chat log): da g.', '2021-05-10 20:23:09'),
(930, 'AnDreeW', 36, '* (chat log): sus.', '2021-05-10 20:23:23'),
(931, 'AnDreeW', 36, '* (chat log): fa.', '2021-05-10 20:23:23'),
(932, 'AnDreeW', 36, '* (chat log): ce.', '2021-05-10 20:23:44'),
(933, 'AnDreeW', 36, '* (chat log): drq.', '2021-05-10 20:23:44'),
(934, 'AnDreeW', 36, '* (chat log): rpg.pornohub.com.', '2021-05-10 20:32:21'),
(935, 'AnDreeW', 36, '* (chat log): asd.', '2021-05-10 20:32:25'),
(936, 'AnDreeW', 36, '* (chat log): stiu eu.', '2021-05-10 20:34:57'),
(937, 'AnDreeW', 36, '* (chat log): unde sa punem.', '2021-05-10 20:35:00'),
(938, 'AnDreeW', 36, '* (chat log): paint.', '2021-05-10 20:35:01'),
(939, 'AnDreeW', 36, '* (chat log): dami kill.', '2021-05-10 20:35:03'),
(940, 'AnDreeW', 36, '* (chat log): sa fiu ls.', '2021-05-10 20:35:04'),
(941, 'Vicentzo', 4, '* (chat log): nu in ls.', '2021-05-10 20:35:08'),
(942, 'Vicentzo', 4, '* (chat log): .', '2021-05-10 20:35:11'),
(943, 'Vicentzo', 4, '* (chat log): coaie.', '2021-05-10 20:35:40'),
(944, 'Vicentzo', 4, '* (chat log): e in lv oras principal.', '2021-05-10 20:35:43'),
(945, 'Vicentzo', 4, '* (chat log): in pula mea.', '2021-05-10 20:35:45'),
(946, 'AnDreeW', 36, '* (chat log): aa.', '2021-05-10 20:35:45'),
(947, 'AnDreeW', 36, '* (chat log): a m uitat.', '2021-05-10 20:35:47'),
(948, 'AnDreeW', 36, '* (chat log): cum e aici.', '2021-05-10 20:36:17'),
(949, 'Vicentzo', 4, '* (chat log): am gasit direct acolo-n sat.', '2021-05-10 20:36:24'),
(950, 'Vicentzo', 4, '* (chat log): aici e spawn.', '2021-05-10 20:36:47'),
(951, 'AnDreeW', 36, '* (chat log): nu prea e asa fain aki acolo era tare.', '2021-05-10 20:36:57'),
(952, 'Vicentzo', 4, '* (chat log): daca aici e satu principal.', '2021-05-10 20:37:11'),
(953, 'Vicentzo', 4, '* (chat log): pe care se bazeaza.', '2021-05-10 20:37:14'),
(954, 'AnDreeW', 36, '* (chat log): e bine si asta.', '2021-05-10 20:37:19'),
(955, 'Vicentzo', 4, '* (chat log): se bazeaza pe tot lv, dar aici e orasul principal.', '2021-05-10 20:37:20'),
(956, 'AnDreeW', 36, '* (chat log): cand il fakem.', '2021-05-10 20:37:51'),
(957, 'AnDreeW', 36, '* (chat log): ha?.', '2021-05-10 20:38:10'),
(958, 'AnDreeW', 36, '* (chat log): set.', '2021-05-10 20:43:05'),
(959, 'Vicentzo', 4, '* (chat log): ia-ti putin o masin.', '2021-05-11 15:14:04'),
(960, 'Vicentzo', 4, '* (chat log): ia-ti si tu o masina si eu.', '2021-05-11 15:14:14'),
(961, 'Vicentzo', 4, '* (chat log): sa vad ceva.', '2021-05-11 15:14:16'),
(962, 'RoLEX', 7, '* (chat log): mda.', '2021-05-11 15:14:38'),
(963, 'Vicentzo', 4, '* (chat log): ia ia-ti un infernus.', '2021-05-11 15:14:46'),
(964, 'Vicentzo', 4, '* (chat log): sultan.', '2021-05-11 15:14:48'),
(965, 'Vicentzo', 4, '* (chat log): 560.', '2021-05-11 15:14:49'),
(966, 'Vicentzo', 4, '* (chat log): mi-am dat seama de la ce e.', '2021-05-11 15:15:10'),
(967, 'Vicentzo', 4, '* (chat log): stai 1 minut sa dau restart.', '2021-05-11 15:15:13'),
(968, 'RoLEX', 7, '* (chat log): k.', '2021-05-11 15:15:17'),
(969, 'RoLEX', 7, '* (chat log): am a fost plecat.', '2021-05-11 15:17:58'),
(970, 'RoLEX', 7, '* (chat log): acm.', '2021-05-11 15:18:00'),
(971, 'Vicentzo', 4, '* (chat log): ez.', '2021-05-11 15:18:11'),
(972, 'RoLEX', 7, '* (chat log): ala i.', '2021-05-11 15:18:11'),
(973, 'Vicentzo', 4, '* (chat log): sultan.', '2021-05-11 15:18:13'),
(974, 'Vicentzo', 4, '* (chat log): ?.', '2021-05-11 15:18:14'),
(975, 'RoLEX', 7, '* (chat log): da.', '2021-05-11 15:18:16'),
(976, 'Vicentzo', 4, '* (chat log): daca eram mai multi sa testam daca ma pune in spate era bine.', '2021-05-11 15:18:26'),
(977, 'Vicentzo', 4, '* (chat log): da acum asta e.', '2021-05-11 15:18:28'),
(978, 'Vicentzo', 4, '* (chat log): 560.', '2021-05-11 15:18:37'),
(979, 'RoLEX', 7, '* (chat log): hai.', '2021-05-11 15:18:38'),
(980, 'RoLEX', 7, '* (chat log): pff.', '2021-05-11 15:18:40'),
(981, 'RoLEX', 7, '* (chat log): ez.', '2021-05-11 15:18:49'),
(982, 'Vicentzo', 4, '* (chat log): ma pune-n si-n spate.', '2021-05-11 15:18:54'),
(983, 'Vicentzo', 4, '* (chat log): =))).', '2021-05-11 15:18:55'),
(984, 'RoLEX', 7, '* (chat log): mereu am tentinda sa mi iau.', '2021-05-11 15:18:56'),
(985, 'Vicentzo', 4, '* (chat log): ce fain.', '2021-05-11 15:18:57'),
(986, 'RoLEX', 7, '* (chat log): d ala.', '2021-05-11 15:18:59'),
(987, 'RoLEX', 7, '* (chat log): infernus.', '2021-05-11 15:19:02'),
(988, 'Vicentzo', 4, '* (chat log): ai vazut.', '2021-05-11 15:19:11'),
(989, 'Vicentzo', 4, '* (chat log): sa vedem.', '2021-05-11 15:19:14'),
(990, 'Vicentzo', 4, '* (chat log): daca apare.', '2021-05-11 15:19:15'),
(991, 'Vicentzo', 4, '* (chat log): 2/20.', '2021-05-11 15:19:17'),
(992, 'Vicentzo', 4, '* (chat log): la paunt?.', '2021-05-11 15:19:19'),
(993, 'RoLEX', 7, '* (chat log): da.', '2021-05-11 15:19:21'),
(994, 'Vicentzo', 4, '* (chat log): du-te-n spate.', '2021-05-11 15:19:22'),
(995, 'RoLEX', 7, '* (chat log): st.', '2021-05-11 15:19:25'),
(996, 'RoLEX', 7, '* (chat log): vic.', '2021-05-11 15:19:26'),
(997, 'Vicentzo', 4, '* (chat log): a.', '2021-05-11 15:19:27'),
(998, 'RoLEX', 7, '* (chat log): eu nu mai pot sra.', '2021-05-11 15:19:28'),
(999, 'Vicentzo', 4, '* (chat log): ok.', '2021-05-11 15:19:30'),
(1000, 'RoLEX', 7, '* (chat log): scz....', '2021-05-11 15:19:31'),
(1001, 'RoLEX', 7, '* (chat log): ca teb sa plec.', '2021-05-11 15:19:34'),
(1002, 'Vicentzo', 4, '* (chat log): nu-i problema.', '2021-05-11 15:19:35'),
(1003, 'RoLEX', 7, '* (chat log): afara.', '2021-05-11 15:19:35'),
(1004, 'RoLEX', 7, '* (chat log): nu te supara.', '2021-05-11 15:19:38'),
(1005, 'Vicentzo', 4, '* (chat log): nu-i problema x.', '2021-05-11 15:19:41'),
(1006, 'RoLEX', 7, '* (chat log): chiar nu mai pot.', '2021-05-11 15:19:41'),
(1007, 'RoLEX', 7, '* (chat log): ok.', '2021-05-11 15:19:43'),
(1008, 'RoLEX', 7, '* (chat log): ms.', '2021-05-11 15:19:45'),
(1009, 'RoLEX', 7, '* (chat log): ceaw.', '2021-05-11 15:19:46'),
(1010, 'Vicentzo', 4, '* (chat log): sla.', '2021-05-11 15:19:47'),
(1011, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-11 15:20:16'),
(1012, 'RobertShefuMati', 45, '* (chat log): Who asked you..', '2021-05-11 16:33:50'),
(1013, 'RobertShefuMati', 45, '* (chat log): ba.', '2021-05-11 16:34:24'),
(1014, 'RobertShefuMati', 45, '* (chat log): Baa..', '2021-05-11 16:34:29'),
(1015, 'Vicentzo', 4, '* (chat log): ce vrei ma.', '2021-05-11 16:34:31'),
(1016, 'RobertShefuMati', 45, '* (chat log): Sunt beta tester..', '2021-05-11 16:34:38'),
(1017, 'Vicentzo', 4, '* (chat log): confirmare chat beta.', '2021-05-11 16:34:45'),
(1018, 'Vicentzo', 4, '* (chat log): si dupa vorbim.', '2021-05-11 16:34:47'),
(1019, 'RobertShefuMati', 45, '* (chat log): Am confirmat..', '2021-05-11 16:35:37'),
(1020, 'Vicentzo', 4, '* (chat log): ./enterpaint.', '2021-05-11 16:38:50'),
(1021, 'mr.bunny', 2, '* (chat log): ce vr.', '2021-05-11 16:39:01'),
(1022, 'Vicentzo', 4, '* (chat log): dai ma enterpaint.', '2021-05-11 16:39:03'),
(1023, 'Vicentzo', 4, '* (chat log): aici.', '2021-05-11 16:39:04'),
(1024, 'mr.bunny', 2, '* (chat log):  /set mr level 5.', '2021-05-11 16:39:21'),
(1025, 'Vicentzo', 4, '* (chat log): iti arata caum.', '2021-05-11 16:39:34'),
(1026, 'Vicentzo', 4, '* (chat log): ca sunt 1/20?.', '2021-05-11 16:39:36'),
(1027, 'mr.bunny', 2, '* (chat log): am intrat.', '2021-05-11 16:39:36'),
(1028, 'mr.bunny', 2, '* (chat log): pe pl.', '2021-05-11 16:39:37'),
(1029, 'Vicentzo', 4, '* (chat log): pai nu am mapa.', '2021-05-11 16:39:43'),
(1030, 'Vicentzo', 4, '* (chat log): nu intelegi.', '2021-05-11 16:39:45'),
(1031, 'Vicentzo', 4, '* (chat log): acum cand am iesit.', '2021-05-11 16:39:59'),
(1032, 'Vicentzo', 4, '* (chat log): ti-a aratat 1/20?.', '2021-05-11 16:40:04'),
(1033, 'Vicentzo', 4, '* (chat log): ca gen atati au ramas.', '2021-05-11 16:40:07'),
(1034, 'mr.bunny', 2, '* (chat log): pai.', '2021-05-11 16:41:00'),
(1035, 'mr.bunny', 2, '* (chat log): eu nu sunt in arena.', '2021-05-11 16:41:02'),
(1036, 'mr.bunny', 2, '* (chat log): nu vezi?.', '2021-05-11 16:41:04'),
(1037, 'Vicentzo', 4, '* (chat log): coaie.', '2021-05-11 16:41:06'),
(1038, 'Vicentzo', 4, '* (chat log): ce iti spun eu.', '2021-05-11 16:41:07'),
(1039, 'Vicentzo', 4, '* (chat log): ca nu am pus arena.', '2021-05-11 16:41:10'),
(1040, 'mr.bunny', 2, '* (chat log): nu ama arma.', '2021-05-11 16:41:15'),
(1041, 'Vicentzo', 4, '* (chat log): iti arata cand am iesit.', '2021-05-11 16:41:15'),
(1042, 'Vicentzo', 4, '* (chat log): ca sunt 1/20?.', '2021-05-11 16:41:18'),
(1043, 'mr.bunny', 2, '* (chat log): pai zice ca sunt intr o arena.', '2021-05-11 16:41:28'),
(1044, 'mr.bunny', 2, '* (chat log): de painball.', '2021-05-11 16:41:30'),
(1045, 'Vicentzo', 4, '* (chat log): vai de pula mea.', '2021-05-11 16:41:36'),
(1046, 'Vicentzo', 4, '* (chat log): laso asa.', '2021-05-11 16:41:38'),
(1047, 'mr.bunny', 2, '* (chat log): vii voice?.', '2021-05-11 16:41:41'),
(1048, 'Vicentzo', 4, '* (chat log): sal kf.', '2021-05-11 16:44:37'),
(1049, 'mr.bunny', 2, '* (chat log): ai facut goto =)).', '2021-05-11 16:44:40'),
(1050, 'Vicentzo', 4, '* (chat log): da.', '2021-05-11 16:44:41'),
(1051, 'Vicentzo', 4, '* (chat log): era la for playerid, in loc de id.', '2021-05-11 16:44:45'),
(1052, 'Vicentzo', 4, '* (chat log): si verifica daca scaunu era ocupat il punea.', '2021-05-11 16:44:51'),
(1053, 'Vicentzo', 4, '* (chat log): in masina.', '2021-05-11 16:44:52'),
(1054, 'Vicentzo', 4, '* (chat log): acuma mere.', '2021-05-11 16:44:54'),
(1055, 'Vicentzo', 4, '* (chat log): si fi atent.', '2021-05-11 16:44:56'),
(1056, 'Vicentzo', 4, '* (chat log): stai.', '2021-05-11 16:44:57'),
(1057, 'AnDreeW', 36, '* (chat log): sus.', '2021-05-11 18:45:57'),
(1058, 'AnDreeW', 36, '* (chat log): unde sunt ideiler =]].', '2021-05-11 18:46:20'),
(1059, 'AnDreeW', 36, '* (chat log): era fain.', '2021-05-11 18:46:29'),
(1060, 'AnDreeW', 36, '* (chat log): system de futut.', '2021-05-11 18:46:33'),
(1061, 'AnDreeW', 36, '* (chat log): =]]]].', '2021-05-11 18:46:34'),
(1062, 'RoLEX', 7, '* (chat log): de speedomerter?.', '2021-05-11 18:46:39'),
(1063, 'AnDreeW', 36, '* (chat log): sau system de internet caffe.', '2021-05-11 18:46:40'),
(1064, 'RoLEX', 7, '* (chat log): =)).', '2021-05-11 18:46:41'),
(1065, 'RoLEX', 7, '* (chat log): vad.', '2021-05-11 18:46:42'),
(1066, 'AnDreeW', 36, '* (chat log): system de internet caffe.', '2021-05-11 18:46:45'),
(1067, 'AnDreeW', 36, '* (chat log): si gen.', '2021-05-11 18:46:46'),
(1068, 'AnDreeW', 36, '* (chat log): sa te dea real.', '2021-05-11 18:46:49'),
(1069, 'AnDreeW', 36, '* (chat log): pe chrome.', '2021-05-11 18:46:50'),
(1070, 'AnDreeW', 36, '* (chat log): =]]].', '2021-05-11 18:46:52'),
(1071, 'RoLEX', 7, '* (chat log): Bro.', '2021-05-11 18:46:53'),
(1072, 'RoLEX', 7, '* (chat log): noi am vrut sa facem leptop.', '2021-05-11 18:46:58'),
(1073, 'RoLEX', 7, '* (chat log): de unde.', '2021-05-11 18:46:59'),
(1074, 'RoLEX', 7, '* (chat log): sa ti cunperi.', '2021-05-11 18:47:02'),
(1075, 'RoLEX', 7, '* (chat log): masini.', '2021-05-11 18:47:03'),
(1076, 'RoLEX', 7, '* (chat log): sa nu mai fie.', '2021-05-11 18:47:05'),
(1077, 'RoLEX', 7, '* (chat log): ds.', '2021-05-11 18:47:06'),
(1078, 'AnDreeW', 36, '* (chat log): ca pe gta 5.', '2021-05-11 18:47:09'),
(1079, 'RoLEX', 7, '* (chat log): sa cumperi case.', '2021-05-11 18:47:09'),
(1080, 'AnDreeW', 36, '* (chat log): si asta e tare.', '2021-05-11 18:47:10'),
(1081, 'RoLEX', 7, '* (chat log): da.', '2021-05-11 18:47:11'),
(1082, 'RoLEX', 7, '* (chat log): exact.', '2021-05-11 18:47:13'),
(1083, 'RoLEX', 7, '* (chat log): dar zic ei.', '2021-05-11 18:47:15'),
(1084, 'RoLEX', 7, '* (chat log): ca consuma aiurea.', '2021-05-11 18:47:17'),
(1085, 'RoLEX', 7, '* (chat log): resurse.', '2021-05-11 18:47:20'),
(1086, 'RoLEX', 7, '* (chat log): multe.', '2021-05-11 18:47:21'),
(1087, 'RoLEX', 7, '* (chat log): si e adv....', '2021-05-11 18:47:24'),
(1088, 'RoLEX', 7, '* (chat log): ca iti dai seama ce greu e.', '2021-05-11 18:47:32'),
(1089, 'RoLEX', 7, '* (chat log): sa faci td ul.', '2021-05-11 18:47:35'),
(1090, 'RoLEX', 7, '* (chat log): si astea.', '2021-05-11 18:47:36'),
(1091, 'AnDreeW', 36, '* (chat log): un internet caffe in lv.', '2021-05-11 18:47:39'),
(1092, 'AnDreeW', 36, '* (chat log): era blana.', '2021-05-11 18:47:41'),
(1093, 'AnDreeW', 36, '* (chat log): cu mai multe pc.', '2021-05-11 18:47:42'),
(1094, 'RoLEX', 7, '* (chat log): dar o sa vezi ca sunt si al.', '2021-05-11 18:47:49'),
(1095, 'RoLEX', 7, '* (chat log): altele.', '2021-05-11 18:47:50'),
(1096, 'RoLEX', 7, '* (chat log): sistem de tatuaje frizerie card bancar.', '2021-05-11 18:47:57'),
(1097, 'RoLEX', 7, '* (chat log): buletin de la primarie.', '2021-05-11 18:48:02'),
(1098, 'RoLEX', 7, '* (chat log): misiuni ca in gta sa.', '2021-05-11 18:48:06'),
(1099, 'AnDreeW', 36, '* (chat log): o sa fim macar 100?.', '2021-05-11 18:48:06'),
(1100, 'RoLEX', 7, '* (chat log): Noi zicem ca da. Apropo.', '2021-05-11 18:48:14'),
(1101, 'RoLEX', 7, '* (chat log): o sa luam dedicat =)).', '2021-05-11 18:48:18'),
(1102, 'AnDreeW', 36, '* (chat log): sa nu luam flud.', '2021-05-11 18:48:24'),
(1103, 'RoLEX', 7, '* (chat log): nu d aia.', '2021-05-11 18:48:36'),
(1104, 'AnDreeW', 36, '* (chat log): poate ma baga si pe mine in staff buny.', '2021-05-11 18:48:36'),
(1105, 'RoLEX', 7, '* (chat log): Daca esti activ.', '2021-05-11 18:48:42'),
(1106, 'RoLEX', 7, '* (chat log): da.', '2021-05-11 18:48:43'),
(1107, 'RoLEX', 7, '* (chat log): te bagam.', '2021-05-11 18:48:45'),
(1108, 'AnDreeW', 36, '* (chat log): normal ca sunt .', '2021-05-11 18:48:51'),
(1109, 'AnDreeW', 36, '* (chat log): acu am terminat war.', '2021-05-11 18:48:55'),
(1110, 'RoLEX', 7, '* (chat log): vad =)).', '2021-05-11 18:48:56'),
(1111, 'AnDreeW', 36, '* (chat log): pe crowlend.', '2021-05-11 18:48:57'),
(1112, 'RoLEX', 7, '* (chat log): oo.', '2021-05-11 18:48:58'),
(1113, 'RoLEX', 7, '* (chat log): misto.', '2021-05-11 18:49:00'),
(1114, 'AnDreeW', 36, '* (chat log): ma doare in ceafa.', '2021-05-11 18:49:03'),
(1115, 'AnDreeW', 36, '* (chat log): era un retardat.', '2021-05-11 18:49:05'),
(1116, 'AnDreeW', 36, '* (chat log): care mai furat.', '2021-05-11 18:49:06'),
(1117, 'AnDreeW', 36, '* (chat log): 30 de kiluri.', '2021-05-11 18:49:08'),
(1118, 'RoLEX', 7, '* (chat log): =)).', '2021-05-11 18:49:11'),
(1119, 'AnDreeW', 36, '* (chat log): ii lasam low.', '2021-05-11 18:49:12'),
(1120, 'AnDreeW', 36, '* (chat log): el dadaea cu m4.', '2021-05-11 18:49:13'),
(1121, 'AnDreeW', 36, '* (chat log): dar o sa joc aici la war.', '2021-05-11 18:49:26'),
(1122, 'AnDreeW', 36, '* (chat log): nu mai e nv.', '2021-05-11 18:49:27'),
(1123, 'AnDreeW', 36, '* (chat log): de crowland.', '2021-05-11 18:49:29'),
(1124, 'AnDreeW', 36, '* (chat log): =]]].', '2021-05-11 18:49:30'),
(1125, 'AnDreeW', 36, '* (chat log): sper sa fie de lunga durata.', '2021-05-11 18:49:39'),
(1126, 'RoLEX', 7, '* (chat log): da.', '2021-05-11 18:50:52'),
(1127, 'RoLEX', 7, '* (chat log): =).', '2021-05-11 18:50:55'),
(1128, 'RoLEX', 7, '* (chat log): noi zicem ca va fi .', '2021-05-11 18:50:59'),
(1129, 'RoLEX', 7, '* (chat log): acum...', '2021-05-11 18:51:01'),
(1130, 'RoLEX', 7, '* (chat log): dumnezeu stie.', '2021-05-11 18:51:04'),
(1131, 'AnDreeW', 36, '* (chat log): stunt =]].', '2021-05-11 18:51:05'),
(1132, 'AnDreeW', 36, '* (chat log): am picat in picioare de la 9999m.', '2021-05-11 18:51:16'),
(1133, 'RoLEX', 7, '* (chat log): si apropo.', '2021-05-11 18:51:19'),
(1134, 'RoLEX', 7, '* (chat log): noi zicem.', '2021-05-11 18:51:23'),
(1135, 'RoLEX', 7, '* (chat log): cel putin eu =)).', '2021-05-11 18:51:26'),
(1136, 'RoLEX', 7, '* (chat log): zic sa l deschidem in vara cand se termina scoala.', '2021-05-11 18:51:35'),
(1137, 'RoLEX', 7, '* (chat log): atunci.', '2021-05-11 18:51:37'),
(1138, 'RoLEX', 7, '* (chat log): imd.', '2021-05-11 18:51:38'),
(1139, 'AnDreeW', 36, '* (chat log): mama.', '2021-05-11 18:51:40'),
(1140, 'AnDreeW', 36, '* (chat log): dureaza prea mult =]].', '2021-05-11 18:51:47'),
(1141, 'RoLEX', 7, '* (chat log): pai bro da tu vezi ca gm are bugs multe si sisteme nu s aproape deloc.', '2021-05-11 18:51:56'),
(1142, 'AnDreeW', 36, '* (chat log): pai gm burned.', '2021-05-11 18:52:02'),
(1143, 'RoLEX', 7, '* (chat log): si nu pot lucra mult scripterii.', '2021-05-11 18:52:04'),
(1144, 'AnDreeW', 36, '* (chat log): cati scripteri sunt?.', '2021-05-11 18:52:10'),
(1145, 'RoLEX', 7, '* (chat log): ce gm burned.', '2021-05-11 18:52:12'),
(1146, 'RoLEX', 7, '* (chat log): ?.', '2021-05-11 18:52:13'),
(1147, 'AnDreeW', 36, '* (chat log): asta e gm burned.', '2021-05-11 18:52:16'),
(1148, 'RoLEX', 7, '* (chat log): stii ca e de la 0.', '2021-05-11 18:52:17'),
(1149, 'RoLEX', 7, '* (chat log): ce ma.', '2021-05-11 18:52:18'),
(1150, 'RoLEX', 7, '* (chat log): ce gm burned visezi.', '2021-05-11 18:52:22'),
(1151, 'AnDreeW', 36, '* (chat log): asa am inteles =]]].', '2021-05-11 18:52:26'),
(1152, 'AnDreeW', 36, '* (chat log): de la vicentzo.', '2021-05-11 18:52:28'),
(1153, 'RoLEX', 7, '* (chat log): ba da tu nu stii de gluma?.', '2021-05-11 18:52:40'),
(1154, 'RoLEX', 7, '* (chat log): serios =)))).', '2021-05-11 18:52:43'),
(1155, 'AnDreeW', 36, '* (chat log): ba dha.', '2021-05-11 18:52:43'),
(1156, 'RoLEX', 7, '* (chat log): lol.', '2021-05-11 18:52:44'),
(1157, 'AnDreeW', 36, '* (chat log): =]]].', '2021-05-11 18:52:45'),
(1158, 'RoLEX', 7, '* (chat log): glumeste da l in ma sa =))).', '2021-05-11 18:52:52'),
(1159, 'RoLEX', 7, '* (chat log): nu gen serios.', '2021-05-11 18:52:56'),
(1160, 'RoLEX', 7, '* (chat log): acum.', '2021-05-11 18:52:56'),
(1161, 'AnDreeW', 36, '* (chat log): mai este multe comenzi.', '2021-05-11 18:52:58'),
(1162, 'AnDreeW', 36, '* (chat log): de bagat.', '2021-05-11 18:52:59'),
(1163, 'RoLEX', 7, '* (chat log): nu e burned....', '2021-05-11 18:52:59'),
(1164, 'RoLEX', 7, '* (chat log): pai asta zic.', '2021-05-11 18:53:03'),
(1165, 'AnDreeW', 36, '* (chat log):  nici /id nu e.', '2021-05-11 18:53:04'),
(1166, 'AnDreeW', 36, '* (chat log): =]]].', '2021-05-11 18:53:05'),
(1167, 'RoLEX', 7, '* (chat log): se vede ca i de la 0.', '2021-05-11 18:53:06'),
(1168, 'RoLEX', 7, '* (chat log): pai da.', '2021-05-11 18:53:08'),
(1169, 'RoLEX', 7, '* (chat log): exact.', '2021-05-11 18:53:09'),
(1170, 'RoLEX', 7, '* (chat log): iti zic eu ca burned le avea.', '2021-05-11 18:53:14'),
(1171, 'RoLEX', 7, '* (chat log): pe toate =)).', '2021-05-11 18:53:17'),
(1172, 'RoLEX', 7, '* (chat log): daca era.', '2021-05-11 18:53:21'),
(1173, 'AnDreeW', 36, '* (chat log): dc nu a inceput dp un burned.', '2021-05-11 18:53:22'),
(1174, 'AnDreeW', 36, '* (chat log): si nu isi mai batea capu atat.', '2021-05-11 18:53:26'),
(1175, 'RoLEX', 7, '* (chat log): Fiindca aveam unul deja si am zis dc nu.', '2021-05-11 18:53:34'),
(1176, 'RoLEX', 7, '* (chat log): deoarece copia n are valoare.', '2021-05-11 18:53:44'),
(1177, 'RoLEX', 7, '* (chat log): <3.', '2021-05-11 18:53:45'),
(1178, 'RoLEX', 7, '* (chat log): brb in 5 min.', '2021-05-11 18:53:49'),
(1179, 'AnDreeW', 36, '* (chat log): brb fac cerere de rank up.', '2021-05-11 18:54:08'),
(1180, 'AnDreeW', 36, '* (chat log): pe crouland.', '2021-05-11 18:54:10'),
(1181, 'AnDreeW', 36, '* (chat log): iau sio rank 2.', '2021-05-11 18:57:54'),
(1182, 'AnDreeW', 36, '* (chat log): poate iau lidar.', '2021-05-11 18:57:58'),
(1183, 'AnDreeW', 36, '* (chat log): bag pe pi.e.', '2021-05-11 18:58:10'),
(1184, 'AnDreeW', 36, '* (chat log): pile.', '2021-05-11 18:58:12'),
(1185, 'AnDreeW', 36, '* (chat log): =]].', '2021-05-11 18:58:13'),
(1186, 'RoLEX', 7, '* (chat log): =)))))))))))))))))).', '2021-05-11 18:58:19'),
(1187, 'RoLEX', 7, '* (chat log): bon.', '2021-05-11 18:58:23'),
(1188, 'RoLEX', 7, '* (chat log): =)).', '2021-05-11 18:58:24'),
(1189, 'RoLEX', 7, '* (chat log): da si cu speed.', '2021-05-11 18:58:30'),
(1190, 'RoLEX', 7, '* (chat log): maam.', '2021-05-11 18:58:36'),
(1191, 'RoLEX', 7, '* (chat log): =))).', '2021-05-11 18:58:38'),
(1192, 'AnDreeW', 36, '* (chat log): ok.', '2021-05-11 18:58:41'),
(1193, 'AnDreeW', 36, '* (chat log): cum ne mai intoarcem.', '2021-05-11 18:58:43'),
(1194, 'RoLEX', 7, '* (chat log): ff.', '2021-05-11 18:58:43'),
(1195, 'AnDreeW', 36, '* (chat log): =]]]]].', '2021-05-11 18:58:45'),
(1196, 'RoLEX', 7, '* (chat log): ne rugam la ingeri.', '2021-05-11 18:58:50'),
(1197, 'RoLEX', 7, '* (chat log): =))))).', '2021-05-11 18:58:52'),
(1198, 'AnDreeW', 36, '* (chat log): clar.', '2021-05-11 18:59:19'),
(1199, 'AnDreeW', 36, '* (chat log): pregatit.', '2021-05-11 18:59:33'),
(1200, 'AnDreeW', 36, '* (chat log): o sa iei crash.', '2021-05-11 18:59:35'),
(1201, 'AnDreeW', 36, '* (chat log): 30k km.', '2021-05-11 18:59:36'),
(1202, 'RoLEX', 7, '* (chat log): ggda.', '2021-05-11 19:00:12'),
(1203, 'RoLEX', 7, '* (chat log): ggg.', '2021-05-11 19:01:14'),
(1204, 'RoLEX', 7, '* (chat log): baa.', '2021-05-11 19:01:16'),
(1205, 'RoLEX', 7, '* (chat log): ne am dus pepl.', '2021-05-11 19:01:25'),
(1206, 'RoLEX', 7, '* (chat log): =))).', '2021-05-11 19:01:26'),
(1207, 'RoLEX', 7, '* (chat log): ne am dus pepl.', '2021-05-11 19:01:28'),
(1208, 'AnDreeW', 36, '* (chat log): ce faci ma.', '2021-05-11 19:01:28'),
(1209, 'RoLEX', 7, '* (chat log): =))).', '2021-05-11 19:01:30'),
(1210, 'AnDreeW', 36, '* (chat log): jaot.', '2021-05-11 19:01:40'),
(1211, 'AnDreeW', 36, '* (chat log): sus.', '2021-05-11 19:01:41'),
(1212, 'AnDreeW', 36, '* (chat log): taxi 2.', '2021-05-11 19:01:46'),
(1213, 'AnDreeW', 36, '* (chat log): speed.', '2021-05-11 19:01:47'),
(1214, 'AnDreeW', 36, '* (chat log): stii filmu ala.', '2021-05-11 19:01:50'),
(1215, 'AnDreeW', 36, '* (chat log): cu taxi.', '2021-05-11 19:01:51'),
(1216, 'AnDreeW', 36, '* (chat log): ?.', '2021-05-11 19:01:54'),
(1217, 'RoLEX', 7, '* (chat log): nu.', '2021-05-11 19:01:56'),
(1218, 'AnDreeW', 36, '* (chat log): taxi marseille.', '2021-05-11 19:01:58'),
(1219, 'AnDreeW', 36, '* (chat log): cauti asa pe gugal.', '2021-05-11 19:02:11'),
(1220, 'AnDreeW', 36, '* (chat log): taxi 3-2-1-4-5.', '2021-05-11 19:02:15'),
(1221, 'AnDreeW', 36, '* (chat log): w.', '2021-05-11 19:02:18'),
(1222, 'AnDreeW', 36, '* (chat log): da te jos.', '2021-05-11 19:02:27'),
(1223, 'AnDreeW', 36, '* (chat log): si urca iar.', '2021-05-11 19:02:28'),
(1224, 'AnDreeW', 36, '* (chat log): g.', '2021-05-11 19:02:31'),
(1225, 'AnDreeW', 36, '* (chat log): unde doriti sa ajungeti?.', '2021-05-11 19:02:42'),
(1226, 'RoLEX', 7, '* (chat log): la sistemu de curve.', '2021-05-11 19:03:10'),
(1227, 'RoLEX', 7, '* (chat log): puteti.', '2021-05-11 19:03:13'),
(1228, 'RoLEX', 7, '* (chat log): ?.', '2021-05-11 19:03:14'),
(1229, 'AnDreeW', 36, '* (chat log): unde ie systemu.', '2021-05-11 19:03:18'),
(1230, 'RoLEX', 7, '* (chat log): nu e.', '2021-05-11 19:03:21'),
(1231, 'RoLEX', 7, '* (chat log): =))).', '2021-05-11 19:03:22'),
(1232, 'AnDreeW', 36, '* (chat log): tu esti curva.', '2021-05-11 19:03:25'),
(1233, 'AnDreeW', 36, '* (chat log): si eu.', '2021-05-11 19:03:26'),
(1234, 'AnDreeW', 36, '* (chat log): sunt.', '2021-05-11 19:03:27'),
(1235, 'AnDreeW', 36, '* (chat log): pestele.', '2021-05-11 19:03:28'),
(1236, 'AnDreeW', 36, '* (chat log): =]]].', '2021-05-11 19:03:31'),
(1237, 'AnDreeW', 36, '* (chat log): in picioare.', '2021-05-11 19:03:49'),
(1238, 'AnDreeW', 36, '* (chat log): picam.', '2021-05-11 19:03:50'),
(1239, 'AnDreeW', 36, '* (chat log): asa sus.', '2021-05-11 19:04:01'),
(1240, 'AnDreeW', 36, '* (chat log): suntem.', '2021-05-11 19:04:02'),
(1241, 'AnDreeW', 36, '* (chat log): =]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]].', '2021-05-11 19:04:11'),
(1242, 'AnDreeW', 36, '* (chat log): ce bine am ppicat.', '2021-05-11 19:04:14'),
(1243, 'RoLEX', 7, '* (chat log):  .', '2021-05-11 19:04:21'),
(1244, 'RoLEX', 7, '* (chat log): ba.', '2021-05-11 19:04:23'),
(1245, 'AnDreeW', 36, '* (chat log): da.', '2021-05-11 19:04:24'),
(1246, 'RoLEX', 7, '* (chat log): BAAAAAA.', '2021-05-11 19:04:27'),
(1247, 'RoLEX', 7, '* (chat log): TU MI IEI BANI.', '2021-05-11 19:04:32'),
(1248, 'RoLEX', 7, '* (chat log): IN MORTII TAI.', '2021-05-11 19:04:35'),
(1249, 'RoLEX', 7, '* (chat log): DE TAXIMETRIST.', '2021-05-11 19:04:39'),
(1250, 'RoLEX', 7, '* (chat log): PARLIT.', '2021-05-11 19:04:41'),
(1251, 'AnDreeW', 36, '* (chat log): Ma numesc taxi speed.', '2021-05-11 19:04:42'),
(1252, 'RoLEX', 7, '* (chat log): huaaa.', '2021-05-11 19:04:42'),
(1253, 'RoLEX', 7, '* (chat log): =)))).', '2021-05-11 19:04:45'),
(1254, 'AnDreeW', 36, '* (chat log): si am venit sa iti iau bani.', '2021-05-11 19:04:46'),
(1255, 'RoLEX', 7, '* (chat log): vrau banii inapoi.', '2021-05-11 19:04:50'),
(1256, 'AnDreeW', 36, '* (chat log): intr-o secunda.', '2021-05-11 19:04:53'),
(1257, 'AnDreeW', 36, '* (chat log): te duc in celalalt oras.', '2021-05-11 19:04:56'),
(1258, 'AnDreeW', 36, '* (chat log): urca sus.', '2021-05-11 19:05:06'),
(1259, 'corbul', 8, '* (chat log): salut.', '2021-05-11 19:05:07'),
(1260, 'AnDreeW', 36, '* (chat log): sa ai de taxi.', '2021-05-11 19:05:19'),
(1261, 'AnDreeW', 36, '* (chat log): dai g.', '2021-05-11 19:05:20'),
(1262, 'corbul', 8, '* (chat log): multumesc.', '2021-05-11 19:05:29'),
(1263, 'RoLEX', 7, '* (chat log): pm.', '2021-05-11 19:05:32'),
(1264, 'RoLEX', 7, '* (chat log): nu poti corbu.', '2021-05-11 19:05:45'),
(1265, 'corbul', 8, '* (chat log): ok.', '2021-05-11 19:05:51'),
(1266, 'RoLEX', 7, '* (chat log): intra pe discord.', '2021-05-11 19:05:55'),
(1267, 'RoLEX', 7, '* (chat log): st.', '2021-05-11 19:05:56'),
(1268, 'AnDreeW', 36, '* (chat log): clar.', '2021-05-11 19:05:58'),
(1269, 'RoLEX', 7, '* (chat log): sa ti dau link.', '2021-05-11 19:05:59'),
(1270, 'RoLEX', 7, '* (chat log): =)))).', '2021-05-11 19:06:01'),
(1271, 'AnDreeW', 36, '* (chat log): am ajuns la spawn.', '2021-05-11 19:06:08'),
(1272, 'AnDreeW', 36, '* (chat log): intr o secunda.', '2021-05-11 19:06:10'),
(1273, 'RoLEX', 7, '* (chat log): https://discord.gg/adnQGv8nVh.', '2021-05-11 19:06:19'),
(1274, 'RoLEX', 7, '* (chat log): baga asta.', '2021-05-11 19:06:21'),
(1275, 'corbul', 8, '* (chat log): corbul#2934 si dami acolo.', '2021-05-11 19:06:33'),
(1276, 'RoLEX', 7, '* (chat log): k.', '2021-05-11 19:06:36'),
(1277, 'AnDreeW', 36, '* (chat log): de unde ai parola?.', '2021-05-11 19:06:41'),
(1278, 'AnDreeW', 36, '* (chat log): ca tu nu esti pe sv de dis.', '2021-05-11 19:06:44'),
(1279, 'corbul', 8, '* (chat log): nu e parola.', '2021-05-11 19:06:48'),
(1280, 'RoLEX', 7, '* (chat log): nu are parola.', '2021-05-11 19:06:48'),
(1281, 'RoLEX', 7, '* (chat log): a scos o vicentzo.', '2021-05-11 19:06:53'),
(1282, 'AnDreeW', 36, '* (chat log): aa.', '2021-05-11 19:06:53'),
(1283, 'RoLEX', 7, '* (chat log): sa testeze cv.', '2021-05-11 19:06:57'),
(1284, 'AnDreeW', 36, '* (chat log): Sa stii ca.', '2021-05-11 19:07:11'),
(1285, 'AnDreeW', 36, '* (chat log): Parola este.', '2021-05-11 19:07:13'),
(1286, 'AnDreeW', 36, '* (chat log): BlackPussy.', '2021-05-11 19:07:15'),
(1287, 'AnDreeW', 36, '* (chat log): wrong.', '2021-05-11 19:07:17'),
(1288, 'corbul', 8, '* (chat log): ok.', '2021-05-11 19:07:24'),
(1289, 'AnDreeW', 36, '* (chat log): corbule.', '2021-05-11 19:07:40'),
(1290, 'AnDreeW', 36, '* (chat log): Sava?.', '2021-05-11 19:07:42'),
(1291, 'corbul', 8, '* (chat log): lasa franceza cas bata.', '2021-05-11 19:07:54'),
(1292, 'AnDreeW', 36, '* (chat log): de unde sti ca ii franceza.', '2021-05-11 19:08:00'),
(1293, 'AnDreeW', 36, '* (chat log): sava = esti bine?.', '2021-05-11 19:08:11'),
(1294, 'AnDreeW', 36, '* (chat log): zi.', '2021-05-11 19:08:12'),
(1295, 'AnDreeW', 36, '* (chat log): esti bine?.', '2021-05-11 19:08:14'),
(1296, 'corbul', 8, '* (chat log): da.', '2021-05-11 19:08:15'),
(1297, 'AnDreeW', 36, '* (chat log): milsugi.', '2021-05-11 19:08:16'),
(1298, 'corbul', 8, '* (chat log): sunt.', '2021-05-11 19:08:17'),
(1299, 'AnDreeW', 36, '* (chat log): ok.', '2021-05-11 19:08:18'),
(1300, 'corbul', 8, '* (chat log): ai zis dupa ce am zis da.', '2021-05-11 19:08:27'),
(1301, 'RoLEX', 7, '* (chat log): teaca.', '2021-05-11 19:08:34'),
(1302, 'AnDreeW', 36, '* (chat log): daca nu zici da iti dau kik.', '2021-05-11 19:08:35'),
(1303, 'AnDreeW', 36, '* (chat log): mil sugi?.', '2021-05-11 19:08:37'),
(1304, 'AnDreeW', 36, '* (chat log): si mie.', '2021-05-11 19:08:40'),
(1305, 'AnDreeW', 36, '* (chat log): si lui rolex.', '2021-05-11 19:08:42'),
(1306, 'AnDreeW', 36, '* (chat log): zi da.', '2021-05-11 19:08:44'),
(1307, 'AnDreeW', 36, '* (chat log): si iti dam lider.', '2021-05-11 19:08:46'),
(1308, 'AnDreeW', 36, '* (chat log): si helpar.', '2021-05-11 19:08:51'),
(1309, 'corbul', 8, '* (chat log): da in cur/gura nu vr?.', '2021-05-11 19:08:53'),
(1310, 'AnDreeW', 36, '* (chat log): aa asa faci nu.', '2021-05-11 19:08:59'),
(1311, 'AnDreeW', 36, '* (chat log): nu vrei lider.', '2021-05-11 19:09:01'),
(1312, 'AnDreeW', 36, '* (chat log): ?.', '2021-05-11 19:09:01'),
(1313, 'corbul', 8, '* (chat log): nu sunt gay.', '2021-05-11 19:09:07'),
(1314, 'AnDreeW', 36, '* (chat log): ne sugi ?.', '2021-05-11 19:09:13'),
(1315, 'AnDreeW', 36, '* (chat log): daca zici da.', '2021-05-11 19:09:15'),
(1316, 'AnDreeW', 36, '* (chat log): iti dam si lider.', '2021-05-11 19:09:17'),
(1317, 'AnDreeW', 36, '* (chat log): si helper.', '2021-05-11 19:09:19'),
(1318, 'AnDreeW', 36, '* (chat log): sus.', '2021-05-11 19:09:42'),
(1319, 'AnDreeW', 36, '* (chat log): bobita.', '2021-05-11 19:09:43'),
(1320, 'AnDreeW', 36, '* (chat log): avem nevoie de ajutorul tau.', '2021-05-11 19:09:56'),
(1321, 'AnDreeW', 36, '* (chat log): corbule.', '2021-05-11 19:09:57'),
(1322, 'corbul', 8, '* (chat log): ?.', '2021-05-11 19:10:01'),
(1323, 'AnDreeW', 36, '* (chat log): trebuie sa facem system de curve.', '2021-05-11 19:10:02'),
(1324, 'AnDreeW', 36, '* (chat log): si tu trebuie sa fi curva.', '2021-05-11 19:10:05'),
(1325, 'AnDreeW', 36, '* (chat log): iar noi pesti.', '2021-05-11 19:10:07'),
(1326, 'corbul', 8, '* (chat log): ba coaie cati ani ai?.', '2021-05-11 19:10:20'),
(1327, 'AnDreeW', 36, '* (chat log): 12.', '2021-05-11 19:10:23'),
(1328, 'AnDreeW', 36, '* (chat log): frt.', '2021-05-11 19:10:23'),
(1329, 'corbul', 8, '* (chat log): de esti asa de toxic.', '2021-05-11 19:10:25'),
(1330, 'AnDreeW', 36, '* (chat log): mia crescut si mie un floc.', '2021-05-11 19:10:31'),
(1331, 'AnDreeW', 36, '* (chat log): si sunt toxic.', '2021-05-11 19:10:33'),
(1332, 'corbul', 8, '* (chat log): tundel dal drq.', '2021-05-11 19:10:41'),
(1333, 'RoLEX', 7, '* (chat log): Corbule, glumeste =))) nu stii de gluma.', '2021-05-11 19:10:46'),
(1334, 'corbul', 8, '* (chat log): ba DA.', '2021-05-11 19:10:55'),
(1335, 'corbul', 8, '* (chat log): ce naiba.', '2021-05-11 19:10:58'),
(1336, 'AnDreeW', 36, '* (chat log): sus fa.', '2021-05-11 19:11:06'),
(1337, 'AnDreeW', 36, '* (chat log): corbule.', '2021-05-11 19:11:13'),
(1338, 'AnDreeW', 36, '* (chat log): in genuchi.', '2021-05-11 19:11:14'),
(1339, 'AnDreeW', 36, '* (chat log): hai ma.', '2021-05-11 19:11:19'),
(1340, 'AnDreeW', 36, '* (chat log): sus odata.', '2021-05-11 19:11:20'),
(1341, 'AnDreeW', 36, '* (chat log): ca te leg de capota.', '2021-05-11 19:11:22'),
(1342, 'RoLEX', 7, '* (chat log): st.', '2021-05-11 19:11:25'),
(1343, 'RoLEX', 7, '* (chat log): baa.', '2021-05-11 19:11:26'),
(1344, 'AnDreeW', 36, '* (chat log): ce id are sultan.', '2021-05-11 19:11:30'),
(1345, 'AnDreeW', 36, '* (chat log): sa intram toti.', '2021-05-11 19:11:32'),
(1346, 'AnDreeW', 36, '* (chat log): ah.', '2021-05-11 19:11:34'),
(1347, 'AnDreeW', 36, '* (chat log): se pisa in gura ta.', '2021-05-11 19:11:36'),
(1348, 'AnDreeW', 36, '* (chat log): corbule.', '2021-05-11 19:11:37'),
(1349, 'AnDreeW', 36, '* (chat log): corb nu este un animal?.', '2021-05-11 19:11:45'),
(1350, 'corbul', 8, '* (chat log): date jos.', '2021-05-11 19:11:51'),
(1351, 'AnDreeW', 36, '* (chat log): animalul sexos.', '2021-05-11 19:11:53'),
(1352, 'AnDreeW', 36, '* (chat log): ce buci.', '2021-05-11 19:12:02'),
(1353, 'AnDreeW', 36, '* (chat log): misto ai.', '2021-05-11 19:12:03'),
(1354, 'AnDreeW', 36, '* (chat log): alatura te rolex.', '2021-05-11 19:12:09'),
(1355, 'corbul', 8, '* (chat log): pupama intre ele.', '2021-05-11 19:12:11'),
(1356, 'corbul', 8, '* (chat log): ca nu mai sters.', '2021-05-11 19:12:17'),
(1357, 'AnDreeW', 36, '* (chat log): hai sus role.', '2021-05-11 19:12:21'),
(1358, 'corbul', 8, '* (chat log): =).', '2021-05-11 19:12:21');
INSERT INTO `server_chat_logs` (`ID`, `PlayerName`, `PlayerID`, `ChatText`, `Time`) VALUES
(1359, 'RoLEX', 7, '* (chat log): a bicenttzop.', '2021-05-11 19:12:33'),
(1360, 'corbul', 8, '* (chat log): dami un sultan.', '2021-05-11 19:12:43'),
(1361, 'AnDreeW', 36, '* (chat log): cf fa.', '2021-05-11 19:12:44'),
(1362, 'corbul', 8, '* (chat log): 560.', '2021-05-11 19:12:50'),
(1363, 'AnDreeW', 36, '* (chat log): dc fuge ma ala.', '2021-05-11 19:12:51'),
(1364, 'Vicentzo', 4, '* (chat log): re bos.', '2021-05-11 19:13:13'),
(1365, 'corbul', 8, '* (chat log): da is buguit.', '2021-05-11 19:13:42'),
(1366, 'RoLEX', 7, '* (chat log): sus.', '2021-05-11 19:13:50'),
(1367, 'RoLEX', 7, '* (chat log): corbule.', '2021-05-11 19:13:51'),
(1368, 'Vicentzo', 4, '* (chat log): corbule.', '2021-05-11 19:14:00'),
(1369, 'Vicentzo', 4, '* (chat log): vrei sa fim prieteni.', '2021-05-11 19:14:03'),
(1370, 'AnDreeW', 36, '* (chat log): susss.', '2021-05-11 19:14:03'),
(1371, 'Vicentzo', 4, '* (chat log): am 7 ani.', '2021-05-11 19:14:04'),
(1372, 'RoLEX', 7, '* (chat log): .', '2021-05-11 19:14:06'),
(1373, 'AnDreeW', 36, '* (chat log): mi sa sculat.', '2021-05-11 19:14:09'),
(1374, 'AnDreeW', 36, '* (chat log): dati g.', '2021-05-11 19:14:10'),
(1375, 'corbul', 8, '* (chat log): dami m8.', '2021-05-11 19:14:11'),
(1376, 'AnDreeW', 36, '* (chat log): dai g.', '2021-05-11 19:14:19'),
(1377, 'AnDreeW', 36, '* (chat log): corbule.', '2021-05-11 19:14:20'),
(1378, 'AnDreeW', 36, '* (chat log): masina mia.', '2021-05-11 19:14:31'),
(1379, 'Vicentzo', 4, '* (chat log): dai ba g.', '2021-05-11 19:14:32'),
(1380, 'AnDreeW', 36, '* (chat log): corbuke.', '2021-05-11 19:14:33'),
(1381, 'AnDreeW', 36, '* (chat log): nu fi rau.', '2021-05-11 19:14:35'),
(1382, 'AnDreeW', 36, '* (chat log): nu intelegi.', '2021-05-11 19:14:40'),
(1383, 'corbul', 8, '* (chat log): dami un sultan pls.', '2021-05-11 19:14:44'),
(1384, 'AnDreeW', 36, '* (chat log): dai g.', '2021-05-11 19:14:47'),
(1385, 'Vicentzo', 4, '* (chat log): lasa-l ma pe el.', '2021-05-11 19:14:48'),
(1386, 'corbul', 8, '* (chat log): ba asta e  m8.', '2021-05-11 19:14:50'),
(1387, 'Vicentzo', 4, '* (chat log): sa conduca.', '2021-05-11 19:14:50'),
(1388, 'AnDreeW', 36, '* (chat log): condu ma.', '2021-05-11 19:14:52'),
(1389, 'AnDreeW', 36, '* (chat log): pizda praosta.', '2021-05-11 19:14:53'),
(1390, 'Vicentzo', 4, '* (chat log): condu corbule.', '2021-05-11 19:14:55'),
(1391, 'AnDreeW', 36, '* (chat log): Domnule corb.', '2021-05-11 19:15:06'),
(1392, 'corbul', 8, '* (chat log): lingema la pizada.', '2021-05-11 19:15:06'),
(1393, 'corbul', 8, '* (chat log): lingema la pizda.', '2021-05-11 19:15:10'),
(1394, 'Vicentzo', 4, '* (chat log): stai ce.', '2021-05-11 19:15:10'),
(1395, 'Vicentzo', 4, '* (chat log): esti fata.', '2021-05-11 19:15:11'),
(1396, 'Vicentzo', 4, '* (chat log): ?.', '2021-05-11 19:15:12'),
(1397, 'corbul', 8, '* (chat log): nu ma.', '2021-05-11 19:15:15'),
(1398, 'Vicentzo', 4, '* (chat log): si atunci.', '2021-05-11 19:15:18'),
(1399, 'Vicentzo', 4, '* (chat log): esti gay.', '2021-05-11 19:15:20'),
(1400, 'Vicentzo', 4, '* (chat log): ce pula me.', '2021-05-11 19:15:21'),
(1401, 'Vicentzo', 4, '* (chat log): eu am 7 ani.', '2021-05-11 19:15:23'),
(1402, 'corbul', 8, '* (chat log): sunt scroafa.', '2021-05-11 19:15:23'),
(1403, 'RoLEX', 7, '* (chat log): nu.', '2021-05-11 19:15:24'),
(1404, 'AnDreeW', 36, '* (chat log): ai intele pe pizda?.', '2021-05-11 19:15:25'),
(1405, 'RoLEX', 7, '* (chat log): e lazbi.', '2021-05-11 19:15:26'),
(1406, 'AnDreeW', 36, '* (chat log): inele.', '2021-05-11 19:15:27'),
(1407, 'AnDreeW', 36, '* (chat log): ti ai bagat inele in pizda.', '2021-05-11 19:15:30'),
(1408, 'AnDreeW', 36, '* (chat log): =]]]].', '2021-05-11 19:15:32'),
(1409, 'corbul', 8, '* (chat log): sunt baiat.', '2021-05-11 19:15:37'),
(1410, 'Vicentzo', 4, '* (chat log): si esti gay.', '2021-05-11 19:15:40'),
(1411, 'AnDreeW', 36, '* (chat log): esti bisexual?.', '2021-05-11 19:15:41'),
(1412, 'RoLEX', 7, '* (chat log): lazbi?.', '2021-05-11 19:15:41'),
(1413, 'AnDreeW', 36, '* (chat log): =]]].', '2021-05-11 19:15:45'),
(1414, 'AnDreeW', 36, '* (chat log): transexual.', '2021-05-11 19:15:47'),
(1415, 'AnDreeW', 36, '* (chat log): asta are si pula si pizda.', '2021-05-11 19:15:54'),
(1416, 'AnDreeW', 36, '* (chat log): mixate.', '2021-05-11 19:15:56'),
(1417, 'corbul', 8, '* (chat log): sugema ma.', '2021-05-11 19:16:02'),
(1418, 'AnDreeW', 36, '* (chat log): sa te sug.', '2021-05-11 19:16:06'),
(1419, 'AnDreeW', 36, '* (chat log): de puta.', '2021-05-11 19:16:07'),
(1420, 'AnDreeW', 36, '* (chat log): ?.', '2021-05-11 19:16:08'),
(1421, 'corbul', 8, '* (chat log): =))).', '2021-05-11 19:16:09'),
(1422, 'AnDreeW', 36, '* (chat log): aia de 0.1cm.', '2021-05-11 19:16:10'),
(1423, 'RoLEX', 7, '* (chat log): nici atat.', '2021-05-11 19:16:16'),
(1424, 'RoLEX', 7, '* (chat log): nu are.', '2021-05-11 19:16:19'),
(1425, 'AnDreeW', 36, '* (chat log): nici intre degete nu pot sa o tin.', '2021-05-11 19:16:19'),
(1426, 'Vicentzo', 4, '* (chat log): corbule.', '2021-05-11 19:16:22'),
(1427, 'Vicentzo', 4, '* (chat log): eu sunt fata.', '2021-05-11 19:16:24'),
(1428, 'Vicentzo', 4, '* (chat log): am 9 ani.', '2021-05-11 19:16:25'),
(1429, 'AnDreeW', 36, '* (chat log): tio dau pe alu rolex.', '2021-05-11 19:16:25'),
(1430, 'Vicentzo', 4, '* (chat log): vrei sa imi fi iubit.', '2021-05-11 19:16:28'),
(1431, 'AnDreeW', 36, '* (chat log): are 20cm.', '2021-05-11 19:16:28'),
(1432, 'AnDreeW', 36, '* (chat log): daca tio baga pe gat.', '2021-05-11 19:16:31'),
(1433, 'Vicentzo', 4, '* (chat log): vrei sa imi fi iubit corbule.', '2021-05-11 19:16:33'),
(1434, 'Vicentzo', 4, '* (chat log): sunt fata.', '2021-05-11 19:16:36'),
(1435, 'RoLEX', 7, '* (chat log): titan gel boss.', '2021-05-11 19:16:36'),
(1436, 'Vicentzo', 4, '* (chat log): am 9 ani.', '2021-05-11 19:16:37'),
(1437, 'corbul', 8, '* (chat log): ce drq ca ma bagi la parnaie.', '2021-05-11 19:16:49'),
(1438, 'AnDreeW', 36, '* (chat log): Corbule, buna.', '2021-05-11 19:16:52'),
(1439, 'AnDreeW', 36, '* (chat log): sunt raluca.', '2021-05-11 19:16:55'),
(1440, 'Vicentzo', 4, '* (chat log): da dar si tu esti copil.', '2021-05-11 19:16:57'),
(1441, 'Vicentzo', 4, '* (chat log): daca suntem amandoi de acord.', '2021-05-11 19:17:00'),
(1442, 'Vicentzo', 4, '* (chat log): nu intram.', '2021-05-11 19:17:02'),
(1443, 'AnDreeW', 36, '* (chat log): sunt pe contul fratelui meu.', '2021-05-11 19:17:02'),
(1444, 'corbul', 8, '* (chat log): am 14 ani.', '2021-05-11 19:17:04'),
(1445, 'AnDreeW', 36, '* (chat log): vrei sa fi iubitu meu.', '2021-05-11 19:17:04'),
(1446, 'AnDreeW', 36, '* (chat log): TACETI IN PIZDA MEA.', '2021-05-11 19:17:08'),
(1447, 'Vicentzo', 4, '* (chat log): ce tare si eu am 15 ani.', '2021-05-11 19:17:09'),
(1448, 'AnDreeW', 36, '* (chat log): CA VORBESC CU GAGICAMIU.', '2021-05-11 19:17:11'),
(1449, 'Vicentzo', 4, '* (chat log): sunt foarte buna.', '2021-05-11 19:17:12'),
(1450, 'AnDreeW', 36, '* (chat log): corbule.', '2021-05-11 19:17:19'),
(1451, 'RoLEX', 7, '* (chat log): taci andew.', '2021-05-11 19:17:21'),
(1452, 'corbul', 8, '* (chat log): ?.', '2021-05-11 19:17:21'),
(1453, 'AnDreeW', 36, '* (chat log): esti viata mea.', '2021-05-11 19:17:22'),
(1454, 'RoLEX', 7, '* (chat log): andrew.', '2021-05-11 19:17:23'),
(1455, 'AnDreeW', 36, '* (chat log): vrei sa facem sex oral.', '2021-05-11 19:17:25'),
(1456, 'corbul', 8, '* (chat log): ba m8 asta sboara.', '2021-05-11 19:17:33'),
(1457, 'AnDreeW', 36, '* (chat log): ups.', '2021-05-11 19:17:38'),
(1458, 'Vicentzo', 4, '* (chat log): ba corbule.', '2021-05-11 19:17:39'),
(1459, 'AnDreeW', 36, '* (chat log): ce nab e.', '2021-05-11 19:17:46'),
(1460, 'AnDreeW', 36, '* (chat log): =]]]].', '2021-05-11 19:17:48'),
(1461, 'Vicentzo', 4, '* (chat log): ahahahaha.', '2021-05-11 19:17:48'),
(1462, 'AnDreeW', 36, '* (chat log): baaa.', '2021-05-11 19:17:51'),
(1463, 'AnDreeW', 36, '* (chat log): ne am rasturnat.', '2021-05-11 19:17:52'),
(1464, 'AnDreeW', 36, '* (chat log): salot.', '2021-05-11 19:18:02'),
(1465, 'Vicentzo', 4, '* (chat log): salut.', '2021-05-11 19:18:04'),
(1466, 'AnDreeW', 36, '* (chat log): ce faci domnisoara.', '2021-05-11 19:18:06'),
(1467, 'Vicentzo', 4, '* (chat log): i-ati zborul te rog.', '2021-05-11 19:18:07'),
(1468, 'AnDreeW', 36, '* (chat log): du ma si pe mn in las vegos.', '2021-05-11 19:18:09'),
(1469, 'Vicentzo', 4, '* (chat log): te duc in pizda mati.', '2021-05-11 19:18:14'),
(1470, 'Vicentzo', 4, '* (chat log): vrei.', '2021-05-11 19:18:14'),
(1471, 'AnDreeW', 36, '* (chat log): in pizda lu gagicata.', '2021-05-11 19:18:19'),
(1472, 'AnDreeW', 36, '* (chat log): intru adanc.', '2021-05-11 19:18:20'),
(1473, 'Vicentzo', 4, '* (chat log): urca ma corbule.', '2021-05-11 19:18:33'),
(1474, 'Vicentzo', 4, '* (chat log): punemiasi .', '2021-05-11 19:18:35'),
(1475, 'Vicentzo', 4, '* (chat log): urca sus.', '2021-05-11 19:18:37'),
(1476, 'corbul', 8, '* (chat log): la mine este m8.', '2021-05-11 19:18:44'),
(1477, 'Vicentzo', 4, '* (chat log): da nimeni nu tia antrebat.', '2021-05-11 19:18:50'),
(1478, 'Vicentzo', 4, '* (chat log): ez win.', '2021-05-11 19:19:14'),
(1479, 'Vicentzo', 4, '* (chat log): by antiexe.', '2021-05-11 19:19:17'),
(1480, 'RoLEX', 7, '* (chat log): baa.', '2021-05-11 19:19:18'),
(1481, 'RoLEX', 7, '* (chat log): ma ta.', '2021-05-11 19:19:20'),
(1482, 'RoLEX', 7, '* (chat log): vr /speed mane.', '2021-05-11 19:19:24'),
(1483, 'AnDreeW', 36, '* (chat log): dami.', '2021-05-11 19:19:27'),
(1484, 'AnDreeW', 36, '* (chat log):  dami ba.', '2021-05-11 19:19:30'),
(1485, 'AnDreeW', 36, '* (chat log): spedu.', '2021-05-11 19:19:32'),
(1486, 'RoLEX', 7, '* (chat log): /.', '2021-05-11 19:19:33'),
(1487, 'Vicentzo', 4, '* (chat log): tinete ba.', '2021-05-11 19:19:34'),
(1488, 'RoLEX', 7, '* (chat log): wtf.', '2021-05-11 19:19:35'),
(1489, 'AnDreeW', 36, '* (chat log): in pizda mati.', '2021-05-11 19:19:35'),
(1490, 'Vicentzo', 4, '* (chat log): corbu puli mele.', '2021-05-11 19:19:36'),
(1491, 'AnDreeW', 36, '* (chat log): baaaaa.', '2021-05-11 19:19:38'),
(1492, 'AnDreeW', 36, '* (chat log): ai alge la pizda.', '2021-05-11 19:19:41'),
(1493, 'AnDreeW', 36, '* (chat log): dami speedu.', '2021-05-11 19:19:48'),
(1494, 'Vicentzo', 4, '* (chat log): tintete ba corbu puli.', '2021-05-11 19:19:49'),
(1495, 'AnDreeW', 36, '* (chat log): ca te bat.', '2021-05-11 19:19:49'),
(1496, 'AnDreeW', 36, '* (chat log): cu pula peste cap.', '2021-05-11 19:19:52'),
(1497, 'RoLEX', 7, '* (chat log): CORBU IN PULA MEA DE CORB CORBIMI AI SALIVA INTRE COAIE.', '2021-05-11 19:20:01'),
(1498, 'AnDreeW', 36, '* (chat log): dami spedu.', '2021-05-11 19:20:12'),
(1499, 'AnDreeW', 36, '* (chat log): =]]]].', '2021-05-11 19:20:14'),
(1500, 'corbul', 8, '* (chat log): a ba.', '2021-05-11 19:20:25'),
(1501, 'AnDreeW', 36, '* (chat log): coaie asta e surfly?.', '2021-05-11 19:20:27'),
(1502, 'RoLEX', 7, '* (chat log): nu.', '2021-05-11 19:20:30'),
(1503, 'Vicentzo', 4, '* (chat log): nu.', '2021-05-11 19:20:31'),
(1504, 'RoLEX', 7, '* (chat log): e fly.', '2021-05-11 19:20:31'),
(1505, 'RoLEX', 7, '* (chat log): e pule n cur.', '2021-05-11 19:20:34'),
(1506, 'RoLEX', 7, '* (chat log): pizde n trecoaie.', '2021-05-11 19:20:39'),
(1507, 'AnDreeW', 36, '* (chat log): sai fie lui visentzo in cur.', '2021-05-11 19:20:41'),
(1508, 'AnDreeW', 36, '* (chat log): lol.', '2021-05-11 19:21:34'),
(1509, 'AnDreeW', 36, '* (chat log): o disparut.', '2021-05-11 19:21:36'),
(1510, 'AnDreeW', 36, '* (chat log): kilometraju.', '2021-05-11 19:21:38'),
(1511, 'RoLEX', 7, '* (chat log): pai da.', '2021-05-11 19:21:40'),
(1512, 'RoLEX', 7, '* (chat log): e bug uit.', '2021-05-11 19:21:42'),
(1513, 'Vicentzo', 4, '* (chat log): SUIE MA.', '2021-05-11 19:21:47'),
(1514, 'RoLEX', 7, '* (chat log): trb sa l faca bunny.', '2021-05-11 19:21:48'),
(1515, 'AnDreeW', 36, '* (chat log): BAAAA.', '2021-05-11 19:21:50'),
(1516, 'Vicentzo', 4, '* (chat log): CORBU PULI.', '2021-05-11 19:21:51'),
(1517, 'AnDreeW', 36, '* (chat log): DAMI SPEEDU.', '2021-05-11 19:21:52'),
(1518, 'corbul', 8, '* (chat log): ma mananca pizada.', '2021-05-11 19:21:52'),
(1519, 'RoLEX', 7, '* (chat log): fa.', '2021-05-11 19:21:57'),
(1520, 'RoLEX', 7, '* (chat log): corbuke.', '2021-05-11 19:21:59'),
(1521, 'corbul', 8, '* (chat log): ?.', '2021-05-11 19:22:01'),
(1522, 'RoLEX', 7, '* (chat log): vi sa te fut in pizda.', '2021-05-11 19:22:05'),
(1523, 'RoLEX', 7, '* (chat log): ?.', '2021-05-11 19:22:06'),
(1524, 'AnDreeW', 36, '* (chat log): =]]]].', '2021-05-11 19:22:09'),
(1525, 'corbul', 8, '* (chat log): daca dai admin 6 s.', '2021-05-11 19:22:13'),
(1526, 'corbul', 8, '* (chat log): daca dai admin 6 DA.', '2021-05-11 19:22:16'),
(1527, 'Vicentzo', 4, '* (chat log): OK ORICADN.', '2021-05-11 19:22:19'),
(1528, 'AnDreeW', 36, '* (chat log): DAMI ADMINU COI MIC.', '2021-05-11 19:22:25'),
(1529, 'AnDreeW', 36, '* (chat log): CORBULE.', '2021-05-11 19:22:32'),
(1530, 'AnDreeW', 36, '* (chat log): SCRIE ASA.', '2021-05-11 19:22:34'),
(1531, 'AnDreeW', 36, '* (chat log):  /SETADMIN 1 6.', '2021-05-11 19:22:39'),
(1532, 'corbul', 8, '* (chat log): oricum nu mai vin pe acest sv.', '2021-05-11 19:22:55'),
(1533, 'AnDreeW', 36, '* (chat log): suss.', '2021-05-11 19:23:46'),
(1534, 'AnDreeW', 36, '* (chat log): g.', '2021-05-11 19:23:49'),
(1535, 'RoLEX', 7, '* (chat log): andrei.', '2021-05-11 19:23:50'),
(1536, 'AnDreeW', 36, '* (chat log): na.', '2021-05-11 19:23:50'),
(1537, 'RoLEX', 7, '* (chat log): vr sa ma pis in gura ta.', '2021-05-11 19:23:55'),
(1538, 'RoLEX', 7, '* (chat log): pot.', '2021-05-11 19:23:57'),
(1539, 'RoLEX', 7, '* (chat log): ?.', '2021-05-11 19:23:58'),
(1540, 'AnDreeW', 36, '* (chat log): ma pis eu pe tn .', '2021-05-11 19:23:59'),
(1541, 'RoLEX', 7, '* (chat log): /goto 2.', '2021-05-11 19:24:08'),
(1542, 'RoLEX', 7, '* (chat log): goto 2.', '2021-05-11 19:24:09'),
(1543, 'AnDreeW', 36, '* (chat log): ai ramas fara adm.', '2021-05-11 19:24:31'),
(1544, 'corbul', 8, '* (chat log): sugeo.', '2021-05-11 19:25:11'),
(1545, 'AnDreeW', 36, '* (chat log): undei ma.', '2021-05-11 19:25:22'),
(1546, 'AnDreeW', 36, '* (chat log): paintu.', '2021-05-11 19:25:23'),
(1547, 'AnDreeW', 36, '* (chat log): unde e baa.', '2021-05-11 19:25:29'),
(1548, 'Vicentzo', 4, '* (chat log): ba muilor.', '2021-05-11 19:25:37'),
(1549, 'RoLEX', 7, '* (chat log): fuck yu.', '2021-05-11 19:25:39'),
(1550, 'RoLEX', 7, '* (chat log): te fut.', '2021-05-11 19:28:14'),
(1551, 'RoLEX', 7, '* (chat log): .', '2021-05-11 19:29:55'),
(1552, 'RoLEX', 7, '* (chat log): coaiee.', '2021-05-11 19:30:10'),
(1553, 'RoLEX', 7, '* (chat log): lol.', '2021-05-11 19:30:42'),
(1554, 'RoLEX', 7, '* (chat log): ce drecu.', '2021-05-11 19:31:17'),
(1555, 'RoLEX', 7, '* (chat log): aici?.', '2021-05-11 19:31:19'),
(1556, 'RoLEX', 7, '* (chat log): coaiee.', '2021-05-11 19:31:23'),
(1557, 'RoLEX', 7, '* (chat log): lol.', '2021-05-11 19:31:26'),
(1558, 'RoLEX', 7, '* (chat log): penthouse.', '2021-05-11 19:31:27'),
(1559, 'RoLEX', 7, '* (chat log): facem sistem.', '2021-05-11 19:31:30'),
(1560, 'RoLEX', 7, '* (chat log): .', '2021-05-11 19:32:23'),
(1561, 'RoLEX', 7, '* (chat log): a lol.', '2021-05-11 19:32:36'),
(1562, 'RoLEX', 7, '* (chat log): lol.', '2021-05-11 19:35:12'),
(1563, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-11 20:06:35'),
(1564, 'RoLEX', 7, '* (chat log): pai si arme.', '2021-05-11 20:08:09'),
(1565, 'RoLEX', 7, '* (chat log): de unde.', '2021-05-11 20:08:12'),
(1566, 'Vicentzo', 4, '* (chat log): o sa dam.', '2021-05-11 20:08:16'),
(1567, 'Vicentzo', 4, '* (chat log): si arme.', '2021-05-11 20:08:17'),
(1568, 'Vicentzo', 4, '* (chat log): 196 - 197 ticks.', '2021-05-11 20:08:25'),
(1569, 'Vicentzo', 4, '* (chat log): lmao.', '2021-05-11 20:08:26'),
(1570, 'RoLEX', 7, '* (chat log): n ar fi bine sa fie un dialog sa selectezi.', '2021-05-11 20:08:27'),
(1571, 'Vicentzo', 4, '* (chat log): nu mai sta in 198.', '2021-05-11 20:08:28'),
(1572, 'RoLEX', 7, '* (chat log): sunt in 197.', '2021-05-11 20:08:33'),
(1573, 'RoLEX', 7, '* (chat log): e 197.', '2021-05-11 20:08:35'),
(1574, 'RoLEX', 7, '* (chat log): acm.', '2021-05-11 20:08:37'),
(1575, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-11 20:09:50'),
(1576, 'RoLEX', 7, '* (chat log): ff.', '2021-05-11 20:10:02'),
(1577, 'RoLEX', 7, '* (chat log): tfff.', '2021-05-11 20:10:13'),
(1578, 'RoLEX', 7, '* (chat log): ff.', '2021-05-11 20:10:14'),
(1579, 'RoLEX', 7, '* (chat log): ggg.', '2021-05-11 20:10:45'),
(1580, 'RoLEX', 7, '* (chat log): tttttttttttttttt.', '2021-05-11 20:10:49'),
(1581, 'RoLEX', 7, '* (chat log): plm.', '2021-05-11 20:10:52'),
(1582, 'RoLEX', 7, '* (chat log): ff.', '2021-05-11 20:10:58'),
(1583, 'RoLEX', 7, '* (chat log): 188..', '2021-05-11 20:11:08'),
(1584, 'RoLEX', 7, '* (chat log): fff.', '2021-05-11 20:11:21'),
(1585, 'RoLEX', 7, '* (chat log): :777.', '2021-05-11 20:11:28'),
(1586, 'RoLEX', 7, '* (chat log): ddddddddddd.', '2021-05-11 20:11:38'),
(1587, 'RoLEX', 7, '* (chat log): optimgame.', '2021-05-11 20:11:55'),
(1588, 'Vicentzo', 4, '* (chat log): w.', '2021-05-11 20:16:51'),
(1589, 'RoLEX', 7, '* (chat log): .', '2021-05-12 17:00:20'),
(1590, 'RoLEX', 7, '* (chat log): ff.', '2021-05-12 17:01:47'),
(1591, 'Vicentzo', 4, '* (chat log): ./kick .', '2021-05-12 17:01:48'),
(1592, 'Aditsu', 32, '* (chat log): ./kick 1 silent iesi fã .', '2021-05-12 17:02:19'),
(1593, 'Vicentzo', 4, '* (chat log): spune si tu.', '2021-05-12 17:03:10'),
(1594, 'Vicentzo', 4, '* (chat log): ca a picat sv.', '2021-05-12 17:03:11'),
(1595, 'Vicentzo', 4, '* (chat log): ))).', '2021-05-12 17:03:14'),
(1596, 'Aditsu', 32, '* (chat log): spune i asa.', '2021-05-12 17:03:23'),
(1597, 'Aditsu', 32, '* (chat log): cã a revenit.', '2021-05-12 17:03:25'),
(1598, 'Aditsu', 32, '* (chat log): si îi dau eu ban.', '2021-05-12 17:03:27'),
(1599, 'Aditsu', 32, '* (chat log): când intrã.', '2021-05-12 17:03:28'),
(1600, 'Aditsu', 32, '* (chat log): =)))).', '2021-05-12 17:03:30'),
(1601, 'Aditsu', 32, '* (chat log): dãi a6.', '2021-05-12 17:03:36'),
(1602, 'Aditsu', 32, '* (chat log): sã pot sã i dau ban.', '2021-05-12 17:03:38'),
(1603, 'Aditsu', 32, '* (chat log): cã la a7 nu pot.', '2021-05-12 17:03:41'),
(1604, 'Vicentzo', 4, '* (chat log): k.', '2021-05-12 17:03:45'),
(1605, 'Aditsu', 32, '* (chat log): dãi a6.', '2021-05-12 17:04:05'),
(1606, 'Vicentzo', 4, '* (chat log): dai.', '2021-05-12 17:04:05'),
(1607, 'Aditsu', 32, '* (chat log): s.', '2021-05-12 17:04:05'),
(1608, 'Aditsu', 32, '* (chat log):  /ban 2 0 Abuz dã functie.', '2021-05-12 17:04:25'),
(1609, 'Aditsu', 32, '* (chat log): îl banez iar st sã vezi =)).', '2021-05-12 17:04:51'),
(1610, 'Vicentzo', 4, '* (chat log): dai iar.', '2021-05-12 17:05:13'),
(1611, 'Vicentzo', 4, '* (chat log): MOOR.', '2021-05-12 17:05:21'),
(1612, 'Vicentzo', 4, '* (chat log): sal frt.', '2021-05-12 17:06:20'),
(1613, 'Vicentzo', 4, '* (chat log): test tw.', '2021-05-12 17:06:22'),
(1614, 'Vicentzo', 4, '* (chat log): 7 minute.', '2021-05-12 17:06:23'),
(1615, 'Vicentzo', 4, '* (chat log): rapid.', '2021-05-12 17:06:23'),
(1616, 'Vicentzo', 4, '* (chat log): suspectat de cod.', '2021-05-12 17:06:25'),
(1617, 'Adrian_Valentin', 41, '* (chat log): sall frt.', '2021-05-12 17:06:27'),
(1618, 'Aditsu', 32, '* (chat log): 7m supremo.', '2021-05-12 17:06:27'),
(1619, 'Aditsu', 32, '* (chat log): 10m tw11.', '2021-05-12 17:06:33'),
(1620, 'Vicentzo', 4, '* (chat log): suspektat de kod.', '2021-05-12 17:06:43'),
(1621, 'Aditsu', 32, '* (chat log): a nu dai?.', '2021-05-12 17:06:45'),
(1622, 'Adrian_Valentin', 41, '* (chat log): ce aveti.', '2021-05-12 17:06:45'),
(1623, 'Vicentzo', 4, '* (chat log): rapid suprimo sau tv.', '2021-05-12 17:06:47'),
(1624, 'Aditsu', 32, '* (chat log): gt ai fost demis.', '2021-05-12 17:07:03'),
(1625, 'Aditsu', 32, '* (chat log): n ai dat datele.', '2021-05-12 17:07:06'),
(1626, 'Adrian_Valentin', 41, '* (chat log): va picat pe mn.', '2021-05-12 17:07:06'),
(1627, 'Aditsu', 32, '* (chat log): a intrat tasu lu andreea peste el.', '2021-05-12 17:07:19'),
(1628, 'RoLEX', 7, '* (chat log): =)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))).', '2021-05-12 17:07:27'),
(1629, 'Vicentzo', 4, '* (chat log): ba.', '2021-05-12 17:07:40'),
(1630, 'Vicentzo', 4, '* (chat log): adrian.', '2021-05-12 17:07:42'),
(1631, 'Vicentzo', 4, '* (chat log): felicitari.', '2021-05-12 17:07:44'),
(1632, 'Vicentzo', 4, '* (chat log): ai fost promovat.', '2021-05-12 17:07:46'),
(1633, 'Vicentzo', 4, '* (chat log): ca admin.', '2021-05-12 17:07:47'),
(1634, 'Vicentzo', 4, '* (chat log): ba.', '2021-05-12 17:07:52'),
(1635, 'Vicentzo', 4, '* (chat log): civilule.', '2021-05-12 17:07:53'),
(1636, 'Adrian_Valentin', 41, '* (chat log): ok.', '2021-05-12 17:07:55'),
(1637, 'Vicentzo', 4, '* (chat log): ai fost promovat.', '2021-05-12 17:07:56'),
(1638, 'Vicentzo', 4, '* (chat log): la admin.', '2021-05-12 17:07:58'),
(1639, 'Vicentzo', 4, '* (chat log): gg mane.', '2021-05-12 17:08:03'),
(1640, 'RoLEX', 7, '* (chat log): gegege.', '2021-05-12 17:08:07'),
(1641, 'Aditsu', 32, '* (chat log): î.', '2021-05-12 17:10:24'),
(1642, 'Vicentzo', 4, '* (chat log): m.', '2021-05-12 17:11:41'),
(1643, 'Vicentzo', 4, '* (chat log): ba.', '2021-05-12 17:12:06'),
(1644, 'Aditsu', 32, '* (chat log): mia dat rimuv :(((.', '2021-05-12 17:12:15'),
(1645, 'Vicentzo', 4, '* (chat log): a.', '2021-05-12 17:16:14'),
(1646, 'Vicentzo', 4, '* (chat log): ba.', '2021-05-12 17:16:28'),
(1647, 'Adrian_Valentin', 41, '* (chat log): aaa.', '2021-05-12 17:16:33'),
(1648, 'Aditsu', 32, '* (chat log): pune te.', '2021-05-12 17:16:37'),
(1649, 'Vicentzo', 4, '* (chat log): ajuta-l pe aditsu.', '2021-05-12 17:16:38'),
(1650, 'Aditsu', 32, '* (chat log): hduty.', '2021-05-12 17:16:38'),
(1651, 'Vicentzo', 4, '* (chat log): punete helparduty.', '2021-05-12 17:16:40'),
(1652, 'Aditsu', 32, '* (chat log): acu verificã.', '2021-05-12 17:17:10'),
(1653, 'Aditsu', 32, '* (chat log): comanda.', '2021-05-12 17:17:11'),
(1654, 'Adrian_Valentin', 41, '* (chat log): nu mere.', '2021-05-12 17:17:16'),
(1655, 'Aditsu', 32, '* (chat log): asteaptã.', '2021-05-12 17:17:26'),
(1656, 'Vicentzo', 4, '* (chat log): helduty.', '2021-05-12 17:17:36'),
(1657, 'Vicentzo', 4, '* (chat log): ba.', '2021-05-12 17:18:07'),
(1658, 'Vicentzo', 4, '* (chat log): ti s-a.', '2021-05-12 17:18:16'),
(1659, 'Vicentzo', 4, '* (chat log): atribuit.', '2021-05-12 17:18:17'),
(1660, 'Vicentzo', 4, '* (chat log): intrebarea tie.', '2021-05-12 17:18:18'),
(1661, 'Adrian_Valentin', 41, '* (chat log): da.', '2021-05-12 17:18:19'),
(1662, 'Aditsu', 32, '* (chat log): rãsp.', '2021-05-12 17:18:22'),
(1663, 'Aditsu', 32, '* (chat log): la ea.', '2021-05-12 17:18:23'),
(1664, 'Vicentzo', 4, '* (chat log): salut bos.', '2021-05-12 17:19:00'),
(1665, 'Adrian_Valentin', 41, '* (chat log): duty.', '2021-05-12 17:21:19'),
(1666, 'Sebastian.Gaming2010', 42, '* (chat log): ?.', '2021-05-12 17:37:49'),
(1667, 'RoLEX', 7, '* (chat log): ce.', '2021-05-12 17:37:54'),
(1668, 'RoLEX', 7, '* (chat log): nmk.', '2021-05-12 17:37:56'),
(1669, 'RoLEX', 7, '* (chat log): vr sa te vad.', '2021-05-12 17:38:00'),
(1670, 'RoLEX', 7, '* (chat log): ca mi s a facut dor de tn.', '2021-05-12 17:38:07'),
(1671, 'Sebastian.Gaming2010', 42, '* (chat log): :))).', '2021-05-12 17:38:17'),
(1672, 'RoLEX', 7, '* (chat log): probleme cv.', '2021-05-12 17:38:31'),
(1673, 'RoLEX', 7, '* (chat log): sa stiu.', '2021-05-12 17:38:34'),
(1674, 'Sebastian.Gaming2010', 42, '* (chat log): nu nu.', '2021-05-12 17:38:39'),
(1675, 'RoLEX', 7, '* (chat log): daca plec :(.', '2021-05-12 17:38:39'),
(1676, 'RoLEX', 7, '* (chat log): :((.', '2021-05-12 17:38:45'),
(1677, 'Sebastian.Gaming2010', 42, '* (chat log): deocamdata.', '2021-05-12 17:38:45'),
(1678, 'RoLEX', 7, '* (chat log): ok.', '2021-05-12 17:38:46'),
(1679, 'RoLEX', 7, '* (chat log): =))))))))))))))))))))))))))))))))))))))))))))))))).', '2021-05-12 17:38:51'),
(1680, 'RoLEX', 7, '* (chat log): ia da mi si mie sa conduc.', '2021-05-12 17:39:02'),
(1681, 'Sebastian.Gaming2010', 42, '* (chat log): hai.', '2021-05-12 17:39:20'),
(1682, 'Adrian_Valentin', 41, '* (chat log): .', '2021-05-12 17:41:02'),
(1683, 'RoLEX', 7, '* (chat log): fly.', '2021-05-12 17:41:59'),
(1684, 'Aditsu', 32, '* (chat log): cum nu mrg?.', '2021-05-12 17:42:02'),
(1685, 'Vicentzo', 4, '* (chat log): a ?.', '2021-05-12 17:42:58'),
(1686, 'Vicentzo', 4, '* (chat log): adrian.', '2021-05-12 17:43:59'),
(1687, 'Vicentzo', 4, '* (chat log): dai goto al aditsu.', '2021-05-12 17:44:05'),
(1688, 'Vicentzo', 4, '* (chat log): putin.', '2021-05-12 17:44:06'),
(1689, 'Vicentzo', 4, '* (chat log): nu sunt locuri.', '2021-05-12 17:44:20'),
(1690, 'Vicentzo', 4, '* (chat log): d-asta va zic.', '2021-05-12 17:44:22'),
(1691, 'Adrian_Valentin', 41, '* (chat log): ati avut dreptate.', '2021-05-12 17:44:26'),
(1692, 'RoLEX', 7, '* (chat log): G.', '2021-05-12 17:44:59'),
(1693, 'Adrian_Valentin', 41, '* (chat log): prinde 100.', '2021-05-12 17:45:32'),
(1694, 'RoLEX', 7, '* (chat log): df.', '2021-05-12 17:45:34'),
(1695, 'Sebastian.Gaming2010', 42, '* (chat log): chiar e smecher asta.', '2021-05-12 17:45:36'),
(1696, 'RoLEX', 7, '* (chat log): da.', '2021-05-12 17:45:42'),
(1697, 'RoLEX', 7, '* (chat log): ne gabdeam la sistem.', '2021-05-12 17:45:48'),
(1698, 'RoLEX', 7, '* (chat log): de trenuri.', '2021-05-12 17:45:52'),
(1699, 'Adrian_Valentin', 41, '* (chat log): eu am testat banca.', '2021-05-12 17:45:53'),
(1700, 'RoLEX', 7, '* (chat log): =).', '2021-05-12 17:45:54'),
(1701, 'Adrian_Valentin', 41, '* (chat log): ar fi smecher .', '2021-05-12 17:46:04'),
(1702, 'Adrian_Valentin', 41, '* (chat log): dar sa cumperi trenuri.', '2021-05-12 17:46:21'),
(1703, 'RoLEX', 7, '* (chat log): ne gandeam ca nu.', '2021-05-12 17:46:31'),
(1704, 'RoLEX', 7, '* (chat log): ca gen.', '2021-05-12 17:46:32'),
(1705, 'RoLEX', 7, '* (chat log): sa te poti plimba.', '2021-05-12 17:46:36'),
(1706, 'RoLEX', 7, '* (chat log): doar.', '2021-05-12 17:46:37'),
(1707, 'Adrian_Valentin', 41, '* (chat log): cum imi dau pp.', '2021-05-12 17:46:43'),
(1708, 'RoLEX', 7, '* (chat log): ./set.', '2021-05-12 17:46:46'),
(1709, 'Adrian_Valentin', 41, '* (chat log): nu am acces la comanda clar.', '2021-05-12 17:47:14'),
(1710, 'Sebastian.Gaming2010', 42, '* (chat log): rolex da-mi si mie level.', '2021-05-12 17:47:40'),
(1711, 'Adrian_Valentin', 41, '* (chat log): rolex dami si mie pp.', '2021-05-12 17:48:23'),
(1712, 'RoLEX', 7, '* (chat log): frumos no?.', '2021-05-12 17:49:09'),
(1713, 'Sebastian.Gaming2010', 42, '* (chat log): da.', '2021-05-12 17:49:15'),
(1714, 'Sebastian.Gaming2010', 42, '* (chat log): rolex da-mi si mie puncte respect.', '2021-05-12 17:50:06'),
(1715, 'Sebastian.Gaming2010', 42, '* (chat log): sau level.', '2021-05-12 17:50:41'),
(1716, 'RoLEX', 7, '* (chat log): .', '2021-05-12 17:50:50'),
(1717, 'Aditsu', 32, '* (chat log): acover.', '2021-05-12 17:51:53'),
(1718, 'Sebastian.Gaming2010', 42, '* (chat log): dar alte trenuri nu mai sunt?.', '2021-05-12 17:52:50'),
(1719, 'RoLEX', 7, '* (chat log): e ala rapid dar incap 2 pers.', '2021-05-12 17:52:59'),
(1720, 'RoLEX', 7, '* (chat log): si e naspa.', '2021-05-12 17:53:01'),
(1721, 'RoLEX', 7, '* (chat log): prea lung.', '2021-05-12 17:53:03'),
(1722, 'RoLEX', 7, '* (chat log): nu crd.', '2021-05-12 17:53:07'),
(1723, 'RoLEX', 7, '* (chat log): sa ma uit.', '2021-05-12 17:53:11'),
(1724, 'RoLEX', 7, '* (chat log): brb.', '2021-05-12 17:53:12'),
(1725, 'Adrian_Valentin', 41, '* (chat log): rolex cand ai timp imi poti da o lista cu comenzile de admin te rog mult.', '2021-05-12 17:53:47'),
(1726, 'RoLEX', 7, '* (chat log): ai /ah.', '2021-05-12 17:54:05'),
(1727, 'RoLEX', 7, '* (chat log): bro.', '2021-05-12 17:54:06'),
(1728, 'RoLEX', 7, '* (chat log): sunt alea principale.', '2021-05-12 17:54:17'),
(1729, 'RoLEX', 7, '* (chat log): daca ai mai fost staff trebuia sa le stii....', '2021-05-12 17:54:26'),
(1730, 'RoLEX', 7, '* (chat log): stati.', '2021-05-12 17:54:39'),
(1731, 'RoLEX', 7, '* (chat log): acolo.', '2021-05-12 17:54:40'),
(1732, 'Aditsu', 32, '* (chat log): ce bug.', '2021-05-12 17:55:29'),
(1733, 'RoLEX', 7, '* (chat log): gata.', '2021-05-12 17:55:39'),
(1734, 'RoLEX', 7, '* (chat log): s a rezolvat.', '2021-05-12 17:55:41'),
(1735, 'Sebastian.Gaming2010', 42, '* (chat log): vreau si eu sa conduc.', '2021-05-12 17:55:44'),
(1736, 'Vicentzo', 4, '* (chat log): 1150.', '2021-05-12 17:57:37'),
(1737, 'Adrian_Valentin', 41, '* (chat log): .', '2021-05-12 17:57:38'),
(1738, 'Vicentzo', 4, '* (chat log): carinfo.', '2021-05-12 17:57:39'),
(1739, 'RoLEX', 7, '* (chat log): u.', '2021-05-12 18:03:28'),
(1740, 'RoLEX', 7, '* (chat log): =))).', '2021-05-12 18:03:35'),
(1741, 'RoLEX', 7, '* (chat log): cum ne mai intoarcee.', '2021-05-12 18:03:48'),
(1742, 'Sebastian.Gaming2010', 42, '* (chat log): imi dai si mie un tren.', '2021-05-12 18:04:25'),
(1743, 'Adrian_Valentin', 41, '* (chat log): ce masina este aia.', '2021-05-12 18:05:04'),
(1744, 'RoLEX', 7, '* (chat log): nu pot sa l pilotez.', '2021-05-12 18:05:39'),
(1745, 'RoLEX', 7, '* (chat log): :(.', '2021-05-12 18:05:40'),
(1746, 'Sebastian.Gaming2010', 42, '* (chat log): nici eu.', '2021-05-12 18:05:51'),
(1747, 'Adrian_Valentin', 41, '* (chat log): eu te ajut.', '2021-05-12 18:07:59'),
(1748, 'Aditsu', 32, '* (chat log): asa.', '2021-05-12 18:07:59'),
(1749, 'Adrian_Valentin', 41, '* (chat log): ce testam.', '2021-05-12 18:08:28'),
(1750, 'Aditsu', 32, '* (chat log): la factiuni niste comenzi.', '2021-05-12 18:08:36'),
(1751, 'Aditsu', 32, '* (chat log): st asa.', '2021-05-12 18:08:37'),
(1752, 'Aditsu', 32, '* (chat log): notati voi.', '2021-05-12 18:09:10'),
(1753, 'Aditsu', 32, '* (chat log): pe notepad.', '2021-05-12 18:09:12'),
(1754, 'Aditsu', 32, '* (chat log):  /tx nu este.', '2021-05-12 18:09:14'),
(1755, 'Adrian_Valentin', 41, '* (chat log): imd.', '2021-05-12 18:09:16'),
(1756, 'Adrian_Valentin', 41, '* (chat log): mai zi.', '2021-05-12 18:10:01'),
(1757, 'Aditsu', 32, '* (chat log): st.', '2021-05-12 18:10:04'),
(1758, 'Aditsu', 32, '* (chat log): puneti.', '2021-05-12 18:11:06'),
(1759, 'Aditsu', 32, '* (chat log): contract.', '2021-05-12 18:11:07'),
(1760, 'Adrian_Valentin', 41, '* (chat log): am pus contract.', '2021-05-12 18:11:14'),
(1761, 'Aditsu', 32, '* (chat log): nu ai pus.', '2021-05-12 18:11:20'),
(1762, 'Aditsu', 32, '* (chat log): pune pe sebi.', '2021-05-12 18:11:26'),
(1763, 'Aditsu', 32, '* (chat log): pe sebastian.', '2021-05-12 18:11:30'),
(1764, 'Aditsu', 32, '* (chat log): bagã contract.', '2021-05-12 18:11:36'),
(1765, 'Sebastian.Gaming2010', 42, '* (chat log): CE.', '2021-05-12 18:11:43'),
(1766, 'Aditsu', 32, '* (chat log): ai rãbdare.', '2021-05-12 18:11:47'),
(1767, 'Aditsu', 32, '* (chat log): asa.', '2021-05-12 18:11:49'),
(1768, 'Aditsu', 32, '* (chat log): ok bug.', '2021-05-12 18:12:02'),
(1769, 'Adrian_Valentin', 41, '* (chat log): postezi tu.', '2021-05-12 18:12:10'),
(1770, 'Aditsu', 32, '* (chat log): ai pus 100k pe contract si când îl iei aratã cã suma e 0$.', '2021-05-12 18:12:11'),
(1771, 'Aditsu', 32, '* (chat log): st.', '2021-05-12 18:12:18'),
(1772, 'Adrian_Valentin', 41, '* (chat log): ok.', '2021-05-12 18:12:24'),
(1773, 'Adrian_Valentin', 41, '* (chat log): scriu in not pad.', '2021-05-12 18:12:34'),
(1774, 'Adrian_Valentin', 41, '* (chat log): bugul?.', '2021-05-12 18:13:15'),
(1775, 'Aditsu', 32, '* (chat log): îi arãt acm lu vicentzo cã e partajarea pornitã.', '2021-05-12 18:13:24'),
(1776, 'Adrian_Valentin', 41, '* (chat log): intru si eu pe dis daca ma primiti.', '2021-05-12 18:13:42'),
(1777, 'Aditsu', 32, '* (chat log): hai.', '2021-05-12 18:13:45'),
(1778, 'Aditsu', 32, '* (chat log): ok gata si cu hitman.', '2021-05-12 18:15:18'),
(1779, 'Adrian_Valentin', 41, '* (chat log): ma bagati si pe mn pe dis.', '2021-05-12 18:15:24'),
(1780, 'SebyP4', 23, '* (chat log): frt.', '2021-05-12 18:15:55'),
(1781, 'SebyP4', 23, '* (chat log): stai.', '2021-05-12 18:15:58'),
(1782, 'SebyP4', 23, '* (chat log): g.', '2021-05-12 18:16:03'),
(1783, 'SebyP4', 23, '* (chat log): putin.', '2021-05-12 18:16:04'),
(1784, 'SebyP4', 23, '* (chat log): g si aici.', '2021-05-12 18:16:18'),
(1785, 'SebyP4', 23, '* (chat log): g.', '2021-05-12 18:16:48'),
(1786, 'SebyP4', 23, '* (chat log): am gasit bug.', '2021-05-12 18:17:10'),
(1787, 'Adrian_Valentin', 41, '* (chat log): pot intra si eu pe dis.', '2021-05-12 18:17:14'),
(1788, 'Aditsu', 32, '* (chat log): am luat si desync.', '2021-05-12 18:17:15'),
(1789, 'Aditsu', 32, '* (chat log): st asa.', '2021-05-12 18:17:20'),
(1790, 'Sebastian.Gaming2010', 42, '* (chat log): CE BUG.', '2021-05-12 18:17:58'),
(1791, 'Aditsu', 32, '* (chat log): acc.', '2021-05-12 18:23:26'),
(1792, 'Aditsu', 32, '* (chat log): esti în confã?.', '2021-05-12 18:24:05'),
(1793, 'Adrian_Valentin', 41, '* (chat log): da.', '2021-05-12 18:24:09'),
(1794, 'Adrian_Valentin', 41, '* (chat log): fly.', '2021-05-12 18:39:03'),
(1795, 'Vicentzo', 4, '* (chat log): w.', '2021-05-12 18:44:34'),
(1796, 'AnDreeW', 36, '* (chat log): GOTK.', '2021-05-12 18:46:44'),
(1797, 'RoLEX', 7, '* (chat log): .', '2021-05-12 18:51:21'),
(1798, 'RoLEX', 7, '* (chat log): fv.', '2021-05-12 18:53:31'),
(1799, 'Sebastian.Gaming2010', 42, '* (chat log): HAIII.', '2021-05-12 19:11:31'),
(1800, 'Sebastian.Gaming2010', 42, '* (chat log): CONDUC EU.', '2021-05-12 19:11:42'),
(1801, 'Sebastian.Gaming2010', 42, '* (chat log): DATA JOS.', '2021-05-12 19:11:49'),
(1802, 'Adrian_Valentin', 41, '* (chat log): spawneaza.', '2021-05-12 19:12:03'),
(1803, 'Adrian_Valentin', 41, '* (chat log): tiam dat.', '2021-05-12 19:16:10'),
(1804, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-12 19:41:08'),
(1805, 'Vicentzo', 4, '* (chat log): sint foarte bos.', '2021-05-12 19:41:14'),
(1806, 'Vicentzo', 4, '* (chat log): ba.', '2021-05-12 19:41:19'),
(1807, 'RoLEX', 7, '* (chat log): ff.', '2021-05-12 19:41:21'),
(1808, 'Vicentzo', 4, '* (chat log): deasupra la nume.', '2021-05-12 19:41:22'),
(1809, 'RoLEX', 7, '* (chat log): fff.', '2021-05-12 19:41:23'),
(1810, 'Vicentzo', 4, '* (chat log): apare numele sintbos.', '2021-05-12 19:41:25'),
(1811, 'Vicentzo', 4, '* (chat log): ?.', '2021-05-12 19:41:26'),
(1812, 'RoLEX', 7, '* (chat log): da.', '2021-05-12 19:41:26'),
(1813, 'Vicentzo', 4, '* (chat log): pe chat si la logo.', '2021-05-12 19:41:29'),
(1814, 'Vicentzo', 4, '* (chat log): alea le fac dupa.', '2021-05-12 19:41:31'),
(1815, 'Vicentzo', 4, '* (chat log): scoate-te coaie.', '2021-05-12 19:43:05'),
(1816, 'RoLEX', 7, '* (chat log): /a anaa.', '2021-05-12 19:51:21'),
(1817, 'RoLEX', 7, '* (chat log): y.', '2021-05-12 19:51:22'),
(1818, 'Vicentzo', 4, '* (chat log): hai.', '2021-05-12 19:52:03'),
(1819, 'Vicentzo', 4, '* (chat log):  /a hai air.', '2021-05-12 19:52:19'),
(1820, 'Vicentzo', 4, '* (chat log): apasa f.', '2021-05-12 19:52:40'),
(1821, 'Vicentzo', 4, '* (chat log): ba.', '2021-05-12 19:52:43'),
(1822, 'Vicentzo', 4, '* (chat log): hai iar.', '2021-05-12 19:52:45'),
(1823, 'Vicentzo', 4, '* (chat log): sa vedem daca ajungem.', '2021-05-12 19:52:48'),
(1824, 'Vicentzo', 4, '* (chat log): cnn.', '2021-05-12 19:52:48'),
(1825, 'Vicentzo', 4, '* (chat log): da nu o deschide.', '2021-05-12 19:52:54'),
(1826, 'Vicentzo', 4, '* (chat log): sa prinzi viteza.', '2021-05-12 19:52:56'),
(1827, 'RoLEX', 7, '* (chat log): k.', '2021-05-12 19:52:59'),
(1828, 'RoLEX', 7, '* (chat log): baaa.', '2021-05-12 19:54:05'),
(1829, 'RoLEX', 7, '* (chat log): asasinuu.', '2021-05-12 19:54:21'),
(1830, 'RoLEX', 7, '* (chat log): pulii.', '2021-05-12 19:54:22'),
(1831, 'RoLEX', 7, '* (chat log): ma taie cu drujba.', '2021-05-12 19:54:27'),
(1832, 'Vicentzo', 4, '* (chat log): da-i /fly.', '2021-05-12 19:54:31'),
(1833, 'Vicentzo', 4, '* (chat log): si vino jos de tot.', '2021-05-12 19:54:33'),
(1834, 'RoLEX', 7, '* (chat log): nu poti.', '2021-05-12 19:54:41'),
(1835, 'RoLEX', 7, '* (chat log): lol.', '2021-05-12 19:54:42'),
(1836, 'Vicentzo', 4, '* (chat log): st.', '2021-05-12 19:54:43'),
(1837, 'RoLEX', 7, '* (chat log): a gt.', '2021-05-12 19:54:48'),
(1838, 'RoLEX', 7, '* (chat log): dar nu iau.', '2021-05-12 19:54:50'),
(1839, 'RoLEX', 7, '* (chat log): =).', '2021-05-12 19:54:53'),
(1840, 'RoLEX', 7, '* (chat log): ca e setat.', '2021-05-12 19:54:55'),
(1841, 'RoLEX', 7, '* (chat log): gen.', '2021-05-12 19:54:57'),
(1842, 'RoLEX', 7, '* (chat log): sa nu iei dmg.', '2021-05-12 19:55:00'),
(1843, 'RoLEX', 7, '* (chat log): cand ai fly.', '2021-05-12 19:55:02'),
(1844, 'RoLEX', 7, '* (chat log): cred.', '2021-05-12 19:55:03'),
(1845, 'Vicentzo', 4, '* (chat log): e foarte mult hp.', '2021-05-12 19:55:07'),
(1846, 'Vicentzo', 4, '* (chat log): d-aia.', '2021-05-12 19:55:07'),
(1847, 'RoLEX', 7, '* (chat log): aa.', '2021-05-12 19:55:11'),
(1848, 'RoLEX', 7, '* (chat log): k.', '2021-05-12 19:55:12'),
(1849, 'RoLEX', 7, '* (chat log): baa.', '2021-05-12 19:55:27'),
(1850, 'RoLEX', 7, '* (chat log): sange.', '2021-05-12 19:55:28'),
(1851, 'RoLEX', 7, '* (chat log): nu mai dorm la noapte.', '2021-05-12 19:55:33'),
(1852, 'RoLEX', 7, '* (chat log): mane.', '2021-05-12 19:55:34'),
(1853, 'Vicentzo', 4, '* (chat log): acum apare.', '2021-05-12 19:55:34'),
(1854, 'Vicentzo', 4, '* (chat log): ca iti scade.', '2021-05-12 19:55:36'),
(1855, 'Vicentzo', 4, '* (chat log): dan hp.', '2021-05-12 19:55:37'),
(1856, 'RoLEX', 7, '* (chat log): nui.', '2021-05-12 19:55:38'),
(1857, 'RoLEX', 7, '* (chat log): nu.', '2021-05-12 19:55:40'),
(1858, 'Vicentzo', 4, '* (chat log): la bara ta de hp.', '2021-05-12 19:55:43'),
(1859, 'Vicentzo', 4, '* (chat log): mie asa arata.', '2021-05-12 19:55:45'),
(1860, 'RoLEX', 7, '* (chat log): nu scade.', '2021-05-12 19:55:49'),
(1861, 'RoLEX', 7, '* (chat log): wtf.', '2021-05-12 19:56:07'),
(1862, 'RoLEX', 7, '* (chat log): cum.', '2021-05-12 19:56:11'),
(1863, 'Vicentzo', 4, '* (chat log): c-bug.', '2021-05-12 19:56:11'),
(1864, 'RoLEX', 7, '* (chat log): coaie.', '2021-05-12 19:56:12'),
(1865, 'Vicentzo', 4, '* (chat log): cu minigun.', '2021-05-12 19:56:13'),
(1866, 'RoLEX', 7, '* (chat log): cum dracu.', '2021-05-12 19:56:17'),
(1867, 'RoLEX', 7, '* (chat log): ai animatia.', '2021-05-12 19:56:18'),
(1868, 'RoLEX', 7, '* (chat log): aia.', '2021-05-12 19:56:19'),
(1869, 'RoLEX', 7, '* (chat log): hackl?.', '2021-05-12 19:56:21'),
(1870, 'RoLEX', 7, '* (chat log): cheats.', '2021-05-12 19:56:23'),
(1871, 'Vicentzo', 4, '* (chat log): ma uit in jos.', '2021-05-12 19:56:24'),
(1872, 'Vicentzo', 4, '* (chat log): =))))))))))).', '2021-05-12 19:56:25'),
(1873, 'RoLEX', 7, '* (chat log): aa.', '2021-05-12 19:56:26'),
(1874, 'Vicentzo', 4, '* (chat log): invert walk de la cit.', '2021-05-12 19:56:28'),
(1875, 'RoLEX', 7, '* (chat log): a lol.', '2021-05-12 19:56:32'),
(1876, 'Vicentzo', 4, '* (chat log): coaie.', '2021-05-12 19:56:33'),
(1877, 'Vicentzo', 4, '* (chat log): fac c-bug.', '2021-05-12 19:56:34'),
(1878, 'Vicentzo', 4, '* (chat log): cu minigun.', '2021-05-12 19:56:36'),
(1879, 'Vicentzo', 4, '* (chat log): de la cod.', '2021-05-12 19:56:37'),
(1880, 'RoLEX', 7, '* (chat log): =)).', '2021-05-12 19:56:41'),
(1881, 'Vicentzo', 4, '* (chat log): baga fly.', '2021-05-12 19:56:50'),
(1882, 'RoLEX', 7, '* (chat log): loll.', '2021-05-12 20:01:01'),
(1883, 'Vicentzo', 4, '* (chat log): ba.', '2021-05-12 20:01:04'),
(1884, 'Vicentzo', 4, '* (chat log): eu acum.', '2021-05-12 20:01:06'),
(1885, 'RoLEX', 7, '* (chat log): pee.', '2021-05-12 20:01:07'),
(1886, 'Vicentzo', 4, '* (chat log): ma vad cu capu-n jos.', '2021-05-12 20:01:08'),
(1887, 'RoLEX', 7, '* (chat log): baaa.', '2021-05-12 20:01:12'),
(1888, 'RoLEX', 7, '* (chat log): st asa.', '2021-05-12 20:01:15'),
(1889, 'RoLEX', 7, '* (chat log): sa fac poaza.', '2021-05-12 20:01:18'),
(1890, 'Vicentzo', 4, '* (chat log): ma vad cu capu-n jos?.', '2021-05-12 20:01:18'),
(1891, 'Vicentzo', 4, '* (chat log): =))))))))))))).', '2021-05-12 20:01:20'),
(1892, 'RoLEX', 7, '* (chat log): da.', '2021-05-12 20:01:25'),
(1893, 'Vicentzo', 4, '* (chat log): lmao.', '2021-05-12 20:01:27'),
(1894, 'RoLEX', 7, '* (chat log): st sa fac.', '2021-05-12 20:01:28'),
(1895, 'Vicentzo', 4, '* (chat log): laba o fac sus.', '2021-05-12 20:01:29'),
(1896, 'RoLEX', 7, '* (chat log): ss.', '2021-05-12 20:01:29'),
(1897, 'Vicentzo', 4, '* (chat log): sau ce.', '2021-05-12 20:01:29'),
(1898, 'Vicentzo', 4, '* (chat log): y=))))))))))))))))).', '2021-05-12 20:01:31'),
(1899, 'Vicentzo', 4, '* (chat log): io ma vad normal.', '2021-05-12 20:01:45'),
(1900, 'Vicentzo', 4, '* (chat log): da laba cred ca o fac undeva sus.', '2021-05-12 20:01:48'),
(1901, 'RoLEX', 7, '* (chat log): da.', '2021-05-12 20:01:51'),
(1902, 'RoLEX', 7, '* (chat log): esti cu capu in jos.', '2021-05-12 20:01:54'),
(1903, 'Vicentzo', 4, '* (chat log):  da ss.', '2021-05-12 20:01:56'),
(1904, 'Vicentzo', 4, '* (chat log): pe grup.', '2021-05-12 20:01:56'),
(1905, 'RoLEX', 7, '* (chat log): am dat pe general =)).', '2021-05-12 20:02:15'),
(1906, 'RoLEX', 7, '* (chat log): sa vada si restu =))).', '2021-05-12 20:02:25'),
(1907, 'RoLEX', 7, '* (chat log): baa.', '2021-05-12 20:02:35'),
(1908, 'RoLEX', 7, '* (chat log): wtf.', '2021-05-12 20:02:36'),
(1909, 'RoLEX', 7, '* (chat log): e raduq fondator.', '2021-05-12 20:02:40'),
(1910, 'RoLEX', 7, '* (chat log): cplm.', '2021-05-12 20:02:41'),
(1911, 'RoLEX', 7, '* (chat log): pe discord.', '2021-05-12 20:02:44'),
(1912, 'RoLEX', 7, '* (chat log): cplmmmmmmcplmmmmmmcplmmmmmmcplmmmmmmcplmmmmmmcplmmmmmmcplmmmmmmcplmmmmmmcplmmmmmmcplmmmmmmcplmmmmmmcplmmmmmmcplmmm', '2021-05-12 20:02:51'),
(1913, 'Vicentzo', 4, '* (chat log): ce raduq ma.', '2021-05-12 20:02:51'),
(1914, 'RoLEX', 7, '* (chat log): coaie.', '2021-05-12 20:02:53'),
(1915, 'RoLEX', 7, '* (chat log): uitate|.', '2021-05-12 20:02:54'),
(1916, 'Vicentzo', 4, '* (chat log): coaie.', '2021-05-12 20:03:19'),
(1917, 'Vicentzo', 4, '* (chat log): nu apare pe.', '2021-05-12 20:03:20'),
(1918, 'Vicentzo', 4, '* (chat log): sv log in settings.', '2021-05-12 20:03:24'),
(1919, 'Vicentzo', 4, '* (chat log): cine i-a dat.', '2021-05-12 20:03:25'),
(1920, 'Vicentzo', 4, '* (chat log): ce pula mea.', '2021-05-12 20:03:27'),
(1921, 'Vicentzo', 4, '* (chat log): da ss.', '2021-05-12 20:03:39'),
(1922, 'Vicentzo', 4, '* (chat log): pe discord.', '2021-05-12 20:03:40'),
(1923, 'RoLEX', 7, '* (chat log): st.', '2021-05-12 20:03:41'),
(1924, 'Vicentzo', 4, '* (chat log): da ba pozaa.', '2021-05-12 20:04:24'),
(1925, 'Vicentzo', 4, '* (chat log): sa vad cum fac laba sus.', '2021-05-12 20:04:26'),
(1926, 'RoLEX', 7, '* (chat log): am dat.', '2021-05-12 20:04:40'),
(1927, 'RoLEX', 7, '* (chat log): si pe general.', '2021-05-12 20:04:42'),
(1928, 'RoLEX', 7, '* (chat log): si pe grup.', '2021-05-12 20:04:44'),
(1929, 'RoLEX', 7, '* (chat log): =()))).', '2021-05-12 20:05:00'),
(1930, 'RoLEX', 7, '* (chat log): pee.', '2021-05-12 20:05:16'),
(1931, 'Vicentzo', 4, '* (chat log): nu e cine stie ce.', '2021-05-12 20:05:17'),
(1932, 'Vicentzo', 4, '* (chat log): ba.', '2021-05-12 20:05:18'),
(1933, 'RoLEX', 7, '* (chat log): baaa.', '2021-05-12 20:05:21'),
(1934, 'RoLEX', 7, '* (chat log): dc ai plecat.', '2021-05-12 20:05:23'),
(1935, 'RoLEX', 7, '* (chat log): ca sa stau drept.', '2021-05-12 20:05:27'),
(1936, 'Vicentzo', 4, '* (chat log): fa-mi acuma.', '2021-05-12 20:05:28'),
(1937, 'Vicentzo', 4, '* (chat log): poza.', '2021-05-12 20:05:29'),
(1938, 'Vicentzo', 4, '* (chat log): una acum.', '2021-05-12 20:05:33'),
(1939, 'Vicentzo', 4, '* (chat log): si una asa.', '2021-05-12 20:05:37'),
(1940, 'RoLEX', 7, '* (chat log): st.', '2021-05-12 20:06:00'),
(1941, 'RoLEX', 7, '* (chat log): mi a dat crash.', '2021-05-12 20:06:03'),
(1942, 'RoLEX', 7, '* (chat log): diss.', '2021-05-12 20:06:04'),
(1943, 'RoLEX', 7, '* (chat log): imd.', '2021-05-12 20:06:04'),
(1944, 'RoLEX', 7, '* (chat log): gt.', '2021-05-12 20:06:53'),
(1945, 'RoLEX', 7, '* (chat log): eu ies.', '2021-05-13 20:41:30'),
(1946, 'RoLEX', 7, '* (chat log): re.', '2021-05-13 20:41:31'),
(1947, 'RoLEX', 7, '* (chat log): is pe tel.', '2021-05-13 20:47:17'),
(1948, 'RoLEX', 7, '* (chat log): dd.', '2021-05-13 20:48:30'),
(1949, 'andreea', 4, '* (chat log): asd.', '2021-05-14 09:51:12'),
(1950, 'andreea', 4, '* (chat log): sint bos.', '2021-05-14 09:51:13'),
(1951, 'andreea', 4, '* (chat log): asd.', '2021-05-14 09:51:21'),
(1952, 'Vicentzo', 4, '* (chat log): sint bos acum.', '2021-05-14 09:52:09'),
(1953, 'Vicentzo', 4, '* (chat log): LINISTE SE FUTE MA-TA.', '2021-05-14 09:57:28'),
(1954, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-14 09:57:33'),
(1955, 'Vicentzo', 4, '* (chat log): b-huhud.', '2021-05-14 09:57:36'),
(1956, 'Vicentzo', 4, '* (chat log): sint bos.', '2021-05-14 09:57:41'),
(1957, 'Vicentzo', 4, '* (chat log): iar sint bos.', '2021-05-14 09:57:45'),
(1958, 'RoLEX', 7, '* (chat log): .', '2021-05-14 10:03:40'),
(1959, 'RoLEX', 7, '* (chat log): f.', '2021-05-14 10:04:31'),
(1960, 'Adi', 20, '* (chat log): da am apk care arata fps.', '2021-05-14 16:46:13'),
(1961, 'Vicentzo', 4, '* (chat log): in alta ordine de ide.', '2021-05-14 16:46:14'),
(1962, 'Vicentzo', 4, '* (chat log): am vrut sa te intreb.', '2021-05-14 16:46:16'),
(1963, 'Vicentzo', 4, '* (chat log): ai un apk fara un keylogger sau cacaturi .', '2021-05-14 16:46:24'),
(1964, 'Vicentzo', 4, '* (chat log): cu f tab.', '2021-05-14 16:46:27'),
(1965, 'Vicentzo', 4, '* (chat log): etc.', '2021-05-14 16:46:28'),
(1966, 'Vicentzo', 4, '* (chat log): gen cu key.', '2021-05-14 16:46:31'),
(1967, 'Adi', 20, '* (chat log): e samp luncher se descarca de pe magazin play.', '2021-05-14 16:46:47'),
(1968, 'Vicentzo', 4, '* (chat log): si sa inteleg ca are si key-urile.', '2021-05-14 16:46:56'),
(1969, 'Vicentzo', 4, '* (chat log): necesare?.', '2021-05-14 16:46:57'),
(1970, 'Adi', 20, '* (chat log): nu.', '2021-05-14 16:47:04'),
(1971, 'Adi', 20, '* (chat log): bagi ip si te baga.', '2021-05-14 16:47:18'),
(1972, 'Vicentzo', 4, '* (chat log): ca la o poza am vazut ca undeva in stanga sus, aveati sa apsati f si asa mai departe.', '2021-05-14 16:47:24'),
(1973, 'Vicentzo', 4, '* (chat log): la asta ma refer.', '2021-05-14 16:47:26'),
(1974, 'Vicentzo', 4, '* (chat log): f tab y n.', '2021-05-14 16:47:41'),
(1975, 'Vicentzo', 4, '* (chat log): astea.', '2021-05-14 16:47:41'),
(1976, 'Adi', 20, '* (chat log): da.', '2021-05-14 16:48:57'),
(1977, 'Adi', 20, '* (chat log): avem de toate.', '2021-05-14 16:49:01'),
(1978, 'Vicentzo', 4, '* (chat log): ok bro, eventual iti voi face acum un canal de android-help.', '2021-05-14 16:49:13'),
(1979, 'Vicentzo', 4, '* (chat log): cu regim lent de cat vrei tu.', '2021-05-14 16:49:17'),
(1980, 'Vicentzo', 4, '* (chat log): daca mai ai pe cineva ca prieten si stii ca se pricepe cu android.', '2021-05-14 16:49:36'),
(1981, 'Vicentzo', 4, '* (chat log): ne spui si vedem poate ajunge si el android supporter.', '2021-05-14 16:49:42'),
(1982, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-14 17:24:06'),
(1983, 'Vicentzo', 4, '* (chat log): i-am dat kick.', '2021-05-14 17:25:05'),
(1984, 'Vicentzo', 4, '* (chat log): =)))))))))))))))).', '2021-05-14 17:25:07'),
(1985, 'Vicentzo', 4, '* (chat log): MOR.', '2021-05-14 17:25:08'),
(1986, 'Vicentzo', 4, '* (chat log): moor coaie.', '2021-05-14 17:25:58'),
(1987, 'Vicentzo', 4, '* (chat log): =))))))))).', '2021-05-14 17:26:01'),
(1988, 'Vicentzo', 4, '* (chat log): i-am mai dat kick cu aditsu.', '2021-05-14 17:26:04'),
(1989, 'Vicentzo', 4, '* (chat log): si ban i-a dat aditsu.', '2021-05-14 17:26:06'),
(1990, 'mr.bunny', 2, '* (chat log): =)).', '2021-05-14 17:26:09'),
(1991, 'Vicentzo', 4, '* (chat log): ne-am cacat pe noi.', '2021-05-14 17:26:10'),
(1992, 'Vicentzo', 4, '* (chat log): MOR COAIE.', '2021-05-14 17:26:11'),
(1993, 'Vicentzo', 4, '* (chat log): MA ABITIN SA NU RAD.', '2021-05-14 17:26:14'),
(1994, 'Vicentzo', 4, '* (chat log): NUSH CUM TU O FACI.', '2021-05-14 17:26:16'),
(1995, 'Vicentzo', 4, '* (chat log): ii dau iar.', '2021-05-14 17:26:20'),
(1996, 'Vicentzo', 4, '* (chat log): IAR.', '2021-05-14 17:26:26'),
(1997, 'Vicentzo', 4, '* (chat log): =))))))))))))))))))))))))))))))))))))).', '2021-05-14 17:26:31'),
(1998, 'mr.bunny', 2, '* (chat log): zii ca e de la pornhub.', '2021-05-14 17:26:48'),
(1999, 'Comorasu', 33, '* (chat log): aa.', '2021-05-14 17:26:59'),
(2000, 'Comorasu', 33, '* (chat log): re.', '2021-05-14 17:27:03'),
(2001, 'Vicentzo', 4, '* (chat log): mor coaie.', '2021-05-14 17:27:05'),
(2002, 'Comorasu', 33, '* (chat log): scz.', '2021-05-14 17:27:05'),
(2003, 'Vicentzo', 4, '* (chat log): =)))))))))))))))))))))).', '2021-05-14 17:27:06'),
(2004, 'Comorasu', 33, '* (chat log): =]]]]]]]]]]]]]]]]]]]]]]].', '2021-05-14 17:27:08'),
(2005, 'Comorasu', 33, '* (chat log): e gm de la 0 no?.', '2021-05-14 17:27:30'),
(2006, 'mr.bunny', 2, '* (chat log): nu.', '2021-05-14 17:27:33'),
(2007, 'Comorasu', 33, '* (chat log): aa\'.', '2021-05-14 17:27:36'),
(2008, 'Vicentzo', 4, '* (chat log): e gm hpq.', '2021-05-14 17:27:37'),
(2009, 'Vicentzo', 4, '* (chat log): nu e de la 0.', '2021-05-14 17:27:38'),
(2010, 'Comorasu', 33, '* (chat log): care hpq.', '2021-05-14 17:27:50'),
(2011, 'Vicentzo', 4, '* (chat log): bhuhud.', '2021-05-14 17:27:54'),
(2012, 'Comorasu', 33, '* (chat log): Hai k da.', '2021-05-14 17:27:59'),
(2013, 'Vicentzo', 4, '* (chat log): mor coaie.', '2021-05-14 17:28:00'),
(2014, 'mr.bunny', 2, '* (chat log): =).', '2021-05-14 17:28:03'),
(2015, 'Vicentzo', 4, '* (chat log): ii dau acum iar.', '2021-05-14 17:28:03'),
(2016, 'Vicentzo', 4, '* (chat log): skick.', '2021-05-14 17:28:04'),
(2017, 'Vicentzo', 4, '* (chat log): =))))))))))))))).', '2021-05-14 17:28:06'),
(2018, 'Comorasu', 33, '* (chat log): =]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]].', '2021-05-14 17:28:12'),
(2019, 'mr.bunny', 2, '* (chat log): Coaie ma trage o cacare.', '2021-05-14 17:28:15'),
(2020, 'mr.bunny', 2, '* (chat log): smr.', '2021-05-14 17:28:17'),
(2021, 'Comorasu', 33, '* (chat log): tine gura si caca=te.', '2021-05-14 17:28:23'),
(2022, 'Comorasu', 33, '* (chat log): =]]]]]]]]]]]]]]]]]]]]].', '2021-05-14 17:28:25'),
(2023, 'mr.bunny', 2, '* (chat log): tine o.', '2021-05-14 17:28:30'),
(2024, 'Vicentzo', 4, '* (chat log): ba comorasu.', '2021-05-14 17:28:34'),
(2025, 'Vicentzo', 4, '* (chat log): am o afacere pentru tine.', '2021-05-14 17:28:38'),
(2026, 'Vicentzo', 4, '* (chat log): iti dau 15 euro daca lucrezi impreuna cu hpq la gamemodu asta.', '2021-05-14 17:28:46'),
(2027, 'Comorasu', 33, '* (chat log): Numai scriptez mane.', '2021-05-14 17:28:55'),
(2028, 'Vicentzo', 4, '* (chat log): haide frateee.', '2021-05-14 17:28:58'),
(2029, 'Vicentzo', 4, '* (chat log): te ajuta hpq daca este ceva.', '2021-05-14 17:29:02'),
(2030, 'Vicentzo', 4, '* (chat log): am nevoie de 2 scripteri.', '2021-05-14 17:29:05'),
(2031, 'Comorasu', 33, '* (chat log): aa.', '2021-05-14 17:29:09'),
(2032, 'Comorasu', 33, '* (chat log): pai .', '2021-05-14 17:29:10'),
(2033, 'Comorasu', 33, '* (chat log): si dc.', '2021-05-14 17:29:12'),
(2034, 'Comorasu', 33, '* (chat log): nu .', '2021-05-14 17:29:13');
INSERT INTO `server_chat_logs` (`ID`, `PlayerName`, `PlayerID`, `ChatText`, `Time`) VALUES
(2035, 'Comorasu', 33, '* (chat log): il .', '2021-05-14 17:29:14'),
(2036, 'Comorasu', 33, '* (chat log): iei .', '2021-05-14 17:29:15'),
(2037, 'Comorasu', 33, '* (chat log): pe zews.', '2021-05-14 17:29:19'),
(2038, 'Comorasu', 33, '* (chat log): adv.', '2021-05-14 17:29:20'),
(2039, 'Vicentzo', 4, '* (chat log): cinei ala.', '2021-05-14 17:29:22'),
(2040, 'Vicentzo', 4, '* (chat log): alai un neaauzit.', '2021-05-14 17:29:24'),
(2041, 'Vicentzo', 4, '* (chat log): tu iesti cunoscut.', '2021-05-14 17:29:28'),
(2042, 'Vicentzo', 4, '* (chat log): nu ca tn.', '2021-05-14 17:29:29'),
(2043, 'Comorasu', 33, '* (chat log): ca eu is scripter sezonier.', '2021-05-14 17:29:32'),
(2044, 'Vicentzo', 4, '* (chat log): aaaa.', '2021-05-14 17:29:36'),
(2045, 'Vicentzo', 4, '* (chat log): esti dala.', '2021-05-14 17:29:39'),
(2046, 'mr.bunny', 2, '* (chat log): trag pe dreapta sa merg la cacare.', '2021-05-14 17:29:40'),
(2047, 'Vicentzo', 4, '* (chat log): trece sezonu.', '2021-05-14 17:29:40'),
(2048, 'Vicentzo', 4, '* (chat log): teai dus si tu.', '2021-05-14 17:29:42'),
(2049, 'Comorasu', 33, '* (chat log): m-a facut waller vedeta.', '2021-05-14 17:29:43'),
(2050, 'Comorasu', 33, '* (chat log): mai bine asa.', '2021-05-14 17:29:53'),
(2051, 'Vicentzo', 4, '* (chat log): glm mane.', '2021-05-14 17:30:08'),
(2052, 'Comorasu', 33, '* (chat log): mr.bunny porneste motorul vehicului Infernus.', '2021-05-14 17:30:11'),
(2053, 'Comorasu', 33, '* (chat log): xcz.', '2021-05-14 17:30:29'),
(2054, 'Comorasu', 33, '* (chat log): stai ma.', '2021-05-14 17:30:39'),
(2055, 'Comorasu', 33, '* (chat log): gt.', '2021-05-14 17:30:43'),
(2056, 'Comorasu', 33, '* (chat log): Bagati si sampcac?.', '2021-05-14 17:31:04'),
(2057, 'Comorasu', 33, '* (chat log): mama.', '2021-05-14 17:31:05'),
(2058, 'Comorasu', 33, '* (chat log): cee aici.', '2021-05-14 17:31:07'),
(2059, 'Comorasu', 33, '* (chat log): peste tot mappiung.', '2021-05-14 17:31:23'),
(2060, 'Comorasu', 33, '* (chat log): clar.', '2021-05-14 17:31:24'),
(2061, 'Vicentzo', 4, '* (chat log): nu stiu daca o sa bagam si sampcac.', '2021-05-14 17:31:36'),
(2062, 'Comorasu', 33, '* (chat log): aa.', '2021-05-14 17:31:44'),
(2063, 'Vicentzo', 4, '* (chat log): posibil ca va fi nevoie la un moment sa bagam si un ac clientside.', '2021-05-14 17:31:47'),
(2064, 'Comorasu', 33, '* (chat log): ii dau ban lui rolex?.', '2021-05-14 17:32:04'),
(2065, 'Comorasu', 33, '* (chat log): =]].', '2021-05-14 17:32:07'),
(2066, 'Vicentzo', 4, '* (chat log): nu.', '2021-05-14 17:32:08'),
(2067, 'Comorasu', 33, '* (chat log): ok.', '2021-05-14 17:32:12'),
(2068, 'Comorasu', 33, '* (chat log): brb.', '2021-05-14 17:32:29'),
(2069, 'Comorasu', 33, '* (chat log): am gasit un bug.', '2021-05-14 17:33:04'),
(2070, 'Vicentzo', 4, '* (chat log): ce bug.', '2021-05-14 17:33:08'),
(2071, 'Comorasu', 33, '* (chat log):  /factions.', '2021-05-14 17:33:10'),
(2072, 'Vicentzo', 4, '* (chat log): stiu.', '2021-05-14 17:33:15'),
(2073, 'Comorasu', 33, '* (chat log): l-am raportat.', '2021-05-14 17:33:21'),
(2074, 'Comorasu', 33, '* (chat log): Nu poti sa i dai kick acestui jucator..', '2021-05-14 17:34:23'),
(2075, 'Comorasu', 33, '* (chat log): :(((((((((((((((((((.', '2021-05-14 17:34:25'),
(2076, 'Vicentzo', 4, '* (chat log): aolo.', '2021-05-14 17:34:37'),
(2077, 'Vicentzo', 4, '* (chat log): iti darolex.', '2021-05-14 17:34:39'),
(2078, 'Vicentzo', 4, '* (chat log): kick.', '2021-05-14 17:34:40'),
(2079, 'Vicentzo', 4, '* (chat log): omaigad.', '2021-05-14 17:34:40'),
(2080, 'RoLEX', 7, '* (chat log): imi pare bine....', '2021-05-14 17:54:21'),
(2081, 'RoLEX', 7, '* (chat log): atat a fost.', '2021-05-14 17:54:23'),
(2082, 'mr.bunny', 2, '* (chat log): =)).', '2021-05-14 17:54:26'),
(2083, 'RoLEX', 7, '* (chat log): bye.', '2021-05-14 17:54:35'),
(2084, 'mr.bunny', 2, '* (chat log): cveaw.', '2021-05-14 17:54:39'),
(2085, 'RoLEX', 7, '* (chat log):  .', '2021-05-14 17:57:20'),
(2086, 'RoLEX', 7, '* (chat log): ..', '2021-05-14 17:57:29'),
(2087, 'fkffkfk', 7, '* (chat log): fdf.', '2021-05-14 18:30:39'),
(2088, 'fkffkfk', 7, '* (chat log): ff.', '2021-05-14 18:30:45'),
(2089, 'fkffkfk', 7, '* (chat log): fff.', '2021-05-14 18:30:48'),
(2090, 'RoLEX', 7, '* (chat log): fff.', '2021-05-14 18:31:00'),
(2091, 'AnDreeW', 36, '* (chat log): f.', '2021-05-14 18:41:38'),
(2092, 'AnDreeW', 36, '* (chat log): nu era asta parca.', '2021-05-14 18:41:54'),
(2093, 'AnDreeW', 36, '* (chat log): imi arata.', '2021-05-14 18:41:55'),
(2094, 'AnDreeW', 36, '* (chat log): bara de jos.', '2021-05-14 18:41:56'),
(2095, 'AnDreeW', 36, '* (chat log): progress.', '2021-05-14 18:41:58'),
(2096, 'AnDreeW', 36, '* (chat log): level.', '2021-05-14 18:41:58'),
(2097, 'Vicentzo', 4, '* (chat log): da.', '2021-05-14 18:42:01'),
(2098, 'Vicentzo', 4, '* (chat log): a fost schimbata.', '2021-05-14 18:42:02'),
(2099, 'Vicentzo', 4, '* (chat log): .a sa facem sistem de femei.', '2021-05-14 18:43:12'),
(2100, 'Vicentzo', 4, '* (chat log): .a hai ca da.', '2021-05-14 18:43:47'),
(2101, 'mr.bunny', 2, '* (chat log): sdsadas.', '2021-05-14 18:54:18'),
(2102, 'mr.bunny', 2, '* (chat log): asdsa.', '2021-05-14 18:54:19'),
(2103, 'mr.bunny', 2, '* (chat log): sadsa.', '2021-05-14 18:54:20'),
(2104, 'mr.bunny', 2, '* (chat log): sadsa.', '2021-05-14 18:54:30'),
(2105, 'mr.bunny', 2, '* (chat log): sadsa.', '2021-05-14 18:54:32'),
(2106, 'RoLEX', 7, '* (chat log): pee.', '2021-05-14 18:55:22'),
(2107, 'RoLEX', 7, '* (chat log): ff.', '2021-05-14 18:59:27'),
(2108, 'mr.bunny', 2, '* (chat log): Sall.', '2021-05-14 20:45:54'),
(2109, 'SebyP4', 23, '* (chat log): s.', '2021-05-14 20:50:20'),
(2110, 'SebyP4', 23, '* (chat log): merge bunny.', '2021-05-14 20:50:35'),
(2111, 'SebyP4', 23, '* (chat log): nigga.', '2021-05-14 20:50:47'),
(2112, 'SebyP4', 23, '* (chat log): ups.', '2021-05-14 20:50:51'),
(2113, 'SebyP4', 23, '* (chat log): wrong.', '2021-05-14 20:50:52'),
(2114, 'SebyP4', 23, '* (chat log): s.', '2021-05-14 20:51:29'),
(2115, 'SebyP4', 23, '* (chat log): fsd.', '2021-05-14 20:51:32'),
(2116, 'mr.bunny', 2, '* (chat log): am pus deelay pe comenzi.', '2021-05-15 11:21:09'),
(2117, 'RoLEX', 7, '* (chat log): e bn.', '2021-05-15 11:21:13'),
(2118, 'mr.bunny', 2, '* (chat log): incearca sa spamezi comenzi.', '2021-05-15 11:21:15'),
(2119, 'RoLEX', 7, '* (chat log): la ban ai pus mai multa?.', '2021-05-15 11:21:31'),
(2120, 'RoLEX', 7, '* (chat log): delay.', '2021-05-15 11:21:34'),
(2121, 'RoLEX', 7, '* (chat log): f.', '2021-05-15 11:27:18'),
(2122, 'RoLEX', 7, '* (chat log): ff.', '2021-05-15 11:29:40'),
(2123, 'RoLEX', 7, '* (chat log): f.', '2021-05-15 11:29:47'),
(2124, 'mr.bunny', 2, '* (chat log): nu am telefon.', '2021-05-15 11:30:03'),
(2125, 'mr.bunny', 2, '* (chat log): esti surd?.', '2021-05-15 11:30:05'),
(2126, 'mr.bunny', 2, '* (chat log): unde este? .', '2021-05-15 11:30:13'),
(2127, 'mr.bunny', 2, '* (chat log): sdsa.', '2021-05-15 11:32:12'),
(2128, 'RoLEX', 7, '* (chat log): .', '2021-05-15 11:39:37'),
(2129, 'RoLEX', 7, '* (chat log): ad.', '2021-05-15 11:59:41'),
(2130, 'mr.bunny', 2, '* (chat log): @everyone =)).', '2021-05-15 13:21:35'),
(2131, 'mr.bunny', 2, '* (chat log): reactioneaza daca ai vazut mesaju.', '2021-05-15 13:21:59'),
(2132, 'mr.bunny', 2, '* (chat log): @xshadow tu dc nu intri pe server ?.', '2021-05-15 13:22:18'),
(2133, 'mr.bunny', 2, '* (chat log): <?445901733550620674>.', '2021-05-15 13:22:29'),
(2134, 'mr.bunny', 2, '* (chat log): <@445901733550620674>.', '2021-05-15 13:23:06'),
(2135, 'mr.bunny', 2, '* (chat log): <@445901733550620674> .', '2021-05-15 13:23:11'),
(2136, 'mr.bunny', 2, '* (chat log): <@445901733550620674>  .', '2021-05-15 13:23:12'),
(2137, 'mr.bunny', 2, '* (chat log): <@445901733550620674>   .', '2021-05-15 13:23:13'),
(2138, 'mr.bunny', 2, '* (chat log): <@445901733550620674>    .', '2021-05-15 13:23:14'),
(2139, 'mr.bunny', 2, '* (chat log): <@445901733550620674>     .', '2021-05-15 13:23:15'),
(2140, 'mr.bunny', 2, '* (chat log): <@445901733550620674>      INTRA PE JOC.', '2021-05-15 13:23:21'),
(2141, 'mr.bunny', 2, '* (chat log): dc?.', '2021-05-15 13:23:27'),
(2142, 'mr.bunny', 2, '* (chat log): intra de pe tell.', '2021-05-15 13:23:33'),
(2143, 'mr.bunny', 2, '* (chat log): este samp pt telfon.', '2021-05-15 13:23:37'),
(2144, 'mr.bunny', 2, '* (chat log): merg la sala, reee @.', '2021-05-15 13:24:14'),
(2145, 'RoLEX', 7, '* (chat log): ;;.', '2021-05-15 14:01:06'),
(2146, 'Vicentzo', 4, '* (chat log): android test.', '2021-05-15 19:03:00'),
(2147, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-15 20:03:35'),
(2148, 'Vicentzo', 4, '* (chat log): ALO.', '2021-05-15 20:03:36'),
(2149, 'SebyP4', 23, '* (chat log): s.', '2021-05-15 20:10:59'),
(2150, 'mr.buni', 4, '* (chat log): stii cine is io.', '2021-05-15 20:55:53'),
(2151, 'mr.buni', 4, '* (chat log): STII CINE IS IO X2?.', '2021-05-15 20:55:59'),
(2152, 'mr.bunny', 2, '* (chat log): 539.', '2021-05-16 09:28:12'),
(2153, 'Vicentzo', 4, '* (chat log): asd.', '2021-05-16 09:35:59'),
(2154, 'Vicentzo', 4, '* (chat log): sunt bos.', '2021-05-16 10:51:55'),
(2155, 'RoLEX', 7, '* (chat log): eu ti am zis cu despawnarea.', '2021-05-16 11:03:36'),
(2156, 'RoLEX', 7, '* (chat log): masinilor.', '2021-05-16 11:03:38'),
(2157, 'RoLEX', 7, '* (chat log): uite ce e aici.', '2021-05-16 11:03:41'),
(2158, 'Vicentzo', 4, '* (chat log): pai am spawnat noi.', '2021-05-16 11:03:44'),
(2159, 'Vicentzo', 4, '* (chat log): dai aici svf.', '2021-05-16 11:04:32'),
(2160, 'RoLEX', 7, '* (chat log): n am licents.', '2021-05-16 11:04:43'),
(2161, 'RoLEX', 7, '* (chat log): de condus.', '2021-05-16 11:04:45'),
(2162, 'RoLEX', 7, '* (chat log): tu le ai scos.', '2021-05-16 11:04:51'),
(2163, 'RoLEX', 7, '* (chat log): ?.', '2021-05-16 11:04:52'),
(2164, 'Vicentzo', 4, '* (chat log): nu.', '2021-05-16 11:04:54'),
(2165, 'RoLEX', 7, '* (chat log): pai si atunci cum mi au disparut.', '2021-05-16 11:04:59'),
(2166, 'Vicentzo', 4, '* (chat log): de la payday probabil.', '2021-05-16 11:05:04'),
(2167, 'Vicentzo', 4, '* (chat log): cred.', '2021-05-16 11:05:15'),
(2168, 'Vicentzo', 4, '* (chat log): deci acum tre sa iti zica.', '2021-05-16 11:05:21'),
(2169, 'Vicentzo', 4, '* (chat log): ca am viata.', '2021-05-16 11:05:22'),
(2170, 'Vicentzo', 4, '* (chat log): da-mi heal.', '2021-05-16 11:05:24'),
(2171, 'RoLEX', 7, '* (chat log): ai destula.', '2021-05-16 11:05:31'),
(2172, 'Vicentzo', 4, '* (chat log): stai asa.', '2021-05-16 11:05:42'),
(2173, 'Vicentzo', 4, '* (chat log): ia da acum.', '2021-05-16 11:05:54'),
(2174, 'RoLEX', 7, '* (chat log): N AI Bani.', '2021-05-16 11:05:57'),
(2175, 'RoLEX', 7, '* (chat log): scz caps.', '2021-05-16 11:05:59'),
(2176, 'Vicentzo', 4, '* (chat log): pe cat ai dat.', '2021-05-16 11:06:03'),
(2177, 'RoLEX', 7, '* (chat log): 100.', '2021-05-16 11:06:05'),
(2178, 'Vicentzo', 4, '* (chat log): uite bugu.', '2021-05-16 11:06:08'),
(2179, 'Vicentzo', 4, '* (chat log): ca am facut verificarea.', '2021-05-16 11:06:14'),
(2180, 'RoLEX', 7, '* (chat log): =)).', '2021-05-16 11:06:14'),
(2181, 'Vicentzo', 4, '* (chat log): daca ai bani.', '2021-05-16 11:06:15'),
(2182, 'Vicentzo', 4, '* (chat log): sa iti dea asta.', '2021-05-16 11:06:17'),
(2183, 'Vicentzo', 4, '* (chat log): ...', '2021-05-16 11:06:17'),
(2184, 'RoLEX', 7, '* (chat log): am inteles.', '2021-05-16 11:06:20'),
(2185, 'Vicentzo', 4, '* (chat log): uite.', '2021-05-16 11:06:23'),
(2186, 'Vicentzo', 4, '* (chat log): fi atent.', '2021-05-16 11:06:24'),
(2187, 'RoLEX', 7, '* (chat log): modifica acm sa nu uiti.', '2021-05-16 11:06:26'),
(2188, 'Vicentzo', 4, '* (chat log): ia dai acum.', '2021-05-16 11:06:30'),
(2189, 'Vicentzo', 4, '* (chat log): o sa iti zica ca am destula.', '2021-05-16 11:06:33'),
(2190, 'RoLEX', 7, '* (chat log): ai destula.', '2021-05-16 11:06:37'),
(2191, 'Vicentzo', 4, '* (chat log): BAG PULA-N MODPACKU LU ALA.', '2021-05-16 11:06:41'),
(2192, 'Vicentzo', 4, '* (chat log): CA IMI FUTE TIMPU AIUREA.', '2021-05-16 11:06:44'),
(2193, 'Vicentzo', 4, '* (chat log): ca ei au modpack-uri ma.', '2021-05-16 11:06:51'),
(2194, 'RoLEX', 7, '* (chat log): pai n aveam de unde siti.', '2021-05-16 11:06:53'),
(2195, 'Vicentzo', 4, '* (chat log): eu m-am uitat la verificare.', '2021-05-16 11:07:00'),
(2196, 'Vicentzo', 4, '* (chat log): si stiam ca e bine.', '2021-05-16 11:07:01'),
(2197, 'RoLEX', 7, '* (chat log): d aia nu imi  au modpack uri.', '2021-05-16 11:07:04'),
(2198, 'Vicentzo', 4, '* (chat log): da vine sebyp4.', '2021-05-16 11:07:04'),
(2199, 'RoLEX', 7, '* (chat log): <3.', '2021-05-16 11:07:06'),
(2200, 'Vicentzo', 4, '* (chat log): nu inteleg de ce plm.', '2021-05-16 11:07:09'),
(2201, 'Vicentzo', 4, '* (chat log): nu foloses default.', '2021-05-16 11:07:11'),
(2202, 'Vicentzo', 4, '* (chat log): ca e foarte frumos default.', '2021-05-16 11:07:14'),
(2203, 'RoLEX', 7, '* (chat log): dapw.', '2021-05-16 11:07:16'),
(2204, 'Vicentzo', 4, '* (chat log): si eu eram inainte.', '2021-05-16 11:07:21'),
(2205, 'Vicentzo', 4, '* (chat log): modpack pula mea.', '2021-05-16 11:07:24'),
(2206, 'Vicentzo', 4, '* (chat log): da ma ajuta default.', '2021-05-16 11:07:26'),
(2207, 'Vicentzo', 4, '* (chat log): la scripting.', '2021-05-16 11:07:27'),
(2208, 'RoLEX', 7, '* (chat log): coaie logic.', '2021-05-16 11:07:31'),
(2209, 'RoLEX', 7, '* (chat log): fiindca.', '2021-05-16 11:07:32'),
(2210, 'RoLEX', 7, '* (chat log): modkacp urile.', '2021-05-16 11:07:35'),
(2211, 'Vicentzo', 4, '* (chat log): ca unele moduri corup jocu.', '2021-05-16 11:07:36'),
(2212, 'RoLEX', 7, '* (chat log): te fac sa bug uiesti sv.', '2021-05-16 11:07:40'),
(2213, 'RoLEX', 7, '* (chat log): gen for you.', '2021-05-16 11:07:42'),
(2214, 'RoLEX', 7, '* (chat log): pentru tine.', '2021-05-16 11:07:47'),
(2215, 'RoLEX', 7, '* (chat log): nu la toti.', '2021-05-16 11:07:50'),
(2216, 'RoLEX', 7, '* (chat log): logic.', '2021-05-16 11:07:52'),
(2217, 'Vicentzo', 4, '* (chat log): sa vezi ce am futut aseara.', '2021-05-16 11:08:00'),
(2218, 'RoLEX', 7, '* (chat log): pestele.', '2021-05-16 11:08:04'),
(2219, 'RoLEX', 7, '* (chat log): =)).', '2021-05-16 11:08:06'),
(2220, 'Vicentzo', 4, '* (chat log): da ma da fac ca imogen.', '2021-05-16 11:08:09'),
(2221, 'Vicentzo', 4, '* (chat log): dau muie la peste.', '2021-05-16 11:08:11'),
(2222, 'Vicentzo', 4, '* (chat log): de unde pula mea sa fut eu.', '2021-05-16 11:08:14'),
(2223, 'RoLEX', 7, '* (chat log): ce ai facut?.', '2021-05-16 11:08:14'),
(2224, 'Vicentzo', 4, '* (chat log): nimica.', '2021-05-16 11:08:16'),
(2225, 'RoLEX', 7, '* (chat log): ce ai prins.', '2021-05-16 11:08:17'),
(2226, 'Vicentzo', 4, '* (chat log): am scriptat.', '2021-05-16 11:08:18'),
(2227, 'Vicentzo', 4, '* (chat log): ce sa prind.', '2021-05-16 11:08:23'),
(2228, 'RoLEX', 7, '* (chat log): pai ce ai prins.', '2021-05-16 11:08:24'),
(2229, 'Vicentzo', 4, '* (chat log): am prins o pula.', '2021-05-16 11:08:25'),
(2230, 'RoLEX', 7, '* (chat log): peste coaie ai zis ca ai fost la peste in plm.', '2021-05-16 11:08:33'),
(2231, 'Vicentzo', 4, '* (chat log): am prins pula de la peste.', '2021-05-16 11:08:42'),
(2232, 'Vicentzo', 4, '* (chat log): ce sa prind.', '2021-05-16 11:08:44'),
(2233, 'Vicentzo', 4, '* (chat log): ca n-am prins nika.', '2021-05-16 11:08:46'),
(2234, 'RoLEX', 7, '* (chat log): mda.', '2021-05-16 11:08:49'),
(2235, 'RoLEX', 7, '* (chat log): teaca...', '2021-05-16 11:08:55'),
(2236, 'Vicentzo', 4, '* (chat log): futul in gura pe shadow.', '2021-05-16 11:08:56'),
(2237, 'Vicentzo', 4, '* (chat log): pe lekroy ala.', '2021-05-16 11:08:58'),
(2238, 'RoLEX', 7, '* (chat log): i ai vazut cureaua.', '2021-05-16 11:09:00'),
(2239, 'Vicentzo', 4, '* (chat log): mafia smekereilor.', '2021-05-16 11:09:01'),
(2240, 'Vicentzo', 4, '* (chat log): pula mea.', '2021-05-16 11:09:02'),
(2241, 'RoLEX', 7, '* (chat log): da.', '2021-05-16 11:09:03'),
(2242, 'RoLEX', 7, '* (chat log): eu am iesi.', '2021-05-16 11:09:05'),
(2243, 'Vicentzo', 4, '* (chat log): e activ.', '2021-05-16 11:09:05'),
(2244, 'Vicentzo', 4, '* (chat log): e si staff.', '2021-05-16 11:09:06'),
(2245, 'Vicentzo', 4, '* (chat log): e pula mea.', '2021-05-16 11:09:08'),
(2246, 'Vicentzo', 4, '* (chat log): la noi.', '2021-05-16 11:09:09'),
(2247, 'Vicentzo', 4, '* (chat log): o muie.', '2021-05-16 11:09:10'),
(2248, 'RoLEX', 7, '* (chat log): bag pl in ma sa de grup.', '2021-05-16 11:09:11'),
(2249, 'RoLEX', 7, '* (chat log): coaie are probleme gen dar nu inteleg daca la noi e la ei este.', '2021-05-16 11:09:33'),
(2250, 'Vicentzo', 4, '* (chat log): stai putin sa beau un pahar cu apa.', '2021-05-16 11:09:34'),
(2251, 'RoLEX', 7, '* (chat log): k.', '2021-05-16 11:09:39'),
(2252, 'RoLEX', 7, '* (chat log): are probleme grave gen mi a zis mie....', '2021-05-16 11:09:50'),
(2253, 'Vicentzo', 4, '* (chat log): probleme grave?.', '2021-05-16 11:10:34'),
(2254, 'RoLEX', 7, '* (chat log): coaie.', '2021-05-16 11:10:38'),
(2255, 'RoLEX', 7, '* (chat log): daca nu stii.', '2021-05-16 11:10:43'),
(2256, 'RoLEX', 7, '* (chat log): e nenorocit tipu.', '2021-05-16 11:10:47'),
(2257, 'Vicentzo', 4, '* (chat log): ba te inteleg , probleme grave pula mea.', '2021-05-16 11:10:47'),
(2258, 'RoLEX', 7, '* (chat log): ....', '2021-05-16 11:10:48'),
(2259, 'Vicentzo', 4, '* (chat log): ai probleme grave plm.', '2021-05-16 11:10:53'),
(2260, 'RoLEX', 7, '* (chat log): dak ai siti.', '2021-05-16 11:10:54'),
(2261, 'Vicentzo', 4, '* (chat log): da ba.', '2021-05-16 11:10:56'),
(2262, 'Vicentzo', 4, '* (chat log): fi atent.', '2021-05-16 11:10:58'),
(2263, 'RoLEX', 7, '* (chat log): stii.....', '2021-05-16 11:10:59'),
(2264, 'Vicentzo', 4, '* (chat log): asculta-mi putin perspectiva.', '2021-05-16 11:11:03'),
(2265, 'RoLEX', 7, '* (chat log): k.', '2021-05-16 11:11:05'),
(2266, 'Vicentzo', 4, '* (chat log): ok, ti-ai instalat samp ai spus ca ne poti ajuta acum.', '2021-05-16 11:11:10'),
(2267, 'Vicentzo', 4, '* (chat log): ok.', '2021-05-16 11:11:12'),
(2268, 'Vicentzo', 4, '* (chat log): asa a spus el.', '2021-05-16 11:11:16'),
(2269, 'Vicentzo', 4, '* (chat log): bun.', '2021-05-16 11:11:18'),
(2270, 'Vicentzo', 4, '* (chat log): inteleg ca ai probleme grave, nimeni nu iti spune joaca-te sau imi bag pula-n gura ta.', '2021-05-16 11:11:28'),
(2271, 'Vicentzo', 4, '* (chat log): nimeni nu te-a obligat.', '2021-05-16 11:11:31'),
(2272, 'Vicentzo', 4, '* (chat log): dar.', '2021-05-16 11:11:33'),
(2273, 'Vicentzo', 4, '* (chat log): coaie.', '2021-05-16 11:11:34'),
(2274, 'Vicentzo', 4, '* (chat log): macar.', '2021-05-16 11:11:35'),
(2275, 'Vicentzo', 4, '* (chat log): mesaj pe server ceva.', '2021-05-16 11:11:41'),
(2276, 'RoLEX', 7, '* (chat log): a zis ca la deschidere e activ .', '2021-05-16 11:11:45'),
(2277, 'Vicentzo', 4, '* (chat log): aduci un.', '2021-05-16 11:11:46'),
(2278, 'RoLEX', 7, '* (chat log): 100#.', '2021-05-16 11:11:47'),
(2279, 'Vicentzo', 4, '* (chat log): beta-tester.', '2021-05-16 11:11:48'),
(2280, 'Vicentzo', 4, '* (chat log): coaie daon pula mea de deschidere.', '2021-05-16 11:11:56'),
(2281, 'Vicentzo', 4, '* (chat log): ca noi avem nevoie.', '2021-05-16 11:11:59'),
(2282, 'Vicentzo', 4, '* (chat log): de ajutor acum.', '2021-05-16 11:12:00'),
(2283, 'Vicentzo', 4, '* (chat log): beta-testeri ceva.', '2021-05-16 11:12:04'),
(2284, 'Vicentzo', 4, '* (chat log): idei pula mea.', '2021-05-16 11:12:06'),
(2285, 'Vicentzo', 4, '* (chat log): totusi.', '2021-05-16 11:12:14'),
(2286, 'RoLEX', 7, '* (chat log): mda.', '2021-05-16 11:12:14'),
(2287, 'RoLEX', 7, '* (chat log): fi antena.', '2021-05-16 11:12:17'),
(2288, 'RoLEX', 7, '* (chat log): am o intrb.', '2021-05-16 11:12:19'),
(2289, 'Vicentzo', 4, '* (chat log): ?.', '2021-05-16 11:12:21'),
(2290, 'RoLEX', 7, '* (chat log): dar eu stalpii astia care ii sparg.', '2021-05-16 11:12:24'),
(2291, 'RoLEX', 7, '* (chat log): se mai repara?.', '2021-05-16 11:12:27'),
(2292, 'Vicentzo', 4, '* (chat log): pai cred ca nu.', '2021-05-16 11:12:34'),
(2293, 'Vicentzo', 4, '* (chat log): doar la relog.', '2021-05-16 11:12:36'),
(2294, 'Vicentzo', 4, '* (chat log): plm stie.', '2021-05-16 11:12:37'),
(2295, 'RoLEX', 7, '* (chat log): ok.', '2021-05-16 11:12:40'),
(2296, 'Vicentzo', 4, '* (chat log): orikum medicu puli mele.', '2021-05-16 11:12:54'),
(2297, 'Vicentzo', 4, '* (chat log): tre sa platesti.', '2021-05-16 11:12:56'),
(2298, 'RoLEX', 7, '* (chat log): repara aia cu heal sa nu uiti.', '2021-05-16 11:12:56'),
(2299, 'Vicentzo', 4, '* (chat log): ahahhaa.', '2021-05-16 11:12:57'),
(2300, 'Vicentzo', 4, '* (chat log): dadada.', '2021-05-16 11:13:00'),
(2301, 'RoLEX', 7, '* (chat log): ma duc.', '2021-05-16 11:13:15'),
(2302, 'RoLEX', 7, '* (chat log): la ad.', '2021-05-16 11:13:16'),
(2303, 'RoLEX', 7, '* (chat log): imi apare.', '2021-05-16 11:21:47'),
(2304, 'RoLEX', 7, '* (chat log): mie.', '2021-05-16 11:21:48'),
(2305, 'Vicentzo', 4, '* (chat log): ui ce skin am.', '2021-05-16 11:21:52'),
(2306, 'Vicentzo', 4, '* (chat log): bagamias pula.', '2021-05-16 11:21:54'),
(2307, 'RoLEX', 7, '* (chat log): skin de tagan.', '2021-05-16 11:22:04'),
(2308, 'RoLEX', 7, '* (chat log): in factiune de PD.', '2021-05-16 11:22:08'),
(2309, 'RoLEX', 7, '* (chat log): stie mafia.', '2021-05-16 11:22:14'),
(2310, 'RoLEX', 7, '* (chat log): ce stie.', '2021-05-16 11:22:15'),
(2311, 'RoLEX', 7, '* (chat log): mafia guduraku.', '2021-05-16 11:22:20'),
(2312, 'Vicentzo', 4, '* (chat log): baa.', '2021-05-16 11:22:24'),
(2313, 'Vicentzo', 4, '* (chat log): mi-am dat seama.', '2021-05-16 11:22:26'),
(2314, 'Vicentzo', 4, '* (chat log): BAGAMIAS PULA-N EL DE QUERY.', '2021-05-16 11:22:29'),
(2315, 'Vicentzo', 4, '* (chat log): DACA ERAU MAI MULTI PLAYER.', '2021-05-16 11:22:32'),
(2316, 'RoLEX', 7, '* (chat log): query iar.', '2021-05-16 11:22:33'),
(2317, 'Vicentzo', 4, '* (chat log): LE APAREAU LA TOTI.', '2021-05-16 11:22:34'),
(2318, 'RoLEX', 7, '* (chat log): wow.', '2021-05-16 11:22:37'),
(2319, 'Vicentzo', 4, '* (chat log): nu era doar pe player.', '2021-05-16 11:22:42'),
(2320, 'RoLEX', 7, '* (chat log): baga ti ai pl in el de query.', '2021-05-16 11:22:43'),
(2321, 'Vicentzo', 4, '* (chat log): acum o sa apara bn.', '2021-05-16 11:22:44'),
(2322, 'Vicentzo', 4, '* (chat log): nu e query.', '2021-05-16 11:22:46'),
(2323, 'Vicentzo', 4, '* (chat log): ie tquery.', '2021-05-16 11:22:47'),
(2324, 'RoLEX', 7, '* (chat log): bn.', '2021-05-16 11:22:50'),
(2325, 'Vicentzo', 4, '* (chat log): da in sine e cueri.', '2021-05-16 11:22:51'),
(2326, 'Vicentzo', 4, '* (chat log): stai ase.', '2021-05-16 11:22:52'),
(2327, 'Vicentzo', 4, '* (chat log): ca imd termin.', '2021-05-16 11:22:54'),
(2328, 'RoLEX', 7, '* (chat log): repara aia cu seif.', '2021-05-16 11:23:39'),
(2329, 'RoLEX', 7, '* (chat log): sa dea eroare.', '2021-05-16 11:23:43'),
(2330, 'RoLEX', 7, '* (chat log): ca nu ai arme in seif ca sa dai /order.', '2021-05-16 11:23:52'),
(2331, 'RoLEX', 7, '* (chat log): sau cv.', '2021-05-16 11:23:55'),
(2332, 'RoLEX', 7, '* (chat log): ca asa nu apare nimic.', '2021-05-16 11:24:00'),
(2333, 'RoLEX', 7, '* (chat log): sa nu mai dai rr uri multe.', '2021-05-16 11:24:10'),
(2334, 'Vicentzo', 4, '* (chat log): la admin.', '2021-05-16 11:26:21'),
(2335, 'Vicentzo', 4, '* (chat log): nu ar fi ok sa punem rosu.', '2021-05-16 11:26:27'),
(2336, 'Vicentzo', 4, '* (chat log): ca plm.', '2021-05-16 11:26:29'),
(2337, 'RoLEX', 7, '* (chat log): dc.', '2021-05-16 11:26:33'),
(2338, 'RoLEX', 7, '* (chat log): sa stie ca suntem adm.', '2021-05-16 11:26:37'),
(2339, 'Vicentzo', 4, '* (chat log): pai am pus eu o functie.', '2021-05-16 11:26:38'),
(2340, 'Vicentzo', 4, '* (chat log): sa ii ia culoarea numelui.', '2021-05-16 11:26:44'),
(2341, 'Vicentzo', 4, '* (chat log): si practic daca o luam teoretic.', '2021-05-16 11:26:51'),
(2342, 'RoLEX', 7, '* (chat log): aa atunci l;asa la factiune.', '2021-05-16 11:26:55'),
(2343, 'Vicentzo', 4, '* (chat log): daca esti admin sa iti puna culoarea rosu.', '2021-05-16 11:26:56'),
(2344, 'Vicentzo', 4, '* (chat log): am facut doar la factiune.', '2021-05-16 11:27:00'),
(2345, 'RoLEX', 7, '* (chat log): da.', '2021-05-16 11:27:03'),
(2346, 'RoLEX', 7, '* (chat log): asa.', '2021-05-16 11:27:04'),
(2347, 'RoLEX', 7, '* (chat log): e bn.', '2021-05-16 11:27:06'),
(2348, 'RoLEX', 7, '* (chat log): dar cum e calculat payday ul.', '2021-05-16 11:27:19'),
(2349, 'RoLEX', 7, '* (chat log): ca vad ca nu i la ore fixe.', '2021-05-16 11:27:23'),
(2350, 'RoLEX', 7, '* (chat log): de la 14 ex la 15.', '2021-05-16 11:27:33'),
(2351, 'mata', 7, '* (chat log): ff.', '2021-05-16 11:29:37'),
(2352, 'mata', 7, '* (chat log): tg.', '2021-05-16 11:29:45'),
(2353, 'mata', 7, '* (chat log): fff.', '2021-05-16 11:29:48'),
(2354, 'RoLEX', 7, '* (chat log):  .', '2021-05-16 11:41:29'),
(2355, 'RoLEX', 7, '* (chat log): ff.', '2021-05-16 11:46:14'),
(2356, 'RoLEX', 7, '* (chat log): ffff.', '2021-05-16 11:46:20'),
(2357, 'test', 7, '* (chat log): ff.', '2021-05-16 11:50:06'),
(2358, 'RoLEX', 7, '* (chat log): dfff.', '2021-05-16 11:50:21'),
(2359, 'Vicentzo', 4, '* (chat log): tu esti urit.', '2021-05-16 17:35:17'),
(2360, 'Vicentzo', 4, '* (chat log): eu sint bos.', '2021-05-16 17:35:18'),
(2361, 'RoLEX', 7, '* (chat log): dc dai cu hack.', '2021-05-16 17:35:18'),
(2362, 'RoLEX', 7, '* (chat log): mane.', '2021-05-16 17:35:19'),
(2363, 'RoLEX', 7, '* (chat log): ce chat?.', '2021-05-16 17:35:22'),
(2364, 'RoLEX', 7, '* (chat log): fff.', '2021-05-16 17:35:26'),
(2365, 'RoLEX', 7, '* (chat log): aaa.', '2021-05-16 17:35:27'),
(2366, 'Vicentzo', 4, '* (chat log): am uitat sa fiu alb.', '2021-05-16 17:35:28'),
(2367, 'RoLEX', 7, '* (chat log): ce prost is.', '2021-05-16 17:35:29'),
(2368, 'Vicentzo', 4, '* (chat log): hihihihihi.', '2021-05-16 17:35:29'),
(2369, 'Vicentzo', 4, '* (chat log): tu esti prost.', '2021-05-16 17:35:32'),
(2370, 'Vicentzo', 4, '* (chat log): lmao.', '2021-05-16 17:35:33'),
(2371, 'RoLEX', 7, '* (chat log): esti in mafie.', '2021-05-16 17:35:33'),
(2372, 'RoLEX', 7, '* (chat log): si d aia.', '2021-05-16 17:35:36'),
(2373, 'Vicentzo', 4, '* (chat log): da.', '2021-05-16 17:35:36'),
(2374, 'RoLEX', 7, '* (chat log): vicentzo.', '2021-05-16 17:35:38'),
(2375, 'test', 7, '* (chat log): ff.', '2021-05-16 17:37:56'),
(2376, 'RoLEX', 7, '* (chat log):   .', '2021-05-16 18:10:55'),
(2377, 'mr.bunny', 2, '* (chat log): ?goto 1.', '2021-05-16 18:23:18'),
(2378, 'RaresGabriel99', 18, '* (chat log): cu ce sa te ajut ?.', '2021-05-16 18:25:08'),
(2379, 'RoLEX', 7, '* (chat log): scz.', '2021-05-16 18:25:08'),
(2380, 'RoLEX', 7, '* (chat log): gt.', '2021-05-16 18:25:10'),
(2381, 'RoLEX', 7, '* (chat log): fi antena.', '2021-05-16 18:25:12'),
(2382, 'RaresGabriel99', 18, '* (chat log): sunt.', '2021-05-16 18:25:17'),
(2383, 'RoLEX', 7, '* (chat log): stai aici.', '2021-05-16 18:25:39'),
(2384, 'RaresGabriel99', 18, '* (chat log): stau.', '2021-05-16 18:25:51'),
(2385, 'RoLEX', 7, '* (chat log): baga ne am pula n ma ta.', '2021-05-16 18:37:02'),
(2386, 'RaresGabriel99', 18, '* (chat log): :(.', '2021-05-16 18:37:12'),
(2387, 'RaresGabriel99', 18, '* (chat log): st ca nu am tel.', '2021-05-16 18:37:33'),
(2388, 'Vicentzo', 4, '* (chat log): k dute si cmpara.', '2021-05-16 18:37:39'),
(2389, 'Vicentzo', 4, '* (chat log): deci al 3 da?.', '2021-05-16 18:38:34'),
(2390, 'Vicentzo', 4, '* (chat log): 1.', '2021-05-16 18:38:37'),
(2391, 'Vicentzo', 4, '* (chat log): 2.', '2021-05-16 18:38:38'),
(2392, 'Vicentzo', 4, '* (chat log): 3.', '2021-05-16 18:38:39');

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_clans`
--

CREATE TABLE `server_clans` (
  `ID` int(11) NOT NULL,
  `OwnerID` int(11) NOT NULL DEFAULT -1,
  `Name` varchar(24) NOT NULL DEFAULT 'none',
  `Tag` varchar(16) NOT NULL DEFAULT 'none',
  `ClanColor` varchar(32) NOT NULL DEFAULT 'ffffff',
  `Motd` varchar(128) NOT NULL DEFAULT 'none',
  `Days` int(11) NOT NULL,
  `Slots` int(11) NOT NULL,
  `Rank` varchar(32) NOT NULL DEFAULT '%s|%s|%s|%s|%s|%s|%s',
  `Total` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_ds`
--

CREATE TABLE `server_ds` (
  `ID` int(10) NOT NULL,
  `Model` int(11) NOT NULL,
  `Price` int(11) NOT NULL DEFAULT 1,
  `MaxSpeed` int(4) NOT NULL DEFAULT 1,
  `Type` int(10) NOT NULL,
  `Premium` int(10) NOT NULL,
  `Gold` int(10) NOT NULL DEFAULT 500,
  `Stock` int(11) NOT NULL DEFAULT 30
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `server_ds`
--

INSERT INTO `server_ds` (`ID`, `Model`, `Price`, `MaxSpeed`, `Type`, `Premium`, `Gold`, `Stock`) VALUES
(1, 404, 170000, 133, 1, 0, 20, 0),
(2, 418, 190000, 115, 1, 0, 25, 25),
(3, 422, 230000, 140, 1, 0, 30, 22),
(4, 466, 350000, 140, 1, 0, 35, 26),
(5, 549, 310000, 153, 1, 0, 35, 23),
(6, 401, 290000, 147, 1, 0, 30, 25),
(7, 400, 520000, 158, 1, 0, 40, 26),
(8, 543, 325000, 151, 1, 0, 35, 28),
(9, 482, 490000, 156, 1, 0, 50, 30),
(10, 483, 520000, 129, 1, 0, 55, 30),
(11, 508, 570000, 108, 1, 0, 55, 30),
(12, 550, 410000, 130, 1, 0, 55, 21),
(13, 585, 325000, 150, 1, 0, 55, 27),
(14, 496, 500000, 162, 1, 0, 60, 16),
(15, 542, 520000, 164, 1, 0, 65, 8),
(16, 419, 410000, 149, 1, 0, 65, 30),
(17, 554, 530000, 144, 1, 0, 70, 28),
(18, 518, 390000, 164, 1, 0, 70, 26),
(19, 458, 460000, 157, 1, 0, 70, 26),
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
(46, 535, 9700000, 158, 1, 0, 130, 28),
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
(69, 541, 90000000, 203, 1, 0, 500, 28),
(70, 411, 100000000, 222, 1, 1, 550, 27),
(71, 494, 150000000, 214, 1, 1, 600, 30),
(72, 503, 150000000, 214, 1, 1, 600, 30),
(73, 502, 150000000, 214, 1, 1, 600, 29),
(74, 509, 80000, 83, 2, 0, 10, 28),
(75, 510, 90000, 90, 2, 0, 15, 26),
(76, 481, 100000, 90, 2, 0, 20, 26),
(77, 462, 210000, 122, 2, 0, 20, 30),
(78, 471, 270000, 110, 2, 0, 20, 26),
(79, 586, 2000000, 157, 2, 0, 25, 30),
(80, 581, 4000000, 59, 2, 0, 50, 30),
(81, 461, 4200000, 171, 2, 0, 70, 25),
(82, 468, 7200000, 157, 2, 0, 90, 29),
(83, 463, 6400000, 157, 2, 0, 100, 27),
(84, 521, 7600000, 176, 2, 0, 100, 28),
(85, 522, 45000000, 191, 2, 0, 200, 25),
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
(1, 1869.11, -1089.78, 23.6597);

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
  `MinLevel` int(11) NOT NULL DEFAULT 5,
  `MaxMembers` int(11) NOT NULL DEFAULT 10,
  `Interior` int(11) NOT NULL DEFAULT 0,
  `Type` int(11) NOT NULL DEFAULT 0,
  `MapIconType` int(11) NOT NULL DEFAULT 0,
  `Apps` int(11) NOT NULL DEFAULT 0,
  `Locked` int(11) NOT NULL DEFAULT 0,
  `X` float NOT NULL DEFAULT 0,
  `Y` float NOT NULL DEFAULT 0,
  `Z` float NOT NULL DEFAULT 0,
  `ExtX` float NOT NULL DEFAULT 0,
  `ExtY` float NOT NULL DEFAULT 0,
  `ExtZ` float NOT NULL DEFAULT 0,
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
  `Player` int(11) NOT NULL DEFAULT -1,
  `Leader` int(11) NOT NULL DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_gascan`
--

CREATE TABLE `server_gascan` (
  `ID` int(11) NOT NULL,
  `BizID` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Full` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `server_gascan`
--

INSERT INTO `server_gascan` (`ID`, `BizID`, `X`, `Y`, `Z`, `Full`) VALUES
(1, 12, 70.35, 1218.39, 18.81, 44);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_houses`
--

CREATE TABLE `server_houses` (
  `ID` int(11) NOT NULL,
  `Title` varchar(32) NOT NULL DEFAULT 'none',
  `Description` varchar(64) NOT NULL DEFAULT 'none',
  `ExtX` float NOT NULL DEFAULT 0,
  `ExtY` float NOT NULL DEFAULT 0,
  `ExtZ` float NOT NULL DEFAULT 0,
  `X` float NOT NULL DEFAULT 0,
  `Y` float NOT NULL DEFAULT 0,
  `Z` float NOT NULL DEFAULT 0,
  `Interior` int(11) NOT NULL,
  `Locked` int(11) NOT NULL DEFAULT 0,
  `Price` int(11) NOT NULL,
  `Balance` int(11) NOT NULL DEFAULT 0,
  `Owner` varchar(32) NOT NULL,
  `OwnerID` int(11) NOT NULL DEFAULT -1,
  `Owned` int(11) NOT NULL DEFAULT 1,
  `Rentabil` int(11) NOT NULL DEFAULT 1,
  `Renters` int(11) NOT NULL DEFAULT 0,
  `Upgrade` int(11) NOT NULL DEFAULT 0,
  `RentPrice` int(11) NOT NULL DEFAULT 500
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_houses`
--

INSERT INTO `server_houses` (`ID`, `Title`, `Description`, `ExtX`, `ExtY`, `ExtZ`, `X`, `Y`, `Z`, `Interior`, `Locked`, `Price`, `Balance`, `Owner`, `OwnerID`, `Owned`, `Rentabil`, `Renters`, `Upgrade`, `RentPrice`) VALUES
(1, 'A new house', 'A new house medium', -36.14, 1115.44, 20.93, -68.84, 1351.67, 1080.21, 6, 0, 0, 1000, 'Admbot', -1, 1, 1, 0, 0, 500),
(2, 'A new house', 'A new house medium', -18.33, 1115.64, 20.93, -68.84, 1351.67, 1080.21, 6, 0, 0, 0, 'Admbot', -1, 1, 1, 0, 0, 500),
(3, 'A new house', 'A new house medium', 12.76, 1113.31, 20.93, -42.65, 1405.65, 1084.42, 8, 0, 0, 0, 'Admbot', -1, 1, 1, 0, 0, 500),
(4, 'A new house', 'A new house small', -44.96, 1081.14, 20.93, 318.61, 1114.88, 1083.88, 5, 0, 0, 0, 'Admbot', -1, 1, 1, 0, 0, 500),
(5, 'A new house', 'A new house medium', 1.24, 1076.01, 20.93, 260.8, 1237.58, 1084.25, 9, 0, 0, 0, 'Admbot', -1, 1, 1, 1, 0, 500),
(6, 'A new house', 'A new house big', 12.91, 1210.9, 19.34, 2807.68, -1174.25, 1025.57, 8, 0, 0, 0, 'Admbot', -1, 1, 1, 1, 0, 500),
(7, 'A new house', 'A new house big', -26.94, 1214.59, 19.35, 2495.9, -1692.49, 1014.74, 3, 0, 0, 1000, 'Admbot', -1, 1, 1, 0, 0, 500),
(8, 'A new house', 'A new house big', -26.88, 1214.65, 22.46, 2495.9, -1692.49, 1014.74, 3, 0, 0, 0, 'Admbot', -1, 1, 1, 0, 0, 500),
(9, 'A new house', 'A new house big', 13.12, 1220.19, 19.34, 2807.68, -1174.25, 1025.57, 8, 0, 0, 3000, 'Admbot', -1, 1, 1, 0, 0, 500),
(10, 'A new house', 'A new house big', 12.95, 1219.93, 22.5, 2324.46, -1149.13, 1050.71, 12, 0, 0, 1500, 'Admbot', -1, 1, 1, 0, 0, 500),
(11, 'A new house', 'A new house small', -36.02, 1215.34, 19.35, 318.61, 1114.88, 1083.88, 5, 0, 0, 500, 'Admbot', -1, 1, 1, 0, 0, 500),
(12, 'Bine ati venit !', 'Bine ati venit !', 1043.04, 1010.97, 11, 940.8, -18.57, 1000.92, 3, 1, 0, 0, 'Aditsu', 32, 1, 1, 0, 0, 500),
(13, 'sintbos', 'A new house small', 13.88, 1229.39, 19.34, 266.89, 304.95, 999.14, 2, 0, 0, 0, 'Vicentzo', 4, 1, 1, 0, 0, 500);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_jobs`
--

CREATE TABLE `server_jobs` (
  `ID` int(11) NOT NULL,
  `Name` varchar(32) NOT NULL DEFAULT 'none',
  `Level` int(11) NOT NULL DEFAULT 1,
  `PosX` float NOT NULL DEFAULT 0,
  `PosY` float NOT NULL DEFAULT 0,
  `PosZ` float NOT NULL DEFAULT 0,
  `Legal` int(11) NOT NULL,
  `Description` varchar(95) NOT NULL,
  `XST` float NOT NULL DEFAULT 0,
  `YST` float NOT NULL DEFAULT 0,
  `ZST` float NOT NULL DEFAULT 0
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
  `PlayerID` int(11) NOT NULL DEFAULT 0,
  `AdminName` varchar(24) NOT NULL DEFAULT 'AdmBot',
  `AdminID` int(11) NOT NULL DEFAULT 0,
  `Reason` varchar(64) NOT NULL DEFAULT 'none',
  `Date` varchar(32) NOT NULL DEFAULT 'none'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_kick_logs`
--

INSERT INTO `server_kick_logs` (`ID`, `PlayerName`, `PlayerID`, `AdminName`, `AdminID`, `Reason`, `Date`) VALUES
(1, 'RoLEX', 7, 'Vicentzo', 4, '', 'server spart by iuliano / procen'),
(2, 'RaresGabriel99', 18, 'AnDreeW', 36, '(silent) ', 'a'),
(3, 'RoLEX', 7, 'Vicentzo', 4, '(silent) ', 're'),
(4, 'RoLEX', 7, 'Aditsu', 32, '(silent) ', '0'),
(5, 'RoLEX', 7, 'Vicentzo', 4, '(silent) ', 'server closed connection.'),
(6, 'RoLEX', 7, 'Vicentzo', 4, '(silent) ', 'sintbos'),
(7, 'RoLEX', 7, 'Vicentzo', 4, '(silent) ', 're'),
(8, 'RoLEX', 7, 'Vicentzo', 4, '(silent) ', 're'),
(9, 'Comorasu', 33, 'RoLEX', 7, '', 'Bn mane'),
(10, 'RoLEX', 7, 'mr.bunny', 2, '(silent) ', 'test'),
(11, 'mata', 49, 'Vicentzo', 4, '', 'nu intra cu ma-ta intra cu numel');

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_labels`
--

CREATE TABLE `server_labels` (
  `ID` int(11) NOT NULL,
  `X` float NOT NULL DEFAULT 0,
  `Y` float NOT NULL DEFAULT 0,
  `Z` float NOT NULL DEFAULT 0,
  `Text` varchar(128) NOT NULL DEFAULT 'none',
  `WorldID` int(11) NOT NULL DEFAULT -1,
  `Interior` int(11) NOT NULL DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_logs`
--

CREATE TABLE `server_logs` (
  `ID` int(11) NOT NULL,
  `text` varchar(128) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
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
  `PlayerID` int(11) NOT NULL DEFAULT 0,
  `AdminName` varchar(24) NOT NULL DEFAULT 'AdmBot',
  `AdminID` int(11) NOT NULL DEFAULT 0,
  `MuteReason` varchar(64) NOT NULL DEFAULT 'None',
  `MuteMinutes` int(11) NOT NULL DEFAULT 1,
  `Time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `server_mute_logs`
--

INSERT INTO `server_mute_logs` (`ID`, `PlayerName`, `PlayerID`, `AdminName`, `AdminID`, `MuteReason`, `MuteMinutes`, `Time`) VALUES
(1, 'Vicentzo', 4, 'RoLEX', 7, 'asa', 1, '2021-05-09 10:05:13');

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_personal_vehicles`
--

CREATE TABLE `server_personal_vehicles` (
  `ID` int(11) NOT NULL,
  `ModelID` int(11) NOT NULL DEFAULT 400,
  `OwnerID` int(11) NOT NULL DEFAULT 0,
  `ColorOne` int(11) NOT NULL DEFAULT 0,
  `ColorTwo` int(11) NOT NULL DEFAULT 0,
  `X` float NOT NULL DEFAULT 0,
  `Y` float NOT NULL DEFAULT 0,
  `Z` float NOT NULL DEFAULT 0,
  `Angle` float NOT NULL DEFAULT 0,
  `Odometer` float NOT NULL DEFAULT 0,
  `Fuel` float NOT NULL DEFAULT 100,
  `Age` int(11) NOT NULL,
  `CarPlate` varchar(12) NOT NULL DEFAULT 'New Car',
  `Components` varchar(64) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `InsurancePoints` int(11) NOT NULL DEFAULT 5,
  `LockStatus` int(11) NOT NULL DEFAULT 0,
  `VirtualWorld` int(11) NOT NULL DEFAULT 0,
  `Interior` int(11) NOT NULL DEFAULT 0,
  `Health` float NOT NULL DEFAULT 1000,
  `DamagePanels` int(11) NOT NULL DEFAULT 0,
  `DamageDoors` int(11) NOT NULL DEFAULT 0,
  `DamageLights` int(11) NOT NULL DEFAULT 0,
  `DamageTires` int(11) NOT NULL DEFAULT 0,
  `PaintJob` int(11) NOT NULL DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Eliminarea datelor din tabel `server_personal_vehicles`
--

INSERT INTO `server_personal_vehicles` (`ID`, `ModelID`, `OwnerID`, `ColorOne`, `ColorTwo`, `X`, `Y`, `Z`, `Angle`, `Odometer`, `Fuel`, `Age`, `CarPlate`, `Components`, `InsurancePoints`, `LockStatus`, `VirtualWorld`, `Interior`, `Health`, `DamagePanels`, `DamageDoors`, `DamageLights`, `DamageTires`, `PaintJob`) VALUES
(1, 463, 2, 1, 1, 1411.3, -2241.7, 13.274, 179.814, 0, 100, 9, 'DS Car', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 10, 0, 0, 0, 1000, 0, 0, 0, 0, -1),
(2, 466, 4, 1, 1, 1404.8, -2242.41, 13.274, 179.975, 0, 100, 9, 'DS Car', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 10, 1, 0, 0, 1000, 0, 0, 0, 0, -1),
(3, 463, 4, 1, 1, 1401.48, -2242.2, 13.274, 179.625, 0, 100, 7, 'DS Car', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 10, 1, 0, 0, 1000, 0, 0, 0, 0, -1),
(4, 401, 4, 1, 1, 1411.3, -2241.7, 13.274, 179.814, 0, 100, 5, 'DS Car', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 10, 0, 0, 0, 1000, 0, 0, 0, 0, -1),
(5, 541, 32, 2, 14, 1401.48, -2242.2, 13.274, 179.873, 0, 100, 3, 'DS Car', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 8, 1, 0, 0, 1000, 0, 0, 0, 0, -1),
(6, 411, 23, 1, 1, 1414.53, -2241.78, 13.274, 179.095, 0, 100, 1, 'DS Car', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', 10, 1, 0, 0, 1000, 0, 0, 0, 0, -1);

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_pickups`
--

CREATE TABLE `server_pickups` (
  `ID` int(11) NOT NULL,
  `Model` int(11) NOT NULL DEFAULT 1239,
  `X` float NOT NULL DEFAULT 0,
  `Y` float NOT NULL DEFAULT 0,
  `Z` float NOT NULL DEFAULT 0,
  `WorldID` int(11) NOT NULL DEFAULT 0,
  `Interior` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_safes`
--

CREATE TABLE `server_safes` (
  `ID` int(11) NOT NULL,
  `Faction` int(11) NOT NULL DEFAULT 0,
  `Money` int(11) NOT NULL DEFAULT 0,
  `Drugs` int(11) NOT NULL DEFAULT 0,
  `Materials` int(11) NOT NULL DEFAULT 0,
  `VirtualWorld` int(11) NOT NULL DEFAULT -1,
  `X` float NOT NULL DEFAULT 0,
  `Y` float NOT NULL DEFAULT 0,
  `Z` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_turfs`
--

CREATE TABLE `server_turfs` (
  `ID` int(11) NOT NULL,
  `Owned` int(11) NOT NULL DEFAULT 0,
  `MinX` float NOT NULL DEFAULT 0,
  `MaxX` float NOT NULL DEFAULT 0,
  `MinY` float NOT NULL DEFAULT 0,
  `MaxY` float NOT NULL DEFAULT 0,
  `Time` int(11) NOT NULL DEFAULT -1
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
  `RegisterDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `Skin` int(11) NOT NULL DEFAULT 250,
  `Admin` int(11) NOT NULL DEFAULT 0,
  `Helper` int(11) NOT NULL DEFAULT 0,
  `Level` int(11) NOT NULL DEFAULT 1,
  `RespectPoints` int(11) NOT NULL DEFAULT 0,
  `Money` int(11) NOT NULL DEFAULT 2500,
  `Bank` int(11) NOT NULL DEFAULT 5000,
  `Hours` int(11) NOT NULL DEFAULT 0,
  `Seconds` int(11) NOT NULL DEFAULT 0,
  `Mute` int(11) NOT NULL DEFAULT 0,
  `Gender` int(11) NOT NULL DEFAULT 1,
  `Tutorial` tinyint(1) NOT NULL DEFAULT 0,
  `Licenses` varchar(48) NOT NULL DEFAULT '0|0|0|0|0|0|0|0',
  `Warn` int(11) NOT NULL DEFAULT 0,
  `ReportMute` int(11) NOT NULL DEFAULT 0,
  `Status` int(11) NOT NULL,
  `PremiumPoints` int(11) NOT NULL,
  `Job` int(11) NOT NULL DEFAULT 0,
  `Business` int(11) NOT NULL,
  `BusinessID` int(11) NOT NULL,
  `IP` varchar(16) NOT NULL,
  `AccountBlocked` int(11) NOT NULL DEFAULT 0,
  `House` int(11) NOT NULL,
  `HouseID` int(11) NOT NULL,
  `FRank` int(11) NOT NULL DEFAULT 0,
  `SpawnChange` int(11) NOT NULL DEFAULT 1,
  `Rent` int(11) NOT NULL DEFAULT -1,
  `VehicleSlots` int(11) NOT NULL DEFAULT 2,
  `FishSkill` int(11) NOT NULL DEFAULT 1,
  `FishTimes` int(11) NOT NULL DEFAULT 0,
  `TruckTimes` int(11) NOT NULL DEFAULT 0,
  `TruckSkill` int(11) NOT NULL DEFAULT 1,
  `ArmsSkill` int(11) NOT NULL DEFAULT 1,
  `ArmsTimes` int(11) NOT NULL DEFAULT 0,
  `DrugsSkill` int(11) NOT NULL DEFAULT 1,
  `DrugsTimes` int(11) NOT NULL DEFAULT 0,
  `Tickets` int(11) NOT NULL DEFAULT 0,
  `Unbans` int(11) NOT NULL,
  `Complaints` int(11) NOT NULL,
  `Drugs` int(11) NOT NULL,
  `VIP` int(11) NOT NULL,
  `Premium` int(11) NOT NULL,
  `FWarns` int(11) NOT NULL DEFAULT 0,
  `FPunish` int(11) NOT NULL DEFAULT 0,
  `Beta` int(11) NOT NULL,
  `LastIP` varchar(16) NOT NULL,
  `StaffWarns` int(11) NOT NULL,
  `Note` varchar(250) NOT NULL,
  `Mats` int(11) NOT NULL,
  `Faction` int(11) NOT NULL DEFAULT 0,
  `CarpenterTimes` int(11) NOT NULL DEFAULT 0,
  `CarpenterSkill` int(11) NOT NULL DEFAULT 1,
  `Phone` int(11) NOT NULL,
  `FAge` int(11) NOT NULL DEFAULT 0,
  `PhoneBook` int(11) NOT NULL,
  `MBank` int(11) NOT NULL,
  `MStore` int(100) NOT NULL,
  `JailTime` int(11) NOT NULL DEFAULT 0,
  `Jailed` int(11) NOT NULL DEFAULT 0,
  `Arrested` int(11) NOT NULL DEFAULT 0,
  `WantedDeaths` int(11) NOT NULL DEFAULT 0,
  `Commands` int(11) NOT NULL,
  `WantedLevel` int(11) NOT NULL DEFAULT 0,
  `DailyMission` int(11) NOT NULL DEFAULT -1,
  `DailyMission2` int(11) NOT NULL DEFAULT -1,
  `Progress` int(11) NOT NULL,
  `Progress2` int(11) NOT NULL,
  `NeedProgress1` int(10) NOT NULL,
  `NeedProgress2` int(10) NOT NULL,
  `WTChannel` int(11) NOT NULL DEFAULT 0,
  `WTalkie` int(11) NOT NULL,
  `WToggle` int(11) NOT NULL,
  `WantedTime` int(11) NOT NULL DEFAULT 0,
  `LiveToggle` int(11) NOT NULL,
  `Guns` varchar(35) NOT NULL DEFAULT '0|0|0|0|0',
  `Clan` int(11) NOT NULL DEFAULT 0,
  `ClanRank` int(11) NOT NULL DEFAULT 1,
  `ClanAge` int(11) NOT NULL DEFAULT 0,
  `ClanWarns` int(11) NOT NULL DEFAULT 0,
  `ClanTag` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `server_users`
--

INSERT INTO `server_users` (`ID`, `Name`, `Password`, `EMail`, `LastLogin`, `RegisterDate`, `Skin`, `Admin`, `Helper`, `Level`, `RespectPoints`, `Money`, `Bank`, `Hours`, `Seconds`, `Mute`, `Gender`, `Tutorial`, `Licenses`, `Warn`, `ReportMute`, `Status`, `PremiumPoints`, `Job`, `Business`, `BusinessID`, `IP`, `AccountBlocked`, `House`, `HouseID`, `FRank`, `SpawnChange`, `Rent`, `VehicleSlots`, `FishSkill`, `FishTimes`, `TruckTimes`, `TruckSkill`, `ArmsSkill`, `ArmsTimes`, `DrugsSkill`, `DrugsTimes`, `Tickets`, `Unbans`, `Complaints`, `Drugs`, `VIP`, `Premium`, `FWarns`, `FPunish`, `Beta`, `LastIP`, `StaffWarns`, `Note`, `Mats`, `Faction`, `CarpenterTimes`, `CarpenterSkill`, `Phone`, `FAge`, `PhoneBook`, `MBank`, `MStore`, `JailTime`, `Jailed`, `Arrested`, `WantedDeaths`, `Commands`, `WantedLevel`, `DailyMission`, `DailyMission2`, `Progress`, `Progress2`, `NeedProgress1`, `NeedProgress2`, `WTChannel`, `WTalkie`, `WToggle`, `WantedTime`, `LiveToggle`, `Guns`, `Clan`, `ClanRank`, `ClanAge`, `ClanWarns`, `ClanTag`) VALUES
(1, 'Vicentzosntbos', '3D35EFB6BAFB1213ECF5120FEDACD36859475ACAFA4EDC7762A98C50059E202F', 'asd@Gmail.com', ' Bine ai venit, Vicentzosntbos.', '2021-04-30 08:52:33', 250, 6, 0, 1, 1, 2625, 5000, 1, 1066, 0, 0, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '86.120.191.35', 0, 0, 0, 7, 1, 0, 20, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '86.120.191.35', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(2, 'mr.bunny', '65A134209A6CF777E2E9415709DB14EAC16FAB3F50A02DB56C1981D856128FE4', 'vlogsdaniel13@gmail.com', '10:02 - 21/11/2021', '2021-04-30 08:54:14', 250, 7, 0, 26, 38, 834163000, 300004500, 5, 6180, 0, 0, 1, '99|0|99|0|99|0|99|0', 0, 0, 0, 0, 0, 0, 0, '127.0.0.1', 1, 0, 0, 7, 1, 0, 20, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '127.0.0.1', 0, '', 0, 0, 0, 1, 11294, 0, 0, 0, 0, 0, 0, 0, 0, 18, 0, 2, 4, 0, 0, 1, 1, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(3, 'Lil_Cagula', '796F8C5335CBBFBDD74ABAD8CDC453B1C6D856F5CA1C2C1A5A56EDA1587A882A', 'alex@gmail.com', ' Bine ai venit, Lil_Cagula.', '2021-04-30 09:20:57', 250, 0, 0, 1, 0, 2000, 5000, 0, 198, 0, 1, 1, '100|0|0|0|0|0|0|0', 0, 13, 0, 0, 0, 0, 0, '79.118.215.179', 0, 0, 0, 0, 1, 0, 20, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(4, 'Vicentzo', '3D35EFB6BAFB1213ECF5120FEDACD36859475ACAFA4EDC7762A98C50059E202F', 'asd@gmail.com', '09:00 - 17/05/2021', '2021-04-30 14:48:33', 271, 7, 0, 69, 500, 100, 0, 16, 204, 0, 1, 1, '87|0|87|0|87|0|87|0', 1, 0, 0, 4950, 1, 0, 0, '86.120.191.175', 0, 1, 13, 7, 4, -1, 20, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, '86.120.191.175', 0, '', 0, 8, 0, 1, 11179, 0, 0, 1000000000, 0, 0, 0, 0, 0, 18, 0, 3, 2, 0, 0, 1, 1, 0, 0, 0, 0, 0, '1|1|1|0|0', 0, 1, 0, 0, 0),
(5, 'gab1', 'CAEF307ABE424B55FBAA92745771EA38CEEE3FB7121E5400A338183C43615AF9', 'gabrielm200.000@gmail.com', '00:18 - 16/05/2021', '2021-04-30 14:49:23', 12, 6, 0, 1, 1, 79008, 5000, 0, 942, 0, 0, 1, '300|0|300|0|300|0|300|0', 0, 0, 0, 0, 0, 0, 0, '86.121.205.94', 0, 0, 0, 0, 1, 0, 20, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '86.121.205.94', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 0, 1, 4, 0, 0, 7, 1, 0, 0, 0, 0, 1, '0|0|0|0|0', 0, 1, 0, 0, 0),
(6, 'Awake', 'B3751C5F73E5ABB528AFF44F3F9CBAF35C06D4C3A57B06EBF25B61CE4F8F5EBE', 'maximsisianu@gmail.com', ' Bine ai venit, Awake.', '2021-04-30 14:55:14', 250, 0, 0, 1, 0, 2500, 5000, 0, 223, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '86.107.167.111', 0, 0, 0, 0, 1, 0, 20, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(7, 'RoLEX', 'C6B9E22CC4C442731C2047E041FCD41F45ED70C3C41C3EEF95708CE27EA64378', 'davidciocanete@gmail.com', '21:24 - 16/05/2021', '2021-04-30 17:26:25', 250, 6, 0, 101, 2, 2500, 0, 0, 998, 0, 0, 1, '99|0|99|0|99|0|99|0', 0, 0, 0, 950, 1, 0, 0, '84.232.193.62', 0, 0, 0, 7, 1, 9, 20, 1, 5, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '84.232.193.62', 0, '', 0, 0, 0, 1, 15603, 0, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 4, 0, 0, 7, 1, 0, 1, 0, 0, 1, '0|0|0|0|0', 0, 1, 0, 0, 0),
(8, 'corbul', '274A7E245654B029AF15338F626330D875E4680A82A8726DA9128B00E68FBF1E', 'gasgdfg@gmail.com', '22:04 - 11/05/2021', '2021-04-30 18:12:26', 12, 1, 3, 1, 0, 5952500, 5000, 0, 145, 0, 0, 1, '1|0|1|0|1|0|1|0', 0, 0, 0, 0, 0, 0, 0, '31.5.71.17', 0, 0, 0, 0, 1, 0, 20, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '31.5.71.17', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(9, 'Maxadv.r$', 'B3751C5F73E5ABB528AFF44F3F9CBAF35C06D4C3A57B06EBF25B61CE4F8F5EBE', 'awwkeYOUTBUE@gmail.com', '14:36 - 01/05/2021', '2021-05-01 09:09:21', 250, 5, 0, 1, 0, 2500, 5000, 0, 178, 0, 1, 1, '100|0|100|0|100|0|100|0', 0, 0, 0, 0, 0, 0, 0, '86.107.167.111', 0, 0, 0, 0, 1, 0, 20, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '86.107.167.111', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(10, 'Alexandru098', '77F2D0F56FCC6ED13439225F67118C137B8B3B0E46CCB3F87D34613EB07373D2', 'sdfghj@dfghjkl.com', '13:09 - 01/05/2021', '2021-05-01 09:09:28', 250, 6, 0, 1, 0, 219832500, 5000, 0, 3129, 0, 1, 1, '100|0|100|0|100|0|100|0', 0, 0, 0, 0, 0, 0, 0, '93.122.249.138', 0, 0, 0, 0, 1, 0, 20, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '93.122.249.138', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(11, 'asdklasdl', '7E3D33409AE3EA4ECE6A8AA752BC5C504EDAE4A03CC3C873DA61C4F9F08147F1', 'asdasdas@yahoo.com', ' Bine ai venit, asdklasdl.', '2021-05-01 09:44:38', 250, 0, 0, 1, 0, 2500, 5000, 0, 166, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '86.124.142.133', 0, 0, 0, 0, 1, 0, 20, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(12, 'xMasteRx11', '41EFB24207A7BAD91B650AB15CF8880D77389A4759013F10A1BE3ADC9CD59933', 'None', ' Bine ai venit, xMasteRx11.', '2021-05-02 13:57:32', 250, 0, 0, 1, 0, 2500, 5000, 0, 9, 0, 1, 0, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '86.124.142.167', 0, 0, 0, 0, 1, 0, 20, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(13, 'rafi71', 'B28532892AB9AB26623727DEE3250688DEFBDCABC66BBE90E9DA603F98F127DA', 'dasda@gmail.com', '22:28 - 05/05/2021', '2021-05-02 22:19:13', 227, 0, 0, 1, 1, 2625, 5000, 0, 140, 0, 1, 1, '99|0|99|0|99|0|99|0', 0, 0, 0, 0, 0, 0, 0, '212.93.128.55', 0, 0, 0, 7, 4, 0, 20, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '212.93.128.55', 0, '', 0, 1, 0, 1, 11443, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(14, 'cristi.20', '5C724D8780682889F334EBB4FCD41CA7102F7FDD69D7B08680344C0AB439D2B6', '111111111@gmail.col', '19:50 - 03/05/2021', '2021-05-03 16:51:09', 12, 0, 0, 1, 0, 2500, 5000, 0, 174, 0, 0, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '188.26.8.187', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(15, 'MasTerAdv', '2D5457225CF7CC82B74066E5B7C6EA6FE7369179DF1B69F819456D1524094D9A', 'aureliansorin96@gmail.com', '19:08 - 09/05/2021', '2021-05-03 16:57:54', 294, 0, 0, 3, 4, 3000, 5000, 2, 30, 0, 1, 1, '96|0|96|0|96|0|96|0', 0, 0, 0, 0, 2, 0, 0, '5.15.223.150', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '5.12.143.61', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 1, '0|0|0|0|0', 0, 1, 0, 0, 0),
(16, 'HPQ123', 'B28532892AB9AB26623727DEE3250688DEFBDCABC66BBE90E9DA603F98F127DA', 'mafia@gmail.com', '22:34 - 03/05/2021', '2021-05-03 17:46:48', 12, 6, 0, 1, 0, 99772500, 5000, 0, 1535, 0, 0, 1, '100|0|100|0|100|0|100|0', 0, 0, 0, 0, 0, 0, 0, '109.97.71.45', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '109.97.71.45', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(17, 'oNeTaaP', 'F92DF7551EA6FFA9FB994FD1ACD96DA557CE23A2E8E41FDD65E760D68EBD6F12', 'mateialex25@yahoo.com', '21:04 - 03/05/2021', '2021-05-03 18:04:54', 250, 0, 0, 1, 0, 2500, 5000, 0, 507, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '109.166.134.125', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(18, 'RaresGabriel99', '12700F2BC3186454EB7B7DE02F63E2D271BA230711579E07284A0EFD369FDE58', 'gabriel22rares@gmail.com', '21:35 - 16/05/2021', '2021-05-04 07:38:51', 250, 7, 0, 4, 2, 10001500, 204000000, 1, 7813, 0, 1, 1, '10|0|0|0|0|0|0|0', 0, 0, 0, 0, 1, 0, 0, '82.77.126.21', 0, 0, 0, 7, 1, -1, 2, 1, 2, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, '82.77.126.21', 0, '', 0, 0, 0, 1, 19102, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1, 0, 0, 1, 6, 0, 1, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(19, 'Dr.nicolas', 'A74CD9F559FBF3E2C60704864A89EB09A13734E849CD64344D311F75A695B09A', 'scoleabom@gmail.com', '12:03 - 04/05/2021', '2021-05-04 09:03:44', 250, 0, 0, 1, 0, 2500, 5000, 0, 112, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 91, 0, 0, 0, 0, 0, '90.95.168.232', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(20, 'Adi', '9E411A7401490C044CDC30B544E71122775FE82DAD1959898C3A883362FEB700', 'sanfierroparamedicdepartament@gmail.com', '19:45 - 14/05/2021', '2021-05-04 09:49:30', 293, 7, 0, 10, 1, 10003750, 5000, 1, 1594, 0, 1, 1, '299|0|299|0|299|0|299|0', 0, 0, 0, 0, 5, 0, 0, '79.114.191.219', 0, 0, 0, 7, 4, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '79.118.77.151', 0, '', 0, 7, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 7, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 1, '0|0|0|0|0', 0, 1, 0, 0, 0),
(21, 'Sag3ata', '3CE07CF4E31E7BC8ED4060AC193A2B66EAF0427E3DFE00550E68099FFD880A97', 'alexletai15@gmail.com', '13:40 - 04/05/2021', '2021-05-04 10:34:21', 250, 7, 0, 1, 1, 840640875, 5000, 0, 166, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 1, 0, 0, '82.78.21.65', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(22, 'Florindatease', '65A134209A6CF777E2E9415709DB14EAC16FAB3F50A02DB56C1981D856128FE4', 'None', 'None', '2021-05-04 10:40:30', 250, 0, 0, 1, 0, 840640750, 5000, 0, 0, 0, 1, 0, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(23, 'SebyP4', 'FFBD1E809A597E239363A62F3F1936BEA4D1468E2983782B9E9BD3024617E3E9', 'sebipreda112@gmail.com', '23:03 - 15/05/2021', '2021-05-04 12:24:55', 227, 4, 0, 100, 4, 900046250, 5000, 1, 1684, 0, 1, 1, '296|0|296|0|296|0|296|0', 0, 0, 0, 0, 0, 0, 0, '95.76.16.172', 0, 0, 0, 7, 4, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '95.76.16.172', 0, '', 0, 1, 0, 1, 15781, 0, 1, 0, 99, 0, 0, 0, 0, 6, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 1, '0|0|0|0|0', 0, 1, 0, 0, 0),
(24, 'MARIUS', '04410B71D2A87EA1B45ED702A6667D91D19C95B73D71D5E8ED2106FCBBC73F32', 'MARIUSSANDRONI@YAHOO.COM', ' Bine ai venit, MARIUS.', '2021-05-04 16:02:06', 250, 0, 0, 1, 0, 2500, 5000, 0, 0, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '178.138.195.107', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '178.138.193.107', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(25, 'Manevra._.Gamer', '0F4CD5B4137796CF1730E642E728071DF89B99954A2BF66A888220F0DF66DE41', 'Tutorialefree99@gmail.com', '20:32 - 04/05/2021', '2021-05-04 17:33:04', 250, 0, 0, 1, 1, 2625, 5000, 0, 0, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '178.138.32.39', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(26, 'MARIANQQ', '88FE4432728B94123CCC27D935900AC3B1FCC2B68E20AD13126C369F982761E4', 'moll@gmail.om', '20:33 - 04/05/2021', '2021-05-04 17:34:02', 250, 0, 0, 1, 0, 2500, 5000, 0, 0, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '82.76.153.194', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(27, 'zeNN0.', '9E1BB20ED8B0D8FAD221CBD7DF5339AFF28F8449EC011C34AE50DD267E719C6E', 'n-amemail@wemai.com', '20:40 - 04/05/2021', '2021-05-04 17:40:35', 12, 0, 0, 1, 0, 2500, 5000, 0, 0, 0, 0, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '79.119.240.44', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(28, 'Dani3l.', '29FC0A0B43A599E144AA042F3905CAAD9BF5044FBB8C4691F413DA914FDD4EDD', 'dada@gmail.com', '21:23 - 04/05/2021', '2021-05-04 18:11:26', 12, 6, 0, 1, 0, 2500, 5000, 0, 0, 0, 0, 1, '100|0|100|0|100|0|100|0', 0, 0, 0, 0, 1, 0, 0, '109.53.21.133', 0, 0, 0, 0, 1, 0, 2, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '109.53.21.133', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(29, 'ZeCo.F', '620E25D5198936CB184942B3284FCC04C5B30D58C578E87BB2FB376A29945EB3', 'f_zeco@yahoo.com', '21:22 - 04/05/2021', '2021-05-04 18:23:16', 250, 7, 0, 1, 1, 2750, 5000, 0, 0, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '82.20.32.76', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(30, 'oDaiCuAnto', 'E4C15C8006F1A16A9F8E85EF8FA0624CAE014CE0A79B021944064F3F5057836D', 'iopsfdgilkj@gmail.com', '22:00 - 04/05/2021', '2021-05-04 19:00:32', 12, 0, 0, 1, 0, 2500, 5000, 0, 52, 0, 0, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '31.5.24.183', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(31, 'sen0h@daulacap', '2C1CF5FEA6622626E38354BCB629284D61E5DA8ED690F7361B29DA4CDDCBFD1D', 'Dimachea030@gmail.com', '10:54 - 06/05/2021', '2021-05-06 07:54:33', 250, 4, 0, 150, 0, 111002500, 5000, 0, 0, 0, 0, 1, '300|0|300|0|300|0|300|0', 0, 0, 0, 0, 0, 0, 0, '86.123.29.88', 0, 0, 0, 7, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(32, 'Aditsu', '93453876914CD68A7CB7ADF7B85A95857950C5570ACA60992FC6D371CB6C7DF0', 'weaewa@yahoo.com', '07:08 - 16/05/2021', '2021-05-07 16:46:26', 293, 7, 0, 69, 2, 4624, 5000, 1, 2497, 0, 1, 1, '299|0|299|0|299|0|299|0', 0, 0, 0, 0, 0, 0, 0, '89.123.227.235', 0, 1, 12, 7, 4, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, '89.123.227.164', 0, '', 0, 7, 0, 1, 0, 0, 0, 999999999, 1, 0, 0, 0, 0, 0, 0, 3, 2, 0, 0, 1, 1, 0, 0, 0, 0, 0, '1|1|1|1|1', 0, 1, 0, 0, 0),
(33, 'Comorasu', 'F027475286C0507173C7B363F08DDE34CAC018AC7EE05AB0EA8A1A77DFCA049F', 'comorasuuspargeconturi@gmail.com', '20:25 - 14/05/2021', '2021-05-08 07:30:24', 12, 4, 0, 1, 0, 2500, 5000, 0, 721, 0, 0, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 1, 0, 0, '37.251.223.196', 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '185.53.197.218', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(34, 'NeZmEz_yBIb', '12700F2BC3186454EB7B7DE02F63E2D271BA230711579E07284A0EFD369FDE58', 'None', 'None', '2021-05-08 15:30:56', 250, 0, 0, 1, 0, 0, 5000, 0, 0, 0, 1, 0, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(35, 'NeZmEz_M3lW', 'AAF979DC8A5480B76E0E7E443EB5FE0198DC34C3B07A16DD692D459A56AADD5A', 'None', 'None', '2021-05-08 15:31:13', 250, 0, 0, 1, 0, 0, 5000, 0, 0, 0, 1, 0, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(36, 'AnDreeW', '69F0BEBE00E27233CDFFC14BDC7149587DFF43C7DB0622F936C18D81E9066E11', 'booste@yahoo.com', '21:38 - 14/05/2021', '2021-05-08 21:46:40', 250, 5, 3, 69, 1, 2119520, 5000, 0, 1437, 0, 1, 1, '100|0|100|0|100|0|100|0', 0, 0, 0, 0, 3, 0, 0, '78.116.30.130', 0, 0, 0, 7, 1, -1, 2, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 3, 0, '78.116.30.130', 0, '', 0, 0, 0, 1, 19360, 0, 1, 0, 0, 0, 0, 0, 0, 2, 0, -1, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, '1|1|0|1|1', 0, 1, 0, 0, 0),
(37, 'silviu1STARK', '547FA5AE751D024A2A13BE2B20DA2A5E2180147AD4BF96E6FAFBBF5362D7F316', 'silviu@gmail.com', '01:07 - 09/05/2021', '2021-05-08 22:07:37', 105, 0, 0, 1, 0, 2500, 5000, 0, 502, 0, 1, 1, '3|0|3|0|3|0|3|0', 0, 0, 0, 0, 0, 0, 0, '212.93.128.139', 0, 0, 0, 0, 1, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(38, 'SureSpoT', '695890C3B1937134D8840AAEE492895460475D43740E600631ABA2056099AADF', 'madalinadrian383@gmail.com', '13:12 - 09/05/2021', '2021-05-09 10:12:25', 250, 7, 0, 1, 0, 2500, 5000, 0, 1179, 0, 1, 1, '100|0|100|0|100|0|100|0', 0, 0, 0, 0, 0, 0, 0, '83.137.2.195', 0, 0, 0, 0, 1, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(39, 'STADRIX', '5B8CAEEE8146921D6DCA7A8F13BA6472C8FD9C81AC49D843C526208495EC9AB5', 'vasileiulian292@gmail.com', '19:09 - 09/05/2021', '2021-05-09 16:10:12', 250, 0, 0, 1, 1, 2625, 5000, 0, 196, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '92.80.93.77', 0, 0, 0, 0, 1, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(40, 'qFrostHD2.v', '82FF1E560E1CE696A0C6BA120657553275B4731414EBBD627AF955278A2AB014', 'sfantul.tau3333@gmail.com', '20:29 - 09/05/2021', '2021-05-09 17:29:45', 250, 0, 0, 1, 0, 2500, 5000, 0, 17, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '84.247.39.84', 0, 0, 0, 0, 1, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(41, 'Adrian_Valentin', 'FC869AD2E4162595EF02B8EECC5221A3BD81FC01BE8F135C210C047FEDF0450D', 'adrianvalentin584@gmail.com', '22:02 - 12/05/2021', '2021-05-09 17:34:14', 295, 5, 0, 54, 676874892, 733657977, 990318333, 3, 1694, 0, 1, 1, '300|0|300|0|300|0|300|0', 0, 0, 0, 0, 0, 0, 0, '92.85.167.101', 0, 0, 0, 7, 1, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, '92.85.167.101', 0, '', 0, 2, 0, 1, 15301, 0, 1, 0, 72529, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(42, 'Sebastian.Gaming2010', '8DD554D69ACC5C3C9D306652E5D6972EBAD0C3731ADE6F143A0E74B8422249FB', 'sebastian81@gmail.com', '22:14 - 12/05/2021', '2021-05-09 19:34:25', 0, 5, 0, 14, 12, 679981125, 10005000, 2, 1759, 0, 1, 1, '100|0|97|0|97|0|97|0', 0, 0, 0, 0, 0, 0, 0, '92.85.167.101', 0, 0, 0, 7, 4, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '92.85.167.101', 0, '', 0, 2, 0, 1, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(43, 'MARIUSYT166', '43E8062989D5195B3544F33785E469DE0640170187B670759DF95EE6049F66CA', 'dobremarius007@gmail.com', '10:28 - 10/05/2021', '2021-05-10 07:28:37', 250, 0, 0, 1, 1, 2625, 5000, 0, 29, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '86.124.56.139', 0, 0, 0, 0, 1, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(44, 'DemonMDL', '592EFA39E308B71839EA992587E3DEF1779B5AA007EE96AF1D611CB8C000D783', 'stas@mail.ru', '12:17 - 10/05/2021', '2021-05-10 09:17:33', 250, 0, 0, 1, 0, 2500, 5000, 0, 98, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '109.185.11.68', 0, 0, 0, 0, 1, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(45, 'RobertShefuMati', 'E9503CCEF0FBFC2442BE73CC267667EF7B559663C653F2FAC0CBA06E2E059E80', 'robert@yahoo.com', '19:32 - 11/05/2021', '2021-05-11 16:32:16', 227, 5, 0, 1, 0, 2500, 5000, 0, 2013, 0, 0, 1, '100|0|100|0|100|0|100|0', 0, 0, 0, 0, 0, 0, 0, '78.96.39.125', 0, 0, 0, 7, 4, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(46, 'RobertZisShefuMati', '0140922E2585DB71B5DAAB21A5B24DDBB3BC5EB8947E3747D218BA3C1B48F05F', 'None', 'None', '2021-05-15 20:44:42', 250, 0, 0, 1, 0, 0, 5000, 0, 0, 0, 1, 0, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(47, 'RobertShefuMati.', '0140922E2585DB71B5DAAB21A5B24DDBB3BC5EB8947E3747D218BA3C1B48F05F', 'dospinarobert@yahoo.com', '23:47 - 15/05/2021', '2021-05-15 20:47:15', 12, 0, 0, 1, 0, 2500, 5000, 0, 35, 0, 0, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '78.96.39.125', 0, 0, 0, 0, 1, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(48, 'Heart1405', 'CAEF307ABE424B55FBAA92745771EA38CEEE3FB7121E5400A338183C43615AF9', 'None', '00:17 - 16/05/2021', '2021-05-15 21:17:58', 250, 0, 0, 1, 0, 2500, 5000, 0, 4, 0, 1, 0, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '86.121.205.94', 0, 0, 0, 0, 1, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1, 0, 0, 1, 5, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(49, 'mata', 'C6B9E22CC4C442731C2047E041FCD41F45ED70C3C41C3EEF95708CE27EA64378', 'davidciocanete@gmail.com', '14:30 - 16/05/2021', '2021-05-16 11:30:58', 250, 0, 0, 1, 0, 2500, 5000, 0, 10, 0, 1, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '84.232.193.62', 0, 0, 0, 0, 1, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 6, 8, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(50, 'test', 'C6B9E22CC4C442731C2047E041FCD41F45ED70C3C41C3EEF95708CE27EA64378', 'None', 'None', '2021-05-16 18:07:20', 250, 0, 0, 1, 0, 100, 5000, 0, 0, 0, 1, 0, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 0, 4, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(51, 'sintembosi', '3D35EFB6BAFB1213ECF5120FEDACD36859475ACAFA4EDC7762A98C50059E202F', 'None', '21:36 - 16/05/2021', '2021-05-16 18:36:14', 250, 0, 0, 1, 0, 2500, 5000, 0, 19, 0, 1, 0, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '86.120.191.175', 0, 0, 0, 0, 1, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1, 1, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0),
(52, 'mr.test', '65A134209A6CF777E2E9415709DB14EAC16FAB3F50A02DB56C1981D856128FE4', 'nuam@gmail.com', '19:41 - 20/07/2021', '2021-07-20 16:41:25', 12, 0, 0, 1, 0, 2500, 5000, 0, 9, 0, 0, 1, '0|0|0|0|0|0|0|0', 0, 0, 0, 0, 0, 0, 0, '127.0.0.1', 1, 0, 0, 0, 1, -1, 2, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 4, 0, 0, 7, 1, 0, 0, 0, 0, 0, '0|0|0|0|0', 0, 1, 0, 0, 0);

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
  `Model` int(11) NOT NULL DEFAULT 400,
  `X` float NOT NULL DEFAULT 0,
  `Y` float NOT NULL DEFAULT 0,
  `Z` float NOT NULL DEFAULT 0,
  `Angle` float NOT NULL DEFAULT 0,
  `Faction` int(11) NOT NULL DEFAULT 0,
  `ColorOne` int(11) NOT NULL DEFAULT 1,
  `ColorTwo` int(11) NOT NULL DEFAULT 1,
  `VirtualWorld` int(11) NOT NULL,
  `Rank` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `server_warn_logs`
--

CREATE TABLE `server_warn_logs` (
  `ID` int(11) NOT NULL,
  `PlayerName` varchar(24) NOT NULL DEFAULT 'None',
  `PlayerID` int(11) NOT NULL DEFAULT 0,
  `AdminName` varchar(24) NOT NULL DEFAULT 'AdmBot',
  `AdminID` int(11) NOT NULL DEFAULT 0,
  `WarnReason` varchar(64) NOT NULL DEFAULT 'None',
  `WarnTime` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Eliminarea datelor din tabel `server_warn_logs`
--

INSERT INTO `server_warn_logs` (`ID`, `PlayerName`, `PlayerID`, `AdminName`, `AdminID`, `WarnReason`, `WarnTime`) VALUES
(1, 'Vicentzo', 4, 'Vicentzo', 4, 're', '2021-05-08 16:42:44'),
(2, 'Vicentzo', 4, 'Vicentzo', 4, 'ne mutam pe', '2021-05-08 16:45:15'),
(3, 'Vicentzo', 4, 'Vicentzo', 4, 'rpg.iauban.ro #antiserverefantoma', '2021-05-08 16:46:21'),
(4, 'Vicentzo', 4, 'Vicentzo', 4, 'ne mutam pe rpg.b-hood.ro', '2021-05-09 18:51:25'),
(5, 'Adrian_Valentin', 41, 'Adrian_Valentin', 41, 'ia', '2021-05-12 17:56:51');

--
-- Indexuri pentru tabele eliminate
--

--
-- Indexuri pentru tabele `2fa_connect`
--
ALTER TABLE `2fa_connect`
  ADD PRIMARY KEY (`ID`);

--
-- Indexuri pentru tabele `panelactions2`
--
ALTER TABLE `panelactions2`
  ADD PRIMARY KEY (`id`);

--
-- Indexuri pentru tabele `panel_notifications`
--
ALTER TABLE `panel_notifications`
  ADD PRIMARY KEY (`ID`);

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
-- Indexuri pentru tabele `server_clans`
--
ALTER TABLE `server_clans`
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
-- Indexuri pentru tabele `server_gascan`
--
ALTER TABLE `server_gascan`
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
-- AUTO_INCREMENT pentru tabele eliminate
--

--
-- AUTO_INCREMENT pentru tabele `2fa_connect`
--
ALTER TABLE `2fa_connect`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT pentru tabele `panelactions2`
--
ALTER TABLE `panelactions2`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pentru tabele `panel_notifications`
--
ALTER TABLE `panel_notifications`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pentru tabele `server_bans`
--
ALTER TABLE `server_bans`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pentru tabele `server_bans_ip`
--
ALTER TABLE `server_bans_ip`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `server_business`
--
ALTER TABLE `server_business`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pentru tabele `server_chat_logs`
--
ALTER TABLE `server_chat_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2393;

--
-- AUTO_INCREMENT pentru tabele `server_ds`
--
ALTER TABLE `server_ds`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT pentru tabele `server_exam_checkpoints`
--
ALTER TABLE `server_exam_checkpoints`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
-- AUTO_INCREMENT pentru tabele `server_gascan`
--
ALTER TABLE `server_gascan`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pentru tabele `server_houses`
--
ALTER TABLE `server_houses`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pentru tabele `server_jobs`
--
ALTER TABLE `server_jobs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pentru tabele `server_kick_logs`
--
ALTER TABLE `server_kick_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pentru tabele `server_labels`
--
ALTER TABLE `server_labels`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `server_logs`
--
ALTER TABLE `server_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=132;

--
-- AUTO_INCREMENT pentru tabele `server_mute_logs`
--
ALTER TABLE `server_mute_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pentru tabele `server_personal_vehicles`
--
ALTER TABLE `server_personal_vehicles`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pentru tabele `server_pickups`
--
ALTER TABLE `server_pickups`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT pentru tabele `server_vars`
--
ALTER TABLE `server_vars`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pentru tabele `server_vehicles`
--
ALTER TABLE `server_vehicles`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `server_warn_logs`
--
ALTER TABLE `server_warn_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
