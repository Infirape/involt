# Manual Técnico de Despliegue e Infraestructura
**Sistema:** InVolt (Administración y Sincronización)  
**Entidad Destino:** Municipalidad Distrital de Chetilla  
**Plataforma de Despliegue:** Windows Server 2022 (vía WSL2 & Docker)  
**Fecha:** Agosto 2026  

---

## 1. Introducción y Arquitectura General

El sistema **InVolt** es una plataforma de software diseñada para la gestión, lectura y facturación de consumo de energía eléctrica para la Municipalidad Distrital de Chetilla. 

La arquitectura tecnológica implementada se basa en contenedores independientes que garantizan el aislamiento, la escalabilidad y la facilidad de mantenimiento. El despliegue se realiza sobre **Windows Server 2022** utilizando el **Subsistema de Windows para Linux 2 (WSL2)** y **Docker Engine**, ejecutando contenedores nativos de Linux.

```
[ Clientes LAN / Otras PCs ]
             │ (Puertos 3034 y 8081 abiertos en Firewall)
             ▼
   [ Windows Server 2022 (Host) ]
             │ (Redirección vía netsh interface portproxy)
             ▼
   [ WSL2 (Ubuntu 22.04 VM) ]
             │
             ├──► [ Puerto 3034 ] ──► Contenedor Frontend (Next.js - Admin UI)
             └──► [ Puerto 8081 ] ──► Contenedor Backend (Go ConnectRPC API)
                                           │ (Red Interna Docker)
                                           ▼
                                      Contenedor Base de Datos (PostgreSQL 16)
```

---

## 2. Requisitos Previos del Servidor

Para garantizar el funcionamiento óptimo del sistema, el servidor físico o virtual con Windows Server 2022 debe contar con:
*   **Procesador:** 4 núcleos x64 con soporte de virtualización habilitado en BIOS/UEFI.
*   **Memoria RAM:** Mínimo 8 GB (Recomendado 16 GB).
*   **Almacenamiento:** Mínimo 50 GB de espacio libre (formateado en sistema de archivos **NTFS**).
*   **Características de Windows habilitadas:**
    *   Subsistema de Windows para Linux (WSL).
    *   Plataforma de Máquina Virtual.

---

## 3. Estructura de Contenedores (Docker Compose)

La infraestructura de servicios se define y administra mediante el archivo `docker-compose.yml` que orquesta tres componentes principales:

1.  **`involt_db` (Base de Datos):** Servidor relacional PostgreSQL 16 Alpine. Mantiene los datos persistentes mediante un volumen de almacenamiento aislado de Windows.
2.  **`involt_backend` (API Rest / RPC):** Backend de alto rendimiento programado en Go 1.23+. Se conecta a la base de datos PostgreSQL y expone los servicios de administración y la API de sincronización móvil.
3.  **`involt_admin` (Frontend UI):** Interfaz web de administración construida en Next.js. Se comunica con el backend a través de la red de Windows.

---

## 4. Proceso de Instalación y Despliegue

### 4.1. Habilitación de WSL2 e instalación de Ubuntu
En la consola de PowerShell (como Administrador) del Windows Server:
```powershell
# 1. Habilitar características de Windows
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart

# (Requerido reiniciar el servidor después de este paso)

# 2. Configurar WSL en versión 2 e instalar Ubuntu
wsl --set-default-version 2
wsl --install -d Ubuntu-22.04
```

### 4.2. Instalación de Docker CE dentro de Ubuntu
Dentro del entorno Linux Ubuntu, se realiza la instalación limpia del motor de Docker CE:
```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Agregar llave GPG y repositorio oficial de Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar paquetes
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Agregar usuario al grupo docker
sudo usermod -aG docker $USER
```

### 4.3. Descarga del código y variables de entorno
El repositorio del código de la rama de producción (`chetilla`) se almacena en el sistema de archivos nativo de Linux para garantizar máxima velocidad:
```bash
cd ~
git clone -b chetilla git@github.com:Infirape/involt.git
cd involt
```

Se crea el archivo de variables de entorno `.env` en la raíz del proyecto para conectar los servicios y definir los orígenes CORS permitidos:
```env
# Configuración de base de datos
DB_USER=involt_user
DB_PASSWORD=contraseña_segura
DB_NAME=involt_db
DATABASE_URL=postgres://involt_user:contraseña_segura@db:5432/involt_db?sslmode=disable

# URLs de comunicación (Reemplazar con la IP real del servidor Windows)
NEXT_PUBLIC_API_URL=http://192.168.1.31:8081
ALLOWED_ORIGINS=http://192.168.1.31:3034,http://localhost:3034
```

Para compilar y levantar los servicios:
```bash
docker compose up -d --build
```

---

## 5. Configuración de Red local (LAN) y Firewall

Debido a que WSL2 opera bajo una subred NAT dinámica interna del servidor, se implementó una solución automatizada para mapear los puertos del Windows Server hacia la máquina virtual de Linux.

### 5.1. Script de inicio y reenvío de puertos (`C:\Scripts\wsl-deploy-startup.ps1`)
Este script se ejecuta en PowerShell de Windows al arrancar y realiza las siguientes tareas:
1. Asegurar el inicio del servicio Docker en Linux.
2. Extraer la IP interna dinámica de WSL2.
3. Resetear redirecciones anteriores.
4. Mapear los puertos del Host a la IP de la VM.

**Código del script:**
```powershell
wsl -u root service docker start
Start-Sleep -Seconds 5
$wsl_ip = (wsl hostname -I).Trim().Split(" ")[0]
netsh interface portproxy reset
netsh interface portproxy add v4tov4 listenport=3034 listenaddress=0.0.0.0 connectport=3034 connectaddress=$wsl_ip
netsh interface portproxy add v4tov4 listenport=8081 listenaddress=0.0.0.0 connectport=8081 connectaddress=$wsl_ip
```

### 5.2. Reglas del Firewall de Windows
Para permitir que otras terminales de la Municipalidad de Chetilla accedan, se abrieron los siguientes puertos de entrada en el Firewall del Servidor:
*   **Puerto 3034 (TCP):** Acceso web a la aplicación de Administración (Frontend).
*   **Puerto 8081 (TCP):** Acceso a los servicios de la API (Backend).

Comandos aplicados:
```powershell
New-NetFirewallRule -DisplayName "InVolt Admin UI" -Direction Inbound -LocalPort 3034 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "InVolt Backend API" -Direction Inbound -LocalPort 8081 -Protocol TCP -Action Allow
```

---

## 6. Automatización del Arranque (Mantenimiento Autónomo)

Para evitar la intervención manual tras un reinicio del servidor físico, se configuró una tarea en el **Programador de Tareas de Windows**:

*   **Nombre de la tarea:** `Iniciar WSL y Docker`
*   **Desencadenador:** Al iniciar el sistema (At startup).
*   **Usuario ejecutor:** `Administrador` (con opción *"Ejecutar tanto si el usuario inició sesión como si no"* y *"Con privilegios más altos"*).
*   **Acción a ejecutar:**
    *   Programa: `powershell.exe`
    *   Argumentos: `-ExecutionPolicy Bypass -File "C:\Scripts\wsl-deploy-startup.ps1"`

---

## 7. Plan de Gestión de Respaldos (Backups)

### 7.1. Restauración de un backup `.sql` existente
Si se requiere levantar una copia de seguridad histórica del sistema:
1. Copiar el archivo `.sql` al entorno de Linux en `~/projects/involt/`.
2. Ejecutar el comando para limpiar el esquema actual (evita conflictos de llaves primarias duplicadas):
   ```bash
   docker exec -it involt_db psql -U involt_user -d involt_db -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
   ```
3. Importar los datos del archivo de respaldo:
   ```bash
   docker exec -i involt_db psql -U involt_user -d involt_db < nombre_de_tu_backup.sql
   ```

### 7.2. Generación manual de un nuevo backup
Para respaldar la base de datos actual en un archivo `.sql`:
```bash
docker exec -t involt_db pg_dumpall -U involt_user > backup_involt_$(date +%Y%m%d).sql
```

---

## 8. Comandos Útiles de Administración

Estos comandos se ejecutan dentro del directorio del proyecto en la consola de Ubuntu:

*   **Verificar el estado de los servicios:** `docker compose ps`
*   **Ver los logs del backend en tiempo real:** `docker compose logs -f backend`
*   **Reiniciar todos los contenedores:** `docker compose restart`
*   **Apagar la aplicación completa:** `docker compose down`
*   **Encender la aplicación completa:** `docker compose up -d`
