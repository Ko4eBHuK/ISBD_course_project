from django.db import models

class Arena(models.Model):
    title = models.TextField()
    characteristic = models.ForeignKey('ArenaCharacteristic', models.DO_NOTHING, blank=True, null=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = 'arena'


class ArenaCharacteristic(models.Model):
    seats_count = models.IntegerField(blank=True, null=True)
    address = models.TextField()
    condition = models.TextField()
    technical_inspection_date = models.DateField(blank=True, null=True)
    open_date = models.DateField(blank=True, null=True)
    close_date = models.DateField(blank=True, null=True)

    def __str__(self):
        return self.address

    class Meta:
        db_table = 'arena_characteristic'


class Fight(models.Model):
    tournament = models.ForeignKey('Tournament', models.DO_NOTHING, blank=True, null=True)
    phase = models.TextField(blank=True, null=True)
    class_field = models.ForeignKey('RobotClasses', models.DO_NOTHING, db_column='class_id', blank=True, null=True)  # Field renamed because it was a Python reserved word.

    def __str__(self):
        return self.phase

    class Meta:
        db_table = 'fight'


class FightParticipation(models.Model):
    fight = models.OneToOneField(Fight, models.DO_NOTHING, primary_key=True)
    robot = models.ForeignKey('Robot', models.DO_NOTHING)
    scores = models.IntegerField(blank=True, null=True)
    comment = models.TextField(blank=True, null=True)

    class Meta:
        db_table = 'fight_participation'
        unique_together = (('fight', 'robot'),)


class Member(models.Model):
    surname = models.TextField(blank=True, null=True)
    name = models.TextField()
    team = models.ForeignKey('Team', models.DO_NOTHING, blank=True, null=True)
    role = models.TextField(blank=True, null=True)
    entrance_date = models.DateField()
    exit = models.DateField(blank=True, null=True)

    def __str__(self):
        return self.name + ' ' + self.surname

    class Meta:
        db_table = 'member'


class Race(models.Model):
    tournament = models.ForeignKey('Tournament', models.DO_NOTHING, blank=True, null=True)
    robot = models.ForeignKey('Robot', models.DO_NOTHING, blank=True, null=True)
    race_time = models.TimeField(blank=True, null=True)

    class Meta:
        db_table = 'race'


class RatingTable(models.Model):
    robot = models.ForeignKey('Robot', models.DO_NOTHING, blank=True, null=True)
    participate_count = models.IntegerField(blank=True, null=True)
    scores = models.IntegerField(blank=True, null=True)
    average_score = models.FloatField(blank=True, null=True)
    last_modification_date = models.DateField(blank=True, null=True)

    class Meta:
        db_table = 'rating_table'


class Robot(models.Model):
    title = models.TextField(unique=True)
    team = models.ForeignKey('Team', models.DO_NOTHING, blank=True, null=True)
    class_field = models.ForeignKey('RobotClasses', models.DO_NOTHING, db_column='class_id', blank=True, null=True)  # Field renamed because it was a Python reserved word.
    first_participation_date = models.DateField(blank=True, null=True)
    last_participation_date = models.DateField(blank=True, null=True)
    condition = models.BooleanField(blank=True, null=True)

    def __str__(self):
    	return self.title

    class Meta:
        db_table = 'robot'


class RobotClasses(models.Model):
    size = models.TextField()  # This field type is a guess.
    drone_control = models.BooleanField(blank=True, null=True)
    role = models.TextField()  # This field type is a guess.

    def __str__(self):
        return self.size + ' ' + self.role

    class Meta:
        db_table = 'robot_classes'


class Show(models.Model):
    title = models.TextField()
    fromat = models.TextField(blank=True, null=True)
    id_arena = models.ForeignKey(Arena, models.DO_NOTHING, db_column='id_arena', blank=True, null=True)
    show_date = models.DateField()
    show_time = models.TimeField(blank=True, null=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = 'show'


class ShowParticipation(models.Model):
    show = models.OneToOneField(Show, models.DO_NOTHING, primary_key=True)
    robot = models.ForeignKey(Robot, models.DO_NOTHING)
    comment = models.TextField(blank=True, null=True)

    class Meta:
        db_table = 'show_participation'
        unique_together = (('show', 'robot'),)


class Team(models.Model):
    title = models.TextField()
    creation_date = models.DateField()
    close_date = models.DateField(blank=True, null=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = 'team'


class Tournament(models.Model):
    title = models.TextField()
    show = models.ForeignKey(Show, models.DO_NOTHING, blank=True, null=True)
    tournament_time = models.TimeField(blank=True, null=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = 'tournament'