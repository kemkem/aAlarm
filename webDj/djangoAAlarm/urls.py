from django.conf.urls import patterns, include, url
from aalarm import views

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'djangoAAlarm.views.home', name='home'),
    # url(r'^djangoAAlarm/', include('djangoAAlarm.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
    url(r'^aalarm/', include('aalarm.urls')),
)

urlpatterns += patterns('',
	#(r'^site_media/(?P<path>.*)$', 'django.views.static.serve', {'document_root': '/home/kemkem/work/djangoAAlarm/static'}),
    (r'^site_media/(?P<path>.*)$', 'django.views.static.serve', {'document_root': '/home/kemkem/Work/djangoAAlarm/static'}),
)
