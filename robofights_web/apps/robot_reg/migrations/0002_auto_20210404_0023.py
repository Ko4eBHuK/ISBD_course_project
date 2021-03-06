# Generated by Django 3.1.7 on 2021-04-04 00:23

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('robot_reg', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='robot',
            old_name='rorot_name',
            new_name='robot_name',
        ),
        migrations.RemoveField(
            model_name='robot',
            name='robot_id',
        ),
        migrations.RemoveField(
            model_name='robot',
            name='rorot_condition',
        ),
        migrations.AddField(
            model_name='robot',
            name='robot_condition',
            field=models.BooleanField(default=False, verbose_name='Состояние'),
        ),
        migrations.AlterField(
            model_name='robot',
            name='first_participation_date',
            field=models.DateField(blank=True, verbose_name='Дата первого участия'),
        ),
        migrations.AlterField(
            model_name='robot',
            name='last_participation_date',
            field=models.DateField(blank=True, verbose_name='Дата последнего участия'),
        ),
    ]
