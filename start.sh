#!/bin/bash

# ShopFlutter - Script de démarrage rapide

echo "🚀 ShopFlutter - Démarrage..."
echo ""

# Vérifier si Flutter est installé
if ! command -v flutter &> /dev/null
then
    echo "❌ Flutter n'est pas installé"
    exit 1
fi

echo "✅ Flutter détecté"
echo ""

# Installer les dépendances
echo "📦 Installation des dépendances..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'installation des dépendances"
    exit 1
fi

echo "✅ Dépendances installées"
echo ""

# Générer les mocks pour les tests
echo "🔧 Génération des mocks..."
flutter pub run build_runner build --delete-conflicting-outputs

if [ $? -ne 0 ]; then
    echo "⚠️  Erreur lors de la génération des mocks (non bloquant)"
fi

echo ""

# Demander la plateforme
echo "Sur quelle plateforme voulez-vous lancer l'application ?"
echo "1) Web (Chrome)"
echo "2) Android"
echo "3) iOS"
echo "4) Exécuter les tests"
echo ""
read -p "Choix (1-4): " choice

case $choice in
    1)
        echo ""
        echo "🌐 Lancement sur Web..."
        flutter run -d chrome
        ;;
    2)
        echo ""
        echo "📱 Lancement sur Android..."
        flutter run -d android
        ;;
    3)
        echo ""
        echo "📱 Lancement sur iOS..."
        flutter run -d ios
        ;;
    4)
        echo ""
        echo "🧪 Exécution des tests..."
        flutter test
        echo ""
        echo "✅ Tests terminés"
        ;;
    *)
        echo "❌ Choix invalide"
        exit 1
        ;;
esac
