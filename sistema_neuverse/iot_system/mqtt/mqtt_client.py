import json
import ssl
import random
from paho.mqtt import client as mqtt_client
import os
from django.conf import settings
import logging

# Configurando o logger
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(message)s')

broker = 'f897f821.ala.us-east-1.emqxsl.com'
port = 8883
client_id = f'subscribe-{random.randint(0, 100)}'
username = 'neuverse'
password = 'M@r040370'

class MQTTService:
    def __init__(self):
        self.client = None

    def connect_mqtt(self, acao):
        """Conecta ao broker MQTT e envia uma mensagem de controle"""
        logging.debug(f"Conectando ao broker MQTT: {broker}:{port}")

        def on_connect(client, userdata, flags, rc, properties=None):
            if rc == 0:
                logging.debug("Conectado ao broker MQTT com sucesso!")
                self.publish_message(client, acao)  # Publica a mensagem quando conecta
            else:
                logging.error(f"Falha na conexão ao broker MQTT. Código de retorno: {rc}")

        # Certifique-se de que o caminho do certificado esteja correto
        cert_path = os.path.join(settings.BASE_DIR, 'iot_system', 'mqtt', 'emqxsl-ca.crt')
        logging.debug(f"Usando certificado em: {cert_path}")

        self.client = mqtt_client.Client(client_id=client_id, protocol=mqtt_client.MQTTv5)
        self.client.tls_set(ca_certs=cert_path, tls_version=ssl.PROTOCOL_TLS_CLIENT)
        self.client.username_pw_set(username, password)
        self.client.on_connect = on_connect
        logging.debug("Iniciando conexão MQTT...")
        self.client.connect(broker, port)

        # Mantém a conexão ativa para processamento de eventos
        self.client.loop_forever()

    def publish_message(self, client, acao):
        """Cria e publica a mensagem para controle de dispositivos"""
        logging.debug(f"Publicando mensagem de ação: {acao}")

        # Estrutura da mensagem igual ao script original
        pool = {
            "nick": "Matinhos",
            "id": "9fe164fd-38bb-430f-b66d-e93a1881207a",
            "dispositivos": [{
                "id": 2,
                "nick": "Luz da cozinha",
                "status": acao,
                "idPool": "9fe164fd-38bb-430f-b66d-e93a1881207a",
                "nivelAcionamento": "HIGH",
                "genero": "CONTROLELAMPADA"
            }]
        }
        msg = json.dumps([pool], indent=4)
        logging.debug(f"Mensagem formatada para enviar: {msg}")

        topico = f"br/com/neuverse/servidores/{pool['id']}/atualizar"
        logging.debug(f"Publicando no tópico: {topico}")

        result = client.publish(topico, msg)
        status = result[0]
        if status == 0:
            logging.info("Mensagem publicada com sucesso.")
        else:
            logging.error("Falha ao publicar a mensagem.")

        client.disconnect()

    def subscribe(self):
        """Assina um tópico MQTT"""
        logging.debug(f"Subscribing no tópico {topic}")

        def on_message(client, userdata, msg):
            logging.debug(f"Recebido `{msg.payload.decode()}` do tópico `{msg.topic}`")

        self.client.subscribe(topic)
        self.client.on_message = on_message
        self.client.loop_forever()
