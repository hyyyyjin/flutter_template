import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled2/common/const/data.dart';
import 'package:untitled2/common/secure_storage/secure_storage.dart';
import 'package:untitled2/user/provider/auth_provider.dart';
import 'package:untitled2/user/provider/user_me_provider.dart';

final dioProvider = Provider((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor (
        storage: storage,
        ref: ref
    )
  );
  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref; // 모든 Provider를 읽어들일 수 있다.

  CustomInterceptor({
    required this.storage,
    required this.ref
  });

  // 1) 요청 보낼 때
  //  요청이 보내질때마다, 만약에 요청의 Header에 accessToken: true라는 값이 있다면,
  // 실제 토큰을 가져와서 (Storage에서) authorization: 'Bearer Token으로
  // 헤더를 변경한다.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if(options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      // 실제 token으로 대체
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if(options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      // 실제 token으로 대체
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을 떄
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401 에러가 났을때 (status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청한다.
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken이 아예 없으면
    // 당연히 에러를 던진다.
    if(refreshToken == null) {
      // 에러를 던질때는 handler.reject를 사용한다.
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    // 리프레스 토큰 자체에 문제가 있는 경우
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if(isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization' : 'Bearer $refreshToken'
            }
          )
        );

        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        // 토큰 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken'
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioError catch(e) {
        // refreshToken 까지 모두 만료 되었을 경우
        // A, B
        // A -> B 의 친구
        // B -> A 의 친구
        // 사람 입장: A와 B는 친구다.
        // 컴퓨터 : A -> B -> A ... -> B 무한 루프
        // userMeProvider는 dio가 필요하고, dio는 userMeProvider가 필요한 상황

        // 해결 방법:
        ref.read(authProvider.notifier).logout();

        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}