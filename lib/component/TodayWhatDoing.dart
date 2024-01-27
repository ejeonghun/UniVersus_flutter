import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TodayWhatDoing extends StatefulWidget {
  @override
  _TodayWhatDoingState createState() => _TodayWhatDoingState();
}

class _TodayWhatDoingState extends State<TodayWhatDoing> {
 CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('오늘 뭐했어?'),
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ko_KR',
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; 
                // API 호출 및 데이터 업데이트
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          // 선택된 날짜의 데이터를 표시하는 위젯
          Expanded(
            child: ListView.builder(
              itemCount: 10, // 데이터의 개수
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('데이터 $index'), // 데이터 표시
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}