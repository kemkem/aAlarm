from django.conf.urls import patterns, include, url
from aalarm import views


urlpatterns = patterns('',
    url(r'^$', views.index),
    url(r'^command/setOnline$', views.commandSetOnline),
    url(r'^command/setOffline$', views.commandSetOffline),
)

