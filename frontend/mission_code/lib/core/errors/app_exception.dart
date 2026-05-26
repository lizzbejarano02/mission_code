class AppException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const AppException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  @override
  String toString() => message;

  static AppException fromDioError(dynamic error) {
    if (error?.response?.data is Map) {
      final data = error.response.data as Map<String, dynamic>;
      // Django devuelve errores de campo como Map<field, [messages]>
      final firstError = data.entries
          .where((e) => e.key != 'detail')
          .map((e) => e.value is List ? (e.value as List).join(', ') : e.value.toString())
          .firstOrNull;
      return AppException(
        message: data['detail'] ?? firstError ?? 'Error del servidor',
        statusCode: error.response?.statusCode,
        errors: data,
      );
    }
    return const AppException(message: 'Error de conexión. Verifica tu internet.');
  }
}