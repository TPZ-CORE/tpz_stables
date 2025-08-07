-- Dumping structure for table tpzcore.horses
CREATE TABLE IF NOT EXISTS `horses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(40) NOT NULL,
  `charidentifier` int(11) NOT NULL,
  `model` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `stats` longtext NOT NULL,
  `components` longtext NOT NULL,
  `type` varchar(50) NOT NULL,
  `age` int(11) NOT NULL DEFAULT 0,
  `sex` int(11) NOT NULL DEFAULT 0,
  `training_experience` int(11) DEFAULT 0,
  `breeding` int(11) DEFAULT 0,
  `container` int(11) DEFAULT 0,
  `isdead` int(11) NOT NULL DEFAULT 0,
  `bought_account` int(11) DEFAULT -1,
  `date` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;