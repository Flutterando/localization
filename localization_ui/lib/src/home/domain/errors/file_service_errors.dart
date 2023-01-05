class FileServiceError implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const FileServiceError(this.message, [this.stackTrace]);

  @override
  String toString() {
    return '$runtimeType: $message${stackTrace == null ? '' : '\n' + stackTrace.toString()}';
  }
}

class NotFoundFiles extends FileServiceError {
  const NotFoundFiles(String message, [StackTrace? stackTrace]) : super(message, stackTrace);
}

class NoFilesSelected extends FileServiceError {
  const NoFilesSelected() : super('no-files-selected-error-message', null);
}
