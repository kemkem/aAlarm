from django.db import models

class Command(models.Model):
    command = models.CharField(max_length=20)
    date = models.DateTimeField()
    completed = models.SmallIntegerField()

class Event(models.Model):
    date = models.DateTimeField()
    stateType = models.SmallIntegerField()
    sensorId = models.SmallIntegerField()
    state = models.SmallIntegerField()

class RefState(models.Model):
    stateType = models.SmallIntegerField()
    state = models.CharField(max_length=30)

class Sensor(models.Model):
    name = models.CharField(max_length=30)

class Parameters(models.Model):
    key = models.CharField(max_length=50)
    value = models.CharField(max_length=250)

