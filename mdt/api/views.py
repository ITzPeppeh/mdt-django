
# Create your views here.
from .models import Civilian
from .serializers import CivilianSerializer
from rest_framework.generics import ListAPIView

class CivilianList(ListAPIView):
    queryset = Civilian.objects.all()
    serializer_class = CivilianSerializer
