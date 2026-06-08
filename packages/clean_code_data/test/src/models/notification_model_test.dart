import 'package:clean_code_data/clean_code_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationModel', () {
    test('should create NotificationModel with all required fields', () {
      final model = NotificationModel(
        objectId: 'notif-123',
        title: 'Test Notification',
        body: 'This is a test notification',
        viewed: false,
        imageUrl: 'https://example.com/image.png',
      );

      expect(model.objectId, 'notif-123');
      expect(model.title, 'Test Notification');
      expect(model.body, 'This is a test notification');
      expect(model.viewed, false);
      expect(model.imageUrl, 'https://example.com/image.png');
    });

    test('should create NotificationModel from valid map', () {
      final map = <String, dynamic>{
        'objectId': 'notif-456',
        'title': 'Welcome',
        'body': 'Welcome to the app!',
        'viewed': true,
        'imageUrl': 'https://example.com/welcome.png',
      };

      final model = NotificationModel.fromMap(map);

      expect(model.objectId, 'notif-456');
      expect(model.title, 'Welcome');
      expect(model.body, 'Welcome to the app!');
      expect(model.viewed, true);
      expect(model.imageUrl, 'https://example.com/welcome.png');
    });

    test('should use default values for missing fields in fromMap', () {
      final map = <String, dynamic>{};

      final model = NotificationModel.fromMap(map);

      expect(model.objectId, '');
      expect(model.title, '');
      expect(model.body, '');
      expect(model.viewed, false);
      expect(model.imageUrl, isNull);
    });

    test('should handle null imageUrl in fromMap', () {
      final map = <String, dynamic>{
        'objectId': 'notif-789',
        'title': 'No Image',
        'body': 'This notification has no image',
        'viewed': false,
        'imageUrl': null,
      };

      final model = NotificationModel.fromMap(map);

      expect(model.imageUrl, isNull);
    });

    test('should not throw BaseException with empty map', () {
      final map = <String, dynamic>{};

      expect(
        () => NotificationModel.fromMap(map),
        returnsNormally,
      );
    });
  });
}
