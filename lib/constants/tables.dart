const Map<String, List<String>> cnaesColumns = {
  'ID': ['ID', 'Codigo', 'Descricao'],
};

const Map<String, List<String>> paisesColumns = {
  'ID': ['ID', 'Codigo', 'Descricao'],
};

const Map<String, List<String>> municipiosColumns = {
  'ID': ['ID', 'Codigo', 'Descricao'],
};

const Map<String, List<String>> empresasColumns = {
  'ID': [
    'ID',
    'cnpj_basico',
    'Nome',
    'Natureza',
    'qualificacao_do_responsavel',
    'Capital',
    'Porte',
    'ente_responsavel'
  ],
};

const Map<String, List<String>> estabelecimentosColumns = {
  'ID': [
    'ID',
    'cnpj_basico',
    'cnpj_ordem',
    'cnpj_dv',
    'Identificador',
    'Nome',
    'Situacao',
    'data_situacao',
    'motivo_situacao',
    'nome_exterior',
    'Pais',
    'data_inicio',
    'cnae_principal',
    'cnae_secundaria',
    'tipo_logradouro',
    'Logradouro',
    'Numero',
    'Complemento',
    'Bairro',
    'CEP',
    'UF',
    'Municipio',
    'DDD_Telefone',
    'Telefone',
    'DDD_Celular',
    'Celular',
    'DDD_Fax',
    'Fax',
    'correio_eletronico',
    'situacao_especial',
    'data_sit_especial'
  ],
};

const Map<String, List<String>> estoqueProcessosColumns = {
  'ID': [
    'ID',
    'numero_processoo',
    'data_protocolo',
    'questionamento_primario',
    'questionamento_secundario',
    'tipo_contribuinte',
    'Tributo',
    'fase_processual',
    'Instancia',
    'data_entrada_carf'
  ],
};

const Map<String, List<String>> lucroRealColumns = {
  'ID': [
    'ID',
    'Ano',
    'Cnpj',
    'cnpj_da_scp',
    'forma_de_tributacao',
    'quantidade_de_escrituracoes'
  ],
};

const Map<String, List<String>> lucroPresumidoColumns = {
  'ID': [
    'ID',
    'Ano',
    'Cnpj',
    'cnpj_da_scp',
    'forma_de_tributacao',
    'quantidade_de_escrituracoes'
  ],
};

const Map<String, List<String>> lucroArbitradoColumns = {
  'ID': [
    'ID',
    'Ano',
    'Cnpj',
    'cnpj_da_scp',
    'forma_de_tributacao',
    'quantidade_de_escrituracoes'
  ],
};
