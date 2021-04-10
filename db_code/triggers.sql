	1)Добавление\изменение члена команды -> Дата создания\закрытия команды

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

	2)Первое\последнее участие робота -> Дата создания\закрытия команды

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
