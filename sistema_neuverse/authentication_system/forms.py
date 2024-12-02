from django import forms
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm

class CustomUserCreationForm(UserCreationForm):
    email = forms.EmailField(required=True)  # Campo de e-mail obrigatório

    class Meta:
        model = User
        fields = ['username', 'email', 'password1', 'password2']  # Define os campos no formulário

    def save(self, commit=True):
        user = super().save(commit=False)
        user.email = self.cleaned_data['email']  # Salva o e-mail do usuário
        if commit:
            user.save()
        return user
