sealed class Failure implements Exception {
  final String message;
  const Failure(this.message);
  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error. Check your connection.']);
}

class ApiFailure extends Failure {
  const ApiFailure([super.message = 'Something went wrong. Try again.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error.']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied.']);
}
