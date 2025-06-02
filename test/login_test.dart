import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/ViewModel/db_provider.dart';
import 'package:proyecto_final/ViewModel/sesionProvider.dart';
import 'package:proyecto_final/Model/models.dart';
import 'package:proyecto_final/View/login.dart';
import 'package:proyecto_final/main.dart';
import 'mock_database_provider.mocks.dart';

void main() {
  testWidgets('Login exitoso con usuario y contraseña correctos', (WidgetTester tester) async {
    final mockDatabaseProvider = MockDatabaseProvider();
    final mockSesionProvider = MockSesionProvider();

    final testUser = Usuario(
      nombre: 'Test',
      apellidos: 'User',
      nombre_usuario: 'testUser',
      password: 'testPassword',
      email: 'test@user.com',
      id: 1,
    );

    when(mockDatabaseProvider.usuarios).thenReturn([testUser]);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<DatabaseProvider>.value(
          value: mockDatabaseProvider,
          child: ChangeNotifierProvider<SesionProvider>.value(
            value: mockSesionProvider,
            child: const Login(), // Pantalla Login
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(2));

    await tester.enterText(find.byType(TextField).at(0), 'testUser');
    await tester.enterText(find.byType(TextField).at(1), 'testPassword');

    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    verify(mockSesionProvider.login(testUser)).called(1);

    expect(find.byType(Main), findsOneWidget);
  });

  testWidgets('Login falla con contraseña incorrecta', (WidgetTester tester) async {
    // Mockear los proveedores
    final mockDatabaseProvider = MockDatabaseProvider();
    final mockSesionProvider = MockSesionProvider();

    final testUser = Usuario(
      nombre: 'Test',
      apellidos: 'User',
      nombre_usuario: 'testUser',
      password: 'testPassword',
      email: 'test@user.com',
      id: 1,
    );

    when(mockDatabaseProvider.usuarios).thenReturn([testUser]);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<DatabaseProvider>.value(
          value: mockDatabaseProvider,
          child: ChangeNotifierProvider<SesionProvider>.value(
            value: mockSesionProvider,
            child: const Login(), // Pantalla Login
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'testUser');
    await tester.enterText(find.byType(TextField).at(1), 'wrongPassword');

    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(find.text('Contraseña incorrecta'), findsOneWidget);
  });
}
