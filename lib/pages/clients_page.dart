import 'package:control/models/client.dart';
import 'package:control/models/client_type.dart';
import 'package:control/models/clients.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/hamburger_menu.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key, required this.title});
  final String title;

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  // List<Client> clients = [
  //   Client(name: 'Geraldo', email: 'leo@email.com', type: ClientType(name: 'Platinum', icon: Icons.credit_card)),
  //   Client(name: 'Paulo', email: 'leo@email.com', type: ClientType(name: 'Golden', icon: Icons.card_membership)),
  //   Client(name: 'Caio', email: 'leo@email.com', type: ClientType(name: 'Titanium', icon: Icons.credit_score)),
  //   Client(name: 'Ruan', email: 'ruan@email.com', type: ClientType(name: 'Diamond', icon: Icons.diamond)),
  // ];

  // Carregar dados de clients.dart que é o provider de dados
  // List<Client> clients = [];

  // @override

  // void initState() {
  //   super.initState();
  //   clients = context.read<Clients>().clients;
  // }

  List<ClientType> types = [
    ClientType(name: 'Platinum', icon: Icons.credit_card),
    ClientType(name: 'Golden', icon: Icons.card_membership),
    ClientType(name: 'Titanium', icon: Icons.credit_score),
    ClientType(name: 'Diamond', icon: Icons.diamond),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const HamburgerMenu(),
      body: Consumer<Clients>(
          builder: (BuildContext context, Clients list, Widget? child) {
        return ListView.builder(
          itemCount: list.clients.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Icon(list.clients[index].type.icon),
              title: Text(
                  '${list.clients[index].name}(${list.clients[index].type.name} )'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    list.clients.removeAt(index);
                  });
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          createType(context);
        },
        tooltip: 'Add Tipo',
        child: const Icon(Icons.add),
      ),
    );
  }

  void createType(context) {
    TextEditingController nomeInput = TextEditingController();
    TextEditingController emailInput = TextEditingController();
    ClientType dropdownValue = types[0];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Cadastrar cliente'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: nomeInput,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        icon: Icon(Icons.account_box),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    TextFormField(
                      controller: emailInput,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return DropdownButton(
                        isExpanded: true,
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.indigo,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue as ClientType;
                          });
                        },
                        items: types.map((ClientType type) {
                          return DropdownMenuItem<ClientType>(
                            value: type,
                            child: Text(type.name),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),
            actions: [
              Consumer(
                  builder: (BuildContext context, Clients list, Widget? child) {
                return TextButton(
                  child: const Text("Salvar"),
                  onPressed: () async {
                    setState(() {
                      list.clients.add(Client(
                          name: nomeInput.text,
                          email: emailInput.text,
                          type: dropdownValue));
                      Navigator.pop(context);
                    });
                  },
                );
              }),
              TextButton(
                  child: const Text("Calcelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
}
