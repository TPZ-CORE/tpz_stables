-- Dumping structure for table tpzcore.wagons
CREATE TABLE IF NOT EXISTS `wagons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(40) NOT NULL,
  `charidentifier` int(11) NOT NULL,
  `model` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `stats` longtext NOT NULL,
  `components` longtext NOT NULL,
  `type` varchar(50) NOT NULL,
  `container` int(11) DEFAULT 0,
  `broken` int(11) DEFAULT 0,
  `bought_account` int(11) DEFAULT -1,
  `date` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;