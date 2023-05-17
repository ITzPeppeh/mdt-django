from django.urls import path
from api import views

urlpatterns = [
    path('civilian/', views.CivilianList.as_view()),
]