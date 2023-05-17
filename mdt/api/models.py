from django.db import models

# Create your models here.
class Civilian(models.Model):
    civId = models.IntegerField()
    fullName = models.CharField(max_length=100)
    imageProfileURL = models.CharField(max_length=1000)
    detailsProfile = models.CharField(max_length=1000)