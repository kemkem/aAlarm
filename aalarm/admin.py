from django.contrib import admin
from aalarm.models import Command,Event,RefSensorType, RefState,Sensor,Parameter

admin.site.register(Command)
admin.site.register(Event)
admin.site.register(RefSensorType)
admin.site.register(RefState)
admin.site.register(Sensor)
admin.site.register(Parameter)

