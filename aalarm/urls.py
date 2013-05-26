from django.conf.urls import patterns, include, url
from aalarm import views


urlpatterns = patterns('',
    url(r'^$', views.index),
    url(r'^command/(?P<name>\w+)$', views.command),
    url(r'^config/$', views.config),
    url(r'^history/$', views.history),
    url(r'^lastZmEvent/$', views.lastZmEvent),
    url(r'^getLastState/(?P<sensorName>\w+)$', views.getLastState),
    url(r'^getLastEvents/(?P<nbEvents>\w+)$', views.getLastEvents),
)

