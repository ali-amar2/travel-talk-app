import '../../data/home_repository.dart';
import '../entities/home_data.dart';

class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase({required this.repository});

  Future<HomeData> call() {
    return repository.getHomeData();
  }
}
