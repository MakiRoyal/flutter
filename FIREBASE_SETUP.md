# Configuration Firebase pour GameVault

## Étapes pour activer l'authentification réelle

### 1. Créer un projet Firebase

1. Allez sur https://console.firebase.google.com/
2. Cliquez sur "Ajouter un projet"
3. Nom du projet : **GameVault Shop** (ou votre choix)
4. Acceptez les conditions et cliquez sur "Continuer"
5. Désactivez Google Analytics si vous le souhaitez
6. Cliquez sur "Créer le projet"

### 2. Activer l'authentification Email/Password

1. Dans votre projet Firebase, allez dans **Authentication** (menu de gauche)
2. Cliquez sur "Commencer"
3. Dans l'onglet **Sign-in method**, cliquez sur **Email/Password**
4. Activez **Email/Password** (premier switch)
5. Cliquez sur "Enregistrer"

### 3. Ajouter votre application Web

1. Dans les paramètres du projet (icône engrenage ⚙️), allez dans "Paramètres du projet"
2. En bas, cliquez sur l'icône **</>** (Web)
3. Donnez un surnom : **GameVault Web**
4. Cochez "Configurer également Firebase Hosting"
5. Cliquez sur "Enregistrer l'application"
6. Firebase vous donnera un objet de configuration - **COPIEZ-LE**

### 4. Configurer automatiquement avec FlutterFire CLI

Après avoir créé le projet sur la console, revenez dans le terminal et lancez :

```bash
cd /Users/mikaramanantsoa/coursFlutter/projectflutter
flutterfire configure
```

Sélectionnez votre projet dans la liste et les plateformes que vous voulez (web, ios, android, macos).

Cela va créer automatiquement le fichier `lib/firebase_options.dart`.

### 5. Relancer l'application

```bash
flutter run -d chrome
```

L'authentification fonctionnera maintenant avec de vrais comptes Firebase ! 🎮

## Alternative : Configuration manuelle

Si FlutterFire CLI ne fonctionne pas, je peux créer manuellement le fichier `firebase_options.dart` avec votre configuration Firebase.

Il vous suffit de me fournir la configuration Firebase (l'objet JavaScript avec apiKey, authDomain, etc.).
