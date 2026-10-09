#!/usr/bin/env python3
"""
Generate or update miyoogamelist.xml for INSTEAD quests on Miyoo Mini / OnionOS.
Reads title metadata ($Name: / $Name(ru):) from .zip and .idf files in Roms/INSTEAD.
Outputs clean UTF-8 XML recognized by Onion MainUI.
"""

import os
import sys
import re
import zipfile
import xml.etree.ElementTree as ET
from xml.dom import minidom

def extract_title_from_text(content):
    # Match $Name(ru):Title or $Name:Title
    match_ru = re.search(r'--\s*\$Name\(ru\)\s*:\s*([^\$\r\n]+)', content, re.IGNORECASE)
    if match_ru:
        return match_ru.group(1).strip()
    match = re.search(r'--\s*\$Name\s*:\s*([^\$\r\n]+)', content, re.IGNORECASE)
    if match:
        return match.group(1).strip()
    return None

def extract_meta_from_zip(zip_path):
    try:
        with zipfile.ZipFile(zip_path, 'r') as z:
            for name in z.namelist():
                if name.endswith(('main.lua', 'main3.lua')):
                    try:
                        content = z.read(name).decode('utf-8', errors='ignore')
                        title = extract_title_from_text(content)
                        if title:
                            return title
                    except Exception:
                        pass
    except Exception as e:
        sys.stderr.write(f"Error reading {zip_path}: {e}\n")
    return None

def extract_meta_from_idf(idf_path):
    try:
        with open(idf_path, 'rb') as f:
            data = f.read(65536).decode('utf-8', errors='ignore')
            return extract_title_from_text(data)
    except Exception:
        pass
    return None

def generate_gamelist(roms_dir):
    xml_path = os.path.join(roms_dir, "miyoogamelist.xml")
    imgs_dir = os.path.join(roms_dir, "Imgs")
    os.makedirs(imgs_dir, exist_ok=True)

    root = ET.Element("gameList")

    for fname in sorted(os.listdir(roms_dir)):
        if not fname.lower().endswith(('.zip', '.idf')):
            continue
        
        full_path = os.path.join(roms_dir, fname)
        base_name, ext = os.path.splitext(fname)

        title = None
        if ext.lower() == '.zip':
            title = extract_meta_from_zip(full_path)
        elif ext.lower() == '.idf':
            title = extract_meta_from_idf(full_path)

        if not title:
            title = base_name

        game_elem = ET.SubElement(root, "game")
        path_elem = ET.SubElement(game_elem, "path")
        path_elem.text = f"./{fname}"

        name_elem = ET.SubElement(game_elem, "name")
        name_elem.text = title

        # Check for matching boxart image
        img_rel = None
        for img_ext in ('.png', '.jpg', '.jpeg'):
            candidate = os.path.join(imgs_dir, f"{base_name}{img_ext}")
            if os.path.isfile(candidate):
                img_rel = f"./Imgs/{base_name}{img_ext}"
                break
        if not img_rel:
            img_rel = f"./Imgs/{base_name}.png"

        image_elem = ET.SubElement(game_elem, "image")
        image_elem.text = img_rel

    # Pretty print XML with UTF-8 declaration
    xml_bytes = ET.tostring(root, encoding='utf-8')
    dom = minidom.parseString(xml_bytes)
    pretty_xml = dom.toprettyxml(indent="  ", encoding="utf-8")

    with open(xml_path, 'wb') as f:
        f.write(pretty_xml)
    print(f"Generated {xml_path} successfully.")

if __name__ == '__main__':
    target_dir = sys.argv[1] if len(sys.argv) > 1 else "."
    generate_gamelist(target_dir)
