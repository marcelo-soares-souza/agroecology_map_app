// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Mapa de Agroecologia';

  @override
  String get locations => 'Locais';

  @override
  String get practices => 'Práticas';

  @override
  String get accounts => 'Contas';

  @override
  String get about => 'Sobre';

  @override
  String get chat => 'Conversas';

  @override
  String get login => 'Entrar';

  @override
  String get logout => 'Sair';

  @override
  String get map => 'Mapa';

  @override
  String get language => 'Idioma';

  @override
  String get searchLocation => 'Buscar Local...';

  @override
  String get searchPractice => 'Buscar Prática...';

  @override
  String get searchAccount => 'Buscar Conta...';

  @override
  String get searchGalleryByLocation => 'Buscar por localização...';

  @override
  String get incorrectEmailOrPassword => 'E-mail ou senha incorretos.';

  @override
  String somethingWrong(String message) {
    return 'Algo deu errado $message';
  }

  @override
  String get passwordRecoveryNotImplemented =>
      'Recuperação de senha não implementada';

  @override
  String get emailRequired => 'E-mail é obrigatório';

  @override
  String get passwordMinLength => 'A senha deve ter pelo menos 6 caracteres.';

  @override
  String get minLength4 => 'Deve ter pelo menos 4 caracteres.';

  @override
  String get yourName => 'Seu Nome';

  @override
  String get privacyPolicyLink => 'Leia nossa Política de Privacidade';

  @override
  String get deleteThisLocation => 'Excluir este Local';

  @override
  String get deleteThisPractice => 'Excluir esta Prática';

  @override
  String get areYouSure => 'Tem certeza?';

  @override
  String get no => 'Não';

  @override
  String get yes => 'Sim';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get ok => 'OK';

  @override
  String get description => 'Descrição';

  @override
  String get country => 'País';

  @override
  String get farmAndFarmingSystem => 'Propriedade e Sistema de Produção';

  @override
  String get whatDoYouHave => 'O que você tem na sua propriedade?';

  @override
  String get farmingSystemDetails => 'Detalhes do sistema de produção';

  @override
  String get whatIsYourDream => 'Qual é o seu sonho?';

  @override
  String get likes => 'Curtidas';

  @override
  String get likeThisLocation => 'Curtir esta localização';

  @override
  String get youAlreadyLiked => 'Você já curtiu esta localização';

  @override
  String get loginRequiredToLike => 'Faça login para curtir esta localização.';

  @override
  String get likeActionFailed =>
      'Não foi possível atualizar a curtida. Tente novamente mais tarde.';

  @override
  String get location => 'Localização';

  @override
  String get responsibleForInfo => 'Responsável pela Informação';

  @override
  String get temperature => 'Temperatura';

  @override
  String get humidity => 'Umidade';

  @override
  String get soilMoisture => 'Umidade do solo';

  @override
  String get ndviValue => 'Valor NDVI';

  @override
  String get cloudCover => 'Cobertura de nuvens';

  @override
  String get updatedAt => 'Atualizado em';

  @override
  String get home => 'Início';

  @override
  String get gallery => 'Galeria';

  @override
  String get ndvi => 'NDVI';

  @override
  String get sensors => 'Sensores';

  @override
  String get summary => 'Resumo';

  @override
  String get characterise => 'Caracterizar';

  @override
  String get ndviTimeline => 'Linha do tempo NDVI';

  @override
  String get noImagesAvailable => 'Nenhuma imagem disponível';

  @override
  String get galleryLocationUnavailable =>
      'Informações de localização não disponíveis para esta mídia';

  @override
  String get noDataAvailable => 'Nenhum dado disponível para esta seção.';

  @override
  String get noNdviData => 'Ainda não há dados de NDVI';

  @override
  String get pleaseLoginToChat =>
      'Por favor, faça login para iniciar uma conversa';

  @override
  String get cannotChatWithYourself =>
      'Você não pode iniciar uma conversa consigo mesmo';

  @override
  String get failedToStartConversation => 'Falha ao iniciar conversa';

  @override
  String get website => 'Site';

  @override
  String get medias => 'Mídias';

  @override
  String get startConversation => 'Iniciar conversa';

  @override
  String get aboutContent =>
      'O Mapa de Agroecologia é uma plataforma de código aberto, ciência cidadã e dados abertos que desde 2017 é mantida por um grupo de voluntários que trabalham para fortalecer e criar novas redes de colaboração que melhoram o compartilhamento de conhecimento sobre Agroecologia.';

  @override
  String get learnMoreAboutUs => 'Saiba mais sobre nós';

  @override
  String get startConversationDialog => 'Iniciar Conversa';

  @override
  String get recipientAccountId => 'ID da conta do destinatário';

  @override
  String get create => 'Criar';

  @override
  String get pleaseLoginToUseChat => 'Por favor, faça login para usar o chat';

  @override
  String get startChat => 'Iniciar chat';

  @override
  String get typeAMessage => 'Digite uma mensagem';

  @override
  String get failedToSendMessage => 'Falha ao enviar mensagem';

  @override
  String get deleteMyAccount => 'Excluir minha conta';

  @override
  String get deleteAccount => 'Excluir Conta';

  @override
  String get deleteAccountConfirmation =>
      'Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.';

  @override
  String get error => 'Erro';

  @override
  String get failedToDeleteAccount =>
      'Falha ao excluir conta. Por favor, tente novamente mais tarde.';

  @override
  String get accountSuccessfullyDeleted => 'Conta excluída com sucesso';

  @override
  String get checkingSession => 'Verificando sessão...';

  @override
  String get addNewLocation => 'Adicionar um novo Local';

  @override
  String get needLoginToAdd =>
      'Você precisa fazer login para adicionar um novo registro';

  @override
  String get locationName => 'Nome do Local';

  @override
  String get isItAFarm => 'É uma propriedade rural?';

  @override
  String get mainPurpose => 'Qual é o objetivo principal?';

  @override
  String get photo => 'Foto';

  @override
  String get locationNameHint =>
      'Como você gostaria de nomear o lugar onde pratica agroecologia?';

  @override
  String get dreamHint =>
      'Você tem um sonho de transformar sua propriedade e/ou local?';

  @override
  String get descriptionHint =>
      'Conte-nos um pouco sobre seu lugar, o que você faz no local que está cadastrando';

  @override
  String get locationServicesDisabled =>
      'Serviços de localização estão desabilitados. Por favor, habilite os serviços';

  @override
  String get locationPermissionsDenied =>
      'Permissões de localização foram negadas';

  @override
  String get locationPermissionsPermanentlyDenied =>
      'Permissões de localização foram negadas permanentemente, não podemos solicitar permissões.';

  @override
  String get save => 'Salvar';

  @override
  String get mainlyHomeConsumption => 'Principalmente Consumo Doméstico';

  @override
  String get editLocation => 'Editar Local';

  @override
  String get needLoginToEdit =>
      'Você precisa fazer login para editar um registro';

  @override
  String get addNewPractice => 'Adicionar uma nova Prática';

  @override
  String get needAtLeastOneLocation =>
      'Você precisa adicionar pelo menos um local';

  @override
  String get practiceName => 'Nome da Prática';

  @override
  String get practiceNameHint =>
      'Nomeie esta prática (ex: minha agrofloresta, experimento de permacultura, etc.).';

  @override
  String get locationRemoved => 'Local removido';

  @override
  String get practiceRemoved => 'Prática removida';

  @override
  String get pickAPhoto => 'Escolher uma Foto';

  @override
  String get photoGallery => 'Galeria de Fotos';

  @override
  String get camera => 'Câmera';

  @override
  String get needLoginToAddPhoto =>
      'Você precisa fazer login para adicionar uma nova foto';

  @override
  String errorOccurred(String message) {
    return 'Ocorreu um erro: $message';
  }

  @override
  String get noItems => 'Nenhum item';

  @override
  String get errorTryAgain => 'Ocorreu um erro, por favor tente novamente.';

  @override
  String lengthBetween(int min, int max) {
    return 'Deve ter entre $min e $max caracteres.';
  }

  @override
  String get noneOfAbove => 'Nenhuma das opções acima';

  @override
  String get agroecologyPrinciplesInvoked =>
      'Princípios agroecológicos invocados?';

  @override
  String get foodSystemComponents =>
      'Componentes do sistema alimentar abordados?';

  @override
  String get locationAdded => 'Local adicionado';

  @override
  String get errorOccurredLoginAgain =>
      'Ocorreu um erro. Por favor, faça login novamente.';

  @override
  String get locationUpdated => 'Local atualizado';

  @override
  String get mediaAdded => 'Mídia adicionada';

  @override
  String get mediaRemoved => 'Mídia removida';

  @override
  String get genericError => 'Erro genérico. Por favor, tente novamente.';

  @override
  String get practiceAdded => 'Prática adicionada';

  @override
  String get characteriseUpdated => 'Caracterização atualizada';

  @override
  String get accountCreated => 'Conta criada';

  @override
  String get summaryDescription => 'Descrição Resumida';

  @override
  String get whereIsRealized => 'Onde é realizado?';

  @override
  String get agroecologyPrinciplesAddressed =>
      'Princípios de agroecologia abordados';

  @override
  String get foodSystemComponentsAddressed =>
      'Componentes do sistema alimentar abordados';

  @override
  String get filters => 'Filtros';

  @override
  String get applyFilters => 'Aplicar Filtros';

  @override
  String get clearFilters => 'Limpar Filtros';

  @override
  String get all => 'Todos';

  @override
  String get farmFunctions => 'Funções da Propriedade';

  @override
  String get mixedHomeConsumptionAndCommercial =>
      'Consumo doméstico misto e comercial';

  @override
  String get mainlyCommercial => 'Principalmente comercial';

  @override
  String get other => 'Outro';

  @override
  String get iAmNotSure => 'Não tenho certeza';

  @override
  String get farmComponents => 'Componentes da Propriedade';

  @override
  String get crops => 'Cultivos';

  @override
  String get animals => 'Animais';

  @override
  String get trees => 'Árvores';

  @override
  String get fish => 'Peixes';

  @override
  String get systemComponent => 'Componente do sistema';

  @override
  String get soil => 'Solo';

  @override
  String get water => 'Água';

  @override
  String get livestock => 'Pecuária';

  @override
  String get pests => 'Pragas';

  @override
  String get energy => 'Energia';

  @override
  String get household => 'Doméstico';

  @override
  String get workers => 'Trabalhadores';

  @override
  String get community => 'Comunidade';

  @override
  String get valueChain => 'Cadeia de valor';

  @override
  String get policy => 'Política';

  @override
  String get wholeFoodSystem => 'Sistema alimentar completo';

  @override
  String get agroecologyPrinciple => 'Princípio da agroecologia';

  @override
  String get recycling => 'Reciclagem';

  @override
  String get inputReduction => 'Redução de insumos';

  @override
  String get soilHealth => 'Saúde do solo';

  @override
  String get animalHealth => 'Saúde animal';

  @override
  String get biodiversity => 'Biodiversidade';

  @override
  String get synergy => 'Sinergia';

  @override
  String get economicDiversification => 'Diversificação econômica';

  @override
  String get coCreationOfKnowledge => 'Cocriação de conhecimento';

  @override
  String get socialValuesAndDiets => 'Valores sociais e dietas';

  @override
  String get fairness => 'Equidade';

  @override
  String get connectivity => 'Conectividade';

  @override
  String get landAndNaturalResourceGovernance =>
      'Governança da terra e dos recursos naturais';

  @override
  String get participation => 'Participação';

  @override
  String get continent => 'Continente';

  @override
  String get africa => 'África';

  @override
  String get asia => 'Ásia';

  @override
  String get europe => 'Europa';

  @override
  String get northAmerica => 'América do Norte';

  @override
  String get southAmerica => 'América do Sul';

  @override
  String get australia => 'Austrália/Oceania';

  @override
  String get antarctica => 'Antártida';

  @override
  String get failedToLoadLocation =>
      'Falha ao carregar detalhes da localização';

  @override
  String get noLocationsRegistered => 'Nenhuma localização cadastrada ainda.';
}
