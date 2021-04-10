from django.shortcuts import render

from django.db import connection

from collections import defaultdict

from .models import Robot
from .models import Arena
from .models import ArenaCharacteristic
from .models import Fight
from .models import FightParticipation
from .models import Member
from .models import Race
from .models import RatingTable
from .models import RobotClasses
from .models import Show
from .models import ShowParticipation
from .models import Team
from .models import Tournament

from django.http import Http404, HttpResponseRedirect

from .forms import TournamentCreateForm

def index(request):
	if request.method == "POST":
		request_data = dict(request.POST)
		del request_data['csrfmiddlewaretoken']
		referer = request_data['referer'][0]
		del request_data['referer']
		
		cursor = connection.cursor()
		results_to_write_list = list()

		if referer == "fight_service":
			class Result_of_robot_fight:
				robot_id = int()
				fight_id = int()
				score = int()
			
			for key in request_data:
				space_pos = key.find(' ')
				result_of_robot_fight = Result_of_robot_fight()
				result_of_robot_fight.robot_id = int(key[:space_pos])
				result_of_robot_fight.fight_id = int(key[space_pos:])
				result_of_robot_fight.score = int(request_data[key][0])
				if result_of_robot_fight.score > 0:
					results_to_write_list.append(result_of_robot_fight)

			for result in results_to_write_list:
				cursor.execute("select write_fight_result_en(%s, %s, %s, %s)", [result.fight_id, result.robot_id, result.score, ''])
		if referer == "race_service":
			class Result_of_robot_race:
				robot_id = int()
				result_time = ''

			tournament_id = request_data['tournament_id'][0]
			del request_data['tournament_id']
			
			for key in request_data:
				result_of_robot_race = Result_of_robot_race()
				result_of_robot_race.robot_id = key
				result_of_robot_race.result_time = request_data[key][0]
				results_to_write_list.append(result_of_robot_race)

			for result in results_to_write_list:
				cursor.execute("select race_result_en(%s, %s, %s)", [tournament_id, result.robot_id, result.result_time])
		if referer == "show_service":
			show_id = int()
			show_id = request_data['show'][0]
			del request_data['show']
			
			for key in request_data:
				results_to_write_list.append(key)

			for result in results_to_write_list:
				cursor.execute("select show_participation_en(%s, %s, %s)", [show_id, result, ''])

		cursor.execute("select robot_default_condition_en()")

	robots_rating_list = RatingTable.objects.order_by('-scores')
	return render(request, 'main/hello_page.html', {'robots_rating_list': robots_rating_list})

#
#Обслуживание боёв
#
def tournament_create(request):
	tournament_create_form = TournamentCreateForm()
	return render(request, 'fights_service/tournament_creations.html', {"tournament_create_form": tournament_create_form})


def registration_of_robots(request):
	if request.method == "POST":
		new_tournament = Tournament()
		new_tournament.title = request.POST.get("title")
		new_tournament.tournament_time = request.POST.get("time")
		new_tournament.show = Show.objects.get(id = request.POST.get("show"))
		new_tournament.save()

		robots_list = Robot.objects.all()

		small_class = RobotClasses.objects.get(id = 1)
		small_robots_list = Robot.objects.filter(class_field = small_class)

		medium_class = RobotClasses.objects.get(id = 5)
		medium_robots_list = Robot.objects.filter(class_field = medium_class)
		
		big_class = RobotClasses.objects.get(id = 8)
		big_robots_list = Robot.objects.filter(class_field = big_class)

	return render(request, 'fights_service/registration_robots.html', {"small_robots_list": small_robots_list, "medium_robots_list": medium_robots_list, "big_robots_list": big_robots_list, "tournament": new_tournament})


def fights_results(request):
	if request.method == "POST":
		data_from_post_robot_ids = list(dict(request.POST).keys())
		data_from_post_robot_ids.remove('csrfmiddlewaretoken')
		data_from_post_robot_ids.remove('tournament_id')

		robot_ready_ids = [int(key) for key in data_from_post_robot_ids]
		ready_robots = Robot.objects.filter(id__in = robot_ready_ids)

		for robot in ready_robots:
			robot.condition = True
			robot.save()

		small_class = RobotClasses.objects.get(id = 1)
		medium_class = RobotClasses.objects.get(id = 5)
		big_class = RobotClasses.objects.get(id = 8)

		tournament_id = request.POST.get("tournament_id")
		tournament = Tournament.objects.get(id = tournament_id)

		cursor = connection.cursor()
		cursor.execute("select organize_figths_en(%s)", [tournament_id])


	#Создание соотношений боёв к роботам
		tournament_fights = Fight.objects.filter(tournament = tournament_id)
		
	#Определение элемента спика
		class Fight_of_robot:
			robot_id = int()
			fight_id = int()
			fight_class = int()
			phase = int()

	#сам список
		fights_of_robots_list = list()

	#формирование списка
	#заполняем сетку малых
		small_robots_count = Robot.objects.filter(id__in = robot_ready_ids, class_field = 1).count()

		small_final_exist = False
		if small_robots_count > 1:
			small_final_exist = True
		#список малых на финал
			small_final_robots = Robot.objects.filter(id__in = robot_ready_ids, class_field = small_class)
		#малые полуфиналы
			small_final = Fight.objects.get(tournament = tournament_id, class_field = 1, phase = "Финал")
		#запись роботов в финал
			for robot in ready_robots:
				if robot in small_final_robots:
					fight_of_robot = Fight_of_robot()
					fight_of_robot.robot_id = robot.id
					fight_of_robot.fight_id = small_final.id
					fight_of_robot.fight_class = 1
					fight_of_robot.phase = 2
					fights_of_robots_list.append(fight_of_robot)

		
		small_semifinals_exist = False
		if small_robots_count > 3:
			small_semifinals_exist = True
		#списки малых роботов на полуфиналы
			small_semifinal_1_robots = Robot.objects.filter(id__in = robot_ready_ids, class_field = small_class)[::2]
			small_semifinal_2_robots = Robot.objects.filter(id__in = robot_ready_ids, class_field = small_class)[1::2]
		#малые полуфиналы
			small_semifinal_1 = Fight.objects.get(tournament = tournament_id, class_field = 1, phase = "Полуфинал 1")
			small_semifinal_2 = Fight.objects.get(tournament = tournament_id, class_field = 1, phase = "Полуфинал 2")
		#распределение роботов по полуфиналам
			for robot in ready_robots:
				if robot in small_semifinal_1_robots:
					fight_of_robot = Fight_of_robot()
					fight_of_robot.robot_id = robot.id
					fight_of_robot.fight_id = small_semifinal_1.id
					fight_of_robot.fight_class = 1
					fight_of_robot.phase = 1
					fights_of_robots_list.append(fight_of_robot)
				if robot in small_semifinal_2_robots:
					fight_of_robot = Fight_of_robot()
					fight_of_robot.robot_id = robot.id
					fight_of_robot.fight_id = small_semifinal_2.id
					fight_of_robot.fight_class = 1
					fight_of_robot.phase = 1
					fights_of_robots_list.append(fight_of_robot)

	#заполняем сетку средних
		medium_robots_count = Robot.objects.filter(id__in = robot_ready_ids, class_field = 5).count()

		medium_final_exist = False
		if medium_robots_count > 1:
			medium_final_exist = True
		#список средних на финал
			medium_final_robots = Robot.objects.filter(id__in = robot_ready_ids, class_field = medium_class)
		#малые полуфиналы
			medium_final = Fight.objects.get(tournament = tournament_id, class_field = 5, phase = "Финал")
		#запись роботов в финал
			for robot in ready_robots:
				if robot in medium_final_robots:
					fight_of_robot = Fight_of_robot()
					fight_of_robot.robot_id = robot.id
					fight_of_robot.fight_id = medium_final.id
					fight_of_robot.fight_class = 2
					fight_of_robot.phase = 2
					fights_of_robots_list.append(fight_of_robot)

		
		medium_semifinals_exist = False
		if medium_robots_count > 3:
			medium_semifinals_exist = True
		#списки средних роботов на полуфиналы
			medium_semifinal_1_robots = Robot.objects.filter(id__in = robot_ready_ids, class_field = medium_class)[::2]
			medium_semifinal_2_robots = Robot.objects.filter(id__in = robot_ready_ids, class_field = medium_class)[1::2]
		#малые полуфиналы
			medium_semifinal_1 = Fight.objects.get(tournament = tournament_id, class_field = 5, phase = "Полуфинал 1")
			medium_semifinal_2 = Fight.objects.get(tournament = tournament_id, class_field = 5, phase = "Полуфинал 2")
		#распределение роботов по полуфиналам
			for robot in ready_robots:
				if robot in medium_semifinal_1_robots:
					fight_of_robot = Fight_of_robot()
					fight_of_robot.robot_id = robot.id
					fight_of_robot.fight_id = medium_semifinal_1.id
					fight_of_robot.fight_class = 2
					fight_of_robot.phase = 1
					fights_of_robots_list.append(fight_of_robot)
				if robot in medium_semifinal_2_robots:
					fight_of_robot = Fight_of_robot()
					fight_of_robot.robot_id = robot.id
					fight_of_robot.fight_id = medium_semifinal_2.id
					fight_of_robot.fight_class = 2
					fight_of_robot.phase = 1
					fights_of_robots_list.append(fight_of_robot)

	#заполняем сетку больших
		big_robots_count = Robot.objects.filter(id__in = robot_ready_ids, class_field = 8).count()

		big_final_exist = False
		if big_robots_count > 1:
			big_final_exist = True
		#список больших на финал
			big_final_robots = Robot.objects.filter(id__in = robot_ready_ids, class_field = big_class)
		#малые полуфиналы
			big_final = Fight.objects.get(tournament = tournament_id, class_field = 8, phase = "Финал")
		#запись роботов в финал
			for robot in ready_robots:
				if robot in big_final_robots:
					fight_of_robot = Fight_of_robot()
					fight_of_robot.robot_id = robot.id
					fight_of_robot.fight_id = big_final.id
					fight_of_robot.fight_class = 3
					fight_of_robot.phase = 2
					fights_of_robots_list.append(fight_of_robot)

		
		big_semifinals_exist = False
		if big_robots_count > 3:
			big_semifinals_exist = True
		#списки больших роботов на полуфиналы
			big_semifinal_1_robots = Robot.objects.filter(id__in = robot_ready_ids, class_field = big_class)[::2]
			big_semifinal_2_robots = Robot.objects.filter(id__in = robot_ready_ids, class_field = big_class)[1::2]
		#малые полуфиналы
			big_semifinal_1 = Fight.objects.get(tournament = tournament_id, class_field = 8, phase = "Полуфинал 1")
			big_semifinal_2 = Fight.objects.get(tournament = tournament_id, class_field = 8, phase = "Полуфинал 2")
		#распределение роботов по полуфиналам
			for robot in ready_robots:
				if robot in big_semifinal_1_robots:
					fight_of_robot = Fight_of_robot()
					fight_of_robot.robot_id = robot.id
					fight_of_robot.fight_id = big_semifinal_1.id
					fight_of_robot.fight_class = 3
					fight_of_robot.phase = 1
					fights_of_robots_list.append(fight_of_robot)
				if robot in big_semifinal_2_robots:
					fight_of_robot = Fight_of_robot()
					fight_of_robot.robot_id = robot.id
					fight_of_robot.fight_id = big_semifinal_2.id
					fight_of_robot.fight_class = 3
					fight_of_robot.phase = 1
					fights_of_robots_list.append(fight_of_robot)


	return render(request, 'fights_service/confirm_fights_results.html', {"ready_robots": ready_robots, "small_class": small_class, "medium_class": medium_class, "big_class": big_class, "tournament_fights": tournament_fights, "fights_of_robots_list": fights_of_robots_list, "small_semifinals_exist": small_semifinals_exist, "small_final_exist": small_final_exist, "medium_semifinals_exist": medium_semifinals_exist, "medium_final_exist": medium_final_exist, "big_semifinals_exist": big_semifinals_exist, "big_final_exist": big_final_exist})


#
#Обслуживание забегов
#
def race_tournament_create(request):
	tournament_create_form = TournamentCreateForm()
	return render(request, 'race_service/race_tournament_creation.html', {"tournament_create_form": tournament_create_form})

def race_registration_of_robots(request):
	if request.method == "POST":
		new_tournament = Tournament()
		new_tournament.title = request.POST.get("title")
		new_tournament.tournament_time = request.POST.get("time")
		new_tournament.show = Show.objects.get(id = request.POST.get("show"))
		new_tournament.save()

		race_class = RobotClasses.objects.get(id = 3)
		race_robots_list = Robot.objects.filter(class_field = race_class)
		
	return render(request, 'race_service/registration_robots.html', {"tournament": new_tournament, "race_robots_list": race_robots_list})

def race_results(request):
	if request.method == "POST":
		data_from_post_robot_ids = list(dict(request.POST).keys())
		data_from_post_robot_ids.remove('csrfmiddlewaretoken')
		data_from_post_robot_ids.remove('tournament_id')

		robot_ready_ids = [int(key) for key in data_from_post_robot_ids]
		ready_robots = Robot.objects.filter(id__in = robot_ready_ids)

		for robot in ready_robots:
			robot.condition = True
			robot.save()

		race_class = RobotClasses.objects.get(id = 3)

		tournament_id = request.POST.get("tournament_id")
		tournament = Tournament.objects.get(id = tournament_id)

	return render(request, 'race_service/confirm_race_results.html', {"tournament": tournament, "ready_robots": ready_robots})


#
#Обслуживание шоу
#
def select_robots_to_show(request):
	show_classes = RobotClasses.objects.filter(role = "шоу")
	show_robots_list = Robot.objects.filter(class_field__in = show_classes)

	shows = Show.objects.all()

	shows_size = Show.objects.all().count()

	return render(request, 'show_service/register_robots_to_show.html', {"show_robots_list": show_robots_list, "shows": shows, "shows_size": shows_size})