-- SQL sBoutique --

CREATE TABLE `tebex_accounts` (
  `steam` varchar(50) NOT NULL DEFAULT '0',
  `investisseur` varchar(50) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `tebex_players_wallet` (
  `identifiers` text NOT NULL,
  `transaction` text,
  `price` text NOT NULL,
  `currency` text,
  `points` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
