// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mapa de Agroecología';

  @override
  String get locations => 'Lugares';

  @override
  String get practices => 'Prácticas';

  @override
  String get accounts => 'Cuentas';

  @override
  String get about => 'Acerca de';

  @override
  String get chat => 'Conversaciones';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get map => 'Mapa';

  @override
  String get language => 'Idioma';

  @override
  String get searchLocation => 'Buscar Lugar...';

  @override
  String get searchPractice => 'Buscar Práctica...';

  @override
  String get searchAccount => 'Buscar Cuenta...';

  @override
  String get searchGalleryByLocation => 'Buscar por ubicación...';

  @override
  String get incorrectEmailOrPassword =>
      'Correo electrónico o contraseña incorrectos.';

  @override
  String somethingWrong(String message) {
    return 'Algo salió mal $message';
  }

  @override
  String get passwordRecoveryNotImplemented =>
      'Recuperación de contraseña no implementada';

  @override
  String get emailRequired => 'El correo electrónico es obligatorio';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get minLength4 => 'Debe tener al menos 4 caracteres.';

  @override
  String get yourName => 'Tu Nombre';

  @override
  String get privacyPolicyLink => 'Lee nuestra Política de Privacidad';

  @override
  String get deleteThisLocation => 'Eliminar este Lugar';

  @override
  String get deleteThisPractice => 'Eliminar esta Práctica';

  @override
  String get areYouSure => '¿Estás seguro?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Sí';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get ok => 'OK';

  @override
  String get description => 'Descripción';

  @override
  String get country => 'País';

  @override
  String get farmAndFarmingSystem => 'Finca y Sistema de Producción';

  @override
  String get whatDoYouHave => '¿Qué tienes en tu finca?';

  @override
  String get farmingSystemDetails => 'Detalles del sistema de producción';

  @override
  String get whatIsYourDream => '¿Cuál es tu sueño?';

  @override
  String get likes => 'Me gusta';

  @override
  String get likeThisLocation => 'Dar me gusta a esta ubicación';

  @override
  String get youAlreadyLiked => 'Ya diste me gusta a esta ubicación';

  @override
  String get loginRequiredToLike =>
      'Inicia sesión para dar me gusta a esta ubicación.';

  @override
  String get likeActionFailed =>
      'No se pudo actualizar el Me gusta. Inténtalo nuevamente más tarde.';

  @override
  String get location => 'Ubicación';

  @override
  String get responsibleForInfo => 'Responsable de la Información';

  @override
  String get temperature => 'Temperatura';

  @override
  String get humidity => 'Humedad';

  @override
  String get soilMoisture => 'Humedad del suelo';

  @override
  String get ndviValue => 'Valor NDVI';

  @override
  String get cloudCover => 'Cobertura de nubes';

  @override
  String get updatedAt => 'Actualizado el';

  @override
  String get home => 'Inicio';

  @override
  String get gallery => 'Galería';

  @override
  String get ndvi => 'NDVI';

  @override
  String get sensors => 'Sensores';

  @override
  String get summary => 'Resumen';

  @override
  String get characterise => 'Caracterizar';

  @override
  String get ndviTimeline => 'Cronología NDVI';

  @override
  String get noImagesAvailable => 'No hay imágenes disponibles';

  @override
  String get galleryLocationUnavailable =>
      'Información de ubicación no disponible para este medio';

  @override
  String get noDataAvailable => 'No hay datos disponibles para esta sección.';

  @override
  String get noNdviData => 'Aún no hay datos de NDVI';

  @override
  String get pleaseLoginToChat =>
      'Por favor, inicia sesión para comenzar una conversación';

  @override
  String get cannotChatWithYourself =>
      'No puedes iniciar una conversación contigo mismo';

  @override
  String get failedToStartConversation => 'Error al iniciar conversación';

  @override
  String get website => 'Sitio web';

  @override
  String get medias => 'Medios';

  @override
  String get startConversation => 'Iniciar conversación';

  @override
  String get aboutContent =>
      'Mapa de Agroecología es una plataforma de código abierto, ciencia ciudadana y datos abiertos que desde 2017 ha sido mantenida por un grupo de voluntarios que trabajan para fortalecer y crear nuevas redes de colaboración que mejoran el intercambio de conocimientos sobre Agroecología.';

  @override
  String get learnMoreAboutUs => 'Conoce más sobre nosotros';

  @override
  String get startConversationDialog => 'Iniciar Conversación';

  @override
  String get recipientAccountId => 'ID de cuenta del destinatario';

  @override
  String get create => 'Crear';

  @override
  String get pleaseLoginToUseChat =>
      'Por favor, inicia sesión para usar el chat';

  @override
  String get startChat => 'Iniciar chat';

  @override
  String get typeAMessage => 'Escribe un mensaje';

  @override
  String get failedToSendMessage => 'Error al enviar mensaje';

  @override
  String get deleteMyAccount => 'Eliminar mi cuenta';

  @override
  String get deleteAccount => 'Eliminar Cuenta';

  @override
  String get deleteAccountConfirmation =>
      '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.';

  @override
  String get error => 'Error';

  @override
  String get failedToDeleteAccount =>
      'Error al eliminar cuenta. Por favor, inténtalo de nuevo más tarde.';

  @override
  String get accountSuccessfullyDeleted => 'Cuenta eliminada con éxito';

  @override
  String get checkingSession => 'Verificando sesión...';

  @override
  String get addNewLocation => 'Agregar un nuevo Lugar';

  @override
  String get needLoginToAdd =>
      'Necesitas iniciar sesión para agregar un nuevo registro';

  @override
  String get locationName => 'Nombre del Lugar';

  @override
  String get isItAFarm => '¿Es una finca?';

  @override
  String get mainPurpose => '¿Cuál es el objetivo principal?';

  @override
  String get photo => 'Foto';

  @override
  String get locationNameHint =>
      '¿Cómo te gustaría nombrar el lugar donde practicas agroecología?';

  @override
  String get dreamHint => '¿Tienes un sueño de transformar tu finca y/o lugar?';

  @override
  String get descriptionHint =>
      'Cuéntanos un poco sobre tu lugar, qué haces en el lugar que registras';

  @override
  String get locationServicesDisabled =>
      'Los servicios de ubicación están deshabilitados. Por favor, habilita los servicios';

  @override
  String get locationPermissionsDenied =>
      'Los permisos de ubicación fueron denegados';

  @override
  String get locationPermissionsPermanentlyDenied =>
      'Los permisos de ubicación fueron denegados permanentemente, no podemos solicitar permisos.';

  @override
  String get save => 'Guardar';

  @override
  String get mainlyHomeConsumption => 'Principalmente Consumo Doméstico';

  @override
  String get editLocation => 'Editar Lugar';

  @override
  String get needLoginToEdit =>
      'Necesitas iniciar sesión para editar un registro';

  @override
  String get addNewPractice => 'Agregar una nueva Práctica';

  @override
  String get needAtLeastOneLocation => 'Necesitas agregar al menos un lugar';

  @override
  String get practiceName => 'Nombre de la Práctica';

  @override
  String get practiceNameHint =>
      'Nombra esta práctica (ej: mi agroforestería, experimento de permacultura, etc.).';

  @override
  String get locationRemoved => 'Lugar eliminado';

  @override
  String get practiceRemoved => 'Práctica eliminada';

  @override
  String get pickAPhoto => 'Elegir una Foto';

  @override
  String get photoGallery => 'Galería de Fotos';

  @override
  String get camera => 'Cámara';

  @override
  String get needLoginToAddPhoto =>
      'Necesitas iniciar sesión para agregar una nueva foto';

  @override
  String errorOccurred(String message) {
    return 'Ocurrió un error: $message';
  }

  @override
  String get noItems => 'No hay elementos';

  @override
  String get errorTryAgain => 'Ocurrió un error, por favor inténtalo de nuevo.';

  @override
  String lengthBetween(int min, int max) {
    return 'Debe tener entre $min y $max caracteres.';
  }

  @override
  String get noneOfAbove => 'Ninguna de las anteriores';

  @override
  String get agroecologyPrinciplesInvoked =>
      '¿Principios agroecológicos invocados?';

  @override
  String get foodSystemComponents =>
      '¿Componentes del sistema alimentario abordados?';

  @override
  String get locationAdded => 'Lugar agregado';

  @override
  String get errorOccurredLoginAgain =>
      'Ocurrió un error. Por favor, inicia sesión de nuevo.';

  @override
  String get locationUpdated => 'Lugar actualizado';

  @override
  String get mediaAdded => 'Medio agregado';

  @override
  String get mediaRemoved => 'Medio eliminado';

  @override
  String get genericError => 'Error genérico. Por favor, inténtalo de nuevo.';

  @override
  String get practiceAdded => 'Práctica agregada';

  @override
  String get characteriseUpdated => 'Caracterización actualizada';

  @override
  String get accountCreated => 'Cuenta creada';

  @override
  String get summaryDescription => 'Descripción Resumida';

  @override
  String get whereIsRealized => '¿Dónde se realiza?';

  @override
  String get agroecologyPrinciplesAddressed =>
      'Principios de agroecología abordados';

  @override
  String get foodSystemComponentsAddressed =>
      'Componentes del sistema alimentario abordados';

  @override
  String get filters => 'Filtros';

  @override
  String get applyFilters => 'Aplicar Filtros';

  @override
  String get clearFilters => 'Limpiar Filtros';

  @override
  String get all => 'Todos';

  @override
  String get farmFunctions => 'Funciones de la Finca';

  @override
  String get mixedHomeConsumptionAndCommercial =>
      'Consumo doméstico mixto y comercial';

  @override
  String get mainlyCommercial => 'Principalmente comercial';

  @override
  String get other => 'Otro';

  @override
  String get iAmNotSure => 'No estoy seguro';

  @override
  String get farmComponents => 'Componentes de la Finca';

  @override
  String get crops => 'Cultivos';

  @override
  String get animals => 'Animales';

  @override
  String get trees => 'Árboles';

  @override
  String get fish => 'Peces';

  @override
  String get systemComponent => 'Componente del sistema';

  @override
  String get soil => 'Suelo';

  @override
  String get water => 'Agua';

  @override
  String get livestock => 'Ganado';

  @override
  String get pests => 'Plagas';

  @override
  String get energy => 'Energía';

  @override
  String get household => 'Hogar';

  @override
  String get workers => 'Trabajadores';

  @override
  String get community => 'Comunidad';

  @override
  String get valueChain => 'Cadena de valor';

  @override
  String get policy => 'Política';

  @override
  String get wholeFoodSystem => 'Sistema alimentario completo';

  @override
  String get agroecologyPrinciple => 'Principio de agroecología';

  @override
  String get recycling => 'Reciclaje';

  @override
  String get inputReduction => 'Reducción de insumos';

  @override
  String get soilHealth => 'Salud del suelo';

  @override
  String get animalHealth => 'Salud animal';

  @override
  String get biodiversity => 'Biodiversidad';

  @override
  String get synergy => 'Sinergia';

  @override
  String get economicDiversification => 'Diversificación económica';

  @override
  String get coCreationOfKnowledge => 'Co-creación de conocimientos';

  @override
  String get socialValuesAndDiets => 'Valores sociales y dietas';

  @override
  String get fairness => 'Equidad';

  @override
  String get connectivity => 'Conectividad';

  @override
  String get landAndNaturalResourceGovernance =>
      'Gobernanza de la tierra y los recursos naturales';

  @override
  String get participation => 'Participación';

  @override
  String get continent => 'Continente';

  @override
  String get africa => 'África';

  @override
  String get asia => 'Asia';

  @override
  String get europe => 'Europa';

  @override
  String get northAmerica => 'América del Norte';

  @override
  String get southAmerica => 'América del Sur';

  @override
  String get australia => 'Australia/Oceanía';

  @override
  String get antarctica => 'Antártida';

  @override
  String get failedToLoadLocation =>
      'Error al cargar los detalles de la ubicación';

  @override
  String get noLocationsRegistered => 'Aún no hay ubicaciones registradas.';
}
