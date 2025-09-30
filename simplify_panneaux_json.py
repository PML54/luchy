#!/usr/bin/env python3
import json

# Lire le fichier JSON original
with open('assets/panneaux/panneaux_manifest_enrichi.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Créer une version simplifiée avec seulement les champs essentiels
simplified_data = []
for item in data:
    simplified_item = {
        "id": item.get("id", ""),
        "nom": item.get("nom", ""),
        "type": item.get("type", ""),
        "image": item.get("image", ""),
        "description": item.get("description", ""),
        "category": item.get("category", "")
    }
    simplified_data.append(simplified_item)

# Sauvegarder le fichier simplifié
with open('assets/panneaux/panneaux_manifest_simplified.json', 'w', encoding='utf-8') as f:
    json.dump(simplified_data, f, ensure_ascii=False, indent=2)

print(f"✅ JSON simplifié créé avec {len(simplified_data)} panneaux")
print("📊 Taille originale vs simplifiée:")
