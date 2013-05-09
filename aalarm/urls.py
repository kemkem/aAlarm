from django.conf.urls import patterns, include, url
from aalarm import views


urlpatterns = patterns('',
    url(r'^$', views.index),
    url(r'^command/(?P<name>\w+)$', views.command),
)

