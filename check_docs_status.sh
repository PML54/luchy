#!/bin/bash

echo "�� ÉTAT DE LA DOCUMENTATION CURSOR"
echo "=================================="
echo ""

# Statistiques générales
total_files=$(find lib/ -name "*.dart" -type f | grep -v ".freezed.dart" | grep -v "app_localizations" | wc -l)
docs_files=$(find lib/ -name "*.dart" -type f | grep -v ".freezed.dart" | grep -v "app_localizations" | xargs grep -l "<cursor>" | wc -l)
coverage=$((docs_files * 100 / total_files))

echo "📈 STATISTIQUES GÉNÉRALES:"
echo "   • Fichiers Dart totaux: $total_files"
echo "   • Fichiers avec doc cursor: $docs_files"
echo "   • Couverture documentation: ${coverage}%"
echo ""

# Vérifier la fraîcheur des docs
echo "🔍 FRAÎCHEUR DES DOCS:"
echo ""

outdated_count=0
fresh_count=0

find lib/ -name "*.dart" -type f | grep -v ".freezed.dart" | grep -v "app_localizations" | while read file; do
    if grep -q "<cursor>" "$file" && grep -q "📅 Dernière modification:" "$file"; then
        doc_date=$(grep "📅 Dernière modification:" "$file" | sed 's/.*: //' | sed 's/.*modification: //' | head -1 | cut -d' ' -f1)
        today=$(date +"%Y-%m-%d")
        
        if [[ "$doc_date" == "$today" ]]; then
            echo "✅ $(basename "$file") - À jour"
            fresh_count=$((fresh_count + 1))
        elif [[ "$doc_date" > "$today" ]]; then
            echo "🤔 $(basename "$file") - Date future ($doc_date)"
        else
            # Vérification simple: si la date est différente d'aujourd'hui
            echo "⚠️  $(basename "$file") - Pas à jour ($doc_date)"
            # Pour une analyse plus précise, utiliser git log
        fi
    fi
done

echo ""
echo "📋 RÉSUMÉ:"
echo "   • Docs à jour aujourd'hui: $fresh_count"
echo "   • Docs obsolètes (>7 jours): $outdated_count"
echo ""

if [ $outdated_count -gt 0 ]; then
    echo "🔧 RECOMMANDATIONS:"
    echo "   • Exécuter: ./update_docs_after_edit.sh --all"
    echo "   • Vérifier les fichiers avec ❌"
    echo ""
fi

echo "=================================="
echo "✅ Analyse terminée"
