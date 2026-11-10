import 'package:flutter/foundation.dart';

class AppConfig {
  static const String appName = 'NoteVault';
  static const String webdavBase = 'https://cloud.mail.ru';
  static const String webdavDavPath = '/dav/mail/';
  static const String remoteSharedDir = '/shared/';
  static const String remoteUsersDir = '/users/';
  static const String remoteSystemDir = '/system/';
  static const String remoteBackupsDir = '/backups/';
  static const String remoteTrashDir = '/trash/';
  static const int pbkdf2Iterations = 200000;
  static const int aesKeyLength = 32;
  static const int gcmNonceLength = 12;
  static const int gcmTagLength = 16;
  static const int maxVersions = 5;
  static const int trashRetentionDays = 30;
  
  static bool get isDesktop => defaultTargetPlatform == TargetPlatform.windows || 
      defaultTargetPlatform == TargetPlatform.macOS || 
      defaultTargetPlatform == TargetPlatform.linux;
  static bool get isMobile => defaultTargetPlatform == TargetPlatform.iOS || 
      defaultTargetPlatform == TargetPlatform.android;
}
