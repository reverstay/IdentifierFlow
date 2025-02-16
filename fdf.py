import cv2
import numpy as np

# Carrega a imagem (substitua 'input.jpg' pelo caminho da sua imagem)
img = cv2.imread('IdentifierFlow_logo.png')

# Verifica se a imagem foi carregada corretamente
if img is None:
    print("Erro ao carregar a imagem. Verifique o caminho e o nome do arquivo.")
    exit()

# ===============================
# 1. Redução de ruído
# ===============================
# O método fastNlMeansDenoisingColored remove ruídos mantendo os detalhes da imagem
img_denoised = cv2.fastNlMeansDenoisingColored(img, None, h=10, hColor=10, templateWindowSize=7, searchWindowSize=21)

# ===============================
# 2. Equalização do histograma para melhorar o contraste
# ===============================
# Em imagens coloridas, é recomendado equalizar somente o canal de luminância.
# Convertendo a imagem do espaço de cor BGR para YUV.
img_yuv = cv2.cvtColor(img_denoised, cv2.COLOR_BGR2YUV)

# Equaliza o canal Y (luminância)
img_yuv[:, :, 0] = cv2.equalizeHist(img_yuv[:, :, 0])

# Converte de volta para o espaço de cor BGR
img_equalized = cv2.cvtColor(img_yuv, cv2.COLOR_YUV2BGR)

# ===============================
# 3. Aumento de nitidez (Sharpening)
# ===============================
# Definindo um kernel para realçar as bordas e detalhes da imagem
kernel_sharpening = np.array([[-1, -1, -1],
                              [-1,  9, -1],
                              [-1, -1, -1]])
img_sharpened = cv2.filter2D(img_equalized, -1, kernel_sharpening)

# ===============================
# Salva a imagem resultante
# ===============================
cv2.imwrite('output.png', img_sharpened)
print("Processamento concluído. A imagem melhorada foi salva como 'output.jpg'.")
