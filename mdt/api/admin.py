from django.contrib import admin
from .models import Civilian

@admin.register(Civilian)
class CivilianAdmin(admin.ModelAdmin):
    list_display = ['civId', 'fullName', 'imageProfileURL', 'detailsProfile']