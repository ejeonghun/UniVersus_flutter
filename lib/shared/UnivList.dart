import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:universus/class/api/ApiCall.dart';

class Univ with CustomDropdownListFilter {
  final String school_name;
  const Univ(this.school_name);

  @override
  String toString() {
    return school_name;
  }

  @override
  bool filter(String query) {
    return school_name.toLowerCase().contains(query.toLowerCase());
  }
}

class UnivList extends StatefulWidget {
  final Function(Univ? selectedUniv) onUnivSelected;

  const UnivList({Key? key, required this.onUnivSelected}) : super(key: key);

  @override
  _UnivListState createState() => _UnivListState();
}

class _UnivListState extends State<UnivList> {
  Univ? _selectedUniv;
  Future<List<Univ>>? _universityListFuture;

  @override
  void initState() {
    super.initState();
    _universityListFuture = _fetchUniversityList();
  }

  Future<List<Univ>> _fetchUniversityList() async {
    ApiCall api = ApiCall();
    final response = await api.get('/university/univList');
    if (response['success'] == true) {
      return List<Univ>.from(
          response['data'].map((item) => Univ(item['schoolName'])).toList());
    } else {
      return []; // 에러 처리 추가 필요
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Univ>>(
      future: _universityListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final universityList = snapshot.data!;
          return CustomDropdown<Univ>.search(
            hintText: '대학 선택',
            items: universityList,
            excludeSelected: false,
            onChanged: (value) {
              setState(() {
                _selectedUniv = value;
              });
              widget.onUnivSelected(
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
