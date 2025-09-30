#!/bin/bash

# Script d'optimisation de toutes les images PNG, JPG, JPEG dans assets/
# Objectif : réduire toutes les images sous 500KB

echo "🚀 Optimisation de toutes les images dans assets/"
echo "=================================================="

# Créer un dossier de sauvegarde
BACKUP_DIR="assets_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Compter les images
TOTAL_IMAGES=$(find assets/ -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) | wc -l)
echo "📊 Total d'images à optimiser: $TOTAL_IMAGES"
echo ""

# Fonction d'optimisation
optimize_image() {
    local file="$1"
    local filename=$(basename "$file")
    local extension="${filename##*.}"
    local name="${filename%.*}"
    
    echo "🖼️  Optimisation: $filename"
    
    # Sauvegarder l'original
    cp "$file" "$BACKUP_DIR/"
    
    # Obtenir la taille originale
    original_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    original_size_kb=$((original_size / 1024))
    
    # Optimiser selon le type
    if [[ "$extension" =~ ^(png|PNG)$ ]]; then
        # PNG -> JPG avec compression
        magick "$file" -quality 85 -strip "assets/${name}.jpg"
        rm "$file"  # Supprimer l'original PNG
        optimized_file="assets/${name}.jpg"
    else
        # JPG/JPEG -> compression plus agressive
        magick "$file" -quality 80 -strip -resize "1024x1024>" "$file"
        optimized_file="$file"
    fi
    
    # Vérifier la taille finale
    final_size=$(stat -f%z "$optimized_file" 2>/dev/null || stat -c%s "$optimized_file" 2>/dev/null)
    final_size_kb=$((final_size / 1024))
    
    # Afficher le résultat
    if [ $final_size_kb -lt 500 ]; then
        echo "  ✅ $filename: ${original_size_kb}KB → ${final_size_kb}KB"
    else
        echo "  ⚠️  $filename: ${original_size_kb}KB → ${final_size_kb}KB (toujours > 500KB)"
        # Essayer une compression plus agressive
        magick "$optimized_file" -quality 70 -strip -resize "800x800>" "$optimized_file"
        final_size=$(stat -f%z "$optimized_file" 2>/dev/null || stat -c%s "$optimized_file" 2>/dev/null)
        final_size_kb=$((final_size / 1024))
        echo "  🔄 Compression agressive: ${final_size_kb}KB"
    fi
}

# Optimiser toutes les images
counter=0
find assets/ -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) | while read -r file; do
    counter=$((counter + 1))
    echo "[$counter/$TOTAL_IMAGES]"
    optimize_image "$file"
    echo ""
done

echo "🎉 Optimisation terminée !"
echo "📁 Sauvegarde des originaux dans: $BACKUP_DIR"
echo ""
echo "📊 Résumé des images optimisées:"
find assets/ -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) | while read -r file; do
    size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    size_kb=$((size / 1024))
    echo "  $(basename "$file"): ${size_kb}KB"
done

