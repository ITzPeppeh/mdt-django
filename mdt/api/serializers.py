from rest_framework import serializers
from .models import Civilian

class CivilianSerializer(serializers.ModelSerializer):
    class Meta:
        model = Civilian
        fields = ['civId', 'fullName', 'imageProfileURL', 'detailsProfile']