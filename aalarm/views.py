from django.template import RequestContext
from django.shortcuts import render_to_response, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect
from aalarm.models import Command, Execute, RefSensorType, RefState, Sensor, Event, Parameter, ZMIntrusion, ZMIntrusionPicture
#from datetime import datetime
from django.forms.models import modelformset_factory
#from django.forms.formsets import formset_factory
from django import forms
from django.forms import TextInput, BooleanField
from django.core.exceptions import ValidationError
from django.contrib.auth.decorators import login_required

class SecondaryItem():
    def __init__(self, pConfig):
        self.rowPos = pConfig.split(":")[0].split(",")[0]
        self.colPos = pConfig.split(":")[0].split(",")[1]
        self.sensor = pConfig.split(":")[1]

@login_required
def index(request):
#    if not request.user.is_authenticated():
#        return HttpResponseRedirect('/aalarm/login')

    listEvents = Event.objects.all().order_by('id').reverse()
    listCommands = Command.objects.all()
    
    #get secondary items defined rows and cols 
    secondaryItemsRows = int(Parameter.objects.filter(name='secondaryItemsRows')[0].value)
    secondaryItemsCols = int(Parameter.objects.filter(name='secondaryItemsCols')[0].value)
    #get secondary items list
    secondaryItemsList = Parameter.objects.filter(name='secondaryItemsList')[0].value
    
    #set bootstrap col class according cols nb
    colClass = ""
    if secondaryItemsCols == 1:
        colClass = "span12"
    if secondaryItemsCols == 2:
        colClass = "span6"
    if secondaryItemsCols == 3:
        colClass = "span4"
    if secondaryItemsCols == 4:
        colClass = "span3"

    #split list to array
    aSecondaryItems = secondaryItemsList.split(";")
    hItems = {}
    #iterate over items
    for strSecondaryItem in aSecondaryItems:
        secondaryItem = SecondaryItem(strSecondaryItem)
        #use hash to store sensorname h[row.col] -> sensor name
        hItems[secondaryItem.rowPos + "." + secondaryItem.colPos] = secondaryItem.sensor
    
    #prepare bootstrap "table" of items
    htmlSecondaryItems = ""
    htmlAjaxSensorsToRequest = ""
    #build a table as defined in parameters
    for row in range(0, secondaryItemsRows):
        htmlSecondaryItems += "<div class=\"row\">"
        for col in range(0, secondaryItemsCols):
            hashAdress = str(row + 1) + "." + str(col + 1)
            #if this row.col is defined in list
            if hItems.has_key(hashAdress):
                #request display name
                sensor = Sensor.objects.filter(name=hItems[hashAdress])
                sensorLoadingText = "<span class=\"label labelState\">" + hItems[hashAdress] + "?</span>"
                if sensor.count() > 0:
                    htmlAjaxSensorsToRequest += hItems[hashAdress] + ","
                    sensorLoadingText = "loading..."
                htmlSecondaryItems += "<div class=\""+colClass+" columnCentered\">"
                htmlSecondaryItems += "<p id=\"" + hItems[hashAdress] + "\">" + sensorLoadingText + "</p>"
                htmlSecondaryItems += "</div>"
        htmlSecondaryItems += "</div>"

    #Next Online/Offline command 
    sensor = Sensor.objects.filter(name='Global')
    lastGlobalState = Event.objects.filter(sensor=sensor).latest('id')
    stateOffline = RefState.objects.filter(state="Offline")
    stateOnline = RefState.objects.filter(state="Online")
    #by default, propose next command is setOffline (from every other state than offline)
    nextCommand = Command.objects.filter(command="setOffline")[0]
    #if current state is offline, next command is setOnline
    if lastGlobalState.state == stateOffline[0]:
        nextCommand = Command.objects.filter(command="setOnline")[0]

    return render_to_response('index.html', {'listEvents': listEvents, 'listCommands':listCommands, 'htmlSecondaryItems':htmlSecondaryItems, 'htmlAjaxSensorsToRequest':htmlAjaxSensorsToRequest,'nextCommand':nextCommand,}, context_instance=RequestContext(request))

@login_required
def getLastSensorState(request, sensorName):
    try:
        sensor = Sensor.objects.get(name=sensorName)
    except Sensor.DoesNotExist:
        return HttpResponse("Sensor " + sensorName + " does not exists")
    try:
        lastEvent = Event.objects.filter(sensor=sensor).latest('id')
    except Event.DoesNotExist:
        return HttpResponse(sensor.displayName + " no events")
    return render_to_response('getLastSensorState.html', {'lastEvent': lastEvent}, context_instance=RequestContext(request))

#thats repeated,to get a bigger label and different text
@login_required
def getLastGlobalState(request, sensorName):
    try:
        sensor = Sensor.objects.get(name=sensorName)
    except Sensor.DoesNotExist:
        return HttpResponse("Sensor " + sensorName + " does not exists")
    try:
        lastEvent = Event.objects.filter(sensor=sensor).latest('id')
    except Event.DoesNotExist:
        return HttpResponse(sensor.displayName + " no events")
    return render_to_response('getLastGlobalState.html', {'lastEvent': lastEvent}, context_instance=RequestContext(request))

@login_required
def getLastEvents(request, nbEvents):
    try:
        listEvents = Event.objects.all().order_by('id').reverse()[:nbEvents]
    except Event.DoesNotExist:
        return HttpResponse("no events")
    return render_to_response('getLastEvents.html', {'listEvents': listEvents}, context_instance=RequestContext(request))

@login_required
def command(request, name):
    if Execute.objects.count() > 0:    
        executeNotCompleted = Execute.objects.filter(completed=0)
        if executeNotCompleted.count() > 0:
            return HttpResponse("ko")
    command = get_object_or_404(Command, command=name)
    execute = Execute(command=command)
    execute.save()
    return HttpResponse("ok")

@login_required
def config(request):
    #controller general ui delays

    ParameterFormSet = modelformset_factory(Parameter, extra=0, fields=('value',))
    if request.method == "POST":
        try:
            formset = ParameterFormSet(request.POST, request.FILES)
        except ValidationError:
            formset = None
            return HttpResponse("ko")
        if formset.is_valid():
            formset.save()
    parameterFormSetController = ParameterFormSet(queryset=Parameter.objects.filter(showInUI=1, group="controller").order_by('order'))
    parameterFormSetGeneral = ParameterFormSet(queryset=Parameter.objects.filter(showInUI=1, group="general").order_by('order'))
    parameterFormSetUi = ParameterFormSet(queryset=Parameter.objects.filter(showInUI=1, group="ui").order_by('order'))
    parameterFormSetDelay = ParameterFormSet(queryset=Parameter.objects.filter(showInUI=1, group="delay").order_by('order'))
    return render_to_response('config.html', {'parameterFormSetController': parameterFormSetController,'parameterFormSetGeneral': parameterFormSetGeneral,'parameterFormSetUi': parameterFormSetUi,'parameterFormSetDelay': parameterFormSetDelay,}, context_instance=RequestContext(request))

@login_required
def history(request):
    return render_to_response('history.html', {}, context_instance=RequestContext(request))

@login_required
def lastZmEvent(request):
    try:
        lastZmIntrusion = ZMIntrusion.objects.latest('id')
    except ZMIntrusion.DoesNotExist:
        truc = ""

    try:
        lastZmIntrusionPictures = ZMIntrusionPicture.objects.filter(zmIntrusion=lastZmIntrusion)
    except ZMIntrusionPicture.DoesNotExist:
        truc = ""

    return render_to_response('lastZmEvent.html', {'lastZmIntrusion':lastZmIntrusion, 'lastZmIntrusionPictures':lastZmIntrusionPictures,}, context_instance=RequestContext(request))

