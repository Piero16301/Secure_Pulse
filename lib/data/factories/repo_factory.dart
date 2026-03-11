import '../../domain/repositories/items_repository.dart';
import '../repositories/local_items_repository.dart';
import '../repositories/mock_items_repository.dart';

enum Environment { mock, dev, prod }

class RepoFactory {
  static ItemsRepository createItemsRepository(Environment env) {
    switch (env) {
      case Environment.mock:
        return MockItemsRepository();
      case Environment.dev:
      case Environment.prod:
        return LocalItemsRepository();
    }
  }
}
