/*
    This SQL script is used to set up the database for this framework.
*/

/* player data */
CREATE TABLE rsc_players (
    identifier VARCHAR(255) NOT NULL PRIMARY KEY,
    group VARCHAR(255) NOT NULL
);

/* a players character */
CREATE TABLE rsc_character (
    citizenid VARCHAR(16) NOT NULL PRIMARY KEY,
    owned_by VARCHAR(255) NOT NULL REFERENCES rsc_players(identifier),
    firstname VARCHAR(32) NOT NULL,
    lastname VARCHAR(32) NOT NULL,
    dateofbirth DATE NOT NULL,
    last_played TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP()
);