import os
import re
import hashlib
import zipfile
import shutil

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
PACKAGES_DIR = os.path.join(ROOT_DIR, 'packages')
ADDON_ID = 'plugin.video.fenlight'
ADDON_DIR = os.path.join(PACKAGES_DIR, ADDON_ID)

def build_addon():
	# Read addon.xml to get version
	addon_xml_path = os.path.join(ADDON_DIR, 'addon.xml')
	if not os.path.exists(addon_xml_path):
		print(f"Error: {addon_xml_path} not found.")
		return
	with open(addon_xml_path, 'r', encoding='utf-8') as f:
		addon_xml = f.read()

	version_match = re.search(r'version="([^"]+)"', addon_xml)
	if not version_match:
		print("Error: Could not find version in addon.xml")
		return

	version = version_match.group(1)
	print(f"Building {ADDON_ID} version {version}")

	# Create Zip File
	zip_path = os.path.join(PACKAGES_DIR, f"{ADDON_ID}-{version}.zip")
	print(f"Archiving addon to {zip_path}...")
	with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
		for root, dirs, files in os.walk(ADDON_DIR):
			for file in files:
				if file == '.DS_Store' or file.endswith('.pyc') or '__pycache__' in root:
					continue
				file_path = os.path.join(root, file)
				arcname = os.path.relpath(file_path, PACKAGES_DIR)
				zipf.write(file_path, arcname)
	print(f"Successfully Created: {zip_path}")

	# Create addons.xml
	print("Generating addons.xml...")
	addons_xml = '<?xml version="1.0" encoding="UTF-8"?>\n<addons>\n'
	addons_xml += addon_xml
	addons_xml += '\n</addons>\n'

	addons_xml_path = os.path.join(ROOT_DIR, 'addons.xml')
	with open(addons_xml_path, 'w', encoding='utf-8') as f:
		f.write(addons_xml)
	print(f"Successfully Created: {addons_xml_path}")

	# Create addons.xml.md5
	md5 = hashlib.md5(addons_xml.encode('utf-8')).hexdigest()
	addons_xml_md5_path = os.path.join(ROOT_DIR, 'addons.xml.md5')
	with open(addons_xml_md5_path, 'w', encoding='utf-8') as f:
		f.write(md5)
	print(f"Successfully Created: {addons_xml_md5_path}")
	print("\nBuild complete! GitHub deploy commands:")
	print("------------------------------------------")
	print("git add .")
	print(f'git commit -m "Optimize FenLight to version {version} for Android TV"')
	print("git push origin main")
	print("------------------------------------------")

if __name__ == '__main__':
	build_addon()
