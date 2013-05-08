from django.conf.urls import patterns, include, url
from aalarm import views


urlpatterns = patterns('',
    url(r'^hello/$', views.hello),
)

