#!/data/data/com.termux/files/usr/bin/bash
# Script para actualizar este repo automáticamente desde ZIP descargado

# --- CONFIGURACIÓN ---
DOWNLOADS_DIR="/storage/emulated/0/Download"
TEMP_DIR="./temp_export"

# --- PASO 1: Detectar el último ZIP descargado ---
ZIP_PATH=$(ls -t "$DOWNLOADS_DIR"/*.zip 2>/dev/null | head -n 1)

if [ -z "$ZIP_PATH" ]; then
    echo "No se encontró ningún archivo ZIP en $DOWNLOADS_DIR"
    exit 1
fi

echo "Se detectó el ZIP: $ZIP_PATH"

# --- PASO 2: Pedir mensaje de commit ---
echo "Ingresa el mensaje de commit:"
read COMMIT_MSG

# --- PASO 3: Limpiar carpeta temporal y descomprimir ---
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
unzip -o "$ZIP_PATH" -d "$TEMP_DIR"

# --- PASO 4: Reemplazar contenido del repo ---
# Esto elimina todo excepto la carpeta .git
rsync -a --delete --exclude='.git/' "$TEMP_DIR/" "./"

# --- PASO 5: Git add, commit y push ---
git add .
git commit -m "$COMMIT_MSG"
git push origin main

# --- PASO 6: Limpiar carpeta temporal ---
rm -rf "$TEMP_DIR"

echo "¡Listo! El repo se actualizó y se hizo push con el commit: $COMMIT_MSG"
