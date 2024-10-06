import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  HomeBloc(this._connectivity)
      : super(const HomeState.initial(HomeStateData())) {
    on<ChangeNavIndexEvent>(_changeNavIndex);
    on<ChangeLibraryIndexEvent>(_changeLibraryIndex);
    on<ConnectivityLostEvent>(_onConnectivityLost);
    on<ConnectivityRestoredEvent>(_onConnectivityRestored);
    _subscription =
        _connectivity.onConnectivityChanged.listen(__onConnectivityChanged);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  void _changeNavIndex(ChangeNavIndexEvent event, Emitter<HomeState> emit) {
    emit(
      ChangeNavIndex(
        state.data.copyWith(
          currentNavIndex: event.index,
        ),
      ),
    );
  }

  void _changeLibraryIndex(
      ChangeLibraryIndexEvent event, Emitter<HomeState> emit) {
    emit(
      ChangeLibraryIndex(
        state.data.copyWith(
          currentLibraryIndex: event.index,
        ),
      ),
    );
  }

  void __onConnectivityChanged(List<ConnectivityResult> event) {
    if (event.contains(ConnectivityResult.none)) {
      add(const ConnectivityLostEvent());
    } else {
      add(const ConnectivityRestoredEvent());
    }
  }

  void _onConnectivityLost(
      ConnectivityLostEvent event, Emitter<HomeState> emit) {
    emit(
      ConnectivityLost(state.data),
    );
  }

  void _onConnectivityRestored(
      ConnectivityRestoredEvent event, Emitter<HomeState> emit) {
    emit(
      ConnectivityRestored(state.data),
    );
  }
}
