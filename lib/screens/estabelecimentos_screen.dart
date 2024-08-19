// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EstabelecimentosScreen extends StatefulWidget {
  final Map<String, TextEditingController> controllers;

  EstabelecimentosScreen({required this.controllers});

  @override
  _EstabelecimentosScreenState createState() => _EstabelecimentosScreenState();
}

class _EstabelecimentosScreenState extends State<EstabelecimentosScreen> {
  List<Map<String, dynamic>> estabelecimentos = [];
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
        'http://127.0.0.1:5000/estabelecimentos?page=$currentPage&limit=$rowsPerPage&$queryParams'));

    if (response.statusCode == 200) {
      setState(() {
        estabelecimentos =
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
        title: Text('Estabelecimentos'),
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
                    DataColumn(label: Text('CNPJ')),
                    DataColumn(label: Text('Identificador')),
                    DataColumn(label: Text('Nome')),
                    DataColumn(label: Text('Situacao')),
                    DataColumn(label: Text('Data Situação')),
                    DataColumn(label: Text('Motivo Situação')),
                    DataColumn(label: Text('Nome Exterior')),
                    DataColumn(label: Text('País')),
                    DataColumn(label: Text('Data Inicio')),
                    DataColumn(label: Text('CNAE Principal')),
                    DataColumn(label: Text('CNAE Secundária')),
                    DataColumn(label: Text('Tipo Logradouro')),
                    DataColumn(label: Text('Logradouro')),
                    DataColumn(label: Text('Número')),
                    DataColumn(label: Text('Complemento')),
                    DataColumn(label: Text('Bairro')),
                    DataColumn(label: Text('CEP')),
                    DataColumn(label: Text('UF')),
                    DataColumn(label: Text('Municipio')),
                    DataColumn(label: Text('DDD Telefone')),
                    DataColumn(label: Text('Telefone')),
                    DataColumn(label: Text('DDD Celular')),
                    DataColumn(label: Text('Celular')),
                    DataColumn(label: Text('DDD Fax')),
                    DataColumn(label: Text('Fax')),
                    DataColumn(label: Text('Correio Eletrônico')),
                    DataColumn(label: Text('Situação Especial')),
                    DataColumn(label: Text('Data Situação Especial')),
                  ],
                  rows: estabelecimentos
                      .map((e) => DataRow(cells: [
                            DataCell(Text(e['ID'].toString())),
                            DataCell(Text(
                              '${e['cnpj_basico'] ?? ''}${e['cnpj_ordem'] ?? ''}${e['cnpj_dv'] ?? ''}',
                            )),
                            DataCell(Text(e['identificador'])),
                            DataCell(Text(e['nome'])),
                            DataCell(Text(e['situacao'])),
                            DataCell(Text(e['data_situacao'])),
                            DataCell(Text(e['motivo_situacao'])),
                            DataCell(Text(e['nome_exterior'])),
                            DataCell(Text(e['pais'])),
                            DataCell(Text(e['data_inicio'])),
                            DataCell(Text(e['cnae_principal'])),
                            DataCell(Text(e['cnae_secundaria'])),
                            DataCell(Text(e['tipo_logradouro'])),
                            DataCell(Text(e['logradouro'])),
                            DataCell(Text(e['numero'])),
                            DataCell(Text(e['complemento'])),
                            DataCell(Text(e['bairro'])),
                            DataCell(Text(e['CEP'])),
                            DataCell(Text(e['UF'])),
                            DataCell(Text(e['Municipio'])),
                            DataCell(Text(e['DDD_Telefone'])),
                            DataCell(Text(e['telefone'])),
                            DataCell(Text(e['DDD_Celular'])),
                            DataCell(Text(e['celular'])),
                            DataCell(Text(e['DDD_Fax'])),
                            DataCell(Text(e['Fax'])),
                            DataCell(Text(e['correio_eletronico'])),
                            DataCell(Text(e['situacao_especial'])),
                            DataCell(Text(e['data_sit_especial'])),
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
