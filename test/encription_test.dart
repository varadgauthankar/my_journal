import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/services/encryption_service.dart';

main() {
  EncryptionService _encryptionService = EncryptionService();

  test('encryption', () {
    const plainText = 'Hello World!';
    final base64 = RegExp(
        r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$');
    final encryptedText = _encryptionService.encrypt(plainText);
    expect(base64.hasMatch(encryptedText), true);
  });

  test('decryption', () {
    final j = Journal(title: 'sat, 12 Mar', description: 'world');

    final encryptedjournal = Journal.encrypt(j);
    final decryotedJournal = Journal.decrypt(encryptedjournal);

    expect(j.title, decryotedJournal.title);
  });
}
