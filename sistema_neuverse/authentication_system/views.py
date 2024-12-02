from django.contrib.auth import login, authenticate
from django.contrib.auth.forms import UserCreationForm
from django.contrib import messages  # Adiciona mensagens de sucesso/erro
from django.shortcuts import render, redirect
from .forms import CustomUserCreationForm  # Importe o formulário personalizado
from django.contrib.auth.decorators import login_required

# Garante que apenas usuários logados podem acessar essa página
@login_required
def home_view(request):
    # Aqui você pode buscar os dados que quer mostrar na página inicial, como notificações, feed, etc.
    return render(request, 'iot_system/home.html')  # Corrigido para usar o template certo

# Função para lidar com temas e renderizar a página inicial
def index(request):
    theme = request.GET.get('theme')
    if theme:
        request.session['theme'] = theme
    theme = request.session.get('theme', 'light')
    return render(request, 'authentication_system/index.html', {'theme': theme})  # Corrigido o caminho do template

# Função de registro
def register(request):
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, 'Sua conta foi criada com sucesso! Você já pode fazer login.')
            return redirect('login')  # Redireciona para a página de login após o registro
    else:
        form = CustomUserCreationForm()
    return render(request, 'authentication_system/register.html', {'form': form})  # Corrigido o caminho do template
