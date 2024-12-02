from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include
from django.views.generic import RedirectView
from django.contrib.auth import views as auth_views
from authentication_system import views as authentication_system_views  # Importa suas views personalizadas

urlpatterns = [
    path('admin/', admin.site.urls),
    path('authentication_system/', include('authentication_system.urls')),  # Inclui as URLs do sistema de autenticação
    path('i18n/', include('django.conf.urls.i18n')),

    # URLs de autenticação
    path('login/', auth_views.LoginView.as_view(template_name='authentication_system/login.html'), name='login'),  # Corrigido para usar o template do authentication_system
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),

    # URL para registro de usuários usando a nova view personalizada
    path('register/', authentication_system_views.register, name='register'),  # Usando a view personalizada de registro

    # Redireciona a URL raiz para /iot_system/
    path('', RedirectView.as_view(url='/authentication_system/', permanent=True)),  # Redireciona para a home do app IoT
    path('home/', authentication_system_views.home_view, name='home'),

    # Inclui URLs do novo app iot_system
    path('iot/', include('iot_system.urls')),  # Novo app IoT, corrigido para incluir as URLs do iot_system
]

# Configurações de arquivos estáticos no modo DEBUG
if settings.DEBUG:
    urlpatterns += static(
        settings.MEDIA_URL,
        document_root=settings.MEDIA_ROOT
    )
