import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

class StorageItem {
  StorageItem(this.key, this.value);

  final String key;
  final String value;
}

@Singleton()
class SecureStorageService {

  final _secureStorage = const FlutterSecureStorage();
  final _androidOptions = const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  Future<void> writeSecureData(StorageItem newItem) async {
    await _secureStorage.write(
      key: newItem.key,
      value: newItem.value,
      aOptions: _androidOptions,
    );
  }

  Future<String?> readSecureData(String key) async {
    var readData = await _secureStorage.read(
      key: key,
      aOptions: _androidOptions,
    );
    return readData;
  }

  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key, aOptions: _androidOptions);
  }
}
