#!/bin/bash

# Script d'optimisation des nouvelles images sous 500KB

echo "🖼️  Optimisation des nouvelles images sous 500KB..."

# Fonction pour optimiser une image avec magick
optimize_image() {
    local file="$1"
    local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    
    if [ "$size" -gt 512000 ]; then  # 500KB = 512000 bytes
        echo "📉 Optimisation de $file ($(($size/1024))KB)"
        
        # Créer une copie temporaire
        cp "$file" "$file.backup"
        
        # Essayer différentes stratégies d'optimisation
        local success=false
        
        # Stratégie 1: Réduction de qualité pour JPG
        if [[ "$file" == *.jpg ]] || [[ "$file" == *.jpeg ]]; then
            for quality in 60 50 40 35 30; do
                magick "$file" -quality $quality -strip "$file.tmp" 2>/dev/null
                if [ $? -eq 0 ]; then
                    local new_size=$(stat -f%z "$file.tmp" 2>/dev/null || stat -c%s "$file.tmp" 2>/dev/null)
                    if [ "$new_size" -lt 512000 ]; then
                        mv "$file.tmp" "$file"
                        echo "✅ $file optimisé (JPG): $(($size/1024))KB → $(($new_size/1024))KB (qualité: $quality)"
                        success=true
                        break
                    fi
                fi
            done
        fi
        
        # Stratégie 2: Réduction des dimensions si toujours trop gros
        if [ "$success" = false ]; then
            for scale in 80 70 60 50; do
                magick "$file" -resize ${scale}% -quality 60 -strip "$file.tmp" 2>/dev/null
                if [ $? -eq 0 ]; then
                    local new_size=$(stat -f%z "$file.tmp" 2>/dev/null || stat -c%s "$file.tmp" 2>/dev/null)
                    if [ "$new_size" -lt 512000 ]; then
                        mv "$file.tmp" "$file"
                        echo "✅ $file redimensionné: $(($size/1024))KB → $(($new_size/1024))KB (${scale}%)"
                        success=true
                        break
                    fi
                fi
            done
        fi
        
        # Si toujours trop gros, restaurer la sauvegarde
        if [ "$success" = false ]; then
            mv "$file.backup" "$file"
            echo "⚠️  $file: impossible d'optimiser sous 500KB"
        else
            rm -f "$file.backup"
        fi
        
        rm -f "$file.tmp"
    else
        echo "✅ $file déjà optimisé ($(($size/1024))KB)"
    fi
}

# Optimiser les nouvelles images problématiques (avec espaces dans les noms)
new_files=(
    "assets/eva - 1.jpeg"
    "assets/clemchat - 1.jpeg"
    "assets/2cv - 1.jpeg"
)

for file in "${new_files[@]}"; do
    if [ -f "$file" ]; then
        optimize_image "$file"
    else
        echo "⚠️  Fichier non trouvé: $file"
    fi
done

echo ""
echo "📊 Vérification finale des nouvelles images:"
echo "============================================="
for file in "${new_files[@]}"; do
    if [ -f "$file" ]; then
        local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
        if [ "$size" -gt 512000 ]; then
            echo "❌ $(($size/1024))KB $file"
        else
            echo "✅ $(($size/1024))KB $file"
        fi
    fi
done

echo ""
echo "🎉 Optimisation des nouvelles images terminée!"


