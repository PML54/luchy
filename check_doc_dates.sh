#!/bin/bash

echo "🔍 ANALYSE DES FICHIERS AVEC DOC CURSOR NON À JOUR"
echo "=================================================="
echo ""

find lib/ -name "*.dart" -type f -mtime -3 | while read file; do
    # Obtenir la date de modification du fichier
    file_date=$(stat -f "%Sm" -t "%Y-%m-%d" "$file")
    
    # Obtenir la date dans la doc cursor
    doc_date=$(grep "📅 Dernière modification:" "$file" | sed 's/.*: //' | sed 's/.*modification: //' | head -1)
    
    if [ -n "$doc_date" ]; then
        # Extraire juste la date (sans l'heure)
        doc_date_clean=$(echo "$doc_date" | cut -d' ' -f1)
        
        # Comparer les dates
        if [[ "$doc_date_clean" < "$file_date" ]] || [[ "$doc_date_clean" == "2025-"* ]]; then
            echo "❌ $file"
            echo "   📁 Modifié le: $file_date"
            echo "   📝 Doc indique: $doc_date_clean"
            echo ""
        fi
    else
        echo "⚠️  $file"
        echo "   📝 PAS DE DOC CURSOR"
        echo ""
    fi
done

echo "=================================================="
echo "✅ Analyse terminée"
