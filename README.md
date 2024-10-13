# Application Mobile "Objets Trouvés" - SNCF

## 1. Présentation de l'Application

### Objectif
Cette application mobile permet aux voyageurs de consulter la liste des objets trouvés dans les trains de la SNCF. Elle utilise l'API officielle des objets trouvés de la SNCF, permettant aux utilisateurs de filtrer les objets en fonction de divers critères, comme la gare d'origine ou la catégorie d'objet.

### Fonctionnalités
- **Filtrage des objets** : Les utilisateurs peuvent filtrer les objets trouvés en fonction de la gare d'origine, de leur catégorie (Téléphone portable, Sac à dos, etc.), et de leur date de découverte.
- **Consultation des objets récents** : L'application permet de voir les objets trouvés depuis la dernière consultation de l'utilisateur.
- **Design soigné et adaptatif** : Une interface utilisateur intuitive et responsive, adaptée à différents appareils mobiles pour une meilleure expérience.

## 2. Fonctionnalités Techniques

### Gestion de l'état
- **Provider** est utilisé pour gérer les états de l'application, en particulier :
    - `FoundObjectsProvider` : Gère la logique de récupération des objets trouvés via l'API de la SNCF, ainsi que les filtres appliqués par l'utilisateur (gare, catégorie).
    - `GareProvider` : Gère les données liées aux gares, telles que la liste des gares disponibles et la sélection de celles-ci par l'utilisateur.

### API SNCF
- **API des Objets Trouvés** : L'application interagit avec l'API proposée par la SNCF, permettant de récupérer en temps réel les objets trouvés dans les trains. [Lien vers l'API](https://data.sncf.com/explore/dataset/objets-trouves-restitution/api/).
- **Récupération des objets récents** : Lors de chaque connexion, l'application affiche les objets trouvés depuis la dernière visite de l'utilisateur.

### Filtrage des résultats
- **Par gare** : Les utilisateurs peuvent filtrer les objets trouvés en fonction de la gare d'origine (par exemple : Paris Gare de Lyon, Bordeaux).
- **Par catégorie** : Filtrage selon la nature de l'objet (Téléphones, Vêtements, Bagages, etc.).
- **Objets récents** : Affichage des objets trouvés depuis la dernière consultation de l'utilisateur, facilitant la recherche d'objets perdus récents.

### Interface Utilisateur
- **Recherche** : L'interface inclut une barre de recherche qui permet à l'utilisateur de taper le nom d'une gare et de la sélectionner pour filtrer les objets trouvés.
- **Design adaptatif** : L'interface a été pensée pour s'adapter aux différentes tailles d'écran, garantissant une expérience utilisateur fluide sur smartphones et tablettes.

## 3. Architecture du Projet

- **Gestion de l'état** : L'application utilise `Provider` pour gérer efficacement les données et les interactions des utilisateurs.
- **API REST** : Les appels à l'API SNCF sont effectués via des requêtes HTTP, et les données sont traitées pour être affichées sous forme de liste filtrée.
- **SharedPreferences** : Utilisé pour sauvegarder les informations liées à la dernière connexion de l'utilisateur, permettant d'afficher les objets trouvés récemment.

### Structure du Code
- `main.dart` : Point d'entrée de l'application, qui initialise les différents Providers.
- `FoundObjectsProvider` : Gère les données des objets trouvés, les filtres et la récupération des données depuis l'API.
- `GareProvider` : Gère la liste des gares et la sélection multiple pour les filtres.
- `MySearchBar` : Composant pour la recherche et la sélection des gares.
- `FoundObjectItem` : Widget pour afficher un objet trouvé sous forme de carte.
- `CategoryObjectsScreen` : Écran qui affiche les objets filtrés par catégorie.

## 4. Prochaines étapes

### Améliorations Techniques
- **Sauvegarde des favoris** : Permettre aux utilisateurs de marquer des objets comme favoris pour les retrouver facilement.
- **Notifications push** : Intégration de notifications push pour alerter les utilisateurs quand un objet est trouvé dans une gare spécifique.
- **Amélioration de la performance des appels API** : Optimiser la gestion de la pagination et réduire le nombre d'appels réseau nécessaires.

### Améliorations de l'Expérience Utilisateur
- **Optimisation du design** : Améliorer l'interface graphique avec des animations plus fluides et des transitions douces.

## Conclusion

Cette application propose une solution pratique pour les voyageurs de la SNCF en facilitant la recherche et la consultation des objets trouvés dans les trains. Avec un design soigné et des fonctionnalités basées sur l'API des objets trouvés, l'application offre une base solide pour l'amélioration et l'ajout de nouvelles fonctionnalités, comme la sauvegarde des favoris et les notifications push.

