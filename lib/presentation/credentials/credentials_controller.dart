import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/credentials/credentials.dart';

class CredentialsController extends BaseController {
  final CredentialsStore _credentialsStore;
  final ListCredentialUseCase _listCredentialUseCase;
  final UpdateCredentialUseCase _updateCredentialUseCase;

  CredentialsController({
    required CredentialsStore credentialsStore,
    required ListCredentialUseCase listCredentialUseCase,
    required UpdateCredentialUseCase updateCredentialUseCase,
  }) : _credentialsStore = credentialsStore,
       _listCredentialUseCase = listCredentialUseCase,
       _updateCredentialUseCase = updateCredentialUseCase;

  RxList<CredentialEntity> get credentials => _credentialsStore.credentials;
  RxBool isLoading = RxBool(false);
  RxString errorMessage = RxString('');

  ScrollController? scrollController;

  @override
  void onReady() {
    super.onReady();
    getAllCredentials();
  }

  Future<void> getAllCredentials() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      credentials.value = await _listCredentialUseCase.call();
      // TODO Remover na próxima versão
      _updateCredentialWithFaviconUrl(credentials);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCredential() async {
    _credentialsStore.credential.value = null;
    final int? scrollToIndex = await AppNavigator.toNamed(AppRouter.credential);
    _listCredentialsToSaveLocally();
    if (scrollToIndex != null) {
      scrollController?.jumpTo(scrollToIndex * 56);
    }
  }

  Future<void> openCredential(CredentialEntity item) async {
    _credentialsStore.credential.value = item;
    final int? scrollToIndex = await AppNavigator.toNamed(AppRouter.credential);
    _listCredentialsToSaveLocally();
    if (scrollToIndex != null) {
      scrollController?.jumpTo(scrollToIndex * 56);
    }
  }

  void _listCredentialsToSaveLocally() {
    try {
      _listCredentialUseCase.call();
    } catch (_) {}
  }

  // TODO Remover na próxima versão
  Future<void> _updateCredentialWithFaviconUrl(
    List<CredentialEntity> list,
  ) async {
    final listWithoutFavIcons = list.where((item) => item.faviconUrl == null);
    for (final item in listWithoutFavIcons) {
      try {
        final String? favIconUrl = item.url == null
            ? null
            : '${Uri.parse(item.url!).origin}/favicon.ico';
        await _updateCredentialUseCase.call(
          item.copyWith(faviconUrl: favIconUrl),
        );
      } catch (_) {}
    }
  }
}
