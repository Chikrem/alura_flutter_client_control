import 'package:control/models/clients.dart';
import 'package:control/models/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:control/main.dart' as app;
import 'package:provider/provider.dart';

// Tela inicial (tela de clientes)
// Verificar se o drawer está completo
// Testar a navegação
// Verificar a tela "Tipos de clientes"
// Criar um novo tipo de cliente
// Criar um novo cliente com o novo tipo
// Verificar o que não é necessário testar

void main (){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Integration Test', (tester) async {
    final providerKey = GlobalKey();
    app.main(list: [], providerKey: providerKey);
    await tester.pumpAndSettle();

    // Teste Drawer tela inicial
    expect(find.text('Clientes'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Teste Drawer menu hamburguer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Gerenciar clientes'), findsOneWidget);
    expect(find.text('Tipos de clientes'), findsOneWidget);
    expect(find.text('Sair'), findsOneWidget);


    // Teste navegação para tipos de clientes
    await tester.tap(find.text('Tipos de clientes'));
    await tester.pumpAndSettle();
    expect(find.text('Tipos de cliente'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.text('Platinum'), findsOneWidget);
    expect(find.text('Golden'), findsOneWidget);
    expect(find.text('Titanium'), findsOneWidget);
    expect(find.text('Diamond'), findsOneWidget);

    // Teste cadastrar novo tipo de cliente
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Silver');
    await tester.tap(find.text('Selecionar icone'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.card_giftcard));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Silver'), findsOneWidget);
    expect(find.byIcon(Icons.card_giftcard), findsOneWidget);

    expect(Provider.of<Types>(providerKey.currentContext!, listen: false).types.last.name, 'Silver'); // Verifica se o tipo foi adicionado
    expect(Provider.of<Types>(providerKey.currentContext!, listen: false).types.last.icon, Icons.card_giftcard); // Verifica se o tipo foi adicionado

    // Teste cadastrar novo cliente
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gerenciar clientes'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.enterText(find.byKey(const Key('Nome')), 'Teste');
    await tester.enterText(find.byKey(const Key('Email')), 'Teste@teste');
    await tester.tap(find.byIcon(Icons.arrow_downward));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Silver').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Teste (Silver)'), findsOneWidget);
    expect(find.byIcon(Icons.card_giftcard), findsOneWidget);

    expect(Provider.of<Clients>(providerKey.currentContext!, listen: false).clients.last.name, 'Teste'); // Verifica se o cliente foi adicionado
    expect(Provider.of<Clients>(providerKey.currentContext!, listen: false).clients.last.email, 'Teste@teste'); // Verifica se o cliente foi adicionado

  });

}