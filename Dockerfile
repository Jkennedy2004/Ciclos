# FROM python:3.9-slim
# WORKDIR /app
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt
# COPY . .
# EXPOSE 5000
# CMD ["python", "app.py"]




# Se utiliza la imagen base de Python
FROM python:3.9-slim

# Se crea un grupo y un usuario no privilegiado llamado 'nonrootuser'.
# Esta es una mejor práctica de seguridad y soluciona el fallo CKV_DOCKER_3.
# Los contenedores no deben ejecutarse como root.
RUN groupadd -r nonrootuser && useradd --no-log-init -r -g nonrootuser nonrootuser

# Se establece el directorio de trabajo para la aplicación
WORKDIR /app

# Se copian los archivos de requisitos y se instalan las dependencias.
# El flag --chown asegura que el nuevo usuario sea el propietario de los archivos.
COPY --chown=nonrootuser:nonrootuser requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Se copia el resto del código de la aplicación
# El flag --chown también se aplica aquí.
COPY --chown=nonrootuser:nonrootuser . .

# Se cambia al usuario no privilegiado antes de ejecutar la aplicación.
USER nonrootuser

# Se expone el puerto 5000
EXPOSE 5000

# Se añade la instrucción HEALTHCHECK.
# Esto es una buena práctica y soluciona el fallo CKV_DOCKER_2.
# Permite a orquestadores como Kubernetes monitorear si la aplicación está funcionando.
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl --fail http://localhost:5000/ || exit 1

# Comando para ejecutar la aplicación
CMD ["python", "app.py"]