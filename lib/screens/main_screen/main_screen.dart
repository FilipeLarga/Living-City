import 'package:flutter/material.dart';
import 'journal_page/journal_page.dart';
import 'map_page/map_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex;

  final _pageController = PageController();

  @override
  void initState() {
    _pageIndex = 0;
    _pageController.addListener(() {
      if (_pageController.page.round() != _pageIndex) {
        setState(() {
          _pageIndex = _pageController.page.round();
        });
      }
    });
    super.initState();
  }

  void _showPage(int index) {
    if (index != _pageIndex) {
      setState(() {
        _pageIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: _showPage,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.thumb_up),
            title: const Text('Travel'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.thumb_down),
            title: const Text('Journal'),
          )
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [const MapPage(), JournalPage()],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
