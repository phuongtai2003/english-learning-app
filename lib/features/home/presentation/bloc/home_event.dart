part of 'home_bloc.dart';

@freezed
abstract class HomeEvent with _$HomeEvent {
  const factory HomeEvent.changeNavIndex(int index) = ChangeNavIndexEvent;
  const factory HomeEvent.changeLibraryIndex(int index) =
      ChangeLibraryIndexEvent;
  const factory HomeEvent.connectivityLost() = ConnectivityLostEvent;
  const factory HomeEvent.connectivityRestored() = ConnectivityRestoredEvent;
}
