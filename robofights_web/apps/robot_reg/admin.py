from django.contrib import admin

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

admin.site.register(Robot)
admin.site.register(Arena)
admin.site.register(ArenaCharacteristic)
admin.site.register(Fight)
admin.site.register(FightParticipation)
admin.site.register(Member)
admin.site.register(Race)
admin.site.register(RatingTable)
admin.site.register(RobotClasses)
admin.site.register(Show)
admin.site.register(ShowParticipation)
admin.site.register(Team)
admin.site.register(Tournament)