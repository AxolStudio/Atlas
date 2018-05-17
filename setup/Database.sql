CREATE TABLE `tiles` (
  `id` bigint(20) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `lastedited` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `editedby` int(11) NOT NULL,
  `tags` longtext NOT NULL,
  `finished` tinyint(1) NOT NULL DEFAULT '0',
  `stars` int(11) NOT NULL DEFAULT '0',
  `flags` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `tiles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `coords` (`x`,`y`) USING BTREE;

ALTER TABLE `tiles`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

 CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `username` varchar(32) NOT NULL,
  `email` varchar(64) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `lastonline` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `code` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;