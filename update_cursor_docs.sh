#!/bin/bash

echo "🔄 MISE À JOUR AUTOMATIQUE DES DOCS CURSOR"
echo "=========================================="
echo ""

# Date actuelle formatée
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M")

echo "📅 Date actuelle: $CURRENT_DATE"
echo ""

# Fonction pour mettre à jour la doc cursor d'un fichier
update_cursor_doc() {
    local file="$1"
    local current_date="$2"
    
    echo "📝 Mise à jour: $file"
    
    # Vérifier si le fichier a une doc cursor
    if grep -q "📅 Dernière modification:" "$file"; then
        # Sauvegarder l'ancienne date
        local old_date=$(grep "📅 Dernière modification:" "$file" | sed 's/.*: //' | sed 's/.*modification: //' | head -1)
        
        # Mettre à jour la date
        sed -i.bak "s/📅 Dernière modification:.*/📅 Dernière modification: $current_date/" "$file"
        
        echo "   ✅ Date mise à jour: $old_date → $current_date"
        
        # Ajouter une entrée dans l'historique récent si elle existe
        if grep -q "HISTORIQUE RÉCENT:" "$file"; then
            # Trouver la ligne après HISTORIQUE RÉCENT
            local hist_line=$(grep -n "HISTORIQUE RÉCENT:" "$file" | cut -d: -f1)
            if [ -n "$hist_line" ]; then
                local next_line=$((hist_line + 1))
                # Insérer une nouvelle ligne d'historique
                sed -i.bak "${next_line}i\\/// - Mise à jour documentation et date ($current_date)" "$file"
                echo "   📖 Historique mis à jour"
            fi
        fi
        
    else
        echo "   ⚠️  Pas de doc cursor trouvée"
    fi
    echo ""
}

# Traiter tous les fichiers modifiés récemment (sauf .freezed.dart et autres générés)
find lib/ -name "*.dart" -type f -mtime -3 | grep -v ".freezed.dart" | grep -v "app_localizations" | while read file; do
    update_cursor_doc "$file" "$CURRENT_DATE"
done

echo "=========================================="
echo "✅ MISE À JOUR TERMINÉE"
echo ""
echo "📋 Récapitulatif:"
echo "   - Date mise à jour: $CURRENT_DATE"
echo "   - Fichiers traités: $(find lib/ -name "*.dart" -type f -mtime -3 | grep -v ".freezed.dart" | grep -v "app_localizations" | wc -l)"
echo "   - Fichiers générés ignorés: .freezed.dart, app_localizations"
echo ""
