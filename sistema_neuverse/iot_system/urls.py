from django.urls import path
from . import views

urlpatterns = [
    path('home/', views.iot_home, name='iot_home'),
    path('add_house/', views.add_house, name='add_house'),
    path('add_device/<int:house_id>/', views.add_device, name='add_device'),
    path('control_device/<int:house_id>/<int:device_id>/<str:action>/', views.control_device, name='control_device'),  # Controle de dispositivos
]
