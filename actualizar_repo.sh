#!/data/data/com.termux/files/usr/bin/bash
# Script FINAL y estable para Termux (sin rsync)

DOWNLOADS_DIR="/storage/emulated/0/Download"

echo "🔎 Buscando ZIP en Downloads..."

ZIP_PATH=$(ls -t "$DOWNLOADS_DIR"/*.zip 2>/dev/null | head -n 1)

if [ -z "$ZIP_PATH" ]; then
    echo "❌ No se encontró ningún ZIP en Downloads"
    exit 1
fi

ZIP_NAME=$(basename "$ZIP_PATH")
echo "📦 ZIP detectado: $ZIP_NAME"

echo "✏️ Ingresa el mensaje de commit:"
read COMMIT_MSG

echo "📂 Descomprimiendo ZIP directamente en el repo..."
unzip -o "$ZIP_PATH" -d . >/dev/null

echo "📌 Preparando commit..."
git add .

if git diff --cached --quiet; then
    echo "⚠️ No hay cambios para commitear"
else
    git commit -m "$COMMIT_MSG"
    git push origin main
    echo "✅ Commit y push realizados"
fi

echo "🧹 Eliminando ZIP de Downloads..."
rm -f "$ZIP_PATH"

echo "🚀 Proceso terminado correctamente"
