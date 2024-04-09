import 'package:flutter/material.dart';

class TeamMemberDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> teamMembers;

  const TeamMemberDropdown({Key? key, required this.teamMembers}) : super(key: key);

  @override
  _TeamMemberDropdownState createState() => _TeamMemberDropdownState();
}

class _TeamMemberDropdownState extends State<TeamMemberDropdown> {
  String? selectedMemberId;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text('멤버 목록'),
      value: selectedMemberId,
      onChanged: (String? newValue) {
        setState(() {
          selectedMemberId = newValue!;
          if (selectedMemberId != null) {
            print('Selected Member ID: $selectedMemberId');
            // 추 후 멤버 상세 페이지로 이동 기능 구현
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => MemberDetailScreen(memberIdx: int.parse(selectedMemberId!)),
            //   ),
            // );
          }
        });
      },
      items: widget.teamMembers.map<DropdownMenuItem<String>>((Map<String, dynamic> member) {
        return DropdownMenuItem<String>(
          value: member['memberIdx'].toString(),
          child: Row(
            children: [
              Icon(Icons.person),
              SizedBox(width: 10),
              Text('${member['name']} (${member['memberIdx']})'),
            ],
          ),
        );
      }).toSet().toList(), // Use Set to remove duplicates and then convert back to List
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      underline: Container(
        height: 2,
        color: Colors.blueAccent,
      ),
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 36,
    );
  }
}
