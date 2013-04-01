from django.db import models

class Command(models.Model):
    command = models.CharField(max_length=20)
    date = models.DateTimeField()
    completed = models.SmallIntegerField()
    def __unicode__(self):
        return self.command

class RefStateType(models.Model):
    stateType = models.CharField(max_length=30)
    def __unicode__(self):
        return self.stateType

class RefState(models.Model):
    stateType = models.ForeignKey(RefStateType)
    state = models.CharField(max_length=30)
    def __unicode__(self):
        return self.state

class Sensor(models.Model):
    name = models.CharField(max_length=30)
    def __unicode__(self):
        return self.name

class Event(models.Model):
    date = models.DateTimeField()
    stateType = models.ForeignKey(RefStateType)
    sensor = models.ForeignKey(Sensor)
    state = models.ForeignKey(RefState)
    def __unicode__(self):
        return self.sensor.name + " " + self.state.state

class Parameter(models.Model):
    key = models.CharField(max_length=50)
    value = models.CharField(max_length=250)
    def __unicode__(self):
        return self.key
