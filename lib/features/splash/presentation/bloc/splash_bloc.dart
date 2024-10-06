import 'package:final_flashcard/features/splash/domain/entities/configuration.dart';
import 'package:final_flashcard/features/splash/domain/use_case/get_configuration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_event.dart';
part 'splash_state.dart';
part 'splash_bloc.freezed.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final GetConfigurationUseCase _getConfigurationUseCase;
  SplashBloc(
    this._getConfigurationUseCase,
  ) : super(const SplashState.initial(SplashStateData())) {
    on<SplashCheckEvent>(_splashCheck);
  }

  void _splashCheck(SplashCheckEvent event, Emitter<SplashState> emit) async {
    emit(
      SplashStateLoading(
        state.data,
      ),
    );
    final result = await _getConfigurationUseCase();
    print(result);
    result.fold(
      (failure) {
        emit(
          SplashStateError(
            state.data.copyWith(
              message: failure.message,
            ),
          ),
        );
      },
      (configuration) {
        if (configuration.isFirstTime == false) {
          if (configuration.token != null && configuration.token!.isNotEmpty) {
            emit(
              SplashStateToMain(
                state.data.copyWith(
                  configuration: configuration,
                ),
              ),
            );
          } else {
            emit(
              SplashStateNotFirstTime(
                state.data.copyWith(
                  configuration: configuration,
                ),
              ),
            );
          }
        } else {
          emit(
            SplashStateFirstTime(
              state.data.copyWith(
                configuration: configuration,
              ),
            ),
          );
        }
      },
    );
  }
}
