IdentifierFlow - Sistema de Controle de Acesso com Reconhecimento Facial
Descrição do Projeto
O IdentifierFlow é um sistema de controle de acesso baseado em reconhecimento facial, projetado para gerenciar entradas e saídas de pessoas em ambientes controlados, como academias, hospitais, empresas e órgãos públicos. O sistema integra Flask, FastAPI, MQTT, ESP32, Flutter e Supabase para oferecer um fluxo de autenticação seguro, automatizado e eficiente.

Arquitetura do Sistema
O projeto é composto por diversos componentes que trabalham em conjunto para garantir o funcionamento adequado do sistema.

ESP32 (Hardware - Catraca)

Conexão WiFi e MQTT para comunicação com o servidor.
Processamento de comandos de liberação e negação de acesso.
Controle de LEDs para indicar status de autenticação.
Subscreve ao tópico MQTT para receber comandos do servidor.
Fluxograma:

Inicialização e conexão com WiFi.
Conexão com o broker MQTT.
Processamento de comandos de liberação ("LIBERAR") ou negação ("NEGADO").
Controle da catraca e feedback visual com LEDs.
Backend (FastAPI + Flask)

Gerenciamento das solicitações de autenticação facial.
Integração com a biblioteca face_recognition para identificação de usuários.
API para envio de imagens de reconhecimento e sincronização de arquivos.
Gerenciamento de usuários e permissões.
Endpoints principais:

/identify/ → Processa a imagem de um rosto e retorna permissão ou negação de acesso.
/sync-files/ → Sincroniza arquivos locais e remotos armazenados no Supabase Storage.
Processo de identificação:
Baixa a imagem do usuário.
Processa e compara com o banco de dados.
Retorna um status (entrada/saída) e registra logs.
Aplicação Flutter (App do Usuário)

Interface móvel para usuários autenticarem a entrada via reconhecimento facial.
Utilização do Google ML Kit para detectar e capturar rostos.
Upload das imagens para o Supabase Storage.
Navegação e seleção de dispositivos de entrada e saída.
Fluxo do app:

Login do usuário.
Seleção do dispositivo (entrada/saída).
Captura de imagem via câmera do smartphone.
Upload da imagem para o servidor.
Retorno do status de acesso.
Painel Administrativo (Web)

Gerenciamento de usuários e permissões via interface web.
Dashboards para administradores, diretores e recepcionistas.
Controle de organizações e usuários (criação, edição e remoção).
Funcionalidades principais:

Login e autenticação.
Gerenciamento de organizações e diretores.
Adição e remoção de recepcionistas e usuários.
Visualização de logs de acesso.

📂 CÓDIGOS  
│── 📂 __pycache__  
│── 📂 .vscode  
│── 📂 Catraca - ESP32 - C++    # Código do ESP32  
│── 📂 Flutter                 # Aplicação Flutter  
│── 📂 migrations              # Arquivos de migração do banco de dados  
│── 📂 static                  # Arquivos estáticos da aplicação web  
│── 📂 templates               # Templates HTML do painel administrativo  
│── 📂 usuarios                # Gerenciamento de usuários  
│── .env                       # Variáveis de ambiente  
│── app.py                     # Backend Flask  
│── fastAPI.py                 # Backend FastAPI  
│── fastAPI_funcional.py        # Funções auxiliares do FastAPI  
│── mqtt.py                     # Integração MQTT  


Tecnologias Utilizadas
Backend: Flask, FastAPI, Face Recognition
Banco de Dados: Supabase
Frontend: Flutter (mobile), HTML/CSS (web)
Hardware: ESP32 (WiFi + MQTT)
Comunicação: MQTT
