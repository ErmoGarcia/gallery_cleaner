import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

part 'model.g.dart';

const tableDeleted = SqfEntityTable(
  tableName: 'deleted',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  fields: [
    SqfEntityField('img_id', DbType.text),
    SqfEntityField('cloud', DbType.bool),
    SqfEntityField('date', DbType.datetime),
  ]
);

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
  databaseName: 'deleted.db',
  password: null,
  databaseTables: [tableDeleted],
);