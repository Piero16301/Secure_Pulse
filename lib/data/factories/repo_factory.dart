import '../../domain/repositories/items_repository.dart';
import '../../domain/repositories/security_repository.dart';
import '../decorators/cache_items_repository_decorator.dart';
import '../repositories/local_items_repository.dart';
import '../repositories/local_security_repository.dart';
import '../repositories/mock_items_repository.dart';
import '../decorators/logging_items_repository_decorator.dart';
import '../repositories/mock_security_repository.dart';

enum Environment { mock, local, remote }

class RepoFactory {
  static ItemsRepository createItemsRepository(Environment env) {
    ItemsRepository baseRepository;

    switch (env) {
      case Environment.mock:
        baseRepository = MockItemsRepository();
        break;
      case Environment.local:
        baseRepository = LocalItemsRepository();
        break;
      case Environment.remote:
        baseRepository = LocalItemsRepository();
        break;
    }

    final loggedRepository = LoggingItemsRepositoryDecorator(baseRepository);
    final cachedAndLoggedRepository = CacheItemsRepositoryDecorator(
      loggedRepository,
    );

    return cachedAndLoggedRepository;
  }

  static SecurityRepository createSecurityRepository(Environment env) {
    switch (env) {
      case Environment.mock:
        return MockSecurityRepository();
      case Environment.local:
        return LocalSecurityRepository();
      case Environment.remote:
        return LocalSecurityRepository();
    }
  }
}
