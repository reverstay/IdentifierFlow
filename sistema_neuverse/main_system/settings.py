from pathlib import Path
import os
from dotenv import load_dotenv

# Configura a manipulação de caminhos de forma segura e portável entre sistemas operacionais.
# 'Path' ajuda a evitar problemas com diferentes formatos de caminhos (ex: Windows vs. Linux).
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR.parent / 'data' / 'web'

# Carrega variáveis de ambiente do arquivo 'keys.env' usando dotenv.
# Isso permite que dados sensíveis (como senhas) fiquem fora do código e não sejam expostos.
load_dotenv(BASE_DIR.parent / 'keys.env', override=True)

# Configurações sensíveis como a SECRET_KEY do Django e o modo DEBUG, que são
# fundamentais para a segurança e depuração. Elas são carregadas das variáveis de ambiente.
SECRET_KEY = os.getenv('SECRET_KEY', 'change-me')  # Se não encontrar a variável de ambiente, usa um valor padrão inseguro.
DEBUG = bool(int(os.getenv('DEBUG', 0)))  # DEBUG deve estar desligado (False) em produção por questões de segurança.
ALLOWED_HOSTS = [h.strip() for h in os.getenv('ALLOWED_HOSTS', '').split(',') if h.strip()]  # Define os hosts permitidos para evitar acessos não autorizados.

# Lista de aplicativos Django que serão carregados no projeto.
# Estes incluem apps padrão como autenticação, sessões e arquivos estáticos, além de apps personalizados como o 'iot_system'.
INSTALLED_APPS = [
    'django.contrib.admin',  # Painel administrativo do Django.
    'django.contrib.auth',  # Sistema de autenticação e permissões.
    'django.contrib.contenttypes',  # Tipos de conteúdo (estrutura que permite o uso de conteúdo genérico).
    'django.contrib.sessions',  # Gerenciamento de sessões entre as requisições.
    'django.contrib.messages',  # Sistema de mensagens (flash messages).
    'django.contrib.staticfiles',
    'widget_tweaks',# Gerenciamento de arquivos estáticos como CSS e JavaScript.
    'authentication_system',  # Aplicativo personalizado, no caso aqui, um iot_system.
    'iot_system',  # Novo app IoT
    'django_summernote',  # Plugin de editor de texto rico.
]

# Middleware são funções que processam a requisição/resposta em todas as interações entre cliente e servidor.
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',  # Middleware de segurança.
    'django.contrib.sessions.middleware.SessionMiddleware',  # Gerencia as sessões do usuário.
    'django.middleware.locale.LocaleMiddleware',  # Adiciona suporte à internacionalização.
    'django.middleware.common.CommonMiddleware',  # Processa requisições comuns (como redirecionamentos automáticos).
    'django.middleware.csrf.CsrfViewMiddleware',  # Protege contra ataques CSRF (Cross-Site Request Forgery).
    'django.contrib.auth.middleware.AuthenticationMiddleware',  # Gerencia autenticação.
    'django.contrib.messages.middleware.MessageMiddleware',  # Gerencia mensagens flash (feedbacks do sistema).
    'django.middleware.clickjacking.XFrameOptionsMiddleware',  # Protege contra clickjacking (tentativa de roubar cliques).
]

# Configura o arquivo principal de URLs do projeto (geralmente urls.py).
ROOT_URLCONF = 'main_system.urls'

# Configuração de templates (HTML). Define onde o Django deve procurar por arquivos de templates.
# O Django pode usar templates definidos tanto nos diretórios dos apps quanto em diretórios customizados (como o '/templates').
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],  # Diretório de templates customizados fora dos apps.
        'APP_DIRS': True,  # Ativa a busca de templates nas pastas de cada app.
        'OPTIONS': {
            'context_processors': [  # Define variáveis globais que sempre estarão disponíveis nos templates.
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',  # Autenticação disponível nos templates.
                'django.contrib.messages.context_processors.messages',  # Sistema de mensagens flash.
                'django.template.context_processors.i18n',  # Suporte a internacionalização.
            ],
        },
    },
]

# Configuração do WSGI (Web Server Gateway Interface), necessário para que o Django se comunique com o servidor web.
WSGI_APPLICATION = 'main_system.wsgi.application'

# Configuração do banco de dados. Neste caso, usa-se o PostgreSQL.
# Todas as credenciais do banco estão carregadas das variáveis de ambiente, o que é uma prática recomendada para segurança.
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',  # Define o banco de dados como PostgreSQL.
        'NAME': os.getenv('POSTGRES_DB', 'change-me'),  # Nome do banco de dados.
        'USER': os.getenv('POSTGRES_USER', 'change-me'),  # Usuário do banco de dados.
        'PASSWORD': os.getenv('POSTGRES_PASSWORD', 'change-me'),  # Senha do banco de dados.
        'HOST': os.getenv('POSTGRES_HOST', 'change-me'),  # Endereço do servidor de banco de dados.
        'PORT': os.getenv('POSTGRES_PORT', 'change-me'),  # Porta de comunicação com o banco.
    }
}

# Regras de validação de senha. Aumentam a segurança forçando padrões mínimos de complexidade.
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',  # Proíbe senhas parecidas com os atributos do usuário.
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',  # Exige um comprimento mínimo de caracteres.
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',  # Proíbe senhas comuns (fracas).
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',  # Proíbe senhas apenas numéricas.
    },
]

# Configurações de internacionalização (suporte a múltiplos idiomas).
LANGUAGE_CODE = 'pt-us'  # Define o idioma padrão como português (Brasil).
LANGUAGES = [  # Lista de idiomas suportados.
    ('en', 'English'),
    ('pt', 'Portuguese'),
    ('es', 'Spanish'),
]
LOCALE_PATHS = [  # Diretórios onde o Django busca arquivos de tradução.
    BASE_DIR / 'locale',
    ]

# Configurações de fuso horário e internacionalização de datas.
TIME_ZONE = 'America/Sao_Paulo'  # Fuso horário definido para o Brasil.
USE_I18N = True  # Ativa a internacionalização.
USE_L10N = True  # Ativa a formatação de datas e números de acordo com o local definido.
USE_TZ = True  # Ativa o uso de fusos horários.

# Configurações de arquivos estáticos (CSS, JS, imagens) e mídia (arquivos enviados pelos usuários).
STATIC_URL = '/static/'  # URL para acessar arquivos estáticos.
STATICFILES_DIRS = [  # Diretórios onde o Django procura por arquivos estáticos.
    BASE_DIR / 'iot_system' / 'templates' / 'iot_system' / 'css'
]
STATIC_ROOT = BASE_DIR / 'staticfiles'  # Diretório onde o comando 'collectstatic' vai armazenar os arquivos estáticos em produção.
MEDIA_URL = '/media/'  # URL para acessar arquivos de mídia enviados pelo usuário.
MEDIA_ROOT = DATA_DIR / 'media'  # Diretório onde os arquivos de mídia são armazenados.

# Define o tipo de campo de chave primária padrão para os modelos do Django.
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'  # Define que o Django vai usar automaticamente um campo BigAutoField como chave primária.


LOGIN_REDIRECT_URL = '/iot/home/'
