#!/bin/bash

# Configuration
REPO_DIR="repo"
ADDON_ID="plugin.video.fenlight.am"
ADDON_SRC="packages/${ADDON_ID}"
ADDON_XML="${ADDON_SRC}/addon.xml"

echo "Starting FenLight Optimization Packaging Process..."

# Extract version using awk/grep
if [ ! -f "$ADDON_XML" ]; then
    echo "Error: $ADDON_XML not found!"
    exit 1
fi

VERSION=$(grep -oE 'version="[^"]+"' "$ADDON_XML" | head -1 | cut -d'"' -f2)

if [ -z "$VERSION" ]; then
    echo "Error: Could not extract version number."
    exit 1
fi

echo "Detected version: $VERSION"

# Create directories
mkdir -p "$REPO_DIR/$ADDON_ID"

# Create zip file
ZIP_NAME="${ADDON_ID}-${VERSION}.zip"
ZIP_PATH="${REPO_DIR}/${ADDON_ID}/${ZIP_NAME}"

echo "Creating Zip Archive..."
# Remove old zip if it exists
rm -f "$ZIP_PATH"

# Zip the directory, excluding pyc and DS_Store
# cd into packages so the folder structure in the zip is plugin.video.fenlight/
cd packages || exit 1
zip -r "../$ZIP_PATH" "$ADDON_ID" -x "*.pyc" -x "*.DS_Store" -x "*/__pycache__/*" > /dev/null
cd .. || exit 1

echo "Zip created at $ZIP_PATH"

# Copy addon.xml and artworks to the repo folder for standard Kodi repository structures
cp "${ADDON_SRC}/addon.xml" "${REPO_DIR}/${ADDON_ID}/"
if [ -f "${ADDON_SRC}/icon.png" ]; then
    cp "${ADDON_SRC}/icon.png" "${REPO_DIR}/${ADDON_ID}/"
fi
if [ -f "${ADDON_SRC}/fanart.jpg" ]; then
    cp "${ADDON_SRC}/fanart.jpg" "${REPO_DIR}/${ADDON_ID}/"
fi

echo "Generating addons.xml..."
ADDONS_XML="${REPO_DIR}/addons.xml"
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
    # macOS
    md5 -q "$ADDONS_XML" > "${ADDONS_XML}.md5"
else
    # Linux
    md5sum "$ADDONS_XML" | awk '{print $1}' > "${ADDONS_XML}.md5"
fi

echo "Generating directory indexing (index.html) for Kodi File Manager..."
cat <<EOF > "${REPO_DIR}/index.html"
<html>
<body>
<h1>FenLight AM Repo</h1>
<hr/>
<pre>
<a href="../">../</a>
<a href="addons.xml">addons.xml</a>
<a href="addons.xml.md5">addons.xml.md5</a>
<a href="${ADDON_ID}/">${ADDON_ID}/</a>
</pre>
</body>
</html>
EOF

cat <<EOF > "${REPO_DIR}/${ADDON_ID}/index.html"
<html>
<body>
<h1>${ADDON_ID} package</h1>
<hr/>
<pre>
<a href="../">../</a>
<a href="${ZIP_NAME}">${ZIP_NAME}</a>
<a href="addon.xml">addon.xml</a>
<a href="icon.png">icon.png</a>
<a href="fanart.jpg">fanart.jpg</a>
</pre>
</body>
</html>
EOF

echo "Generating root directory indexing (index.html)..."
cat <<EOF > "index.html"
<html>
<head><title>FenLight AM Repository</title></head>
<body>
<h1>FenLight AM Repository</h1>
<hr/>
<pre>
<a href="${ZIP_PATH}">${ZIP_NAME}</a>
<a href="repo/addons.xml">addons.xml</a>
<a href="repo/addons.xml.md5">addons.xml.md5</a>
</pre>
</body>
</html>
EOF

echo "============================================="
echo "Build Complete!"
echo "Zip: $ZIP_PATH"
echo "XMLs: ${ADDONS_XML}, ${ADDONS_XML}.md5"
echo ""
echo "You can now commit the repo/ directory and push to GitHub Pages."
echo "============================================="
