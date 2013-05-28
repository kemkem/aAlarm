from django.conf.urls import patterns, include, url
from aalarm import views


urlpatterns = patterns('',
    url(r'^$', views.index),
    url(r'^command/(?P<name>\w+)$', views.command),
    url(r'^config/$', views.config),
    url(r'^history/$', views.history),
    url(r'^lastZmEvent/$', views.lastZmEvent),
    url(r'^getLastGlobalState/(?P<sensorName>\w+)$', views.getLastGlobalState),
    url(r'^getLastSensorState/(?P<sensorName>\w+)$', views.getLastSensorState),
    url(r'^getLastEvents/(?P<nbEvents>\w+)$', views.getLastEvents),
)

