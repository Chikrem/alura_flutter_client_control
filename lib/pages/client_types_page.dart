import 'package:control/models/client_type.dart'; // Importa o modelo para representar o tipo de cliente
import 'package:control/models/types.dart'; // Importa o modelo que gerencia a lista de tipos
import 'package:flutter/material.dart'; // Importa o pacote principal do Flutter
import 'package:provider/provider.dart'; // Importa o Provider para gerenciar o estado

import '../components/hamburger_menu.dart'; // Importa o menu lateral (drawer)
import '../components/icon_picker.dart'; // Importa o componente para seleção de ícones

class ClientTypesPage extends StatefulWidget {
  const ClientTypesPage({super.key, required this.title});
  final String title;

  @override
  State<ClientTypesPage> createState() => _ClientTypesPageState();
}

class _ClientTypesPageState extends State<ClientTypesPage> {
  IconData? selectedIcon; // Armazena o ícone selecionado pelo usuário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Define o título da AppBar
      ),
      drawer: const HamburgerMenu(), // Adiciona o menu lateral
      body: Consumer<Types>(
        builder: (BuildContext context, Types list, Widget? child) {
          return ListView.builder(
            itemCount: list.types.length, // Define o número de itens na lista
            itemBuilder: (context, index) {
              return Dismissible(
                key: UniqueKey(), // Garante uma chave única para o item
                background: Container(color: Colors.red), // Define o fundo ao deslizar o item
                child: ListTile(
                  leading: Icon(list.types[index].icon), // Mostra o ícone do tipo de cliente
                  title: Text(list.types[index].name), // Mostra o nome do tipo de cliente
                  iconColor: Colors.deepOrange, // Define a cor do ícone
                ),
                onDismissed: (direction) {
                  setState(() {
                    list.remove(index); // Remove o item da lista ao ser deslizado
                  });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange, // Define a cor do botão
        onPressed: () {
          createType(context); // Abre o diálogo para criar um novo tipo de cliente
        },
        tooltip: 'Add Tipo', // Texto exibido ao passar o mouse sobre o botão
        child: const Icon(Icons.add), // Ícone do botão flutuante
      ),
    );
  }

  // Método para exibir o diálogo de criação de um novo tipo de cliente
  void createType(context) {
    TextEditingController nomeInput = TextEditingController(); // Controlador para o campo de texto do nome

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true, // Permite rolar o conteúdo do diálogo se necessário
          title: const Text('Cadastrar tipo'), // Título do diálogo
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: nomeInput, // Controlador do campo de texto
                    decoration: const InputDecoration(
                      labelText: 'Nome', // Placeholder para o campo
                      icon: Icon(Icons.account_box), // Ícone do campo
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)), // Espaçamento entre os campos
                  StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                    return Column(children: [
                      const Padding(padding: EdgeInsets.all(5)), // Espaçamento
                      selectedIcon != null
                          ? Icon(selectedIcon, color: Colors.deepOrange) // Mostra o ícone selecionado
                          : const Text('Selecione um ícone'), // Mensagem padrão
                      const Padding(padding: EdgeInsets.all(5)), // Espaçamento
                      SizedBox(
                        width: double.infinity, // Define o botão com largura total
                        child: ElevatedButton(
                          onPressed: () async {
                            // Abre o seletor de ícones
                            final IconData? result = await showIconPicker(
                              context: context,
                              defalutIcon: selectedIcon,
                            );
                            setState(() {
                              selectedIcon = result; // Atualiza o ícone selecionado
                            });
                          },
                          child: const Text('Selecionar ícone'), // Texto do botão
                        ),
                      ),
                    ]);
                  }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Salvar"),
              onPressed: () {
                selectedIcon ??= Icons.credit_score; // Define um ícone padrão se nenhum for selecionado
                Provider.of<Types>(context, listen: false).add(
                  ClientType(name: nomeInput.text, icon: selectedIcon), // Adiciona o novo tipo à lista
                );
                selectedIcon = null; // Reseta o ícone selecionado
                Navigator.pop(context); // Fecha o diálogo
              },
            ),
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                selectedIcon = null; // Reseta o ícone selecionado
                Navigator.pop(context); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }
}
