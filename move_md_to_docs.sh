#!/bin/bash

# Script de déplacement des fichiers .md vers le dossier docs/
# Projet Luchy - Organisation centralisée de la documentation

echo "📁 Déplacement des fichiers .md vers le dossier docs/..."

# Créer le dossier docs/ s'il n'existe pas
mkdir -p docs/

# Compter les fichiers .md à déplacer
md_files_count=$(find . -maxdepth 1 -name "*.md" -type f | wc -l)
echo "📊 $md_files_count fichiers .md trouvés dans le répertoire racine"

# Déplacer tous les fichiers .md du répertoire racine vers docs/
echo "🔄 Déplacement en cours..."
moved_count=0

find . -maxdepth 1 -name "*.md" -type f | while read -r file; do
    filename=$(basename "$file")
    echo "📝 Déplacement: $filename → docs/$filename"
    mv "$file" "docs/$filename"
    ((moved_count++))
done

echo ""
echo "✅ Déplacement terminé !"
echo "📊 Résumé des fichiers déplacés :"
echo ""

# Afficher la liste des fichiers dans docs/
echo "📁 Contenu du dossier docs/ :"
ls -la docs/*.md | while read -r line; do
    filename=$(echo "$line" | awk '{print $NF}' | xargs basename)
    size=$(echo "$line" | awk '{print $5}')
    date=$(echo "$line" | awk '{print $6, $7, $8}')
    echo "📄 $filename ($size bytes, $date)"
done

echo ""
echo "🎯 Organisation centralisée de la documentation terminée !"
echo "📚 Tous les fichiers .md sont maintenant dans docs/"
