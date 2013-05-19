from django.template import RequestContext
from django.shortcuts import render_to_response, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect
from aalarm.models import Command, Execute, RefSensorType, RefState, Sensor, Event, Parameter
#from datetime import datetime
from django.forms.models import modelformset_factory
#from django.forms.formsets import formset_factory
from django import forms
from django.forms import TextInput, BooleanField

class MyWidget(forms.TextInput):
    def render(self, name, value, attrs=None):
        #tpl = Template(u"""<h1>There would be a colour widget here, for value $colour</h1>""")
        #return mark_safe(tpl.substitute(colour=value))
        return "<label>" + value + "</label>"

class ParameterForm(forms.ModelForm):
    key = forms.CharField(widget=MyWidget)

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
        parameterForm = ParameterForm(request.POST)
		        if(parameterForm.is_valid()):
			        session = sessionForm.save()
                    return HttpResponse("ok")
    ParameterFormSet = modelformset_factory(Parameter, extra=0, fields=('key', 'value'), form=ParameterForm)
    parameterFormSet = ParameterFormSet(queryset=Parameter.objects.filter(showInUI=1))
    return render_to_response('config.html', {'parameterFormSet': parameterFormSet}, context_instance=RequestContext(request))

