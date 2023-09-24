
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/user_model.dart';
import '../riverpod/user_profilelist_provider.dart';

/// refer to [UserModel]
class CVTable extends ConsumerWidget {
  const CVTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider= ref.watch(videoEditListProvider);

    if (userProvider.isEmpty) {
      return const SizedBox.shrink();
    }
    // else{
    //   //_userProvider.map((e) => );
    //       DataRow(cells:
    //         _userProvider.map((e) => DataCell(Text(e.name))).toList(),
    //       );
    // }
    final dtSource = UserDataTableSource(
      onRowSelect: (index) => (/*_showDetails(context, _model[index]*/),
      userData: userProvider,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 500),
      child: DataTable2(columns: const [
          DataColumn2(label: Text("Name"), size: ColumnSize.L),
          DataColumn2(label: Text("headline"), size: ColumnSize.L),
          DataColumn2(label: Text("Location"), size: ColumnSize.L),
          DataColumn2(label: Text("Email"), size: ColumnSize.L),
          DataColumn2(label: Text("Github"), size: ColumnSize.L),
          DataColumn2(label: Text("Phone"), size: ColumnSize.L),
          DataColumn2(label: Text("Experience Year"), size: ColumnSize.L),
          DataColumn2(label: Text("Skill Frontend"), size: ColumnSize.L),
          DataColumn2(label: Text("Skill Backend"), size: ColumnSize.L),
          //DataColumn2(label: Text("Details"), size: ColumnSize.L),
        ],
      rows: dtSource.getAllRows()),
    );
  }
}



typedef OnRowSelect = void Function(int index);

class UserDataTableSource extends DataTableSource {
  UserDataTableSource({
    required List<UserModel> userData,
    required this.onRowSelect,
  })  : _userData = userData;

  final List<UserModel> _userData;
  final OnRowSelect onRowSelect;

  List<DataRow> getAllRows() {
    List<DataRow> rows= [];
    for (var i=0; i<_userData.length; i++) {
      if(getRow(i) != null) {
        rows.add(getRow(i)!);
      }
    }
    return rows;
  }

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= _userData.length) {
      return null;
    }
    final _user = _userData[index];

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(_user.name)),
        DataCell(Text(_user.headline)),
        DataCell(Text(_user.location)),
        DataCell(Text(_user.email)),
        DataCell(RichText(
            text: TextSpan(
              text: _user.github,
              style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchUrl(Uri.parse(_user.github));
            },
            ),),),
        DataCell(Text(_user.number)),
        DataCell(Text(_user.experienceYear.toString())),
        DataCell(SingleChildScrollView(child: Text(_user.skillsFrontend.join(", ")))),
        DataCell(SingleChildScrollView(child: Text(_user.skillsBackend.join(", ")))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _userData.length;

  @override
  int get selectedRowCount => 0;

  /*
   *
   * Sorts this list according to the order specified by the [compare] function.

    The [compare] function must act as a [Comparator].

    List<String> numbers = ['two', 'three', 'four'];
// Sort from shortest to longest.
    numbers.sort((a, b) => a.length.compareTo(b.length));
    print(numbers);  // [two, four, three]
    The default List implementations use [Comparable.compare] if [compare] is omitted.

    List<int> nums = [13, 2, -11];
    nums.sort();
    print(nums);  // [-11, 2, 13]
   */
  void sort<T>(Comparable<T> Function(UserModel d) getField, bool ascending) {
    _userData.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    notifyListeners();
  }
}
