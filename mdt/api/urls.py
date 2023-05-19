from django.urls import path
from api import views

urlpatterns = [
    path('civilians/', views.CivilianList.as_view()),
    path('civilians/<int:pk>', views.CivilianDetailList.as_view()),

    path('charges/', views.ChargeList.as_view()),

    path('reports/', views.ReportList.as_view()),
    path('reports/<int:pk>', views.ReportDetailList.as_view()),

    path('crims/<int:pk>', views.CrimsDetailList.as_view()),
]