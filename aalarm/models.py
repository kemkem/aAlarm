from django.db import models
from datetime import datetime

class Command(models.Model):
    name = models.CharField(max_length=20)
    def __unicode__(self):
        return self.name

class Execute(models.Model):
    command = models.ForeignKey(Command)
    date = models.DateTimeField(default=datetime.now())
    completed = models.SmallIntegerField(default=0)
    def __unicode__(self):
        return self.command.name

class RefSensorType(models.Model):
    sensorType = models.CharField(max_length=30)
    def __unicode__(self):
        return self.sensorType

class RefState(models.Model):
    sensorType = models.ForeignKey(RefSensorType)
    state = models.CharField(max_length=30)
    css = models.CharField(max_length=30)
    def __unicode__(self):
        return self.state

class Sensor(models.Model):
    sensorType = models.ForeignKey(RefSensorType)
    name = models.CharField(max_length=30)
    def __unicode__(self):
        return self.name

class Event(models.Model):
    date = models.DateTimeField(default=datetime.now())
#    stateType = models.ForeignKey(RefStateType)
    sensor = models.ForeignKey(Sensor)
    state = models.ForeignKey(RefState)
    def __unicode__(self):
        return self.sensor.name + " " + self.state.state

class Parameter(models.Model):
    key = models.CharField(max_length=50)
    value = models.CharField(max_length=250)
    showInUI = models.SmallIntegerField()
    def __unicode__(self):
        return self.key
