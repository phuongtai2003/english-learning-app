import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/features/splash/domain/entities/configuration.dart';

abstract class SplashRepository {
  const SplashRepository();
  ResultFuture<Configuration> getConfiguration();
}
