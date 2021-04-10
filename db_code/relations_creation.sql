CREATE TYPE robot_size as enum ('малый', 'средний', 'большой');
CREATE TYPE robot_role as enum ('боевой', 'лабиринт', 'шоу');

CREATE TABLE robot_classes (
	id serial PRIMARY KEY,
	size robot_size NOT NULL,
	drone_control boolean DEFAULT false,
	role robot_role NOT NULL
);

CREATE TABLE team(
	id serial PRIMARY KEY,
	title text NOT NULL,
	creation_date date NOT NULL,
	close_date date CHECK(close_date is null or close_date >= creation_date)
);

CREATE TABLE member(
	id serial PRIMARY KEY,
	surname text,
	name text NOT NULL,
	team_id integer REFERENCES team(id) ON DELETE SET NULL,
	role text,
	entrance_date date NOT NULL CHECK (entrance_date <= current_date),
	exit date CHECK (exit >= entrance_date OR exit IS NULL)
);

CREATE TABLE robot (
	id serial PRIMARY KEY,
	title text UNIQUE NOT NULL,
	team_id integer REFERENCES team (id) ON DELETE SET NULL,
	class_id integer REFERENCES robot_classes (id) ON DELETE SET NULL,
	first_participation_date date,
	last_participation_date date,
	condition boolean DEFAULT false
);

CREATE TABLE rating_table (
	id serial PRIMARY KEY,
	robot_id integer REFERENCES robot (id) ON DELETE CASCADE,
	participate_count integer CHECK (participate_count >= 0),
	scores integer CHECK (scores >= 0),
	average_score real,
	last_modification_date date
);

CREATE TABLE arena_characteristic (
	id serial PRIMARY KEY,
	seats_count integer CHECK (seats_count >= 0),
	address text NOT NULL,
	condition text NOT NULL,
	technical_inspection_date date,
	open_date date,
	close_date date
);

CREATE TABLE arena (
	id serial PRIMARY KEY,
	title text NOT NULL,
	characteristic_id integer REFERENCES arena_characteristic (id) ON DELETE SET NULL
);

CREATE TABLE show(
	id serial PRIMARY KEY,
	title text NOT NULL,
	fromat text,
	id_arena integer REFERENCES arena (id) ON DELETE SET NULL,
	show_date date NOT NULL,
	show_time time
);

CREATE TABLE show_participation (
	show_id integer REFERENCES show (id) ON DELETE CASCADE,
	robot_id integer REFERENCES robot (id) ON DELETE CASCADE,
	comment text,
	PRIMARY KEY (show_id, robot_id)
);

CREATE TABLE tournament (
	id serial PRIMARY KEY,
	title text NOT NULL,
	show_id integer REFERENCES show (id) ON DELETE CASCADE,
	tournament_time time 
);

CREATE TABLE fight (
	id serial PRIMARY KEY,
	tournament_id integer REFERENCES tournament (id) ON DELETE CASCADE,
	phase text,
	class_id integer REFERENCES robot_classes (id) ON DELETE SET NULL
);

CREATE TABLE race (
	id serial PRIMARY KEY,
	tournament_id integer REFERENCES tournament (id) ON DELETE CASCADE,
	robot_id integer REFERENCES robot (id) ON DELETE CASCADE,
	race_time time
);

CREATE TABLE fight_participation (
	fight_id integer REFERENCES fight (id) ON DELETE CASCADE,
	robot_id integer REFERENCES robot (id) ON DELETE CASCADE,
	scores integer CHECK (scores  > 0),
	comment text,
	PRIMARY KEY (fight_id, robot_id)
);