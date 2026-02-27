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
    final track = CrashlyticsServiceManager.instance.trackOperation(
      name: 'get-all-credentials-performance-tracking',
      operation: 'get-all-credentials',
    );
    try {
      isLoading.value = true;
      errorMessage.value = '';
      credentials.value = await _listCredentialUseCase.call();
    } on BaseException catch (error) {
      Log.error('getAllCredentials', error: error);
      errorMessage.value = error.message.tr;
      track.catchError(error: error);
    } catch (error, stackTrace) {
      Log.error('getAllCredentials', error: error, stackTrace: stackTrace);
      errorMessage.value = error.toString();
      track.catchError(error: error);
    } finally {
      isLoading.value = false;
      track.finish();
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
}
