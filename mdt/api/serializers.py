from rest_framework import serializers
from . import models

class CivilianSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Civilian
        fields = ['civId', 'fullName', 'imageProfileURL', 'detailsProfile']
        
class ChargeSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Charge
        fields = ['chargeName']
        
class ReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Report
        fields = ['repId', 'reportName', 'detailsReport', 'dateCreated']
        
class ArrestedSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Arrested
        fields = ['repId', 'civId', 'isWarrant']