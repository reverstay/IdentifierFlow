# **IdentifierFlow - Sistema de Controle de Acesso com Reconhecimento Facial**

## **Descrição do Projeto**
O **IdentifierFlow** é um sistema de controle de acesso baseado em **reconhecimento facial**, projetado para gerenciar entradas e saídas de pessoas em ambientes controlados, como academias, hospitais, empresas e órgãos públicos. O sistema integra **Flask, FastAPI, MQTT, ESP32, Flutter e Supabase** para oferecer um fluxo de autenticação seguro, automatizado e eficiente.

---

## **Arquitetura do Sistema**
O projeto é composto por diversos componentes que trabalham em conjunto para garantir o funcionamento adequado do sistema.  

### **1. ESP32 (Hardware - Catraca)**
- Conexão WiFi e MQTT para comunicação com o servidor.
- Processamento de comandos de liberação e negação de acesso.
- Controle de LEDs para indicar status de autenticação.
- Subscreve ao tópico MQTT para receber comandos do servidor.  

**Fluxograma:**
- Inicializa e conecta ao WiFi.
- Conecta ao broker MQTT.
- Processa comandos de liberação ("LIBERAR") ou negação ("NEGADO").
- Controla a catraca e exibe feedback visual via LEDs.

### **2. Backend (FastAPI + Flask)**
- Gerenciamento das solicitações de autenticação facial.
- Integração com a biblioteca `face_recognition` para identificação de usuários.
- API para envio de imagens de reconhecimento e sincronização de arquivos.
- Gerenciamento de usuários e permissões.

**Endpoints principais:**
- `/identify/` → Processa a imagem de um rosto e retorna permissão ou negação de acesso.
- `/sync-files/` → Sincroniza arquivos locais e remotos armazenados no **Supabase Storage**.

**Processo de Identificação:**
1. Baixa a imagem do usuário.
2. Processa e compara com o banco de dados.
3. Retorna um status (entrada/saída) e registra logs.

### **3. Aplicação Flutter (App do Usuário)**
- Interface móvel para usuários autenticarem a entrada via reconhecimento facial.
- Utiliza o **Google ML Kit** para detectar e capturar rostos.
- Faz upload das imagens para o **Supabase Storage**.
- Permite seleção de dispositivos de entrada e saída.

**Fluxo do App:**
1. Login do usuário.
2. Seleção do dispositivo (entrada/saída).
3. Captura de imagem via câmera do smartphone.
4. Upload da imagem para o servidor.
5. Retorno do status de acesso.

### **4. Painel Administrativo (Web)**
- Gerenciamento de usuários e permissões via interface web.
- Dashboards para administradores, diretores e recepcionistas.
- Controle de organizações e usuários (criação, edição e remoção).

**Funcionalidades principais:**
- Login e autenticação.
- Gerenciamento de organizações e diretores.
- Adição e remoção de recepcionistas e usuários.
- Visualização de logs de acesso.

---

## **Estrutura de Diretórios**
```
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
```

---

## **Tecnologias Utilizadas**
- **Backend:** Flask, FastAPI, Face Recognition  
- **Banco de Dados:** Supabase  
- **Frontend:** Flutter (mobile), HTML/CSS (web)  
- **Hardware:** ESP32 (WiFi + MQTT)  
- **Comunicação:** MQTT  

---

## **Configuração e Execução**

### **1. Clone este repositório:**
```bash
 git clone https://github.com/seu-repositorio.git
 cd IdentifierFlow
```

### **2. Instale as dependências do backend:**
```bash
pip install -r requirements.txt
```

### **3. Execute o backend Flask/FastAPI:**
```bash
python fastAPI.py
```

### **4. Suba o aplicativo Flutter:**
```bash
flutter run
```

### **5. Configure o ESP32:**
- Suba o firmware fornecido para o ESP32.
- Configure a conexão WiFi e MQTT.
- Certifique-se de que o dispositivo esteja conectado ao servidor corretamente.

---

## **Contribuição**
Caso queira contribuir com melhorias, faça um **fork** do repositório, crie uma **branch** e envie um **pull request** com suas sugestões.

---

## **Licença**
Este projeto está licenciado sob a **MIT License** - veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

Se precisar de ajustes ou adições, me avise! 🚀

