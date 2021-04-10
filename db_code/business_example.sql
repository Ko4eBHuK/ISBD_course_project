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

robot_registration_en(robot_id integer)
	"большие show"
	select robot_registration_en(13);
	select robot_registration_en(12);

show_participation_en(show_id integer, robot_id integer, comment text)
	select show_participation_en(2, 13, 'test function');
	select show_participation_en(2, 12, 'add test data');

"сброс состояний robotов"
select robot_default_condition_en();