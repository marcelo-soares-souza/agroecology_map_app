// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Agroecology Map';

  @override
  String get locations => 'Locations';

  @override
  String get practices => 'Practices';

  @override
  String get accounts => 'Accounts';

  @override
  String get about => 'About';

  @override
  String get chat => 'Chat';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get map => 'Map';

  @override
  String get language => 'Language';

  @override
  String get searchLocation => 'Search Location...';

  @override
  String get searchPractice => 'Search Practice...';

  @override
  String get searchAccount => 'Search Account...';

  @override
  String get searchGalleryByLocation => 'Search by location...';

  @override
  String get incorrectEmailOrPassword => 'Incorrect e-mail or password.';

  @override
  String somethingWrong(String message) {
    return 'Something is wrong $message';
  }

  @override
  String get passwordRecoveryNotImplemented =>
      'Password recovery not implemented';

  @override
  String get emailRequired => 'E-mail is required';

  @override
  String get passwordMinLength =>
      'Password must be at least 6 characters long.';

  @override
  String get minLength4 => 'Must be at least 4 characters long.';

  @override
  String get yourName => 'Your Name';

  @override
  String get privacyPolicyLink => 'Read our Privacy Policy';

  @override
  String get deleteThisLocation => 'Delete this Location';

  @override
  String get deleteThisPractice => 'Delete this Practice';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get ok => 'OK';

  @override
  String get description => 'Description';

  @override
  String get country => 'Country';

  @override
  String get farmAndFarmingSystem => 'Farm and Farming System';

  @override
  String get whatDoYouHave => 'What do you have on your farm?';

  @override
  String get farmingSystemDetails => 'Details of the farming system';

  @override
  String get whatIsYourDream => 'What is your dream?';

  @override
  String get likes => 'Likes';

  @override
  String get likeThisLocation => 'Like this location';

  @override
  String get youAlreadyLiked => 'You already liked this location';

  @override
  String get loginRequiredToLike => 'Please log in to like this location.';

  @override
  String get likeActionFailed =>
      'Unable to update like. Please try again later.';

  @override
  String get location => 'Location';

  @override
  String get responsibleForInfo => 'Responsible for Information';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidity => 'Humidity';

  @override
  String get soilMoisture => 'Soil moisture';

  @override
  String get ndviValue => 'NDVI value';

  @override
  String get cloudCover => 'Cloud cover';

  @override
  String get updatedAt => 'Updated at';

  @override
  String get home => 'Home';

  @override
  String get gallery => 'Gallery';

  @override
  String get ndvi => 'NDVI';

  @override
  String get sensors => 'Sensors';

  @override
  String get summary => 'Summary';

  @override
  String get characterise => 'Characterise';

  @override
  String get ndviTimeline => 'NDVI timeline';

  @override
  String get noImagesAvailable => 'No images available';

  @override
  String get galleryLocationUnavailable =>
      'Location information not available for this media';

  @override
  String get noDataAvailable => 'No data available for this section.';

  @override
  String get noNdviData => 'No NDVI data available yet';

  @override
  String get pleaseLoginToChat => 'Please login to start a conversation';

  @override
  String get cannotChatWithYourself =>
      'You cannot start a conversation with yourself';

  @override
  String get failedToStartConversation => 'Failed to start conversation';

  @override
  String get website => 'Website';

  @override
  String get medias => 'Medias';

  @override
  String get startConversation => 'Start conversation';

  @override
  String get aboutContent =>
      'Agroecology Map is an open source, citizen science and open data platform that since 2017 has been maintained by a group of volunteers who work to strengthen and create new collaboration networks that improve sharing knowledge about Agroecology.';

  @override
  String get learnMoreAboutUs => 'Learn more about us';

  @override
  String get startConversationDialog => 'Start Conversation';

  @override
  String get recipientAccountId => 'Recipient account ID';

  @override
  String get create => 'Create';

  @override
  String get pleaseLoginToUseChat => 'Please login to use chat';

  @override
  String get startChat => 'Start chat';

  @override
  String get typeAMessage => 'Type a message';

  @override
  String get failedToSendMessage => 'Failed to send message';

  @override
  String get deleteMyAccount => 'Delete my account';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirmation =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get error => 'Error';

  @override
  String get failedToDeleteAccount =>
      'Failed to delete account. Please try again later.';

  @override
  String get accountSuccessfullyDeleted => 'Account successfully deleted';

  @override
  String get checkingSession => 'Checking session...';

  @override
  String get addNewLocation => 'Add a new Location';

  @override
  String get needLoginToAdd => 'You need to login to add a new record';

  @override
  String get locationName => 'Location Name';

  @override
  String get isItAFarm => 'Is it a farm?';

  @override
  String get mainPurpose => 'What\'s the main purpose?';

  @override
  String get photo => 'Photo';

  @override
  String get locationNameHint =>
      'How would you like to name the place where you practice agroecology?';

  @override
  String get dreamHint =>
      'Do you have a dream of transforming your farm and/or location?';

  @override
  String get descriptionHint =>
      'Tell us a bit about your place, what you do in the place you register';

  @override
  String get locationServicesDisabled =>
      'Location services are disabled. Please enable the services';

  @override
  String get locationPermissionsDenied => 'Location permissions are denied';

  @override
  String get locationPermissionsPermanentlyDenied =>
      'Location permissions are permanently denied, we cannot request permissions.';

  @override
  String get save => 'Save';

  @override
  String get mainlyHomeConsumption => 'Mainly home consumption';

  @override
  String get editLocation => 'Edit Location';

  @override
  String get needLoginToEdit => 'You need to login to edit a record';

  @override
  String get addNewPractice => 'Add a new Practice';

  @override
  String get needAtLeastOneLocation => 'You need to add at least one location';

  @override
  String get practiceName => 'Practice Name';

  @override
  String get practiceNameHint =>
      'Name this practice (e.g. my agroforestry, permaculture experiment, etc.).';

  @override
  String get locationRemoved => 'Location removed';

  @override
  String get practiceRemoved => 'Practice Removed';

  @override
  String get pickAPhoto => 'Pick a Photo';

  @override
  String get photoGallery => 'Photo Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get needLoginToAddPhoto => 'You need to login to add a new photo';

  @override
  String errorOccurred(String message) {
    return 'An error occured: $message';
  }

  @override
  String get noItems => 'No items';

  @override
  String get errorTryAgain => 'An error has occurred, please try again.';

  @override
  String lengthBetween(int min, int max) {
    return 'Must be between $min and $max characters long.';
  }

  @override
  String get noneOfAbove => 'None of above';

  @override
  String get agroecologyPrinciplesInvoked => 'Agroecology principles invoked?';

  @override
  String get foodSystemComponents => 'Food system components addressed?';

  @override
  String get locationAdded => 'Location added';

  @override
  String get errorOccurredLoginAgain =>
      'An error occurred. Please login again.';

  @override
  String get locationUpdated => 'Location Updated';

  @override
  String get mediaAdded => 'Media added';

  @override
  String get mediaRemoved => 'Media removed';

  @override
  String get genericError => 'Generic Error. Please try again.';

  @override
  String get practiceAdded => 'Practice added';

  @override
  String get characteriseUpdated => 'Characterise Updated';

  @override
  String get accountCreated => 'Account created';

  @override
  String get summaryDescription => 'Summary Description';

  @override
  String get whereIsRealized => 'Where it is realized?';

  @override
  String get agroecologyPrinciplesAddressed =>
      'Agroecology principles addressed';

  @override
  String get foodSystemComponentsAddressed =>
      'Food system components addressed';

  @override
  String get filters => 'Filters';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get all => 'All';

  @override
  String get farmFunctions => 'Farm Functions';

  @override
  String get mixedHomeConsumptionAndCommercial =>
      'Mixed home consumption and commercial';

  @override
  String get mainlyCommercial => 'Mainly commercial';

  @override
  String get other => 'Other';

  @override
  String get iAmNotSure => 'I am not sure';

  @override
  String get farmComponents => 'Farm Components';

  @override
  String get crops => 'Crops';

  @override
  String get animals => 'Animals';

  @override
  String get trees => 'Trees';

  @override
  String get fish => 'Fish';

  @override
  String get systemComponent => 'System Component';

  @override
  String get soil => 'Soil';

  @override
  String get water => 'Water';

  @override
  String get livestock => 'Livestock';

  @override
  String get pests => 'Pests';

  @override
  String get energy => 'Energy';

  @override
  String get household => 'Household';

  @override
  String get workers => 'Workers';

  @override
  String get community => 'Community';

  @override
  String get valueChain => 'Value chain';

  @override
  String get policy => 'Policy';

  @override
  String get wholeFoodSystem => 'Whole food system';

  @override
  String get agroecologyPrinciple => 'Agroecology principle';

  @override
  String get recycling => 'Recycling';

  @override
  String get inputReduction => 'Input reduction';

  @override
  String get soilHealth => 'Soil health';

  @override
  String get animalHealth => 'Animal health';

  @override
  String get biodiversity => 'Biodiversity';

  @override
  String get synergy => 'Synergy';

  @override
  String get economicDiversification => 'Economic diversification';

  @override
  String get coCreationOfKnowledge => 'Co-creation of knowledge';

  @override
  String get socialValuesAndDiets => 'Social values and diets';

  @override
  String get fairness => 'Fairness';

  @override
  String get connectivity => 'Connectivity';

  @override
  String get landAndNaturalResourceGovernance =>
      'Land and natural resource governance';

  @override
  String get participation => 'Participation';

  @override
  String get continent => 'Continent';

  @override
  String get africa => 'Africa';

  @override
  String get asia => 'Asia';

  @override
  String get europe => 'Europe';

  @override
  String get northAmerica => 'North America';

  @override
  String get southAmerica => 'South America';

  @override
  String get australia => 'Australia/Oceania';

  @override
  String get antarctica => 'Antarctica';

  @override
  String get failedToLoadLocation => 'Failed to load location details';

  @override
  String get noLocationsRegistered => 'No locations registered yet';
}
