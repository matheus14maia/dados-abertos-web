import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MunicipiosScreen extends StatefulWidget {
  final Map<String, TextEditingController> controllers;

  MunicipiosScreen({required this.controllers});

  @override
  _MunicipiosScreenState createState() => _MunicipiosScreenState();
}

class _MunicipiosScreenState extends State<MunicipiosScreen> {
  List<Map<String, dynamic>> municipios = [];
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
        'http://127.0.0.1:5000/municipios?page=$currentPage&limit=$rowsPerPage&$queryParams'));

    if (response.statusCode == 200) {
      setState(() {
        municipios =
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
        title: Text('Municipios'),
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
                  rows: municipios
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
