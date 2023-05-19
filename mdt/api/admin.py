from django.contrib import admin
from . import models

@admin.register(models.Civilian)
class CivilianAdmin(admin.ModelAdmin):
    list_display = ['civId', 'fullName', 'imageProfileURL', 'detailsProfile']

@admin.register(models.Charge)
class ChargeAdmin(admin.ModelAdmin):
    list_display = ['id', 'chargeName']

@admin.register(models.Report)
class ReportAdmin(admin.ModelAdmin):
    list_display = ['repId', 'reportName', 'detailsReport', 'dateCreated']
    
@admin.register(models.Arrested)
class ArrestedAdmin(admin.ModelAdmin):
    list_display = ['repId', 'civId', 'isWarrant']