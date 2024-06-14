import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:universus/class/api/ApiCall.dart';
import 'package:universus/shared/Template.dart';

class Event with CustomDropdownListFilter {
  final int eventId;
  final String eventName;
  const Event(this.eventId, this.eventName);

  @override
  String toString() {
    return eventName;
  }

  int getEventId() => eventId;

  @override
  bool filter(String query) {
    return eventName.toLowerCase().contains(query.toLowerCase());
  }
}

class EventList extends StatefulWidget {
  final Function(Event? selectedEvent) onEventSelected;
  const EventList({Key? key, required this.onEventSelected}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  Event? _selectedEvent;
  Future<List<Event>>? _eventListFuture;

  @override
  void initState() {
    super.initState();
    _eventListFuture = _fetchEventList();
  }

  Future<List<Event>> _fetchEventList() async {
    // APICALL class 메소드 정의와 반환값이 달라서 새로 작성
    String baseUrl = dotenv.env['BACKEND_URL'] ?? '';
    var url = '$baseUrl/event/list';
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => Event(item['eventId'], item['eventName']))
          .toList();
    } catch (e) {
      print('Caught error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: _eventListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final eventList = snapshot.data!;
          return CustomDropdown<Event>(
            hintText: '카테고리 선택',
            listItemBuilder: (context, item, isSelected, onItemSelect) =>
                Container(
              decoration: BoxDecoration(
                // color: isSelected ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2) : Colors.white,
                border: Border.all(color: Colors.orange, width: 1.5),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: Template.getIcon(item.eventName),
                title: Text(
                  item.eventName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: isSelected
                        ? const Color.fromARGB(255, 115, 124, 131)
                        : Colors.black87,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : null,
                // tileColor: isSelected ? Colors.lightBlueAccent : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: onItemSelect,
              ),
            ),
            items: eventList,
            excludeSelected: false,
            onChanged: (value) {
              setState(() {
                _selectedEvent = value;
              });
              widget.onEventSelected(value);
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
