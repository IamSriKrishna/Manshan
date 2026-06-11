import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, NavigatorState> {
  NavigatorBloc() : super(NavigatorState.initial()) {
    on<SelectScreenEvent>(_onSelectScreenEvent);
  }

  Future<void> _onSelectScreenEvent(
    SelectScreenEvent event,
    Emitter<NavigatorState> emit,
  ) async {
    emit(state.copyWith(index: event.index));
  }
}

class NavigatorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectScreenEvent extends NavigatorEvent {
  final int index;
  SelectScreenEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class NavigatorState {
  final int index;
  const NavigatorState({required this.index});

  factory NavigatorState.initial() {
    return NavigatorState(index: 0);
  }

  NavigatorState copyWith({int? index}) {
    return NavigatorState(index: index ?? this.index);
  }
}
