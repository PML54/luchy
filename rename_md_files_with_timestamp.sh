#!/bin/bash

# Script de renommage des fichiers .md avec suffixe de date/heure
# Projet Luchy - Documentation avec traçabilité temporelle

echo "🔄 Renommage des fichiers .md avec suffixe de date/heure..."

# Fonction pour obtenir la date de modification d'un fichier
get_file_modification_date() {
    local file="$1"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        stat -f "%Sm" -t "%Y%m%d_%H%M" "$file"
    else
        # Linux
        date -r "$file" "+%Y%m%d_%H%M"
    fi
}

# Fonction pour renommer un fichier
rename_file_with_timestamp() {
    local file="$1"
    local dir=$(dirname "$file")
    local basename=$(basename "$file" .md)
    local timestamp=$(get_file_modification_date "$file")
    local new_name="${basename}_${timestamp}.md"
    local new_path="$dir/$new_name"
    
    if [ "$file" != "$new_path" ]; then
        echo "📝 Renommage: $file → $new_name"
        mv "$file" "$new_path"
    else
        echo "✅ Déjà à jour: $file"
    fi
}

# Traiter tous les fichiers .md (sauf ceux dans ios/ qui sont générés)
echo "📁 Recherche des fichiers .md..."
find . -name "*.md" -type f ! -path "./ios/*" | while read -r file; do
    rename_file_with_timestamp "$file"
done

echo ""
echo "✅ Renommage terminé !"
echo "📊 Résumé des fichiers .md avec suffixe de date/heure :"
echo ""

# Afficher la liste des fichiers renommés
find . -name "*_*.md" -type f ! -path "./ios/*" | sort | while read -r file; do
    local basename=$(basename "$file")
    local timestamp=$(echo "$basename" | grep -o '[0-9]\{8\}_[0-9]\{4\}')
    echo "📄 $file (modifié: $timestamp)"
done

echo ""
echo "🎯 Format du suffixe: YYYYMMDD_HHMM"
echo "📅 Exemple: FICHIERS_DART_HABILETES_MATHS_20250923_1957.md"
