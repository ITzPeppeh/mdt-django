from django.db import models

# Create your models here.
class Civilian(models.Model):
    civId = models.IntegerField(primary_key=True)
    fullName = models.CharField(max_length=100)
    imageProfileURL = models.CharField(max_length=1000, default="https://i.imgur.com/ZSqeINh.png")
    detailsProfile = models.CharField(max_length=1000, blank=True)

class Charge(models.Model):
    chargeName = models.CharField(max_length=60)

class Report(models.Model):
  repId = models.AutoField(primary_key=True)
  reportName = models.CharField(max_length=100)
  detailsReport = models.CharField(max_length=1000)
  dateCreated = models.DateField(auto_now_add=True)

class Arrested(models.Model):
   repId = models.ForeignKey(Report, on_delete=models.RESTRICT)
   civId = models.ForeignKey(Civilian, on_delete=models.RESTRICT)
   isWarrant = models.BooleanField()