~~~~~~~~~~~~~~~~~~~~
~~~~~~создание~~~~~~
~~~~~~~~~~~~~~~~~~~~

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

~~~~~~~~~~~~~~~~~~~~
~~~~~заполнение~~~~~
~~~~~~~~~~~~~~~~~~~~
{}	
	100
	team{}
		team(
			id serial PRIMARY KEY,
			title text NOT NULL,
			creation_date date NOT NULL,
			close_date date
		);	
	
		INSERT INTO team(title, creation_date) VALUES ('Qrage', '2007-01-08'), 
															('Walkyrie Olympus', '2019-08-12'), 
															('ANARCHICTS', '2003-06-02'); 
		INSERT INTO team(title, creation_date, close_date) VALUES ('Iron Quality', '2011-05-16', '2020-10-03'); 
		INSERT INTO team(title, creation_date) VALUES ('TRY HARD', '2019-02-27'),
															('Big Bang Theory', '2013-08-22'), 
															('G A M B I T', '2014-06-15'),
															('Пчёлки', '2000-12-30');
	
	100
	member{}
		member(
			id serial PRIMARY KEY,
			surname text,
			name text NOT NULL,
			team_id integer REFERENCES team(id) ON DELETE SET NULL,
			role text,
			entrance_date date NOT NULL,
			exit date 
		);
	
		INSERT INTO member(surname, name, team_id, role, entrance_date) VALUES ('Сечко', 'Эдуард', 8, 'Командующий', '2011-08-08'); 
		INSERT INTO member(surname, name, team_id, role, entrance_date, exit) VALUES ('Кучкин', 'Алексей', 8, 'Кадровик', '2013-04-18', '2018-10-15');
		INSERT INTO member(surname, name, team_id, role, entrance_date) VALUES ('Богданова', 'Александра', 8, 'Механик', '2011-10-09');
		

		INSERT INTO member(surname, name, team_id, role, entrance_date, exit) VALUES ('Kelly', 'Sam', 1, 'Пилот', '2007-01-12', '2007-07-01');
		INSERT INTO member(surname, name, team_id, role, entrance_date) VALUES ('Hughes', 'Elliot', 1, 'Оператор', '2007-01-12');
		INSERT INTO member(surname, name, team_id, role, entrance_date, exit) VALUES ('Jenkins', 'Lee Roy', 1, 'Помошник оператора', '2010-03-15', '2012-12-21');
		INSERT INTO member(surname, name, team_id, role, entrance_date) VALUES ('Green', 'Lester', 1, 'Программист', '2009-09-05'), ('Turner', 'Victor', 1, 'Представитель', '2007-02-06');
	
		INSERT INTO member(surname, name, team_id, role, entrance_date) VALUES ('Diamandis', 'Callistus', 2, 'Психолог', '2020-03-15'), ('Ariti', 'Sofronio', 2, 'Менеджер', '2019-08-12'), ('Papachristodoulopoulos', 'Lycorida', 2, 'Механик', '2019-10-01');
		INSERT INTO member(surname, name, team_id, role, entrance_date, exit) VALUES ('Argyros', 'Vander', 2, 'Пилот', '2019-11-15', '2020-02-20');

		INSERT INTO member(surname, name, team_id, role, entrance_date) VALUES ('Komorowski', 'Bartosz', 3, 'Пилот', '2004-01-02'), ('Skrzypczak', 'Teodor', 3, 'Пилот-механик', '2003-06-05'), ('Kucharski', 'Kamil', 3, 'Менеджер', '2003-06-02');

		INSERT INTO member(surname, name, team_id, role, entrance_date, exit) VALUES ('Bergmann', 'Gerd', 4, 'Менеджер', '2011-05-16', '2019-07-07'), ('Fried', 'Nele', 4, 'Менеджер', '2019-01-15', '2020-10-03'), ('Arnold', 'Christa', 4, 'Оператор robotа', '2011-08-01', '2019-12-20'), ('Beyer', 'Karl', 4, 'Рекламщик', '2019-11-15', '2019-12-20');

		INSERT INTO member(surname, name, team_id, role, entrance_date) VALUES ('Марков', 'Алексей', 5, 'Основатель', '2019-02-27'), ('Константинов', 'Андрей', 5, 'Управляющий машиной', '2019-02-27');
		INSERT INTO member(surname, name, team_id, role, entrance_date, exit) VALUES ('Давыдов', 'Геннадий', 5, 'Старпом', '2019-02-27', '2019-10-27');
		
		INSERT INTO member(surname, name, team_id, role, entrance_date, exit) VALUES ('Lavigne', 'Matthieu', 6, 'Пилот', '2013-08-22', '2019-01-01');
		INSERT INTO member(surname, name, team_id, role, entrance_date) VALUES ('Michel', 'Grégoire', 6, 'Работник архива', '2013-08-22');
		INSERT INTO member(surname, name, team_id, role, entrance_date) VALUES ('Girard', 'Denis', 6, 'Проектировщик', '2015-07-07');
		
		INSERT INTO member(surname, name, team_id, role, entrance_date) VALUES ('Smith', 'David', 7, 'Тактик', '2015-03-01'), ('Brooks', 'Oliver', 7, 'Пилот', '2015-03-01'), ('Lawrence', 'Walter', 7, 'Аналитик', '2015-03-01');
	
	100
	arena_characteristic{}
		CREATE TABLE arena_characteristic (
			id serial PRIMARY KEY,
			seats_count integer CHECK (seats_count >= 0),
			address text NOT NULL,
			condition text NOT NULL,
			technical_inspection_date date,
			open_date date,
			close_date date
		);
	
		INSERT INTO arena_characteristic(seats_count, address, condition, open_date) Values 
												(850, 'Россия, Москва, Ленинский проспект 38а', 'В эксплуатации', '2018-11-05'),
												(1400, '1 Ma Te Way Park Dr, Renfrew, Канада', 'В эксплуатации', '2008-04-19'),
												(1000, '213 Catherington Ln, Waterlooville, Великобритания', 'В эксплуатации', '2017-07-13');
	
	100
	arena{}
		CREATE TABLE arena (
			id serial PRIMARY KEY,
			title text NOT NULL,
			characteristic_id integer REFERENCES arena_characteristic (id) ON DELETE SET NULL
		);
	
		INSERT INTO arena(title, characteristic_id) Values ('Робоцентр МТИ', 1), ('Renfrew Hockey Arena', 2), ('Robot Arenas Ltd', 3);
	
	100
	robot_classes{}
		robot_classes (
			id serial PRIMARY KEY,
			size robot_size NOT NULL,
			drone_control boolean DEFAULT 0,
			role robot_role NOT NULL
		);
	
		INSERT INTO robot_classes(size, role) VALUES ('малый', 'боевой'), ('малый', 'шоу');
		INSERT INTO robot_classes(size, drone_control, role) VALUES ('малый', true, 'лабиринт'), ('малый', true, 'шоу');
		
		INSERT INTO robot_classes(size, role) VALUES ('средний', 'боевой'), ('средний', 'шоу');
		INSERT INTO robot_classes(size, drone_control, role) VALUES ('средний', true, 'шоу');
		
		INSERT INTO robot_classes(size, role) VALUES ('большой', 'боевой'), ('большой', 'шоу');
		INSERT INTO robot_classes(size, drone_control, role) VALUES ('большой', true, 'шоу');
	
	100
	robot{}
		CREATE TABLE robot (
			id serial PRIMARY KEY,
			title text UNIQUE NOT NULL,
			team_id integer REFERENCES team (id) ON DELETE SET NULL,
			class_id integer REFERENCES robot_classes (id) ON DELETE SET NULL,
			first_participation_date date,
			last_participation_date date,
			condition boolean DEFAULT false
		);
	
		INSERT INTO robot(title, team_id, class_id, first_participation_date, last_participation_date) VALUES ('Razer', 4, 8, '2012-05-16', '2020-07-14');		
		INSERT INTO robot(title, team_id, class_id, first_participation_date, last_participation_date) VALUES ('Mortis', 7, 8, '2014-07-15', '2020-09-22');
		INSERT INTO robot(title, team_id, class_id, first_participation_date, last_participation_date) VALUES ('Bigger Brother', 1, 5, '2007-01-10', '2018-03-02');
		INSERT INTO robot(title, team_id, class_id, first_participation_date, last_participation_date) VALUES ('Dantomkia', 2, 5, '2019-12-12', '2020-09-22');
		INSERT INTO robot(title, team_id, class_id, first_participation_date, last_participation_date) VALUES ('Nemesis', 7, 1, '2014-10-01', '2020-03-02');
		INSERT INTO robot(title, team_id, class_id, first_participation_date, last_participation_date) VALUES ('Killertron', 5, 1, '2019-05-15', '2019-07-30');
		INSERT INTO robot(title, team_id, class_id, first_participation_date, last_participation_date) VALUES ('Крейсер Варяг', 8, 3, '2005-12-30', '2019-07-30');
		INSERT INTO robot(title, team_id, class_id, first_participation_date, last_participation_date) VALUES ('Firestorm', 3, 3, '2019-05-15', '2019-07-30');
		INSERT INTO robot(title, team_id, class_id, first_participation_date, last_participation_date) VALUES ('Panic Attack', 1, 3, '2018-10-01', '2019-07-30');
		INSERT INTO robot(title, team_id, class_id, first_participation_date, last_participation_date) VALUES ('Cassius', 2, 10, '2019-12-20', '2019-12-20');
		INSERT INTO robot(title, team_id, class_id, first_participation_date, last_participation_date) VALUES ('Sir Killalot', 4, 9, '2015-05-16', '2018-10-03');
		INSERT INTO robot(title, team_id, class_id, first_participation_date, last_participation_date) VALUES ('Super Joker Mega Kill', 1, 1, '2017-05-15', '2019-07-30');
		INSERT INTO robot(title, team_id, class_id, first_participation_date, last_participation_date) VALUES ('Le Petit Annihilator', 2, 1, '2019-08-15', '2019-08-30');
	
	100
	show{}
		CREATE TABLE show(
			id serial PRIMARY KEY,
			title text NOT NULL,
			fromat text,
			id_arena integer REFERENCES arena (id) ON DELETE SET NULL,
			show_date date NOT NULL,
			show_time time
		);
	
		INSERT INTO show(title, fromat, id_arena, show_date, show_time) Values ('Всероссийский tournament Боевых robotов', 'Плей офф', 1, '2020-11-05', '15:00:00'), ('Renfrew Robot Show', 'Развлекательно-боевой', 2, '2019-12-05', '14:00:00'), ('London robot tournament', 'Развлекательное show', 3, '2020-05-05', '18:00:00');
	
	100
	tournament{}
		CREATE TABLE tournament (
			id serial PRIMARY KEY,
			title text NOT NULL,
			show_id integer REFERENCES show (id) ON DELETE CASCADE,
			tournament_time time 
		);
	
		INSERT INTO tournament(title, show_id, tournament_time) VALUES ('Скрежет металла', 1, '15:45:00');
		INSERT INTO tournament(title, show_id, tournament_time) VALUES ('Robotic hazard', 2, '15:15:00'), ('El laberinto del fauno', 2, '15:45:00');
		INSERT INTO tournament(title, show_id, tournament_time) VALUES ('Panem et circenses', 3, '13:45:00');

~~~~~~~~~~~~~~~~~~~~
~~~~~~триггеры~~~~~~
~~~~~~~~~~~~~~~~~~~~
1)Добавление\изменение члена команды -> Дата создания\закрытия команды{}
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


	CREATE OR REPLACE FUNCTION check_team_member_date_en() RETURNS TRIGGER AS $$
	DECLARE
		team_info record;
	BEGIN
		select * into team_info from team where id = NEW.team_id;  
		IF FOUND THEN
			IF TG_OP = 'INSERT' THEN
				IF NEW.entrance_date < team_info.creation_date THEN
					NEW.entrance_date = team_info.creation_date + '1 day'::interval;
				END IF;
				IF team_info.close_date is not null and NEW.entrance_date > team_info.close_date THEN
					NEW.entrance_date = team_info.close_date - '1 day'::interval;
				END IF;
				IF NEW.exit is not null and team_info.close_date is not null and NEW.exit > team_info.close_date THEN
					NEW.exit = team_info.close_date;
				END IF;
				RETURN NEW;
			ELSIF TG_OP = 'UPDATE' THEN 
				IF NEW.entrance_date < team_info.creation_date THEN
					NEW.entrance_date = team_info.creation_date + '1 day'::interval;
				END IF;
				IF team_info.close_date is not null and NEW.entrance_date > team_info.close_date THEN
					NEW.entrance_date = team_info.close_date - '1 day'::interval;
				END IF;
				IF NEW.exit is not null and team_info.close_date is not null and NEW.exit > team_info.close_date THEN
					NEW.exit = team_info.close_date;
				END IF;
				RETURN NEW;	
			END IF;
		END IF;
	END;
	$$ LANGUAGE plpgsql;
	
	CREATE TRIGGER t_team_member_update_insert_en BEFORE INSERT OR UPDATE ON member FOR EACH ROW EXECUTE PROCEDURE check_team_member_date_en();

2)Первое\последнее участие робота -> Дата создания\закрытия команды{}

	CREATE OR REPLACE FUNCTION check_robot_date_en() RETURNS TRIGGER AS $$
	DECLARE
		team_info record;
	BEGIN
		select * into team_info from team where id = NEW.team_id;  
		IF FOUND THEN
			IF TG_OP = 'INSERT' THEN
				IF NEW.first_participation_date is not null and NEW.first_participation_date < team_info.creation_date THEN
					RETURN NULL;
				END IF;
				IF team_info.close_date is not null and NEW.first_participation_date is not null and NEW.first_participation_date > team_info.close_date THEN
					RETURN NULL;
				END IF;
				IF NEW.last_participation_date is not null and team_info.close_date is not null and NEW.last_participation_date > team_info.close_date THEN
					RETURN NULL;
				END IF;
				RETURN NEW;
			ELSIF TG_OP = 'UPDATE' THEN 
				IF NEW.first_participation_date is not null and NEW.first_participation_date < team_info.creation_date THEN
					RETURN OLD;
				END IF;
				IF team_info.close_date is not null and NEW.first_participation_date is not null and NEW.first_participation_date > team_info.close_date THEN
					RETURN OLD;
				END IF;
				IF NEW.last_participation_date is not null and team_info.close_date is not null and NEW.last_participation_date > team_info.close_date THEN
					RETURN OLD;
				END IF;
				RETURN NEW;	
			END IF;
		END IF;
		RETURN NULL;
	END;
	$$ LANGUAGE plpgsql;
	
	CREATE TRIGGER t_robot_update_insert_en BEFORE INSERT OR UPDATE ON robot FOR EACH ROW EXECUTE PROCEDURE check_robot_date_en();

3)Добавление\изменение рейтинговой таблицы -> Последнее участие robotа

	CREATE OR REPLACE FUNCTION check_rate_date_en() RETURNS TRIGGER AS $$
	DECLARE
		robot_info record;
	BEGIN
		select * into robot_info from robot where id = NEW.robot_id;  
		IF FOUND THEN
			IF TG_OP = 'INSERT' THEN
				IF NEW.last_modification_date is not null and NEW.last_modification_date < robot_info.first_participation_date THEN
					RETURN NULL;
				END IF;
				IF NEW.last_modification_date is null THEN
					NEW.last_modification_date = date(now());
				END IF;
				RETURN NEW;
			ELSIF TG_OP = 'UPDATE' THEN 
				if NEW.last_modification_date is not null and NEW.last_modification_date < robot_info.first_participation_date THEN
					RETURN OLD;
				END IF;
				IF NEW.last_modification_date is null THEN
					NEW.last_modification_date = date(now());
				END IF;
				RETURN NEW;
			END IF;
		END IF;
		RETURN NULL;
	END;
	$$ LANGUAGE plpgsql;
	
	CREATE TRIGGER t_rate_update_insert_en BEFORE INSERT OR UPDATE ON rating_table FOR EACH ROW EXECUTE PROCEDURE check_rate_date_en();

4)Дата шоу -> Дата открытия\закрытия арены

	CREATE OR REPLACE FUNCTION check_show_date_en() RETURNS TRIGGER AS $$
	DECLARE
		arena_info record;
	BEGIN
		select * into arena_info from arena join arena_characteristic on(arena.characteristic_id = arena_characteristic.id) where arena.id = NEW.id_arena;  
		IF FOUND THEN
			IF TG_OP = 'INSERT' THEN
				IF arena_info.open_date is not null and NEW.show_date < arena_info.open_date THEN
					RETURN NULL;
				END IF;
				IF arena_info.close_date is not null and NEW.show_date > arena_info.close_date THEN
					RETURN NULL;
				END IF;
				RETURN NEW;
			ELSIF TG_OP = 'UPDATE' THEN 
				IF arena_info.open_date is not null and NEW.show_date < arena_info.open_date THEN
					RETURN OLD;
				END IF;
				IF arena_info.close_date is not null and NEW.show_date > arena_info.close_date THEN
					RETURN OLD;
				END IF;
				RETURN NEW;
			END IF;
		END IF;
		RETURN NULL;
	END;
	$$ LANGUAGE plpgsql;
	
	CREATE TRIGGER t_show_update_insert_en BEFORE INSERT OR UPDATE ON show FOR EACH ROW EXECUTE PROCEDURE check_show_date_en();

5)Внесение данных о robotе в рейтингову таблицу при создании записи о robotе{}

	CREATE OR REPLACE FUNCTION write_new_robot_in_rate_table_en() RETURNS TRIGGER AS $$
	BEGIN
		INSERT INTO rating_table(robot_id, participate_count, scores, average_score, last_modification_date) VALUES (NEW.id, 0, 0, 0, DATE(NOW()));
		RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
	
	CREATE TRIGGER t_write_rate_table_on_robot_insert_en AFTER INSERT ON robot FOR EACH ROW EXECUTE PROCEDURE write_new_robot_in_rate_table_en();

~~~~~~~~~~~~~~~~~~~~
~~~~~~business~~~~~~
~~~~~~~~~~~~~~~~~~~~
1)Регистрация и сброс сосотояния robotов, {}	
	CREATE OR REPLACE FUNCTION robot_registration_en(robot_id integer) RETURNS integer
	AS $$
	BEGIN
		update robot set condition = true where id = robot_id;
		RETURN null;
	END;
	$$ LANGUAGE plpgsql;

	CREATE OR REPLACE FUNCTION robot_default_condition_en() RETURNS integer
	LANGUAGE plpgsql
	AS $$
	BEGIN
		update robot set condition = false;
		RETURN null;
	END;
	$$;

CREATE OR REPLACE FUNCTION robot_last_participation_update_rate_table_en(var_robot_id integer, score integer) RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
	participation_count integer;
	current_score integer;
BEGIN
	select participate_count INTO participation_count from rating_table where robot_id = var_robot_id;
	participation_count := participation_count + 1;
	update rating_table set participate_count = participation_count where robot_id = var_robot_id;

	select scores INTO current_score from rating_table where robot_id = var_robot_id;
	current_score := current_score + score;
	update rating_table set scores = current_score where robot_id = var_robot_id;

	update rating_table set average_score = (current_score::real / participation_count::real) where robot_id = var_robot_id;

	update rating_table set last_modification_date = date(now()) where robot_id = var_robot_id;
	update robot set last_participation_date = date(now()) where id = var_robot_id;
	RETURN null;
END;
$$;	

2)Бои{}
	"ПОДСЧЁТ robotОВ ОПРЕДЕЛЁННОГО КЛАССА"
	CREATE OR REPLACE FUNCTION robot_ready_count_by_class_en(robot_class integer) RETURNS integer
	AS $$
	DECLARE
		robot_count integer;
	BEGIN
		select count(*) into robot_count from robot where class_id = robot_class and condition = true;
		RETURN robot_count;
	END;
	$$ LANGUAGE plpgsql;
	

	"СОЗДАНИЕ БОЁВ ПО КЛАССУ, КОЛИЧЕСТВУ И tournamentУ"
	CREATE OR REPLACE FUNCTION create_fight_en(robot_class integer, robot_count integer, tournament_id integer) RETURNS integer
	AS $$
	BEGIN
		IF robot_count = 2 or robot_count = 3 THEN
			INSERT into fight(tournament_id, phase, class_id) values (tournament_id, 'Финал', robot_class);
		ELSEIF robot_count >= 4 and robot_count <= 10 THEN
			INSERT into fight(tournament_id, phase, class_id) values (tournament_id, 'Финал', robot_class);
			INSERT into fight(tournament_id, phase, class_id) values (tournament_id, 'Полуфинал 1', robot_class);
			INSERT into fight(tournament_id, phase, class_id) values (tournament_id, 'Полуфинал 2', robot_class);
		END IF;
		RETURN null;
	END;
	$$ LANGUAGE plpgsql;
	

	"ОРГАНИЗАЦИЯ БОЁВ В tournamentЕ"
	CREATE OR REPLACE FUNCTION organize_figths_en(tournament_id integer) RETURNS integer
	AS $$
	DECLARE
		robot_small_class_count integer;
		robot_medium_class_count integer;
		robot_big_class_count integer;
	BEGIN
		robot_small_class_count = robot_ready_count_by_class_en(1);
		robot_medium_class_count = robot_ready_count_by_class_en(5);
		robot_big_class_count = robot_ready_count_by_class_en(8);
		
		PERFORM create_fight_en(1, robot_small_class_count, tournament_id);
		PERFORM create_fight_en(5, robot_medium_class_count, tournament_id);
		PERFORM create_fight_en(8, robot_big_class_count, tournament_id);
		
		RETURN null;
	END;
	$$ LANGUAGE plpgsql;

	

	"ЗАПОЛНЕНИЕ РЕЗУЛЬТАТОВ МЕНЕДЖЕРОМ"
	CREATE OR REPLACE FUNCTION write_fight_result_en(fight_id integer, robot_id integer, score integer, comment text) RETURNS integer
	AS $$
	DECLARE
		robot_rate record;
	BEGIN
		INSERT into fight_participation(fight_id, robot_id, scores, comment) values (fight_id, robot_id, score, comment);
	
		PERFORM robot_last_participation_update_rate_table_en(robot_id, score);
	
		RETURN null;
	END;
	$$ LANGUAGE plpgsql;

3)raceи в лабиринте{}

	CREATE OR REPLACE FUNCTION race_result_en(tournament_id integer, var_robot_id integer, result time) RETURNS integer
	LANGUAGE plpgsql
	AS $$
	BEGIN
		INSERT INTO race(tournament_id, robot_id, race_time) VALUES (tournament_id, var_robot_id, result);
		PERFORM robot_last_participation_update_rate_table_en(var_robot_id, 0);
		RETURN null;
	END;
	$$;
	
	select race_result_en(1, 9, '00:04:13.154');

4)show{}
	
	CREATE OR REPLACE FUNCTION show_participation_en(show_id integer, var_robot_id integer, comment text) RETURNS integer
	LANGUAGE plpgsql
	AS $$
	BEGIN
		INSERT INTO show_participation(show_id, robot_id, comment) VALUES (show_id, var_robot_id, comment);
		PERFORM robot_last_participation_update_rate_table_en(var_robot_id, 0);
		RETURN null;
	END;
	$$;
		
	select show_participation_en(2, 13, 'test function');

~~~~~~~~~~~~~~~~~~~~
заполнение функциями
~~~~~~~~~~~~~~~~~~~~
{}
	studs=> select id, title, class_id, condition from robot;
	 id |       title        | class_id | condition 
	----+-----------------------+-----------+-----------
	  5 | Bigger Brother        |         5 | f
	  6 | Dantomkia             |         5 | f
	  8 | Killertron            |         1 | f
	 15 | Le Petit Annihilator  |         1 | f
	  7 | Nemesis               |         1 | f
	 14 | Super Joker Mega Kill |         1 | f
	  3 | Razer                 |         8 | f
	  4 | Mortis                |         8 | f
	  9 | Крейсер Варяг         |         3 | f
	 10 | Firestorm             |         3 | f
	 11 | Panic Attack          |         3 | f
	 13 | Sir Killalot          |         9 | f
	 12 | Cassius               |        10 | f
	(13 rows)


	studs=> select * from robot_classes;
	 id | size  | drone_control | role 
	----+---------+------------------------+----------------
	  1 | малый   | f                      | боевой
	  2 | малый   | f                      | show
	  3 | малый   | t                      | лабиринт
	  4 | малый   | t                      | show
	  5 | средний | f                      | боевой
	  6 | средний | f                      | show
	  7 | средний | t                      | show
	  8 | большой | f                      | боевой
	  9 | большой | f                      | show
	 10 | большой | t                      | show
	(10 rows)


	studs=> select * from tournament;
	 id |        title        | show_id | tournament_time 
	----+------------------------+--------+------------------
	  1 | Скрежет металла        |      1 | 15:45:00
	  2 | Robotic hazard         |      2 | 15:15:00
	  3 | El laberinto del fauno |      2 | 15:45:00
	  5 | Panem et circenses     |      3 | 13:45:00
	(4 rows)


	studs=> select * from show;
	 id |              title               |        fromat         | id_arena |    show_date    |  show_time   
	----+-------------------------------------+-----------------------+----------+------------+----------
	  1 | Всероссийский tournament Боевых robotов | Плей офф              |        1 | 2020-11-05 | 15:00:00
	  2 | Renfrew Robot Show                  | Развлекательно-боевой |        2 | 2019-12-05 | 14:00:00
	  3 | London robot tournament             | Развлекательное show   |        3 | 2020-05-05 | 18:00:00
	(3 rows)


1)Бои{}
	robot_registration_en(robot_id integer)
		"малые боевые"
		select robot_registration_en(7);
		select robot_registration_en(8);
		select robot_registration_en(14);
		select robot_registration_en(15);
		
		"большие боевые"
select robot_registration_en(3);
select robot_registration_en(4);
	
	organize_figths_en(tournament_id integer)
		select organize_figths_en(4);
	
	
		studs=> select * from fight;
		 id | tournament_id |    phase     | class_id 
		----+-----------+-------------+-----------
		  4 |         5 | Финал       |         1
		  5 |         5 | Полуфинал 1 |         1
		  6 |         5 | Полуфинал 2 |         1
		  7 |         5 | Финал       |         8
		(4 rows)

		studs=> select * from fight;
		 id | tournament_id |    phase    | class_id 
		----+---------------+-------------+----------
		  2 |             4 | Финал       |        1
		  3 |             4 | Полуфинал 1 |        1
		  4 |             4 | Полуфинал 2 |        1
		  5 |             4 | Финал       |        8
		(4 rows)

	write_fight_result_en(fight_id integer, robot_id integer, score integer, comment text)
		select write_fight_result_en(3, 7, 2, 'протестирована функция');
		select write_fight_result_en(3, 8, 1, 'полуфинал 1 проиграл');
		select write_fight_result_en(4, 14, 2, 'полуфинал 2 выиграл');
		select write_fight_result_en(4, 15, 1, 'полуфинал 2 проиграл');
		select write_fight_result_en(2, 7, 2, 'финал малых победитель');
		select write_fight_result_en(2, 14, 1, 'финал малых проиграл');
		
		select write_fight_result_en(5, 3, 2, 'финал больших победитель');
		select write_fight_result_en(5, 4, 1, 'финал больших проигрыш');

2)raceи{}
	
	robot_registration_en(robot_id integer)
		"малые лабиринт"
		select robot_registration_en(9);
		select robot_registration_en(10);
		select robot_registration_en(11);

	race_result_en(tournament_id integer, robot_id integer, result time)
		select race_result_en(1, 9, '00:04:13.154');
		select race_result_en(1, 10, '00:03:37.8');
		select race_result_en(1, 11, '00:04:22.62');

3)show{}_en
	studs=> select * from show;
	 id |              title               |        fromat         | id_arena |    show_date    |  show_time   
	----+-------------------------------------+-----------------------+----------+------------+----------
	  1 | Всероссийский tournament Боевых robotов | Плей офф              |        1 | 2020-11-05 | 15:00:00
	  2 | Renfrew Robot Show                  | Развлекательно-боевой |        2 | 2019-12-05 | 14:00:00
	  3 | London robot tournament             | Развлекательное show   |        3 | 2020-05-05 | 18:00:00

	robot_registration_en(robot_id integer)
		"большие show"
		select robot_registration_en(13);
		select robot_registration_en(12);

	show_participation_en(show_id integer, robot_id integer, comment text)
		select show_participation_en(2, 13, 'test function');
		select show_participation_en(2, 12, 'add test data');

"сброс состояний robotов"
select robot_default_condition_en();

~~~~~~~~~~~~~~~~~~~~
~~~~~~~indexes~~~~~~
~~~~~~~~~~~~~~~~~~~~
CREATE INDEX robot_id_index ON robot USING HASH (id);
CREATE INDEX rating_table_robot_id_index ON rating_table USING HASH (robot_id);