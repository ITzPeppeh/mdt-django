from django.urls import path
from api import views

urlpatterns = [
    path('civilians/', views.CivilianList.as_view()),
    path('civilians/<int:pk>', views.CivilianDetailList.as_view()),

    path('charges/', views.ChargeList.as_view()),

    path('reports/', views.ReportList.as_view()),
    path('reports/<int:pk>', views.ReportDetailList.as_view()),

    path('crims/', views.CrimsList.as_view()), # crims/ get all warrants
    path('crims/<int:pk>', views.CrimsDetailsList.as_view()), # crims/repId get all arrested of a rep / add arrested to rep
    path('crims/<int:pk>/<int:civ_id>', views.CrimsDetailList.as_view()), # crims/repId/civId get arrested of a rep / update
    
    path('crims/reps/<int:pk>', views.RepsList.as_view()),
    
    
    
]