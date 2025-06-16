/*
    Groups with higher priority will have all the permissions of the groups with lower priority.
*/
CREATE TABLE IF NOT EXISTS `groups` (
    `name` VARCHAR(255) NOT NULL PRIMARY KEY,
    `display_name` VARCHAR(255) NOT NULL DEFAULT 'User',
    `priority` INT NOT NULL DEFAULT 0
);

/*
    All the permissions that all the players of each group will have.
*/
CREATE TABLE IF NOT EXISTS `group_permissions` (
    `group_name` VARCHAR(255) NOT NULL,
    `permission` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`group_name`, `permission`),
    FOREIGN KEY (`group_name`) REFERENCES `groups`(`name`) ON DELETE CASCADE
);

/*
    All the players that have joined the server at some point.
*/
CREATE TABLE IF NOT EXISTS `players` (
    `identifier` VARCHAR(255) NOT NULL PRIMARY KEY,
    `group` VARCHAR(255) NOT NULL DEFAULT `user` REFERENCES `groups`(`name`) ON DELETE SET DEFAULT,
    `last_seen` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

/*
    Additional permissions, in case there are exeptions to the group permissions.
*/
CREATE TABLE IF NOT EXISTS `player_permissions` (
    `identifier` VARCHAR(255) NOT NULL,
    `permission` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`identifier`, `permission`),
    FOREIGN KEY (`identifier`) REFERENCES `players`(`identifier`) ON DELETE CASCADE
);

/*
    Assigns players to characters.
    This should be a one-to-many relationship, as a player can have multiple characters.
    However, a character can only be assigned to one player.
*/
CREATE TABLE IF NOT EXISTS `player_characters` (
    `identifier` VARCHAR(255) NOT NULL,
    `citizen_id` VARCHAR(16) NOT NULL,
    PRIMARY KEY (`identifier`, `citizen_id`),
    FOREIGN KEY (`identifier`) REFERENCES `players`(`identifier`) ON DELETE CASCADE,
    FOREIGN KEY (`citizen_id`) REFERENCES `characters`(`citizen_id`) ON DELETE CASCADE
);

/*
    All the characters that have been created by players.
*/
CREATE TABLE IF NOT EXISTS `characters` (
    `citizen_id` VARCHAR(16) NOT NULL PRIMARY KEY,
    `first_name` VARCHAR(255) NOT NULL,
    `last_name` VARCHAR(255) NOT NULL,
    `date_of_birth` DATE NOT NULL,
    `gender` BOOLEAN NOT NULL DEFAULT 0 /* 0: male, 1: female */
);
