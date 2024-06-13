import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:universus/class/api/ApiCall.dart';

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
          return Text('Error: ${snapshot.error}');
        }
        return Center(child: LinearProgressIndicator());
      },
    );
  }
}
