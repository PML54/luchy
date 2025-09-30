#!/bin/bash

# Script pour générer un PDF à partir du fichier Markdown
# Génère la documentation du système Habileté Maths en PDF

echo "🔄 Génération du PDF de documentation..."

# Vérifier si pandoc est installé
if ! command -v pandoc &> /dev/null; then
    echo "❌ Pandoc n'est pas installé."
    echo "📥 Installation avec Homebrew..."
    
    # Vérifier si Homebrew est installé
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew n'est pas installé."
        echo "🔧 Veuillez installer Homebrew d'abord: https://brew.sh"
        exit 1
    fi
    
    # Installer pandoc
    brew install pandoc
    
    if [ $? -ne 0 ]; then
        echo "❌ Échec de l'installation de pandoc"
        exit 1
    fi
fi

# Vérifier si basicTeX/MacTeX est installé pour la conversion PDF
if ! command -v pdflatex &> /dev/null; then
    echo "❌ pdflatex n'est pas installé."
    echo "📥 Installation de BasicTeX..."
    brew install --cask basictex
    
    if [ $? -ne 0 ]; then
        echo "❌ Échec de l'installation de BasicTeX"
        echo "💡 Vous pouvez aussi installer MacTeX: https://tug.org/mactex/"
        exit 1
    fi
    
    # Ajouter au PATH
    export PATH="/usr/local/texlive/2023/bin/universal-darwin:$PATH"
    echo "🔧 BasicTeX installé. Vous devrez peut-être redémarrer votre terminal."
fi

# Fichier source et destination
SOURCE_FILE="docs/SCHEMA_HABILETE_MATHS.md"
OUTPUT_FILE="docs/SCHEMA_HABILETE_MATHS.pdf"

# Vérifier que le fichier source existe
if [ ! -f "$SOURCE_FILE" ]; then
    echo "❌ Fichier source non trouvé: $SOURCE_FILE"
    exit 1
fi

echo "📄 Conversion de $SOURCE_FILE vers $OUTPUT_FILE..."

# Générer le PDF avec pandoc
pandoc "$SOURCE_FILE" \
    -o "$OUTPUT_FILE" \
    --pdf-engine=pdflatex \
    --variable geometry:margin=2cm \
    --variable fontsize=11pt \
    --variable colorlinks=true \
    --variable linkcolor=blue \
    --variable urlcolor=blue \
    --variable citecolor=blue \
    --toc \
    --toc-depth=3 \
    --number-sections \
    --highlight-style=github \
    --variable mainfont="SF Pro Display" \
    --variable monofont="SF Mono" \
    2>/dev/null

# Vérifier le succès de la conversion
if [ $? -eq 0 ] && [ -f "$OUTPUT_FILE" ]; then
    echo "✅ PDF généré avec succès: $OUTPUT_FILE"
    echo "📖 Ouverture du PDF..."
    open "$OUTPUT_FILE"
else
    echo "❌ Échec de la génération du PDF"
    echo "🔧 Tentative avec une configuration simplifiée..."
    
    # Tentative avec configuration simplifiée
    pandoc "$SOURCE_FILE" \
        -o "$OUTPUT_FILE" \
        --pdf-engine=pdflatex \
        --variable geometry:margin=2cm \
        --toc \
        --number-sections
    
    if [ $? -eq 0 ] && [ -f "$OUTPUT_FILE" ]; then
        echo "✅ PDF généré avec succès (version simplifiée): $OUTPUT_FILE"
        echo "📖 Ouverture du PDF..."
        open "$OUTPUT_FILE"
    else
        echo "❌ Échec de la génération du PDF même avec configuration simplifiée"
        echo "💡 Alternative: Vous pouvez utiliser un convertisseur en ligne ou imprimer le fichier Markdown en PDF depuis un éditeur"
        exit 1
    fi
fi

echo "🎉 Documentation PDF générée !"


