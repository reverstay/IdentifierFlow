from django.db import models
from django.contrib.auth.models import User  # Usuários do Django
from django.utils import timezone

class House(models.Model):
    """Modelo que representa uma casa ou local do proprietário."""
    owner = models.ForeignKey(User, on_delete=models.CASCADE, related_name='houses')  # Relaciona a casa com o proprietário
    name = models.CharField(max_length=100)  # Nome da casa
    address = models.CharField(max_length=255, blank=True, null=True)  # Endereço opcional
    created_at = models.DateTimeField(auto_now_add=True)  # Data de criação da casa

    class Meta:
        unique_together = ('owner', 'name')  # Garante que o proprietário não tenha duas casas com o mesmo nome

    def __str__(self):
        return f"{self.name} - {self.owner.username}"


class Device(models.Model):
    """Modelo que representa um dispositivo IoT dentro de uma casa."""
    STATUS_CHOICES = (
        ('on', 'Ligado'),
        ('off', 'Desligado'),
    )

    house = models.ForeignKey(House, on_delete=models.CASCADE, related_name='devices')  # Dispositivo pertence a uma casa
    name = models.CharField(max_length=100)  # Nome do dispositivo
    mqtt_id = models.IntegerField(default=1)  # Definindo 0 como valor padrão
    status = models.CharField(max_length=3, choices=STATUS_CHOICES, default='off')  # Status do dispositivo (Ligado/Desligado)
    last_status_change = models.DateTimeField(default=timezone.now)  # Última alteração do status

    def __str__(self):
        return f"{self.name} - {self.house.name} - {self.get_status_display()}"

    def toggle_status(self):
        """Alterna o status do dispositivo e atualiza o horário de alteração."""
        self.status = 'off' if self.status == 'on' else 'on'
        self.last_status_change = timezone.now()
        self.save()
        return self.status  # Retorna o novo status após alternar


class DeviceLog(models.Model):
    """Modelo que armazena logs de alterações de dispositivos."""
    device = models.ForeignKey(Device, on_delete=models.CASCADE, related_name='logs')
    timestamp = models.DateTimeField(auto_now_add=True)  # Data e hora da mudança
    status = models.CharField(max_length=3, choices=Device.STATUS_CHOICES)  # Status após a mudança

    def __str__(self):
        return f"Log de {self.device.name} em {self.timestamp}"
