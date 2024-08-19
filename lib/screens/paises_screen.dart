import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaisesScreen extends StatefulWidget {
  final Map<String, TextEditingController> controllers;

  PaisesScreen({required this.controllers});

  @override
  _PaisesScreenState createState() => _PaisesScreenState();
}

class _PaisesScreenState extends State<PaisesScreen> {
  List<Map<String, dynamic>> paises = [];
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
    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:5000/paises?page=$currentPage&limit=$rowsPerPage&$queryParams'),
    );

    if (response.statusCode == 200) {
      setState(() {
        paises = List<Map<String, dynamic>>.from(json.decode(response.body));
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
        title: Text('Paises'),
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
                    DataColumn(label: Text('Código')),
                    DataColumn(label: Text('Descrição')),
                  ],
                  rows: paises
                      .map((e) => DataRow(cells: [
                            DataCell(Text(e['ID'].toString())),
                            DataCell(Text(e['codigo'])),
                            DataCell(Text(e['descricao'])),
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
