part of app;

/**
 * Contains information about api error.
 */
class ApiError extends ServerError {
  final String error;
  final String message;

  ApiError(this.error, this.message, code): super(code);
}
