import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/splash/domain/entities/configuration.dart';
import 'package:final_flashcard/features/splash/domain/repository/splash_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetConfigurationUseCase implements UseCaseWithoutParams<Configuration> {
  final SplashRepository _splashRepository;

  GetConfigurationUseCase(this._splashRepository);
  @override
  ResultFuture<Configuration> call() async {
    return await _splashRepository.getConfiguration();
  }
}
