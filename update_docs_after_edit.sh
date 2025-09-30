#!/bin/bash

echo "🔄 MISE À JOUR DOCS APRÈS MODIFICATION"
echo "====================================="
echo ""

# Vérifier si des fichiers sont passés en argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <fichier1.dart> [fichier2.dart] ..."
    echo "Ou: $0 --all  (pour tous les fichiers modifiés récemment)"
    exit 1
fi

# Date actuelle
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M")

# Fonction de mise à jour d'un fichier
update_file_docs() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo "❌ Fichier non trouvé: $file"
        return 1
    fi
    
    echo "📝 Traitement: $file"
    
    # Vérifier si le fichier a une doc cursor
    if ! grep -q "<cursor>" "$file"; then
        echo "   ⚠️  Pas de doc cursor trouvée"
        return 0
    fi
    
    # Sauvegarder l'ancienne date
    local old_date=""
    if grep -q "📅 Dernière modification:" "$file"; then
        old_date=$(grep "📅 Dernière modification:" "$file" | sed 's/.*: //' | sed 's/.*modification: //' | head -1)
    fi
    
    # Mettre à jour la date
    if [ -n "$old_date" ]; then
        sed -i.bak "s/📅 Dernière modification:.*/📅 Dernière modification: $CURRENT_DATE/" "$file"
        echo "   ✅ Date mise à jour: $old_date → $CURRENT_DATE"
    else
        # Ajouter la ligne de date si elle n'existe pas
        sed -i.bak '/<\/cursor>/i\
/// 📅 Dernière modification: '"$CURRENT_DATE" "$file"
        echo "   ➕ Date ajoutée: $CURRENT_DATE"
    fi
    
    # Demander si on veut mettre à jour l'historique
    echo "   💬 Voulez-vous ajouter une note à l'historique ? (y/N)"
    read -r -n 1 response
    echo ""
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "   📝 Entrez la note d'historique:"
        read -r history_note
        
        if [ -n "$history_note" ]; then
            # Trouver la ligne HISTORIQUE RÉCENT
            local hist_line=$(grep -n "HISTORIQUE RÉCENT:" "$file" | cut -d: -f1)
            if [ -n "$hist_line" ]; then
                local next_line=$((hist_line + 1))
                sed -i.bak "${next_line}i\\/// - $history_note ($CURRENT_DATE)" "$file"
                echo "   📖 Historique mis à jour"
            fi
        fi
    fi
    
    # Nettoyer les backups
    rm -f "$file.bak"
    
    echo "   ✅ $file mis à jour"
    echo ""
}

# Mode --all : traiter tous les fichiers modifiés récemment
if [ "$1" = "--all" ]; then
    echo "🔍 Recherche des fichiers modifiés récemment..."
    find lib/ -name "*.dart" -type f -mtime -1 | grep -v ".freezed.dart" | grep -v "app_localizations" | while read file; do
        update_file_docs "$file"
    done
else
    # Traiter les fichiers passés en argument
    for file in "$@"; do
        update_file_docs "$file"
    done
fi

echo "====================================="
echo "✅ MISE À JOUR TERMINÉE"
echo "📅 Date appliquée: $CURRENT_DATE"
