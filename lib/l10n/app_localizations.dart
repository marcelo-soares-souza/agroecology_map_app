import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Agroecology Map'**
  String get appTitle;

  /// Navigation menu item for locations
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locations;

  /// Navigation menu item for practices
  ///
  /// In en, this message translates to:
  /// **'Practices'**
  String get practices;

  /// Navigation menu item for accounts
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// Navigation menu item for about page
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Navigation menu item for chat
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Login button/menu item
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Logout button/menu item
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Navigation menu item for map
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// Language selector menu item
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Search hint for locations
  ///
  /// In en, this message translates to:
  /// **'Search Location...'**
  String get searchLocation;

  /// Search hint for practices
  ///
  /// In en, this message translates to:
  /// **'Search Practice...'**
  String get searchPractice;

  /// Search hint for accounts
  ///
  /// In en, this message translates to:
  /// **'Search Account...'**
  String get searchAccount;

  /// Search hint for gallery filtered by location
  ///
  /// In en, this message translates to:
  /// **'Search by location...'**
  String get searchGalleryByLocation;

  /// Login error message
  ///
  /// In en, this message translates to:
  /// **'Incorrect e-mail or password.'**
  String get incorrectEmailOrPassword;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something is wrong {message}'**
  String somethingWrong(String message);

  /// Password recovery message
  ///
  /// In en, this message translates to:
  /// **'Password recovery not implemented'**
  String get passwordRecoveryNotImplemented;

  /// Email validation message
  ///
  /// In en, this message translates to:
  /// **'E-mail is required'**
  String get emailRequired;

  /// Password validation message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long.'**
  String get passwordMinLength;

  /// Generic validation message
  ///
  /// In en, this message translates to:
  /// **'Must be at least 4 characters long.'**
  String get minLength4;

  /// Display name field label
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// Link to privacy policy
  ///
  /// In en, this message translates to:
  /// **'Read our Privacy Policy'**
  String get privacyPolicyLink;

  /// Delete location dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete this Location'**
  String get deleteThisLocation;

  /// Delete practice dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete this Practice'**
  String get deleteThisPractice;

  /// Confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// Negative button in dialogs and dropdowns
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Positive button in dialogs and dropdowns
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button/action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Country field label
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Section title for farm information
  ///
  /// In en, this message translates to:
  /// **'Farm and Farming System'**
  String get farmAndFarmingSystem;

  /// Farm contents field label
  ///
  /// In en, this message translates to:
  /// **'What do you have on your farm?'**
  String get whatDoYouHave;

  /// Farming system details label
  ///
  /// In en, this message translates to:
  /// **'Details of the farming system'**
  String get farmingSystemDetails;

  /// Dream field label
  ///
  /// In en, this message translates to:
  /// **'What is your dream?'**
  String get whatIsYourDream;

  /// Label for the number of likes a location has received
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// Tooltip for liking a location that the user has not yet liked
  ///
  /// In en, this message translates to:
  /// **'Like this location'**
  String get likeThisLocation;

  /// Tooltip for a location the user already liked
  ///
  /// In en, this message translates to:
  /// **'You already liked this location'**
  String get youAlreadyLiked;

  /// Message shown when the user must log in before liking
  ///
  /// In en, this message translates to:
  /// **'Please log in to like this location.'**
  String get loginRequiredToLike;

  /// Generic error when the like request fails
  ///
  /// In en, this message translates to:
  /// **'Unable to update like. Please try again later.'**
  String get likeActionFailed;

  /// Location field label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Responsible person label
  ///
  /// In en, this message translates to:
  /// **'Responsible for Information'**
  String get responsibleForInfo;

  /// Temperature sensor label
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// Humidity sensor label
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// Soil moisture sensor label
  ///
  /// In en, this message translates to:
  /// **'Soil moisture'**
  String get soilMoisture;

  /// NDVI value label
  ///
  /// In en, this message translates to:
  /// **'NDVI value'**
  String get ndviValue;

  /// Cloud cover label
  ///
  /// In en, this message translates to:
  /// **'Cloud cover'**
  String get cloudCover;

  /// Last update timestamp label
  ///
  /// In en, this message translates to:
  /// **'Updated at'**
  String get updatedAt;

  /// Home navigation item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Gallery navigation item
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// NDVI navigation item
  ///
  /// In en, this message translates to:
  /// **'NDVI'**
  String get ndvi;

  /// Sensors navigation item
  ///
  /// In en, this message translates to:
  /// **'Sensors'**
  String get sensors;

  /// Summary section title
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// Characterise section title
  ///
  /// In en, this message translates to:
  /// **'Characterise'**
  String get characterise;

  /// NDVI timeline section title
  ///
  /// In en, this message translates to:
  /// **'NDVI timeline'**
  String get ndviTimeline;

  /// Empty state message for gallery
  ///
  /// In en, this message translates to:
  /// **'No images available'**
  String get noImagesAvailable;

  /// Snack bar message when a gallery item does not include a location
  ///
  /// In en, this message translates to:
  /// **'Location information not available for this media'**
  String get galleryLocationUnavailable;

  /// Empty state message for sections
  ///
  /// In en, this message translates to:
  /// **'No data available for this section.'**
  String get noDataAvailable;

  /// Empty state when NDVI timeline is empty
  ///
  /// In en, this message translates to:
  /// **'No NDVI data available yet'**
  String get noNdviData;

  /// Login required message for chat
  ///
  /// In en, this message translates to:
  /// **'Please login to start a conversation'**
  String get pleaseLoginToChat;

  /// Error message when trying to chat with self
  ///
  /// In en, this message translates to:
  /// **'You cannot start a conversation with yourself'**
  String get cannotChatWithYourself;

  /// Error message for conversation creation
  ///
  /// In en, this message translates to:
  /// **'Failed to start conversation'**
  String get failedToStartConversation;

  /// Website field label
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// Media counter label
  ///
  /// In en, this message translates to:
  /// **'Medias'**
  String get medias;

  /// Button to start a conversation
  ///
  /// In en, this message translates to:
  /// **'Start conversation'**
  String get startConversation;

  /// About page content text
  ///
  /// In en, this message translates to:
  /// **'Agroecology Map is an open source, citizen science and open data platform that since 2017 has been maintained by a group of volunteers who work to strengthen and create new collaboration networks that improve sharing knowledge about Agroecology.'**
  String get aboutContent;

  /// Link to learn more
  ///
  /// In en, this message translates to:
  /// **'Learn more about us'**
  String get learnMoreAboutUs;

  /// Start conversation dialog title
  ///
  /// In en, this message translates to:
  /// **'Start Conversation'**
  String get startConversationDialog;

  /// Recipient ID input hint
  ///
  /// In en, this message translates to:
  /// **'Recipient account ID'**
  String get recipientAccountId;

  /// Create button
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Login required for chat feature
  ///
  /// In en, this message translates to:
  /// **'Please login to use chat'**
  String get pleaseLoginToUseChat;

  /// Tooltip for start chat button
  ///
  /// In en, this message translates to:
  /// **'Start chat'**
  String get startChat;

  /// Chat input placeholder
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get typeAMessage;

  /// Error message when message fails to send
  ///
  /// In en, this message translates to:
  /// **'Failed to send message'**
  String get failedToSendMessage;

  /// Delete account button
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteMyAccount;

  /// Delete account dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Delete account confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountConfirmation;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Delete account error message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again later.'**
  String get failedToDeleteAccount;

  /// Success message for account deletion
  ///
  /// In en, this message translates to:
  /// **'Account successfully deleted'**
  String get accountSuccessfullyDeleted;

  /// Loading message while checking auth session
  ///
  /// In en, this message translates to:
  /// **'Checking session...'**
  String get checkingSession;

  /// Title for add location screen
  ///
  /// In en, this message translates to:
  /// **'Add a new Location'**
  String get addNewLocation;

  /// Login required message for adding records
  ///
  /// In en, this message translates to:
  /// **'You need to login to add a new record'**
  String get needLoginToAdd;

  /// Location name field label
  ///
  /// In en, this message translates to:
  /// **'Location Name'**
  String get locationName;

  /// Farm question field label
  ///
  /// In en, this message translates to:
  /// **'Is it a farm?'**
  String get isItAFarm;

  /// Main purpose field label
  ///
  /// In en, this message translates to:
  /// **'What\'s the main purpose?'**
  String get mainPurpose;

  /// Photo field label
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// Hint text for location name input
  ///
  /// In en, this message translates to:
  /// **'How would you like to name the place where you practice agroecology?'**
  String get locationNameHint;

  /// Hint text for dream input
  ///
  /// In en, this message translates to:
  /// **'Do you have a dream of transforming your farm and/or location?'**
  String get dreamHint;

  /// Hint text for description input
  ///
  /// In en, this message translates to:
  /// **'Tell us a bit about your place, what you do in the place you register'**
  String get descriptionHint;

  /// Error when location services are disabled
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Please enable the services'**
  String get locationServicesDisabled;

  /// Error when location permissions are denied
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied'**
  String get locationPermissionsDenied;

  /// Error when location permissions are permanently denied
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied, we cannot request permissions.'**
  String get locationPermissionsPermanentlyDenied;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Farm function option
  ///
  /// In en, this message translates to:
  /// **'Mainly home consumption'**
  String get mainlyHomeConsumption;

  /// Title for edit location screen
  ///
  /// In en, this message translates to:
  /// **'Edit Location'**
  String get editLocation;

  /// Login required message for editing records
  ///
  /// In en, this message translates to:
  /// **'You need to login to edit a record'**
  String get needLoginToEdit;

  /// Title for add practice screen
  ///
  /// In en, this message translates to:
  /// **'Add a new Practice'**
  String get addNewPractice;

  /// Error when trying to add practice without locations
  ///
  /// In en, this message translates to:
  /// **'You need to add at least one location'**
  String get needAtLeastOneLocation;

  /// Practice name field label
  ///
  /// In en, this message translates to:
  /// **'Practice Name'**
  String get practiceName;

  /// Hint text for practice name input
  ///
  /// In en, this message translates to:
  /// **'Name this practice (e.g. my agroforestry, permaculture experiment, etc.).'**
  String get practiceNameHint;

  /// Snackbar message when location is deleted
  ///
  /// In en, this message translates to:
  /// **'Location removed'**
  String get locationRemoved;

  /// Snackbar message when practice is deleted
  ///
  /// In en, this message translates to:
  /// **'Practice Removed'**
  String get practiceRemoved;

  /// Button to pick a photo
  ///
  /// In en, this message translates to:
  /// **'Pick a Photo'**
  String get pickAPhoto;

  /// Option to pick from gallery
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get photoGallery;

  /// Option to take photo with camera
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Login required message for adding photos
  ///
  /// In en, this message translates to:
  /// **'You need to login to add a new photo'**
  String get needLoginToAddPhoto;

  /// Generic error with message
  ///
  /// In en, this message translates to:
  /// **'An error occured: {message}'**
  String errorOccurred(String message);

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get noItems;

  /// Generic error message with retry suggestion
  ///
  /// In en, this message translates to:
  /// **'An error has occurred, please try again.'**
  String get errorTryAgain;

  /// Validation message for length between range
  ///
  /// In en, this message translates to:
  /// **'Must be between {min} and {max} characters long.'**
  String lengthBetween(int min, int max);

  /// Dropdown option
  ///
  /// In en, this message translates to:
  /// **'None of above'**
  String get noneOfAbove;

  /// Label for agroecology principles field
  ///
  /// In en, this message translates to:
  /// **'Agroecology principles invoked?'**
  String get agroecologyPrinciplesInvoked;

  /// Label for food system components field
  ///
  /// In en, this message translates to:
  /// **'Food system components addressed?'**
  String get foodSystemComponents;

  /// Success message when location is added
  ///
  /// In en, this message translates to:
  /// **'Location added'**
  String get locationAdded;

  /// Error message requiring re-login
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please login again.'**
  String get errorOccurredLoginAgain;

  /// Success message when location is updated
  ///
  /// In en, this message translates to:
  /// **'Location Updated'**
  String get locationUpdated;

  /// Success message when media is added
  ///
  /// In en, this message translates to:
  /// **'Media added'**
  String get mediaAdded;

  /// Success message when media is removed
  ///
  /// In en, this message translates to:
  /// **'Media removed'**
  String get mediaRemoved;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Generic Error. Please try again.'**
  String get genericError;

  /// Success message when practice is added
  ///
  /// In en, this message translates to:
  /// **'Practice added'**
  String get practiceAdded;

  /// Success message when characterise is updated
  ///
  /// In en, this message translates to:
  /// **'Characterise Updated'**
  String get characteriseUpdated;

  /// Success message when account is created
  ///
  /// In en, this message translates to:
  /// **'Account created'**
  String get accountCreated;

  /// Practice summary description label
  ///
  /// In en, this message translates to:
  /// **'Summary Description'**
  String get summaryDescription;

  /// Practice location question label
  ///
  /// In en, this message translates to:
  /// **'Where it is realized?'**
  String get whereIsRealized;

  /// Agroecology principles field label
  ///
  /// In en, this message translates to:
  /// **'Agroecology principles addressed'**
  String get agroecologyPrinciplesAddressed;

  /// Food system components field label
  ///
  /// In en, this message translates to:
  /// **'Food system components addressed'**
  String get foodSystemComponentsAddressed;

  /// Filters title
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// Button to apply filters
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// Button to clear all filters
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// Option to select all items in a filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Farm functions filter label
  ///
  /// In en, this message translates to:
  /// **'Farm Functions'**
  String get farmFunctions;

  /// Farm function option
  ///
  /// In en, this message translates to:
  /// **'Mixed home consumption and commercial'**
  String get mixedHomeConsumptionAndCommercial;

  /// Farm function option
  ///
  /// In en, this message translates to:
  /// **'Mainly commercial'**
  String get mainlyCommercial;

  /// Generic other option
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Unsure option
  ///
  /// In en, this message translates to:
  /// **'I am not sure'**
  String get iAmNotSure;

  /// Farm components filter label
  ///
  /// In en, this message translates to:
  /// **'Farm Components'**
  String get farmComponents;

  /// Farm component option
  ///
  /// In en, this message translates to:
  /// **'Crops'**
  String get crops;

  /// Farm component option
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get animals;

  /// Farm component option
  ///
  /// In en, this message translates to:
  /// **'Trees'**
  String get trees;

  /// Farm component option
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get fish;

  /// System component filter label
  ///
  /// In en, this message translates to:
  /// **'System Component'**
  String get systemComponent;

  /// Soil option
  ///
  /// In en, this message translates to:
  /// **'Soil'**
  String get soil;

  /// Water option
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// Livestock option
  ///
  /// In en, this message translates to:
  /// **'Livestock'**
  String get livestock;

  /// Pests option
  ///
  /// In en, this message translates to:
  /// **'Pests'**
  String get pests;

  /// Energy option
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// Household option
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get household;

  /// Workers option
  ///
  /// In en, this message translates to:
  /// **'Workers'**
  String get workers;

  /// Community option
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// Value chain option
  ///
  /// In en, this message translates to:
  /// **'Value chain'**
  String get valueChain;

  /// Policy option
  ///
  /// In en, this message translates to:
  /// **'Policy'**
  String get policy;

  /// Whole food system option
  ///
  /// In en, this message translates to:
  /// **'Whole food system'**
  String get wholeFoodSystem;

  /// Agroecology principle filter label
  ///
  /// In en, this message translates to:
  /// **'Agroecology principle'**
  String get agroecologyPrinciple;

  /// Agroecology principle option
  ///
  /// In en, this message translates to:
  /// **'Recycling'**
  String get recycling;

  /// Agroecology principle option
  ///
  /// In en, this message translates to:
  /// **'Input reduction'**
  String get inputReduction;

  /// Agroecology principle option
  ///
  /// In en, this message translates to:
  /// **'Soil health'**
  String get soilHealth;

  /// Agroecology principle option
  ///
  /// In en, this message translates to:
  /// **'Animal health'**
  String get animalHealth;

  /// Agroecology principle option
  ///
  /// In en, this message translates to:
  /// **'Biodiversity'**
  String get biodiversity;

  /// Agroecology principle option
  ///
  /// In en, this message translates to:
  /// **'Synergy'**
  String get synergy;

  /// Agroecology principle option
  ///
  /// In en, this message translates to:
  /// **'Economic diversification'**
  String get economicDiversification;

  /// Agroecology principle option
  ///
  /// In en, this message translates to:
  /// **'Co-creation of knowledge'**
  String get coCreationOfKnowledge;

  /// Agroecology principle option
  ///
  /// In en, this message translates to:
  /// **'Social values and diets'**
  String get socialValuesAndDiets;

  /// Agroecology principle option
  ///
  /// In en, this message translates to:
  /// **'Fairness'**
  String get fairness;

  /// Agroecology principle option
  ///
  /// In en, this message translates to:
  /// **'Connectivity'**
  String get connectivity;

  /// Agroecology principle option
  ///
  /// In en, this message translates to:
  /// **'Land and natural resource governance'**
  String get landAndNaturalResourceGovernance;

  /// Agroecology principle option
  ///
  /// In en, this message translates to:
  /// **'Participation'**
  String get participation;

  /// Continent filter label
  ///
  /// In en, this message translates to:
  /// **'Continent'**
  String get continent;

  /// Continent name
  ///
  /// In en, this message translates to:
  /// **'Africa'**
  String get africa;

  /// Continent name
  ///
  /// In en, this message translates to:
  /// **'Asia'**
  String get asia;

  /// Continent name
  ///
  /// In en, this message translates to:
  /// **'Europe'**
  String get europe;

  /// Continent name
  ///
  /// In en, this message translates to:
  /// **'North America'**
  String get northAmerica;

  /// Continent name
  ///
  /// In en, this message translates to:
  /// **'South America'**
  String get southAmerica;

  /// Continent name
  ///
  /// In en, this message translates to:
  /// **'Australia/Oceania'**
  String get australia;

  /// Continent name
  ///
  /// In en, this message translates to:
  /// **'Antarctica'**
  String get antarctica;

  /// Error message when location details fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load location details'**
  String get failedToLoadLocation;

  /// Empty state message when an account has no locations
  ///
  /// In en, this message translates to:
  /// **'No locations registered yet'**
  String get noLocationsRegistered;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
