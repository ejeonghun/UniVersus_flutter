import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:universus/class/api/ApiCall.dart';

class Dept with CustomDropdownListFilter {
  final String deptName;
  final int deptId;

  const Dept(this.deptName, this.deptId);

  @override
  String toString() {
    return deptName;
  }

  @override
  bool filter(String query) {
    return deptName.toLowerCase().contains(query.toLowerCase());
  }
}

class DeptList extends StatefulWidget {
  final Function(Dept? selectedDept) onDeptSelected;
  final String univId; // 대학 id값

  const DeptList({Key? key, required this.onDeptSelected, required this.univId})
      : super(key: key);

  @override
  _DeptListState createState() => _DeptListState();
}

class _DeptListState extends State<DeptList> {
  Dept? _selectedDept;
  Future<List<Dept>>? _deptListFuture;

  @override
  void initState() {
    super.initState();
    _deptListFuture = _fetchDeptList();
  }

  Future<List<Dept>> _fetchDeptList() async {
    ApiCall api = ApiCall();
    final response = await api
        .get('/department/matchDept?univId=${widget.univId.toString()}');
    if (response['success'] == true) {
      return List<Dept>.from(response['data']
          .map((item) => Dept(item['deptName'], item['deptId']))
          .toList());
    } else {
      return []; // 에러 처리 추가 필요
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Dept>>(
      future: _deptListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final deptList = snapshot.data!;
          return CustomDropdown<Dept>.search(
            hintText: '학과 선택',
            items: deptList,
            excludeSelected: false,
            onChanged: (value) {
              setState(() {
                _selectedDept = value;
              });
              widget.onDeptSelected(
                  value); // Pass selected value to external widget
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return Center(child: LinearProgressIndicator());
      },
    );
  }
}
