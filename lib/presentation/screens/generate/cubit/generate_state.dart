part of 'generate_cubit.dart';

abstract class GenerateState {}

final class GenerateInitial extends GenerateState {}

final class GenerateLoaded extends GenerateState {
  final String data;
  final String type;
  GenerateLoaded({required this.data, required this.type});
}
