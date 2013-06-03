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

class SecondarySensorItem():
    def __init__(self, pConfig):
        self.rowPos = int(pConfig.split(":")[0].split(",")[0])
        self.colPos = int(pConfig.split(":")[0].split(",")[1])
        self.sensor = pConfig.split(":")[1]
    

def index(request):
    listEvents = Event.objects.all().order_by('id').reverse()
    listCommands = Command.objects.all()

    secondaryStatusRows = int(Parameter.objects.filter(name='secondaryStatusRows')[0].value)
    secondaryStatusCols = int(Parameter.objects.filter(name='secondaryStatusCols')[0].value)
    secondaryStatusList = Parameter.objects.filter(name='secondaryStatusList')[0].value

    colClass = ""
    if secondaryStatusCols == 1:
        colClass = "span12"
    if secondaryStatusCols == 2:
        colClass = "span6"
    if secondaryStatusCols == 3:
        colClass = "span4"
    if secondaryStatusCols == 4:
        colClass = "span3"

    aSecondaryStatus = secondaryStatusList.split(";")
    rows = [secondaryStatusRows, secondaryStatusCols]
    for secondaryStatus in aSecondaryStatus:
        secondarySensorItem = SecondarySensorItem(secondaryStatus)
        rows[1][1] = 33
    
    secondarySensors = ""
    for row in range(0, secondaryStatusRows):
        secondarySensors += "<div class=\"row\">"
        for col in range(0, secondaryStatusCols):
            secondarySensors += "<div class=\""+colClass+"\">"
            secondarySensors += "<p id=\"" + "sensorid" + "\">" + "sensorname" + "</p>"
            secondarySensors += "</div>"
        secondarySensors += "</div>"

    return render_to_response('index.html', {'listEvents': listEvents, 'listCommands':listCommands, 'secondarySensors':secondarySensors}, context_instance=RequestContext(request))

def getLastSensorState(request, sensorName):
    sensor = Sensor.objects.filter(name=sensorName)
    lastEvent = Event.objects.filter(sensor=sensor).latest('id')    
    return render_to_response('getLastSensorState.html', {'lastEvent': lastEvent}, context_instance=RequestContext(request))

def getLastGlobalState(request, sensorName):
    sensor = Sensor.objects.filter(name=sensorName)
    lastEvent = Event.objects.filter(sensor=sensor).latest('id')    
    return render_to_response('getLastGlobalState.html', {'lastEvent': lastEvent}, context_instance=RequestContext(request))

def getLastEvents(request, nbEvents):
    listEvents = Event.objects.all().order_by('id').reverse()[:nbEvents]
    return render_to_response('getLastEvents.html', {'listEvents': listEvents}, context_instance=RequestContext(request))

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
            #return HttpResponse("ok")
    parameterFormSet = ParameterFormSet(queryset=Parameter.objects.filter(showInUI=1))
    return render_to_response('config.html', {'parameterFormSet': parameterFormSet,}, context_instance=RequestContext(request))

def history(request):
    return render_to_response('history.html', {}, context_instance=RequestContext(request))

def lastZmEvent(request):
    return render_to_response('lastZmEvent.html', {}, context_instance=RequestContext(request))

