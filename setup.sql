/*
    All the players that have joined the server at some point.
*/
CREATE TABLE IF NOT EXISTS `players` (
    `identifier` VARCHAR(255) NOT NULL PRIMARY KEY,
    `last_seen` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
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
