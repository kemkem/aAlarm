from django.template import RequestContext
from django.shortcuts import render_to_response, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect
from aalarm.models import Command, RefSensorType, RefState, Sensor, Event, Parameter
#from django.forms.models import modelformset_factory
#from django.forms.formsets import formset_factory
#from django import forms
#import datetime
#from datetime import date

def hello(request):
    listEvents = Event.objects.all()
    return render_to_response('index.html', {'listEvents': listEvents})
    #return HttpResponse("hello");

