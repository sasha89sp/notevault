enum SyncState { idle, syncing, error, offline }
class SyncStatus {
  final SyncState state; final DateTime? lastSync; final String? errorMessage;
  final int pendingUploads; final int pendingDownloads;
  const SyncStatus({this.state = SyncState.idle, this.lastSync, this.errorMessage,
    this.pendingUploads = 0, this.pendingDownloads = 0});
  bool get hasPending => pendingUploads > 0 || pendingDownloads > 0;
}
