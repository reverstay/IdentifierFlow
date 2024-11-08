# Use a imagem base oficial do Python 3.12
FROM python:3.12-slim

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia o arquivo requirements.txt para instalar as dependências
COPY requirements.txt ./

# Instala as dependências necessárias
RUN pip install --no-cache-dir -r requirements.txt

# Copia o restante do código para o diretório de trabalho
COPY . .

# Define a variável de ambiente para dizer ao Flask que estamos em produção
ENV FLASK_ENV=production
ENV FLASK_APP=app.py

# Expõe a porta em que o Flask irá rodar
EXPOSE 5000

# Comando para iniciar o servidor Flask
CMD ["flask", "run", "--host=0.0.0.0", "--port=8080"]
