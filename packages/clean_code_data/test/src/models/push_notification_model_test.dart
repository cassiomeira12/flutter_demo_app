import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PushNotificationModel', () {
    test('should create PushNotificationModel with all required fields', () {
      final model = PushNotificationModel(
        id: 'push-123',
        title: 'Push Title',
        body: 'Push Body',
        imageUrl: 'https://example.com/push.png',
        data: {'key': 'value'},
        androidChannelId: 'channel-1',
        androidPriority: 'high',
        androidVisibility: 'public',
        androidTag: 'tag-1',
        androidSticky: true,
      );

      expect(model.id, 'push-123');
      expect(model.title, 'Push Title');
      expect(model.body, 'Push Body');
      expect(model.imageUrl, 'https://example.com/push.png');
      expect(model.data, {'key': 'value'});
      expect(model.androidChannelId, 'channel-1');
      expect(model.androidPriority, 'high');
      expect(model.androidVisibility, 'public');
      expect(model.androidTag, 'tag-1');
      expect(model.androidSticky, true);
    });

    test('should create PushNotificationModel from valid map', () {
      final map = <String, dynamic>{
        'id': 'push-456',
        'title': 'Alert',
        'body': 'Something happened',
        'imageUrl': 'https://example.com/alert.png',
        'data': {'action': 'open_screen', 'screen_id': '123'},
        'androidChannelId': 'alerts',
        'androidPriority': 'max',
        'androidVisibility': 'private',
        'androidTag': 'alert-tag',
        'androidSticky': false,
      };

      final model = PushNotificationModel.fromMap(map);

      expect(model.id, 'push-456');
      expect(model.title, 'Alert');
      expect(model.body, 'Something happened');
      expect(model.imageUrl, 'https://example.com/alert.png');
      expect(model.data, {'action': 'open_screen', 'screen_id': '123'});
      expect(model.androidChannelId, 'alerts');
      expect(model.androidPriority, 'max');
      expect(model.androidVisibility, 'private');
      expect(model.androidTag, 'alert-tag');
      expect(model.androidSticky, false);
    });

    test('should use default empty strings for missing id, title, body', () {
      final map = <String, dynamic>{};

      final model = PushNotificationModel.fromMap(map);

      expect(model.id, '');
      expect(model.title, '');
      expect(model.body, '');
    });

    test('should handle null optional fields in fromMap', () {
      final map = <String, dynamic>{
        'id': 'push-789',
        'title': 'Test',
        'body': 'Test body',
        'imageUrl': null,
        'data': null,
        'androidChannelId': null,
        'androidPriority': null,
        'androidVisibility': null,
        'androidTag': null,
        'androidSticky': null,
      };

      final model = PushNotificationModel.fromMap(map);

      expect(model.imageUrl, isNull);
      expect(model.data, isNull);
      expect(model.androidChannelId, isNull);
      expect(model.androidPriority, isNull);
      expect(model.androidVisibility, isNull);
      expect(model.androidTag, isNull);
      expect(model.androidSticky, isNull);
    });

    test('should not throw BaseException with empty map', () {
      final map = <String, dynamic>{};

      expect(
        () => PushNotificationModel.fromMap(map),
        returnsNormally,
      );
    });
  });
}
