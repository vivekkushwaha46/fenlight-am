import os

target_dir = '/Users/imvivek/work/fenlight-am/packages/plugin.video.fenlight'
old_id = 'plugin.video.fenlight'
new_id = 'plugin.video.fenlight.am'

extensions = ('.py', '.xml', '.txt', '.md')

for root, _, files in os.walk(target_dir):
	for f in files:
		if f.endswith(extensions):
			path = os.path.join(root, f)
			with open(path, 'r', encoding='utf-8', errors='ignore') as file:
				content = file.read()
			if old_id in content:
				print(f"Replacing in {path}")
				content = content.replace(old_id, new_id)
				with open(path, 'w', encoding='utf-8') as file:
					file.write(content)

addon_xml = os.path.join(target_dir, 'addon.xml')
if os.path.exists(addon_xml):
	with open(addon_xml, 'r', encoding='utf-8') as file:
		content = file.read()
	content = content.replace('name="FenLightAM"', 'name="FenLight AM"')
	content = content.replace('version="2.1.90"', 'version="2.1.91"')
	with open(addon_xml, 'w', encoding='utf-8') as file:
		file.write(content)
	print("Updated addon.xml metadata")
