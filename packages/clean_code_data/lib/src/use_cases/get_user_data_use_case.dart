// import 'package:core/core.dart';

// class GetUserDataUseCaseImpl implements GetUserDataUseCase {
//   final UserService _repository;
//   final UserAuthStorageUseCase _authStorageUseCase;
//   final SessionEntity _sessionEntity;

//   GetUserDataUseCaseImpl({
//     required UserService userService,
//     required UserAuthStorageUseCase authStorageUseCase,
//     required SessionEntity sessionEntity,
//   }) : _repository = userService,
//        _authStorageUseCase = authStorageUseCase,
//        _sessionEntity = sessionEntity;

//   @override
//   Future<UserModel> call() async {
//     if (_sessionEntity.isAuthenticated) {
//       try {
//         final user = await _repository.getUserData();
//         await _authStorageUseCase.saveUserData(user.toMap());
//         AppBinding.put<UserEntity>(user, permanent: true);
//         return user as UserModel;
//       } on BaseException {
//         await SessionHelper.clear();
//         throw InvalidTokenException();
//       }
//     } else {
//       throw BaseException();
//     }
//   }
// }
