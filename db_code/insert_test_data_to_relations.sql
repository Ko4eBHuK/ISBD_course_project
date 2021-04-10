INSERT INTO team(title, creation_date) VALUES ('Qrage', '2007-01-08'), ('Walkyrie Olympus', '2019-08-12'), ('ANARCHICTS', '2003-06-02'); 
INSERT INTO team(title, creation_date, close_date) VALUES ('Iron Quality', '2011-05-16', '2020-10-03'); 
INSERT INTO team(title, creation_date) VALUES ('TRY HARD', '2019-02-27'), ('Big Bang Theory', '2013-08-22'), ('G A M B I T', '2014-06-15'), ('Пчёлки', '2000-12-30');

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
	
INSERT INTO arena_characteristic(seats_count, address, condition, open_date) Values (850, 'Россия, Москва, Ленинский проспект 38а', 'В эксплуатации', '2018-11-05'), (1400, '1 Ma Te Way Park Dr, Renfrew, Канада', 'В эксплуатации', '2008-04-19'), (1000, '213 Catherington Ln, Waterlooville, Великобритания', 'В эксплуатации', '2017-07-13');

INSERT INTO arena(title, characteristic_id) Values ('Робоцентр МТИ', 1), ('Renfrew Hockey Arena', 2), ('Robot Arenas Ltd', 3);
	
INSERT INTO robot_classes(size, role) VALUES ('малый', 'боевой'), ('малый', 'шоу');
INSERT INTO robot_classes(size, drone_control, role) VALUES ('малый', true, 'лабиринт'), ('малый', true, 'шоу');
INSERT INTO robot_classes(size, role) VALUES ('средний', 'боевой'), ('средний', 'шоу');
INSERT INTO robot_classes(size, drone_control, role) VALUES ('средний', true, 'шоу');
INSERT INTO robot_classes(size, role) VALUES ('большой', 'боевой'), ('большой', 'шоу');
INSERT INTO robot_classes(size, drone_control, role) VALUES ('большой', true, 'шоу');
	
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
	
INSERT INTO show(title, fromat, id_arena, show_date, show_time) Values ('Всероссийский tournament Боевых robotов', 'Плей офф', 1, '2020-11-05', '15:00:00'), ('Renfrew Robot Show', 'Развлекательно-боевой', 2, '2019-12-05', '14:00:00'), ('London robot tournament', 'Развлекательное show', 3, '2020-05-05', '18:00:00');
	
INSERT INTO tournament(title, show_id, tournament_time) VALUES ('Скрежет металла', 1, '15:45:00');
INSERT INTO tournament(title, show_id, tournament_time) VALUES ('Robotic hazard', 2, '15:15:00'), ('El laberinto del fauno', 2, '15:45:00');
INSERT INTO tournament(title, show_id, tournament_time) VALUES ('Panem et circenses', 3, '13:45:00');