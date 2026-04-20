import '../../data/discover_repository.dart';
import '../entities/discover_data.dart';

class GetDiscoverDataUseCase {
  final DiscoverRepository repository;

  GetDiscoverDataUseCase({required this.repository});

  Future<DiscoverData> call() {
    return repository.getDiscoverData();
  }
}
