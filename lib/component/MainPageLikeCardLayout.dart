// 파일명: auto_scroll_page_view.dart
import 'package:flutter/material.dart';

class MainPageLikeCardLayout extends StatefulWidget {
  final List<Post> posts;

  MainPageLikeCardLayout({required this.posts});

  @override
  _MainPageLikeCardLayoutState createState() => _MainPageLikeCardLayoutState();
}

class _MainPageLikeCardLayoutState extends State<MainPageLikeCardLayout> with AutomaticKeepAliveClientMixin {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController = PageController(
      initialPage: _currentPage,
    );

    Future.delayed(Duration(seconds: 5), _scrollToNextPage);
  }

  void _scrollToNextPage() {
    if (_currentPage < widget.posts.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }

    _pageController.animateToPage(
      _currentPage,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );

    Future.delayed(Duration(seconds: 5), _scrollToNextPage);
  }

@override
Widget build(BuildContext context) {
  return PageView.builder(
    controller: _pageController,
    itemCount: widget.posts.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              final post = widget.posts[index];
              return AlertDialog(
                title: Text(post.title),
                content: Column(
                  children: [
                    Text(post.content),
                    Text('Likes: ${post.likes}'),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 200.0, // 적절한 높이로 설정
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${widget.posts[index].title}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      '${widget.posts[index].content}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(Icons.thumb_up, color: Colors.blue),
                      SizedBox(width: 5),
                      Text('${widget.posts[index].likes}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

  @override
  bool get wantKeepAlive => true;
}

class Post {
  final String title;
  final String content;
  final int likes;

  Post({required this.title, required this.content, required this.likes});
}
