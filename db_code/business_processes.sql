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



	3)reces в лабиринте{}

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