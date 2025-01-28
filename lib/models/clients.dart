import 'package:flutter/material.dart';
import 'package:flutter_client_control_tests/models/client.dart';

class Clients extends ChangeNotifier {
  List<Client> clients;

  Clients({
    required this.clients
  });

  void add(Client client) {
    clients.add(client);
    notifyListeners();
  }

  void remove(int index) {
    clients.removeAt(index);
    notifyListeners();
  }
}