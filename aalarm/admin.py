from django.contrib import admin
from aalarm.models import Command,Event,RefStateType, RefState,Sensor,Parameter

admin.site.register(Command)
admin.site.register(Event)
admin.site.register(RefStateType)
admin.site.register(RefState)
admin.site.register(Sensor)
admin.site.register(Parameter)

