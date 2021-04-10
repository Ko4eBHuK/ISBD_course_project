# Generated by Django 3.1.7 on 2021-04-04 23:27

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('robot_reg', '0003_auto_20210404_0041'),
    ]

    operations = [
        migrations.CreateModel(
            name='Arena',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.TextField()),
            ],
            options={
                'db_table': 'arena',
            },
        ),
        migrations.CreateModel(
            name='ArenaCharacteristic',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('seats_count', models.IntegerField(blank=True, null=True)),
                ('address', models.TextField()),
                ('condition', models.TextField()),
                ('technical_inspection_date', models.DateField(blank=True, null=True)),
                ('open_date', models.DateField(blank=True, null=True)),
                ('close_date', models.DateField(blank=True, null=True)),
            ],
            options={
                'db_table': 'arena_characteristic',
            },
        ),
        migrations.CreateModel(
            name='RobotClasses',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('size', models.TextField()),
                ('drone_control', models.BooleanField(blank=True, null=True)),
                ('role', models.TextField()),
            ],
            options={
                'db_table': 'robot_classes',
            },
        ),
        migrations.CreateModel(
            name='Show',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.TextField()),
                ('fromat', models.TextField(blank=True, null=True)),
                ('show_date', models.DateField()),
                ('show_time', models.TimeField(blank=True, null=True)),
                ('id_arena', models.ForeignKey(blank=True, db_column='id_arena', null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='robot_reg.arena')),
            ],
            options={
                'db_table': 'show',
            },
        ),
        migrations.CreateModel(
            name='Team',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.TextField()),
                ('creation_date', models.DateField()),
                ('close_date', models.DateField(blank=True, null=True)),
            ],
            options={
                'db_table': 'team',
            },
        ),
        migrations.RemoveField(
            model_name='robot',
            name='class_id',
        ),
        migrations.RemoveField(
            model_name='robot',
            name='robot_condition',
        ),
        migrations.RemoveField(
            model_name='robot',
            name='robot_name',
        ),
        migrations.RemoveField(
            model_name='robot',
            name='team_id',
        ),
        migrations.AddField(
            model_name='robot',
            name='condition',
            field=models.BooleanField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='robot',
            name='title',
            field=models.TextField(default='default_robot_title', unique=True),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='robot',
            name='first_participation_date',
            field=models.DateField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='robot',
            name='last_participation_date',
            field=models.DateField(blank=True, null=True),
        ),
        migrations.AlterModelTable(
            name='robot',
            table='robot',
        ),
        migrations.CreateModel(
            name='Tournament',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.TextField()),
                ('tournament_time', models.TimeField(blank=True, null=True)),
                ('show', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='robot_reg.show')),
            ],
            options={
                'db_table': 'tournament',
            },
        ),
        migrations.CreateModel(
            name='RatingTable',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('participate_count', models.IntegerField(blank=True, null=True)),
                ('scores', models.IntegerField(blank=True, null=True)),
                ('average_score', models.FloatField(blank=True, null=True)),
                ('last_modification_date', models.DateField(blank=True, null=True)),
                ('robot', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='robot_reg.robot')),
            ],
            options={
                'db_table': 'rating_table',
            },
        ),
        migrations.CreateModel(
            name='Race',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('race_time', models.TimeField(blank=True, null=True)),
                ('robot', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='robot_reg.robot')),
                ('tournament', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='robot_reg.tournament')),
            ],
            options={
                'db_table': 'race',
            },
        ),
        migrations.CreateModel(
            name='Member',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('surname', models.TextField(blank=True, null=True)),
                ('name', models.TextField()),
                ('role', models.TextField(blank=True, null=True)),
                ('entrance_date', models.DateField()),
                ('exit', models.DateField(blank=True, null=True)),
                ('team', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='robot_reg.team')),
            ],
            options={
                'db_table': 'member',
            },
        ),
        migrations.CreateModel(
            name='Fight',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('phase', models.TextField(blank=True, null=True)),
                ('class_field', models.ForeignKey(blank=True, db_column='class_id', null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='robot_reg.robotclasses')),
                ('tournament', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='robot_reg.tournament')),
            ],
            options={
                'db_table': 'fight',
            },
        ),
        migrations.AddField(
            model_name='arena',
            name='characteristic',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='robot_reg.arenacharacteristic'),
        ),
        migrations.AddField(
            model_name='robot',
            name='class_field',
            field=models.ForeignKey(blank=True, db_column='class_id', null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='robot_reg.robotclasses'),
        ),
        migrations.AddField(
            model_name='robot',
            name='team',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='robot_reg.team'),
        ),
        migrations.CreateModel(
            name='ShowParticipation',
            fields=[
                ('show', models.OneToOneField(on_delete=django.db.models.deletion.DO_NOTHING, primary_key=True, serialize=False, to='robot_reg.show')),
                ('comment', models.TextField(blank=True, null=True)),
                ('robot', models.ForeignKey(on_delete=django.db.models.deletion.DO_NOTHING, to='robot_reg.robot')),
            ],
            options={
                'db_table': 'show_participation',
                'unique_together': {('show', 'robot')},
            },
        ),
        migrations.CreateModel(
            name='FightParticipation',
            fields=[
                ('fight', models.OneToOneField(on_delete=django.db.models.deletion.DO_NOTHING, primary_key=True, serialize=False, to='robot_reg.fight')),
                ('scores', models.IntegerField(blank=True, null=True)),
                ('comment', models.TextField(blank=True, null=True)),
                ('robot', models.ForeignKey(on_delete=django.db.models.deletion.DO_NOTHING, to='robot_reg.robot')),
            ],
            options={
                'db_table': 'fight_participation',
                'unique_together': {('fight', 'robot')},
            },
        ),
    ]
