// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LucroRealScreen extends StatefulWidget {
  final Map<String, TextEditingController> controllers;

  LucroRealScreen({required this.controllers});

  @override
  _LucroRealScreenState createState() => _LucroRealScreenState();
}

class _LucroRealScreenState extends State<LucroRealScreen> {
  List<Map<String, dynamic>> lucroReal = [];
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
        'http://127.0.0.1:5000/lucroReal?page=$currentPage&limit=$rowsPerPage&$queryParams'));

    if (response.statusCode == 200) {
      setState(() {
        lucroReal =
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
        title: Text('Lucro Real'),
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
                    DataColumn(label: Text('Ano')),
                    DataColumn(label: Text('CNPJ')),
                    DataColumn(label: Text('CNPJ da SCP')),
                    DataColumn(label: Text('Forma de Tributação')),
                    DataColumn(label: Text('Quantidade de Escriturações')),
                  ],
                  rows: lucroReal
                      .map((e) => DataRow(cells: [
                            DataCell(Text(e['ID']?.toString() ?? '')),
                            DataCell(Text(e['ano'] ?? '')),
                            DataCell(Text(e['cnpj'] ?? '')),
                            DataCell(Text(e['cnpj_da_scp'] ?? '')),
                            DataCell(Text(e['forma_de_tributacao'] ?? '')),
                            DataCell(Text(e['quantidade_de_escrituracoes'] ?? '')),
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
