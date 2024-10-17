import 'package:flutter/material.dart';

class PaginationButtons extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationButtons({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.keyboard_double_arrow_left, color: Colors.indigo),
          onPressed:
              currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        ..._buildPageButtons(),
        IconButton(
          icon: Icon(Icons.keyboard_double_arrow_right, color: Colors.indigo),
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }

  List<Widget> _buildPageButtons() {
    List<Widget> buttons = [];

    for (int i = 1; i <= totalPages; i++) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: currentPage == i ? Colors.indigo : Colors.grey,
              ),
              backgroundColor: currentPage == i
                  ? Colors.indigo.withOpacity(0.8)
                  : Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () => onPageChanged(i),
            child: Text(
              '$i',
              style: TextStyle(
                color: currentPage == i ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return buttons.length > 3
        ? buttons.sublist(currentPage - 1, currentPage + 2)
        : buttons;
  }
}
