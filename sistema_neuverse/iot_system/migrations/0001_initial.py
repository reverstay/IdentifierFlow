# Generated by Django 5.1.1 on 2024-10-02 18:11

import django.db.models.deletion
import django.utils.timezone
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='House',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100)),
                ('address', models.CharField(blank=True, max_length=255, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='houses', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'unique_together': {('owner', 'name')},
            },
        ),
        migrations.CreateModel(
            name='Device',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100)),
                ('status', models.CharField(choices=[('on', 'Ligado'), ('off', 'Desligado')], default='off', max_length=3)),
                ('last_status_change', models.DateTimeField(default=django.utils.timezone.now)),
                ('house', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='devices', to='iot_system.house')),
            ],
        ),
    ]
