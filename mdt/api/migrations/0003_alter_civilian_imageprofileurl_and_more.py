# Generated by Django 4.2.1 on 2023-05-19 17:02

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_alter_civilian_detailsprofile_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='civilian',
            name='imageProfileURL',
            field=models.CharField(default='https://i.imgur.com/ZSqeINh.png', max_length=1000),
        ),
        migrations.AlterField(
            model_name='report',
            name='dateCreated',
            field=models.DateField(auto_now_add=True),
        ),
        migrations.AlterField(
            model_name='report',
            name='repId',
            field=models.AutoField(primary_key=True, serialize=False),
        ),
    ]