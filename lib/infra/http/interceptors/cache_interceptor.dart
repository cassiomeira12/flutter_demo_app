// import 'dart:convert';

// import 'package:dio/dio.dart';

// class CacheInterceptor extends Interceptor {
//   final ILocalStorageUseCase _localStorage;

//   CacheInterceptor({
//     required ILocalStorageUseCase localStorage,
//   }) : _localStorage = localStorage;

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) async {
//     if (response.requestOptions.method.toUpperCase() == 'GET') {
//       String data = jsonEncode(response.data);
//       await _localStorage.set(response.requestOptions.path, data);
//     }
//     super.onResponse(response, handler);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     var networkErros = [
//       DioExceptionType.unknown,
//       DioExceptionType.connectionError,
//       DioExceptionType.connectionTimeout,
//     ];

//     if (networkErros.contains(err.type)) {
//       String? body = await _localStorage.get(err.requestOptions.path);
//       if (body != null && body.isNotEmpty) {
//         dynamic data = jsonDecode(body);
//         handler.resolve(
//           Response(
//             data: data,
//             statusCode: 200,
//             requestOptions: err.requestOptions,
//           ),
//         );
//         return;
//       }
//     }

//     super.onError(err, handler);
//   }
// }
