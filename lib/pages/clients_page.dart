import 'package:control/models/client.dart'; // Modelo de cliente
import 'package:control/models/types.dart'; // Modelo que gerencia a lista de tipos
import 'package:control/models/client_type.dart'; // Modelo para representar tipos de cliente
import 'package:control/models/clients.dart'; // Modelo que gerencia a lista de clientes
import 'package:flutter/material.dart'; // Pacote principal do Flutter
import 'package:provider/provider.dart'; // Pacote para gerenciar estado

import '../components/hamburger_menu.dart'; // Componente para o menu lateral

// Página de clientes
class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key, required this.title});
  final String title;

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Define o título da AppBar
      ),
      drawer: const HamburgerMenu(), // Adiciona um menu lateral (drawer)
      body: Consumer<Clients>( // Usa Consumer para acessar a lista de clientes
        builder: (BuildContext context, Clients list, Widget? child) {
          return ListView.builder(
            itemCount: list.clients.length, // Número de clientes
            itemBuilder: (BuildContext context, int index) {
              // Cria um item da lista para cada cliente
              return ListTile(
                leading: Icon(list.clients[index].type.icon), // Ícone do tipo de cliente
                title: Text(
                  '${list.clients[index].name} (${list.clients[index].type.name})', // Nome e tipo do cliente
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete), // Botão de deletar
                  onPressed: () {
                    setState(() {
                      list.remove(index); // Remove o cliente da lista
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          createType(context); // Abre o formulário para cadastrar cliente
        },
        tooltip: 'Add Tipo', // Texto exibido ao passar o cursor sobre o botão
        child: const Icon(Icons.add), // Ícone do botão flutuante
      ),
    );
  }

  // Método para criar um novo cliente
  void createType(context) {
    TextEditingController nomeInput = TextEditingController(); // Controlador do campo "Nome"
    TextEditingController emailInput = TextEditingController(); // Controlador do campo "Email"

    Types listTypes = Provider.of<Types>(context, listen: false); // Acessa a lista de tipos
    ClientType dropdownValue = listTypes.types[0]; // Valor inicial do dropdown

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true, // Permite rolagem se o conteúdo for grande
          title: const Text('Cadastrar cliente'), // Título do diálogo
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Campo de entrada para o nome do cliente
                  TextFormField(
                    controller: nomeInput,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      icon: Icon(Icons.account_box),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)), // Espaçamento
                  // Campo de entrada para o email do cliente
                  TextFormField(
                    controller: emailInput,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)), // Espaçamento
                  // Dropdown para selecionar o tipo de cliente
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return DropdownButton(
                        isExpanded: true, // Expande para ocupar largura total
                        value: dropdownValue, // Valor selecionado
                        icon: const Icon(Icons.arrow_downward), // Ícone do dropdown
                        style: const TextStyle(color: Colors.deepPurple), // Estilo do texto
                        underline: Container(
                          height: 2,
                          color: Colors.indigo, // Cor da linha inferior
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue as ClientType; // Atualiza o valor selecionado
                          });
                        },
                        items: listTypes.types.map((ClientType type) {
                          // Cria os itens do dropdown
                          return DropdownMenuItem<ClientType>(
                            value: type,
                            child: Text(type.name),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            // Botão para salvar o novo cliente
            Consumer(
              builder: (BuildContext context, Clients list, Widget? child) {
                return TextButton(
                  child: const Text("Salvar"),
                  onPressed: () async {
                    list.add(Client(
                      name: nomeInput.text, // Nome do cliente
                      email: emailInput.text, // Email do cliente
                      type: dropdownValue, // Tipo do cliente
                    ));
                    Navigator.pop(context); // Fecha o diálogo
                  },
                );
              },
            ),
            // Botão para cancelar
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }
}
