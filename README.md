# 📁 Neuverse System

Este projeto é uma aplicação web construída com Django 5.1 e utiliza PostgreSQL 17 como banco de dados. Ele contém funcionalidades de autenticação, além de um sistema principal para gerenciar recursos.
## 📂 Estrutura de Diretórios

```bash
📂 neuverse_system/
├── 📄 arvores.sql            # SQL de inicialização do banco de dados
├── 📂 data/                  # Diretório para arquivos de dados
├── 📂 scripts/               # Scripts para automação de tarefas
│   ├── 📄 collectstatic.sh   # Script para coletar arquivos estáticos
│   ├── 📄 migrate.sh         # Script para rodar migrações do banco de dados
├── 📂 sistema_neuverse/      # Diretório principal do sistema
│   ├── 📂 authentication_system/  # App de autenticação do Django
│   ├── 📂 main_system/       # App principal do sistema
│   ├── 📂 staticfiles/       # Arquivos estáticos
├── 🐍 manage.py              # Script de gerenciamento do Django
├── 📄 keys.env               # Arquivo contendo variáveis de ambiente sensíveis
├── 📄 requirements.txt       # Arquivo com dependências do projeto
├── 🐋 Dockerfile             # Arquivo de configuração do Docker
├── 🐋 docker-compose.yml     # Arquivo de configuração do Docker Compose
└── 📄 README.md              # Este arquivo

## 🔧 Versões Atuais

- Django: 5.1
- PostgreSQL: 17
- Python: 3.12.4

## ⚙️ Funcionalidades Principais

- Sistema de autenticação completo usando o Django.
- Gestão de usuários e controle de acesso.
- Integração com banco de dados PostgreSQL para armazenamento de dados.
- Scripts automatizados para gerenciar a aplicação e o banco de dados.

## 🛠️ Comandos Úteis

### Iniciar o projeto com Docker Compose (construção e execução):

docker compose --env-file keys.env up --build

limpar docker

docker system prune -a --volumes


### Explicação:
- **📂**: Representa pastas.
- **📄**: Representa arquivos comuns como `.sql`, `.txt`, `.sh`, `.env`.
- **🐍**: Representa arquivos Python (`.py`).
- **🐋**: Representa arquivos Docker (`Dockerfile`, `docker-compose.yml`).
- Ícones de funcionalidades foram substituídos por emojis relevantes, que são universalmente reconhecíveis no GitHub ou em editores de markdown.

### Como usar:
- Basta copiar e colar o conteúdo acima em um arquivo `README.md` no diretório raiz do seu projeto.
