function addDevice() {
    const device = document.createElement('div');
    device.classList.add('device');
    device.style.left = '50px';
    device.style.top = '50px';

    device.onmousedown = function(event) {
        const mapContainer = document.getElementById('mapContainer');
        const containerRect = mapContainer.getBoundingClientRect();

        let shiftX = event.clientX - device.getBoundingClientRect().left;
        let shiftY = event.clientY - device.getBoundingClientRect().top;

        function moveAt(pageX, pageY) {
            let newLeft = pageX - shiftX - containerRect.left;
            let newTop = pageY - shiftY - containerRect.top;

            if (newLeft < 0) newLeft = 0;
            if (newTop < 0) newTop = 0;
            if (newLeft + device.offsetWidth > containerRect.width) {
                newLeft = containerRect.width - device.offsetWidth;
            }
            if (newTop + device.offsetHeight > containerRect.height) {
                newTop = containerRect.height - device.offsetHeight;
            }

            device.style.left = `${newLeft}px`;
            device.style.top = `${newTop}px`;
        }

        function onMouseMove(event) {
            moveAt(event.pageX, event.pageY);
        }

        document.addEventListener('mousemove', onMouseMove);

        device.onmouseup = function() {
            document.removeEventListener('mousemove', onMouseMove);
            device.onmouseup = null;

            const deviceRect = device.getBoundingClientRect();
            const relativeLeft = deviceRect.left - containerRect.left;
            const relativeTop = deviceRect.top - containerRect.top;

            device.style.left = `${relativeLeft}px`;
            device.style.top = `${relativeTop}px`;

            saveDevicePosition(relativeLeft, relativeTop);
        };
    };

    device.ondragstart = function() {
        return false;
    };

    document.getElementById('mapContainer').appendChild(device);
}

function loadBackgroundImage(event) {
    const imageFile = event.target.files[0];
    if (imageFile) {
        const reader = new FileReader();
        reader.onload = function(e) {
            const img = document.getElementById('backgroundImage');
            img.src = e.target.result;
            img.style.display = 'block';

            saveBackgroundImage(e.target.result);
        };
        reader.readAsDataURL(imageFile);
    }
}

function saveDevicePosition(x, y) {
    console.log(`Dispositivo salvo na posição: (${x}, ${y})`);
    // Enviar as coordenadas para o backend
}

function saveBackgroundImage(base64Image) {
    fetch(`/save-background-image/`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': '{{ csrf_token }}'
        },
        body: JSON.stringify({ base64_image: base64Image })
    }).then(response => {
        if (response.ok) {
            console.log('Imagem salva com sucesso!');
        } else {
            console.error('Erro ao salvar imagem.');
        }
    });
}
// Função para abrir o modal de adição de dispositivo
function showAddDeviceModal() {
    var addDeviceModal = new bootstrap.Modal(document.getElementById('addDeviceModal'));
    addDeviceModal.show();
}

// Função para capturar os dados do formulário e adicionar o dispositivo ao mapa
function submitDeviceForm() {
    const deviceName = document.getElementById('deviceName').value;
    const deviceType = document.getElementById('deviceType').value;
    const mqttId = document.getElementById('mqttId').value;

    // Checa se os dados foram preenchidos
    if (deviceName && deviceType && mqttId) {
        // Chama a função para adicionar o dispositivo com os dados
        addDevice(deviceName, deviceType, mqttId);

        // Fecha o modal
        var addDeviceModal = bootstrap.Modal.getInstance(document.getElementById('addDeviceModal'));
        addDeviceModal.hide();
    } else {
        alert('Por favor, preencha todos os campos.');
    }
}

// Função para adicionar um dispositivo ao mapa
function addDevice(name, type, mqttId) {
    const device = document.createElement('div');
    device.classList.add('device');
    device.style.left = '50px';
    device.style.top = '50px';
    device.dataset.name = name;
    device.dataset.type = type;
    device.dataset.mqttId = mqttId;

    device.onmousedown = function(event) {
        const mapContainer = document.getElementById('mapContainer');
        const containerRect = mapContainer.getBoundingClientRect();

        let shiftX = event.clientX - device.getBoundingClientRect().left;
        let shiftY = event.clientY - device.getBoundingClientRect().top;

        function moveAt(pageX, pageY) {
            let newLeft = pageX - shiftX - containerRect.left;
            let newTop = pageY - shiftY - containerRect.top;

            if (newLeft < 0) newLeft = 0;
            if (newTop < 0) newTop = 0;
            if (newLeft + device.offsetWidth > containerRect.width) {
                newLeft = containerRect.width - device.offsetWidth;
            }
            if (newTop + device.offsetHeight > containerRect.height) {
                newTop = containerRect.height - device.offsetHeight;
            }

            device.style.left = `${newLeft}px`;
            device.style.top = `${newTop}px`;
        }

        function onMouseMove(event) {
            moveAt(event.pageX, event.pageY);
        }

        document.addEventListener('mousemove', onMouseMove);

        device.onmouseup = function() {
            document.removeEventListener('mousemove', onMouseMove);
            device.onmouseup = null;

            const deviceRect = device.getBoundingClientRect();
            const relativeLeft = deviceRect.left - containerRect.left;
            const relativeTop = deviceRect.top - containerRect.top;

            device.style.left = `${relativeLeft}px`;
            device.style.top = `${relativeTop}px`;

            saveDevicePosition(relativeLeft, relativeTop, name, type, mqttId);
        };
    };

    device.ondragstart = function() {
        return false;
    };

    document.getElementById('mapContainer').appendChild(device);
}

// Função para salvar a posição e informações do dispositivo no backend
function saveDevicePosition(x, y, name, type, mqttId) {
    console.log(`Dispositivo ${name} (${type}, MQTT ID: ${mqttId}) salvo na posição: (${x}, ${y})`);
    // Enviar as informações do dispositivo e coordenadas para o backend
}
