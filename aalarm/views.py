from django.template import RequestContext
from django.shortcuts import render_to_response, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect
from aalarm.models import Command, Execute, RefSensorType, RefState, Sensor, Event, Parameter
#from datetime import datetime
from django.forms.models import modelformset_factory
#from django.forms.formsets import formset_factory
from django import forms
from django.forms import TextInput, BooleanField
from django.core.exceptions import ValidationError

def index(request):
    listEvents = Event.objects.all().order_by('id').reverse()
    listCommands = Command.objects.all()
    return render_to_response('index.html', {'listEvents': listEvents, 'listCommands':listCommands}, context_instance=RequestContext(request))

def getLastState(request, sensorName):
    sensor = Sensor.objects.filter(name=sensorName)
    lastEvent = Event.objects.filter(sensor=sensor).latest('id')    
    return render_to_response('getLastState.html', {'lastEvent': lastEvent}, context_instance=RequestContext(request))

def command(request, name):
    if Execute.objects.count() > 0:    
        executeNotCompleted = Execute.objects.filter(completed=0)
        if executeNotCompleted.count() > 0:
            return HttpResponse("ko")
    command = get_object_or_404(Command, command=name)
    execute = Execute(command=command)
    execute.save()
    return HttpResponse("ok")

def config(request):
    ParameterFormSet = modelformset_factory(Parameter, extra=0, fields=('value',))
    if request.method == "POST":
        try:
            formset = ParameterFormSet(request.POST, request.FILES)
        except ValidationError:
            formset = None
            return HttpResponse("ko")
        if formset.is_valid():
            formset.save()
            return HttpResponse("ok")
    parameterFormSet = ParameterFormSet(queryset=Parameter.objects.filter(showInUI=1))
    return render_to_response('config.html', {'parameterFormSet': parameterFormSet,}, context_instance=RequestContext(request))

