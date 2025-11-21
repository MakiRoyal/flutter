# ShopFlutter - E-commerce MVP

Application e-commerce Flutter avec architecture Clean/MVVM, authentification Firebase, et déploiement Web.

## 🎯 Fonctionnalités

### ✅ Implémenté

- **Authentification** (Firebase Auth)
  - Connexion / Inscription par email/password
  - Gestion des sessions
  - Déconnexion

- **Catalogue produits**
  - Liste des produits (API Fake Store)
  - Recherche et filtres par catégorie
  - Détail produit avec images

- **Panier**
  - Ajout/suppression de produits
  - Modification des quantités
  - Calcul automatique du total

- **Checkout & Commandes**
  - Processus de paiement simplifié (mock)
  - Création de commandes
  - Historique des commandes (persistance locale)

- **Navigation**
  - go_router avec guards d'authentification
  - Routes protégées

## 🏗️ Architecture

### Clean Architecture + MVVM

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/
│   └── repositories/      # Implémentations
├── domain/
│   ├── entities/          # Modèles métier
│   ├── repositories/      # Interfaces
│   └── usecases/          # Logique métier
└── presentation/
    ├── pages/             # Écrans UI
    ├── viewmodels/        # State management
    ├── widgets/           # Composants réutilisables
    └── router/            # Navigation
```

## 📦 Dépendances principales

- `go_router` - Navigation
- `provider` - State management
- `firebase_core` & `firebase_auth` - Authentification
- `http` - Appels API
- `shared_preferences` - Stockage local
- `cached_network_image` - Cache d'images
- `equatable` - Comparaison d'objets
- `mockito` - Tests (mocks)

## 🚀 Installation

### 1. Installer les dépendances

```bash
flutter pub get
```

### 2. Configuration Firebase (Optionnel mais recommandé)

**Option A : Firebase configuré**

1. Créer un projet Firebase sur https://console.firebase.google.com
2. Activer Firebase Authentication (Email/Password)
3. Télécharger les fichiers de configuration
4. Pour le Web : `flutterfire configure`

**Option B : Mode démo (sans Firebase)**

L'app fonctionnera en mode démo si Firebase n'est pas configuré.

### 3. Générer les mocks pour les tests

```bash
flutter pub run build_runner build
```

## 🧪 Tests

### Exécuter tous les tests

```bash
flutter test
```

### Tests avec couverture

```bash
flutter test --coverage
```

### Tests inclus

- **5 tests unitaires** : Use cases + ViewModels
- **2 tests widget** : ProductCard + Cart

## 🌐 Lancer l'application

### Web

```bash
flutter run -d chrome
```

### Mobile

```bash
flutter run
```

## 📁 API utilisée

**Fake Store API** : https://fakestoreapi.com

## 🐛 Dépannage

### Erreur Firebase

Si vous voyez `Firebase initialization failed`, l'app fonctionne en mode démo.

### Tests échouent

Générez les mocks :
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📄 Licence

MIT


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
