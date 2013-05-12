from django.template import RequestContext
from django.shortcuts import render_to_response, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect
from aalarm.models import Command, Execute, RefSensorType, RefState, Sensor, Event, Parameter
#from datetime import datetime
#from django.forms.models import modelformset_factory
#from django.forms.formsets import formset_factory
from django import forms

class ParameterForm(forms.ModelForm):
	class Meta:
		model = Parameter
		exclude = ('showInUI',)

def index(request):
    listEvents = Event.objects.all()
    return render_to_response('index.html', {'listEvents': listEvents}, context_instance=RequestContext(request))
    #return HttpResponse("hello")

def command(request, name):
    executeNotCompleted = Execute.objects.filter(completed=0)
    if executeNotCompleted.count() > 0:
        return HttpResponse("ko")
    else:
        command = get_object_or_404(Command, name=name)
        execute = Execute(command=command)
        execute.save()
        return HttpResponse("ok")

def config(request):

    if request.method == "POST":
        postvars = ""
        for key in request.POST:
            value = request.POST[key]
            parameter = Parameter(key=key)
            if parameter.value != value:
                postvars += key + " : changed :" + value + " original :" + parameter.value + "</br>"
        return HttpResponse(postvars)

    listParameter = Parameter.objects.filter(showInUI=1)
    #ParameterFormSet = modelformset_factory(Parameter, extra=0, fields=('key', 'value'))
    #parameterFormSet = ParameterFormSet(queryset=Parameter.objects.filter(showInUI=1))
    #return render_to_response('config.html', {'parameterFormSet': parameterFormSet}, context_instance=RequestContext(request))
    return render_to_response('config.html', {'listParameter': listParameter}, context_instance=RequestContext(request))
