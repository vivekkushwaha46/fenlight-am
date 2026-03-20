# Configuration
ADDON_ID="plugin.video.fenlight.am"
ADDON_SRC="packages/${ADDON_ID}"
ADDON_XML="${ADDON_SRC}/addon.xml"

echo "Starting FenLight Optimization Packaging Process (ROOT DEPLOYMENT)..."

# Extract version
VERSION=$(grep -oE 'version="[^"]+"' "$ADDON_XML" | head -1 | cut -d'"' -f2)
echo "Detected version: $VERSION"

# ZIP file at root
ZIP_NAME="${ADDON_ID}-${VERSION}.zip"
ZIP_PATH="${ZIP_NAME}"

echo "Creating Zip Archive at root..."
rm -f "${ADDON_ID}"-*.zip
cd packages || exit 1
zip -r "../$ZIP_PATH" "$ADDON_ID" -x "*.pyc" -x "*.DS_Store" -x "*/__pycache__/*" > /dev/null
cd .. || exit 1

echo "Zip created at $ZIP_PATH"

echo "Generating addons.xml..."
ADDONS_XML="addons.xml"
cat <<EOF > "$ADDONS_XML"
<?xml version="1.0" encoding="UTF-8"?>
<addons>
EOF
cat "$ADDON_XML" >> "$ADDONS_XML"
cat <<EOF >> "$ADDONS_XML"
</addons>
EOF

echo "Generating addons.xml.md5..."
if command -v md5 >/dev/null 2>&1; then
    md5 -q "$ADDONS_XML" > "${ADDONS_XML}.md5"
else
    md5sum "$ADDONS_XML" | awk '{print $1}' > "${ADDONS_XML}.md5"
fi

# Remove index.html as per user request
rm -f index.html
rm -rf repo/

echo "============================================="
echo "Build Complete (Root Mode)!"
echo "Files at root: $ZIP_PATH, addons.xml, addons.xml.md5"
echo "============================================="
