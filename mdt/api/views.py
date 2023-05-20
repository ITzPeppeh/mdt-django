
# Create your views here.
from . import serializers, models
#from rest_framework.generics import ListAPIView
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

class CivilianList(APIView): #ListAPIView

    def get(self, request): #OTTIENE TUTTO
        civilian = models.Civilian.objects.all()
        serializer = serializers.CivilianSerializer(civilian, many=True)
        return Response(serializer.data)
    
    def put(self, request): #AGGIUNGE
        serializer = serializers.CivilianSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class CivilianDetailList(APIView):
    
    def get_object(self, pk):
        civilian = get_object_or_404(models.Civilian, pk=pk)
        return civilian
    
    def get(self, request, pk): #OTTIENE UNO
        civilian = self.get_object(pk)
        serializer = serializers.CivilianSerializer(civilian)
        return Response(serializer.data)
    
    def put(self, request, pk): #AGGIORNA
        civilian = self.get_object(pk)
        serializer = serializers.CivilianSerializer(civilian, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk): #ELIMINA
        civilian = self.get_object(pk)
        civilian.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class ChargeList(APIView):

    def get(self, request):
        charge = models.Charge.objects.all()
        serializer = serializers.ChargeSerializer(charge, many=True)
        return Response(serializer.data)

class ReportList(APIView):

    def get(self, request): #OTTIENE TUTTO
        report = models.Report.objects.all()
        serializer = serializers.ReportSerializer(report, many=True)
        return Response(serializer.data)
    
    def put(self, request): #AGGIUNGE
        serializer = serializers.ReportSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class ReportDetailList(APIView):
    
    def get_object(self, pk):
        report = get_object_or_404(models.Report, pk=pk)
        return report
    
    def get(self, request, pk): #OTTIENE UNO
        report = self.get_object(pk)
        serializer = serializers.ReportSerializer(report)
        return Response(serializer.data)
    
    def put(self, request, pk): #AGGIORNA
        report = self.get_object(pk)
        serializer = serializers.ReportSerializer(report, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk): #ELIMINA
        report = self.get_object(pk)
        report.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class CrimsList(APIView):

    def get(self, request): #OTTIENE TUTTI I RICERCATI
        report = models.Arrested.objects.filter(isWarrant=True)
        serializer = serializers.ArrestedSerializer(report, many=True)
        return Response(serializer.data)
    
class CrimsDetailsList(APIView):

    def get_object(self, pk):
        arr = get_object_or_404(models.Arrested, pk=pk)
        return arr
    
    def get(self, request, pk): # OTTIENE CRIMS DA REPORTID
        arr = models.Arrested.objects.filter(repId=pk)
        serializer = serializers.ArrestedSerializer(arr, many=True)
        return Response(serializer.data)
    
    def put(self, request, pk): #AGGIUNGE CRIM A REPORTID
        serializer = serializers.ArrestedSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class CrimsDetailList(APIView):
    
    def get_object(self, pk, civ_id):
        arr = get_object_or_404(models.Arrested, repId=pk, civId=civ_id)
        return arr

    def get(self, request, pk, civ_id): #OTTIENE CRIM DA REPORTID E CIVID
        arr = self.get_object(pk, civ_id)
        serializer = serializers.ArrestedSerializer(arr)
        return Response(serializer.data)
    
    def put(self, request, pk, civ_id): #AGGIORNA CRIM DA REPORTID E CIVID
        arr = self.get_object(pk, civ_id)
        serializer = serializers.ArrestedSerializer(arr, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, civ_id): #ELIMINA
        report = self.get_object(pk, civ_id)
        report.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class RepsList(APIView):
    
    def get(self, request, pk): # OTTIENE REPS DA CIVID
        arr = models.Arrested.objects.filter(civId=pk)
        serializer = serializers.ArrestedSerializer(arr, many=True)
        return Response(serializer.data)