from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from .models import Device, House
from .forms import DeviceForm, HouseForm
from .mqtt.mqtt_client import MQTTService  # Importando o serviço MQTT

@login_required
def iot_home(request):
    """Exibe as casas e dispositivos do usuário logado."""
    houses = House.objects.filter(owner=request.user)  # Filtra casas do usuário logado
    return render(request, 'iot_system/home.html', {'houses': houses})

@login_required
def add_device(request, house_id):
    """Adiciona um dispositivo a uma casa específica."""
    house = get_object_or_404(House, id=house_id, owner=request.user)  # Garante que a casa pertence ao usuário
    if request.method == 'POST':
        form = DeviceForm(request.POST)
        if form.is_valid():
            device = form.save(commit=False)
            device.house = house  # Define a casa à qual o dispositivo pertence
            device.save()
            return redirect('iot_home')  # Redireciona para a página principal de IoT após adicionar o dispositivo
    else:
        form = DeviceForm()
    return render(request, 'iot_system/add_device.html', {'form': form, 'house': house})

@login_required
def add_house(request):
    """Adiciona uma nova casa para o usuário logado."""
    if request.method == 'POST':
        form = HouseForm(request.POST)
        if form.is_valid():
            house = form.save(commit=False)
            house.owner = request.user  # Define o proprietário como o usuário logado
            house.save()
            return redirect('iot_home')  # Redireciona para a página principal após adicionar a casa
    else:
        form = HouseForm()
    return render(request, 'iot_system/add_house.html', {'form': form})

@login_required
def control_device(request, house_id, device_id, action):
    """Controla um dispositivo via MQTT (Ligar ou Desligar)"""
    house = get_object_or_404(House, id=house_id, owner=request.user)  # Garante que a casa pertence ao usuário
    device = get_object_or_404(Device, id=device_id, house=house)  # Garante que o dispositivo pertence à casa correta

    mqtt_service = MQTTService()  # Inicializa o serviço MQTT
    mqtt_service.connect_mqtt(action)  # Envia o comando para ligar/desligar o dispositivo

    # Atualiza o status do dispositivo no banco de dados
    device.status = action
    device.save()

    return redirect('iot_home')  # Redireciona de volta para a página principal de IoT