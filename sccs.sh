#!/bin/bash # Création des répertoires dirs=(
   "lib/app" "lib/core" "lib/features/common/domain/models" "lib/features/common/domain/providers" 
   "lib/features/puzzle" "lib/features/settings" "lib/infrastructure" "lib/shared/widgets" "lib/tools"
) for dir in "${dirs[@]}"; do
   mkdir -p "$dir" echo "Créé: $dir" done # Déplacement des fichiers if [ -f 
"lib/domain/models/device_config.dart" ]; then
   mv lib/domain/models/device_config.dart lib/features/common/domain/models/ mv 
   lib/domain/models/device_config.freezed.dart lib/features/common/domain/models/ echo "Fichiers device_config 
   déplacés"
fi # Nettoyage si dossiers vides rmdir lib/domain/models lib/domain 2>/dev/null
echo "Migration terminée"
