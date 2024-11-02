import 'package:proxypin/network/http/http.dart';

/// A Interceptor that can intercept and modify the request and response.
/// @author Hongen Wang
abstract class Interceptor {
  /// The priority of the interceptor.
  int get priority => 0;

  /// Called before the request is sent to the server.
  Future<HttpRequest?> onRequest(HttpRequest request) async {
    return request;
  }

  /// Called after the response is received from the server.
  Future<HttpResponse?> onResponse(HttpRequest request, HttpResponse response) async {
    return response;
  }
}
