// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmpresasScreen extends StatefulWidget {
  final Map<String, TextEditingController> controllers;

  EmpresasScreen({required this.controllers});

  @override
  _EmpresasScreenState createState() => _EmpresasScreenState();
}

class _EmpresasScreenState extends State<EmpresasScreen> {
  List<Map<String, dynamic>> empresas = [];
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
        'http://127.0.0.1:5000/empresas?page=$currentPage&limit=$rowsPerPage&$queryParams'));

    if (response.statusCode == 200) {
      setState(() {
        empresas = List<Map<String, dynamic>>.from(json.decode(response.body));
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
        title: Text('Empresas'),
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
                    DataColumn(label: Text('CNPJ Básico')),
                    DataColumn(label: Text('Nome')),
                    DataColumn(label: Text('Natureza')),
                    DataColumn(label: Text('Qualificacao do Responsavel')),
                    DataColumn(label: Text('Capital')),
                    DataColumn(label: Text('Porte')),
                    DataColumn(label: Text('Ente Responsável')),
                  ],
                  rows: empresas
                      .map((e) => DataRow(cells: [
                            DataCell(Text(e['ID'].toString())),
                            DataCell(Text(e['cnpj_basico'])),
                            DataCell(Text(e['nome'])),
                            DataCell(Text(e['natureza'])),
                            DataCell(Text(e['qualificacao_do_responsavel'])),
                            DataCell(Text(e['capital'])),
                            DataCell(Text(e['porte'])),
                            DataCell(Text(e['ente_responsavel'])),
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
