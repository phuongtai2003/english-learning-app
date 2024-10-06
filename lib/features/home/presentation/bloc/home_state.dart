part of 'home_bloc.dart';

@freezed
class HomeStateData with _$HomeStateData {
  const factory HomeStateData({
    @Default(0) int currentNavIndex,
    @Default(0) int currentLibraryIndex,
  }) = _HomeStateData;
}

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.initial(HomeStateData data) = Initial;
  const factory HomeState.changeNavIndex(HomeStateData data) = ChangeNavIndex;
  const factory HomeState.changeLibraryIndex(HomeStateData data) =
      ChangeLibraryIndex;
  const factory HomeState.connectivityLost(HomeStateData data) = ConnectivityLost;
  const factory HomeState.connectivityRestored(HomeStateData data) = ConnectivityRestored;
}
