// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_api/screens/cnaes_screen.dart';
import 'screens/paises_screen.dart';
import 'screens/municipios_screen.dart';
import 'screens/empresas_screen.dart';
import 'screens/estabelecimentos_screen.dart';
import 'screens/estoqueProcessos_screen.dart';
import 'screens/lucroReal_screen.dart';
import 'screens/lucroArbitrado_screen.dart';
import 'screens/lucroPresumido_screen.dart';
import 'constants/tables.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dados Abertos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedTable = '';
  Map<String, List<String>> tableColumns = {
    'Cnaes': cnaesColumns['ID']!,
    'Paises': paisesColumns['ID']!,
    'Municipios': municipiosColumns['ID']!,
    'Empresas': empresasColumns['ID']!,
    'Estabelecimentos': estabelecimentosColumns['ID']!,
    'Estoque Processos': estoqueProcessosColumns['ID']!,
    'Lucro Real': lucroRealColumns['ID']!,
    'Lucro Presumido': lucroPresumidoColumns['ID']!,
    'Lucro Arbitrado': lucroArbitradoColumns['ID']!,
  };

  Map<String, TextEditingController> controllers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dados Abertos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.yellow[400],
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Dados Abertos',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ...tableColumns.keys.map((String table) {
                return ListTile(
                  title: Text(table),
                  onTap: () {
                    setState(() {
                      selectedTable = table;
                      controllers = {
                        for (var column in tableColumns[selectedTable]!)
                          column: TextEditingController()
                      };
                      Navigator.pop(
                          context); // Close the drawer Navigator.pop(context);
                      // Navigate to the corresponding screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              getTableScreen(selectedTable, controllers),
                        ),
                      );
                    });
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: selectedTable.isEmpty ? null : selectedTable,
                  hint: Text('Selecione uma tabela'),
                  items: tableColumns.keys.map((String table) {
                    return DropdownMenuItem<String>(
                      value: table,
                      child: Text(table),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTable = newValue ?? '';
                      controllers = {
                        for (var column in tableColumns[selectedTable]!)
                          column: TextEditingController()
                      };
                    });
                  },
                ),
                if (selectedTable.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Form(
                    child: Column(
                      children: tableColumns[selectedTable]!
                          .map(
                            (column) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IntrinsicWidth(
                                    child: Text(column,
                                        textAlign: TextAlign.start),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: controllers[column],
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0,
                                          horizontal: 8.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the corresponding screen with the filters
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              getTableScreen(selectedTable, controllers),
                        ),
                      );
                    },
                    child: Text('Buscar'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getTableScreen(
      String table, Map<String, TextEditingController> controllers) {
    switch (table) {
      case 'Cnaes':
        return CnaesScreen(controllers: controllers);
      case 'Paises':
        return PaisesScreen(controllers: controllers);
      case 'Municipios':
        return MunicipiosScreen(controllers: controllers);
      case 'Empresas':
        return EmpresasScreen(controllers: controllers);
      case 'Estabelecimentos':
        return EstabelecimentosScreen(controllers: controllers);
      case 'Estoque Processos':
        return EstoqueProcessosScreen(controllers: controllers);
      case 'Lucro Real':
        return LucroRealScreen(controllers: controllers);
      case 'Lucro Presumido':
        return LucroPresumidoScreen(controllers: controllers);
      case 'Lucro Arbitrado':
        return LucroArbitradoScreen(controllers: controllers);
      default:
        return Center(
          child: Text('Please select a table from the navigation menu'),
        );
    }
  }
}
