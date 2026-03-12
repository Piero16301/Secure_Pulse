import '../../domain/repositories/items_repository.dart';
import '../repositories/local_items_repository.dart';
import '../repositories/mock_items_repository.dart';
import '../decorators/logging_items_repository_decorator.dart';

enum Environment { mock, local, remote }

class RepoFactory {
  static ItemsRepository createItemsRepository(Environment env) {
    ItemsRepository baseRepository;

    switch (env) {
      case Environment.mock:
        baseRepository = MockItemsRepository();
        break;
      case Environment.local:
      case Environment.remote:
        baseRepository = LocalItemsRepository();
        break;
    }

    return LoggingItemsRepositoryDecorator(baseRepository);
  }
}
