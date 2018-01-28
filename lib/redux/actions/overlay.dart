class OverlayErrorAction {
  final String errorMessage;
  final String retryText;
  final void Function() onRetry;

  const OverlayErrorAction(
    this.errorMessage, {
    this.retryText,
    this.onRetry,
  });
}
