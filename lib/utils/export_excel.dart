

import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';

class ExportUtil {

  static void exportUserModelsToExcel(List<UserModel> users, String directoryPath) async {
    // Create an Excel workbook and sheet
    var excel = Excel.createExcel();
    var sheet = excel["Sheet1"];

    // Write column headers
    var columnHeaders = [
      'Name',
      'Headline',
      'Location',
      'Email',
      'GitHub',
      'Number',
      'Experience Year',
      'Skills (Frontend)',
      'Skills (Backend)',
    ];
    for (var columnIndex = 0; columnIndex < columnHeaders.length; columnIndex++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: 0)).value = columnHeaders[columnIndex];
    }

    // Write user data
    for (var rowIndex = 0; rowIndex < users.length; rowIndex++) {
      var user = users[rowIndex];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex + 1)).value = user.name;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex + 1)).value = user.headline;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex + 1)).value = user.location;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex + 1)).value = user.email;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex + 1)).value = user.github;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex + 1)).value = user.number;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex + 1)).value = user.experienceYear.toString();
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex + 1)).value = user.skillsFrontend.join(', ');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex + 1)).value = user.skillsBackend.join(', ');
    }

    // Save the Excel file
    var bytes = excel.save();
    var file = await File('$directoryPath/user_data_export2.xlsx').writeAsBytes(bytes!);

    print('Exported to: ${file.path}');
  }

  static void exportDataTableToExcel(DataTable2 dataTable, String directoryPath) async {
    // Create an Excel workbook and sheet
    var excel = Excel.createExcel();
    var sheet = excel["sheetName"];

    // Get the data from the DataTable
    var rowCount = dataTable.rows.length;
    var columnCount = dataTable.columns.length;

    // Write column headers
    for (var columnIndex = 0; columnIndex < columnCount; columnIndex++) {
      var column = dataTable.columns[columnIndex];
      sheet
          .cell(
          CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: 0))
          .value = column.label.toString();
    }

    // Write data rows
    for (var rowIndex = 0; rowIndex < rowCount; rowIndex++) {
      var dataRow = dataTable.rows[rowIndex];
      for (var columnIndex = 0; columnIndex < columnCount; columnIndex++) {
        var cellValue = dataRow.cells[columnIndex].child?.toString() ?? '';
        sheet
            .cell(CellIndex.indexByColumnRow(
            columnIndex: columnIndex, rowIndex: rowIndex + 1))
            .value = cellValue;
      }
    }

    // Save the Excel file
    var bytes = excel.save();
    var file = await File('$directoryPath/data_table_export.xlsx').writeAsBytes(bytes!);

    print('Exported to: ${file.path}');
  }
}