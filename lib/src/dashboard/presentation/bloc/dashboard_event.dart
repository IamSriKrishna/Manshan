import 'package:equatable/equatable.dart';

class DashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardRequestEvent extends DashboardEvent {}

class LastTransactionRequestEvent extends DashboardEvent {}
