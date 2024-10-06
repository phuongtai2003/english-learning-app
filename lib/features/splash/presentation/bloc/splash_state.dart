part of 'splash_bloc.dart';

@freezed
class SplashStateData with _$SplashStateData {
  const factory SplashStateData({
    Configuration? configuration,
    @Default('') String message,
  }) = _SplashStateData;
}

@freezed
abstract class SplashState with _$SplashState {
  const factory SplashState.initial(SplashStateData data) =
      SplashStateInitial;
  const factory SplashState.loading(SplashStateData data) =
      SplashStateLoading;
  const factory SplashState.loaded(SplashStateData data) = SplashStateLoaded;
  const factory SplashState.error(SplashStateData data) = SplashStateError;
  const factory SplashState.firstTime(SplashStateData data) =
      SplashStateFirstTime;
      const factory SplashState.notFirstTime(SplashStateData data) = SplashStateNotFirstTime;
      const factory SplashState.toMain(SplashStateData data) = SplashStateToMain;
}
