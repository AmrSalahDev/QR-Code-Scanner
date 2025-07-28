import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectionStatus { connected, disconnected }

class ConnectionCubit extends Cubit<ConnectionStatus> {
  ConnectionCubit() : super(ConnectionStatus.connected);

  void setConnected() => emit(ConnectionStatus.connected);
  void setDisconnected() => emit(ConnectionStatus.disconnected);
}
