from django.template import RequestContext
from django.shortcuts import render_to_response, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect
from aalarm.models import Command, Execute, RefSensorType, RefState, Sensor, Event, Parameter
from datetime import date
#from django.forms.models import modelformset_factory
#from django.forms.formsets import formset_factory
#from django import forms
#import datetime

def index(request):
    listEvents = Event.objects.all()
    return render_to_response('index.html', {'listEvents': listEvents})
    #return HttpResponse("hello")

def command(request, name):
    command = get_object_or_404(Command, name=name)
    execute = Execute(command=command, date=date.today(), completed=0)
    execute.save()
    return HttpResponse(command)

