// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EstoqueProcessosScreen extends StatefulWidget {
  final Map<String, TextEditingController> controllers;

  EstoqueProcessosScreen({required this.controllers});

  @override
  _EstoqueProcessosScreenState createState() => _EstoqueProcessosScreenState();
}

class _EstoqueProcessosScreenState extends State<EstoqueProcessosScreen> {
  List<Map<String, dynamic>> estoqueProcessos = [];
  int currentPage = 1;
  final int rowsPerPage = 200;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final queryParams = widget.controllers.entries
        .where((e) => e.value.text.isNotEmpty)
        .map((e) => '${e.key}=${e.value.text}')
        .join('&');
    final response = await http.get(Uri.parse(
        'http://127.0.0.1:5000/estoqueProcessos?page=$currentPage&limit=$rowsPerPage&$queryParams'));

    if (response.statusCode == 200) {
      setState(() {
        estoqueProcessos =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _nextPage() {
    setState(() {
      currentPage++;
      fetchData();
    });
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        fetchData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EstoqueProcessos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Número Processo')),
                    DataColumn(label: Text('Data Protocolo')),
                    DataColumn(label: Text('Questionamento Primario')),
                    DataColumn(label: Text('Questionamento Secundario')),
                    DataColumn(label: Text('Tipo Contribuinte')),
                    DataColumn(label: Text('Tributo')),
                    DataColumn(label: Text('Fase Processual')),
                    DataColumn(label: Text('Instância')),
                    DataColumn(label: Text('Data Entrada CARF')),
                  ],
                  rows: estoqueProcessos
                      .map((e) => DataRow(cells: [
                            DataCell(Text(e['ID']?.toString() ?? '')),
                            DataCell(Text(e['numero_processoo'] ?? '')),
                            DataCell(Text(e['data_protocolo'] ?? '')),
                            DataCell(Text(e['questionamento_primario'] ?? '')),
                            DataCell(Text(e['questionamento_secundario'] ?? '')),
                            DataCell(Text(e['tipo_contribuinte'] ?? '')),
                            DataCell(Text(e['tributo'] ?? '')),
                            DataCell(Text(e['fase_processual'] ?? '')),
                            DataCell(Text(e['instancia'] ?? '')),
                            DataCell(Text(e['data_entrada_carf'] ?? '')),
                          ]))
                      .toList(),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _previousPage,
                child: Text('Previous Page'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _nextPage,
                child: Text('Next Page'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
