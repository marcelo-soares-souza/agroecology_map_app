// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Carte d\'Agroécologie';

  @override
  String get locations => 'Lieux';

  @override
  String get practices => 'Pratiques';

  @override
  String get accounts => 'Comptes';

  @override
  String get about => 'À propos';

  @override
  String get chat => 'Conversations';

  @override
  String get login => 'Se connecter';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get map => 'Carte';

  @override
  String get language => 'Langue';

  @override
  String get searchLocation => 'Rechercher un Lieu...';

  @override
  String get searchPractice => 'Rechercher une Pratique...';

  @override
  String get searchAccount => 'Rechercher un Compte...';

  @override
  String get searchGalleryByLocation => 'Rechercher par lieu...';

  @override
  String get incorrectEmailOrPassword => 'E-mail ou mot de passe incorrect.';

  @override
  String somethingWrong(String message) {
    return 'Quelque chose s\'est mal passé $message';
  }

  @override
  String get passwordRecoveryNotImplemented =>
      'Récupération de mot de passe non implémentée';

  @override
  String get emailRequired => 'L\'e-mail est obligatoire';

  @override
  String get passwordMinLength =>
      'Le mot de passe doit contenir au moins 6 caractères.';

  @override
  String get minLength4 => 'Doit contenir au moins 4 caractères.';

  @override
  String get yourName => 'Votre Nom';

  @override
  String get privacyPolicyLink => 'Lire notre Politique de Confidentialité';

  @override
  String get deleteThisLocation => 'Supprimer ce Lieu';

  @override
  String get deleteThisPractice => 'Supprimer cette Pratique';

  @override
  String get areYouSure => 'Êtes-vous sûr?';

  @override
  String get no => 'Non';

  @override
  String get yes => 'Oui';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get ok => 'OK';

  @override
  String get description => 'Description';

  @override
  String get country => 'Pays';

  @override
  String get farmAndFarmingSystem => 'Ferme et Système de Production';

  @override
  String get whatDoYouHave => 'Qu\'avez-vous sur votre ferme?';

  @override
  String get farmingSystemDetails => 'Détails du système de production';

  @override
  String get whatIsYourDream => 'Quel est votre rêve?';

  @override
  String get likes => 'Mentions J\'aime';

  @override
  String get likeThisLocation => 'Aimer cet emplacement';

  @override
  String get youAlreadyLiked => 'Vous avez déjà aimé cet emplacement';

  @override
  String get loginRequiredToLike =>
      'Connectez-vous pour aimer cet emplacement.';

  @override
  String get likeActionFailed =>
      'Impossible de mettre à jour la mention J\'aime. Veuillez réessayer plus tard.';

  @override
  String get location => 'Emplacement';

  @override
  String get responsibleForInfo => 'Responsable de l\'Information';

  @override
  String get temperature => 'Température';

  @override
  String get humidity => 'Humidité';

  @override
  String get soilMoisture => 'Humidité du sol';

  @override
  String get ndviValue => 'Valeur NDVI';

  @override
  String get cloudCover => 'Couverture nuageuse';

  @override
  String get updatedAt => 'Mis à jour le';

  @override
  String get home => 'Accueil';

  @override
  String get gallery => 'Galerie';

  @override
  String get ndvi => 'NDVI';

  @override
  String get sensors => 'Capteurs';

  @override
  String get summary => 'Résumé';

  @override
  String get characterise => 'Caractériser';

  @override
  String get ndviTimeline => 'Chronologie NDVI';

  @override
  String get noImagesAvailable => 'Aucune image disponible';

  @override
  String get galleryLocationUnavailable =>
      'Informations de localisation non disponibles pour ce média';

  @override
  String get noDataAvailable => 'Aucune donnée disponible pour cette section.';

  @override
  String get noNdviData => 'Aucune donnée NDVI pour le moment';

  @override
  String get pleaseLoginToChat =>
      'Veuillez vous connecter pour démarrer une conversation';

  @override
  String get cannotChatWithYourself =>
      'Vous ne pouvez pas démarrer une conversation avec vous-même';

  @override
  String get failedToStartConversation =>
      'Échec du démarrage de la conversation';

  @override
  String get website => 'Site web';

  @override
  String get medias => 'Médias';

  @override
  String get startConversation => 'Démarrer une conversation';

  @override
  String get aboutContent =>
      'Carte d\'Agroécologie est une plateforme open source, de science citoyenne et de données ouvertes qui depuis 2017 est maintenue par un groupe de bénévoles qui travaillent à renforcer et créer de nouveaux réseaux de collaboration qui améliorent le partage des connaissances sur l\'Agroécologie.';

  @override
  String get learnMoreAboutUs => 'En savoir plus sur nous';

  @override
  String get startConversationDialog => 'Démarrer une Conversation';

  @override
  String get recipientAccountId => 'ID du compte destinataire';

  @override
  String get create => 'Créer';

  @override
  String get pleaseLoginToUseChat =>
      'Veuillez vous connecter pour utiliser le chat';

  @override
  String get startChat => 'Démarrer le chat';

  @override
  String get typeAMessage => 'Tapez un message';

  @override
  String get failedToSendMessage => 'Échec de l\'envoi du message';

  @override
  String get deleteMyAccount => 'Supprimer mon compte';

  @override
  String get deleteAccount => 'Supprimer le Compte';

  @override
  String get deleteAccountConfirmation =>
      'Êtes-vous sûr de vouloir supprimer votre compte? Cette action ne peut pas être annulée.';

  @override
  String get error => 'Erreur';

  @override
  String get failedToDeleteAccount =>
      'Échec de la suppression du compte. Veuillez réessayer plus tard.';

  @override
  String get accountSuccessfullyDeleted => 'Compte supprimé avec succès';

  @override
  String get checkingSession => 'Vérification de la session...';

  @override
  String get addNewLocation => 'Ajouter un nouveau Lieu';

  @override
  String get needLoginToAdd =>
      'Vous devez vous connecter pour ajouter un nouveau enregistrement';

  @override
  String get locationName => 'Nom du Lieu';

  @override
  String get isItAFarm => 'Est-ce une ferme?';

  @override
  String get mainPurpose => 'Quel est l\'objectif principal?';

  @override
  String get photo => 'Photo';

  @override
  String get locationNameHint =>
      'Comment aimeriez-vous nommer l\'endroit où vous pratiquez l\'agroécologie?';

  @override
  String get dreamHint =>
      'Avez-vous un rêve de transformer votre ferme et/ou lieu?';

  @override
  String get descriptionHint =>
      'Parlez-nous un peu de votre lieu, ce que vous faites à l\'endroit que vous enregistrez';

  @override
  String get locationServicesDisabled =>
      'Les services de localisation sont désactivés. Veuillez activer les services';

  @override
  String get locationPermissionsDenied =>
      'Les autorisations de localisation sont refusées';

  @override
  String get locationPermissionsPermanentlyDenied =>
      'Les autorisations de localisation sont refusées définitivement, nous ne pouvons pas demander d\'autorisations.';

  @override
  String get save => 'Enregistrer';

  @override
  String get mainlyHomeConsumption => 'Principalement Consommation Domestique';

  @override
  String get editLocation => 'Modifier le Lieu';

  @override
  String get needLoginToEdit =>
      'Vous devez vous connecter pour modifier un enregistrement';

  @override
  String get addNewPractice => 'Ajouter une nouvelle Pratique';

  @override
  String get needAtLeastOneLocation => 'Vous devez ajouter au moins un lieu';

  @override
  String get practiceName => 'Nom de la Pratique';

  @override
  String get practiceNameHint =>
      'Nommez cette pratique (ex: mon agroforesterie, expérience de permaculture, etc.).';

  @override
  String get locationRemoved => 'Lieu supprimé';

  @override
  String get practiceRemoved => 'Pratique supprimée';

  @override
  String get pickAPhoto => 'Choisir une Photo';

  @override
  String get photoGallery => 'Galerie de Photos';

  @override
  String get camera => 'Appareil photo';

  @override
  String get needLoginToAddPhoto =>
      'Vous devez vous connecter pour ajouter une nouvelle photo';

  @override
  String errorOccurred(String message) {
    return 'Une erreur s\'est produite: $message';
  }

  @override
  String get noItems => 'Aucun élément';

  @override
  String get errorTryAgain => 'Une erreur s\'est produite, veuillez réessayer.';

  @override
  String lengthBetween(int min, int max) {
    return 'Doit contenir entre $min et $max caractères.';
  }

  @override
  String get noneOfAbove => 'Aucune des options ci-dessus';

  @override
  String get agroecologyPrinciplesInvoked =>
      'Principes agroécologiques invoqués?';

  @override
  String get foodSystemComponents =>
      'Composants du système alimentaire abordés?';

  @override
  String get locationAdded => 'Lieu ajouté';

  @override
  String get errorOccurredLoginAgain =>
      'Une erreur s\'est produite. Veuillez vous reconnecter.';

  @override
  String get locationUpdated => 'Lieu mis à jour';

  @override
  String get mediaAdded => 'Média ajouté';

  @override
  String get mediaRemoved => 'Média supprimé';

  @override
  String get genericError => 'Erreur générique. Veuillez réessayer.';

  @override
  String get practiceAdded => 'Pratique ajoutée';

  @override
  String get characteriseUpdated => 'Caractérisation mise à jour';

  @override
  String get accountCreated => 'Compte créé';

  @override
  String get summaryDescription => 'Description Résumée';

  @override
  String get whereIsRealized => 'Où est-il réalisé?';

  @override
  String get agroecologyPrinciplesAddressed =>
      'Principes d\'agroécologie abordés';

  @override
  String get foodSystemComponentsAddressed =>
      'Composantes du système alimentaire abordées';

  @override
  String get filters => 'Filtres';

  @override
  String get applyFilters => 'Appliquer les Filtres';

  @override
  String get clearFilters => 'Effacer les Filtres';

  @override
  String get all => 'Tous';

  @override
  String get farmFunctions => 'Fonctions de la Ferme';

  @override
  String get mixedHomeConsumptionAndCommercial =>
      'Consommation domestique mixte et commerciale';

  @override
  String get mainlyCommercial => 'Principalement commercial';

  @override
  String get other => 'Autre';

  @override
  String get iAmNotSure => 'Je ne suis pas sûr';

  @override
  String get farmComponents => 'Composants de la Ferme';

  @override
  String get crops => 'Cultures';

  @override
  String get animals => 'Animaux';

  @override
  String get trees => 'Arbres';

  @override
  String get fish => 'Poissons';

  @override
  String get systemComponent => 'Composante du système';

  @override
  String get soil => 'Sol';

  @override
  String get water => 'Eau';

  @override
  String get livestock => 'Bétail';

  @override
  String get pests => 'Ravageurs';

  @override
  String get energy => 'Énergie';

  @override
  String get household => 'Ménage';

  @override
  String get workers => 'Travailleurs';

  @override
  String get community => 'Communauté';

  @override
  String get valueChain => 'Chaîne de valeur';

  @override
  String get policy => 'Politique';

  @override
  String get wholeFoodSystem => 'Système alimentaire complet';

  @override
  String get agroecologyPrinciple => 'Principe d\'agroécologie';

  @override
  String get recycling => 'Recyclage';

  @override
  String get inputReduction => 'Réduction des intrants';

  @override
  String get soilHealth => 'Santé des sols';

  @override
  String get animalHealth => 'Santé animale';

  @override
  String get biodiversity => 'Biodiversité';

  @override
  String get synergy => 'Synergie';

  @override
  String get economicDiversification => 'Diversification économique';

  @override
  String get coCreationOfKnowledge => 'Co-création de connaissances';

  @override
  String get socialValuesAndDiets => 'Valeurs sociales et régimes alimentaires';

  @override
  String get fairness => 'Équité';

  @override
  String get connectivity => 'Connectivité';

  @override
  String get landAndNaturalResourceGovernance =>
      'Gouvernance des terres et des ressources naturelles';

  @override
  String get participation => 'Participation';

  @override
  String get continent => 'Continent';

  @override
  String get africa => 'Afrique';

  @override
  String get asia => 'Asie';

  @override
  String get europe => 'Europe';

  @override
  String get northAmerica => 'Amérique du Nord';

  @override
  String get southAmerica => 'Amérique du Sud';

  @override
  String get australia => 'Australie/Océanie';

  @override
  String get antarctica => 'Antarctique';

  @override
  String get failedToLoadLocation =>
      'Échec du chargement des détails de l\'emplacement';

  @override
  String get noLocationsRegistered =>
      'Aucune localisation enregistrée pour le moment.';
}
