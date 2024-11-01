import 'package:command/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Command tests', () {
    test('should complete void command', () async {
      // Void action
      final command = Command(() => Future.value(null));

      // Run void action
      await command.execute();

      // Action completed
      expect(command.completed, true);
    });

    test('running should be true', () async {
      final command = Command(() => Future.value(null));

      // Action not started yet
      expect(command.running, false);
      expect(command.completed, false);

      // Run action
      final future = command.execute();

      // Action is running
      expect(command.running, true);
      expect(command.completed, false);

      // Await execution
      await future;

      // Action finished running
      expect(command.running, false);
      expect(command.completed, true);
    });

    test('should only run once', () async {
      int count = 0;
      final command = Command(() {
        count++;
        return Future.value(null);
      });
      final future = command.execute();

      // Run multiple times
      command.execute();
      command.execute();
      command.execute();
      command.execute();

      // Await execution
      await future;

      // Action is called once
      expect(count, 1);
    });

    test('should handle errors', () async {
      final command = Command(() {
        throw Exception('ERROR!');
      });
      await command.execute();
      expect(command.error, isNotNull);
    });
  });
}
