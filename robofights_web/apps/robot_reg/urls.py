from django.urls import path

from . import views

app_name = 'robot_reg'

urlpatterns = [
	path('', views.index, name = 'index'),
	path('fights_service', views.tournament_create, name = 'tournament_create'),
	path('fights_service/registration_of_robots', views.registration_of_robots, name = 'registration_of_robots'),
	path('fights_service/fights_results', views.fights_results, name = 'fights_results'),
	path('race_service', views.race_tournament_create, name = 'race_tournament_create'),
	path('race_service/registration_of_robots', views.race_registration_of_robots, name = 'race_registration_of_robots'),
	path('race_service/race_results', views.race_results, name = 'race_results'),
	path('show_service', views.select_robots_to_show, name = 'select_robots_to_show')
]