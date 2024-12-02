from django import forms
from .models import House, Device

class HouseForm(forms.ModelForm):
    class Meta:
        model = House
        fields = ['name', 'address']
        labels = {
            'name': 'Nome da Casa',
            'address': 'Endereço da Casa',
        }
        help_texts = {
            'name': 'Digite um nome para identificar a casa ou local.',
            'address': 'Digite o endereço (opcional).',
        }

class DeviceForm(forms.ModelForm):
    class Meta:
        model = Device
        fields = ['name', 'mqtt_id', 'status']  # Incluído o campo mqtt_id
        labels = {
            'name': 'Nome do Dispositivo',
            'mqtt_id': 'ID MQTT do Dispositivo',  # Rótulo para o campo mqtt_id
            'status': 'Status do Dispositivo',
        }
        help_texts = {
            'name': 'Digite o nome do dispositivo IoT (ex: Luz da Sala).',
            'mqtt_id': 'Digite o ID do dispositivo utilizado para comunicação MQTT.',
            'status': 'Escolha o status inicial (Ligado ou Desligado).',
        }
