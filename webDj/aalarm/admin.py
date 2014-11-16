from django.contrib import admin
from aalarm.models import Command,Execute,Event,RefSensorType, RefState,Sensor,Parameter,ZMIntrusion,ZMIntrusionPicture,Security,MotionEventPicture

admin.site.register(Command)
admin.site.register(Execute)
admin.site.register(Event)
admin.site.register(RefSensorType)
admin.site.register(RefState)
admin.site.register(Sensor)
admin.site.register(Parameter)
admin.site.register(ZMIntrusion)
admin.site.register(ZMIntrusionPicture)
admin.site.register(Security)
admin.site.register(MotionEventPicture)
