import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/credentials/credentials.dart';

class CredentialsController extends BaseController {
  final CredentialsStore _credentialsStore;
  final ListCredentialUseCase _listCredentialUseCase;
  final UpdateCredentialUseCase _updateCredentialUseCase;
  final CredentialRepository _repository;

  CredentialsController({
    required CredentialsStore credentialsStore,
    required ListCredentialUseCase listCredentialUseCase,
    required UpdateCredentialUseCase updateCredentialUseCase,
    required CredentialRepository credentialRepository,
  }) : _credentialsStore = credentialsStore,
       _listCredentialUseCase = listCredentialUseCase,
       _updateCredentialUseCase = updateCredentialUseCase,
       _repository = credentialRepository;

  ValueNotifier<List<ValueNotifier<CredentialEntity>>> get credentials =>
      _repository.valueListenable;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  ValueNotifier<String> errorMessage = ValueNotifier<String>('');

  ScrollController? scrollController;

  @override
  Future<void> onReady() async {
    super.onReady();
    await _repository.initLocalDatabase();
    getAllCredentials();
  }

  Future<void> getAllCredentials() async {
    final track = CrashlyticsServiceManager.instance.trackOperation(
      name: 'get-all-credentials-performance-tracking',
    );
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _listCredentialUseCase.call();
    } on BaseException catch (error) {
      Log.error(error, StackTrace.current);
      errorMessage.value = error.message.tr;
      track.setStatus(TrackOperationStatus.internalError);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      errorMessage.value = error.toString();
      track.setStatus(TrackOperationStatus.internalError);
    } finally {
      isLoading.value = false;
      track.finish();
    }
  }

  Future<void> addCredential() async {
    _credentialsStore.credential.value = null;
    final int? scrollToIndex = await AppNavigator.toNamed(AppRouter.credential);
    if (scrollToIndex != null) {
      scrollController?.jumpTo(scrollToIndex * 56);
    }
  }

  Future<void> openCredential(CredentialEntity item) async {
    _credentialsStore.credential.value = item;
    final int? scrollToIndex = await AppNavigator.toNamed(AppRouter.credential);
    if (scrollToIndex != null) {
      scrollController?.jumpTo(scrollToIndex * 56);
    }
  }

  Future<void> errorFavIcon(CredentialEntity item) async {
    try {
      final tempCredential = CredentialEntity(
        objectId: item.objectId,
        name: item.name,
        userName: item.userName,
        password: item.password,
        secretKeyOTP: item.secretKeyOTP,
        url: item.url,
        faviconUrl: null,
        notes: item.notes,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
      );

      await _updateCredentialUseCase.call(tempCredential);
    } catch (_) {}
  }
}
