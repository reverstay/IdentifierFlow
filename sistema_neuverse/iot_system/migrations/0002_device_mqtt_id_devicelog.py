# Generated by Django 5.1.1 on 2024-10-02 20:55

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('iot_system', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='device',
            name='mqtt_id',
            field=models.IntegerField(default=1),
        ),
        migrations.CreateModel(
            name='DeviceLog',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('timestamp', models.DateTimeField(auto_now_add=True)),
                ('status', models.CharField(choices=[('on', 'Ligado'), ('off', 'Desligado')], max_length=3)),
                ('device', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='logs', to='iot_system.device')),
            ],
        ),
    ]