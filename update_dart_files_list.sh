#!/bin/bash

# Script de mise à jour de la liste des fichiers Dart
# Projet Luchy - Génération automatique

echo "🔄 Mise à jour de la liste des fichiers Dart..."

# Variables
OUTPUT_FILE="dart_files_list.txt"
TEMP_FILE="dart_files_temp.txt"
DATE=$(date +"%Y-%m-%d")

# Recherche de tous les fichiers .dart
echo "📁 Recherche des fichiers .dart..."
find lib/ test/ -name "*.dart" -type f | sort > "$TEMP_FILE"

# Comptage
TOTAL_FILES=$(wc -l < "$TEMP_FILE")

# Génération du fichier de sortie
cat > "$OUTPUT_FILE" << EOF
# LISTE DES FICHIERS DART - PROJET LUCHY
# Généré automatiquement le $DATE
# Total: $TOTAL_FILES fichiers
#
# Pour mettre à jour cette liste:
# ./update_dart_files_list.sh

## FICHIERS PRINCIPAUX
EOF

# Fichier main
grep "^lib/main.dart$" "$TEMP_FILE" >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## CONFIGURATION" >> "$OUTPUT_FILE"
grep "^lib/app/config/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## CORE - BASE DE DONNÉES" >> "$OUTPUT_FILE"
grep "^lib/core/database/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## CORE - CONSTANTES" >> "$OUTPUT_FILE"
grep "^lib/core/constants/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## CORE - FORMULES" >> "$OUTPUT_FILE"
grep "^lib/core/formulas/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## CORE - OPÉRATIONS" >> "$OUTPUT_FILE"
grep "^lib/core/operations/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## CORE - UTILITAIRES" >> "$OUTPUT_FILE"
grep "^lib/core/utils/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## CORE - WIDGETS" >> "$OUTPUT_FILE"
grep "^lib/core/widgets/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## FEATURES - COMMON" >> "$OUTPUT_FILE"
grep "^lib/features/common/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## FEATURES - PUZZLE DOMAIN" >> "$OUTPUT_FILE"
grep "^lib/features/puzzle/domain/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## FEATURES - PUZZLE PRESENTATION - CONTROLLERS" >> "$OUTPUT_FILE"
grep "^lib/features/puzzle/presentation/controllers/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## FEATURES - PUZZLE PRESENTATION - SCREENS" >> "$OUTPUT_FILE"
grep "^lib/features/puzzle/presentation/screens/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## FEATURES - PUZZLE PRESENTATION - WIDGETS" >> "$OUTPUT_FILE"
grep "^lib/features/puzzle/presentation/widgets/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## LOCALISATION" >> "$OUTPUT_FILE"
grep "^lib/l10n/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "## TESTS" >> "$OUTPUT_FILE"
grep "^test/" "$TEMP_FILE" | sort >> "$OUTPUT_FILE"

# Nettoyage
rm "$TEMP_FILE"

echo "✅ Liste mise à jour dans $OUTPUT_FILE"
echo "📊 Total: $TOTAL_FILES fichiers Dart trouvés"

# Optionnel: afficher un résumé par catégorie
echo ""
echo "📋 Résumé par catégorie:"
echo "   • Configuration: $(grep -c "^lib/app/config/" "$OUTPUT_FILE") fichiers"
echo "   • Core Database: $(grep -c "^lib/core/database/" "$OUTPUT_FILE") fichiers" 
echo "   • Core Operations: $(grep -c "^lib/core/operations/" "$OUTPUT_FILE") fichiers"
echo "   • Core Utils: $(grep -c "^lib/core/utils/" "$OUTPUT_FILE") fichiers"
echo "   • Features Common: $(grep -c "^lib/features/common/" "$OUTPUT_FILE") fichiers"
echo "   • Features Puzzle: $(grep -c "^lib/features/puzzle/" "$OUTPUT_FILE") fichiers"
echo "   • Localisation: $(grep -c "^lib/l10n/" "$OUTPUT_FILE") fichiers"
echo "   • Tests: $(grep -c "^test/" "$OUTPUT_FILE") fichiers"

