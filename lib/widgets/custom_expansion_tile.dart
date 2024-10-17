import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  final Widget title;
  final Widget? leading;
  final Widget trailing;
  final Color iconColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry? childrenPadding;
  final List<Widget> children;

  const CustomExpansionTile({
    super.key,
    required this.title,
    this.leading,
    required this.trailing,
    this.iconColor = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.childrenPadding,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width > 760;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        leading: isSmallScreen ? null : leading,
        title: isSmallScreen
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) leading!,
                  title,
                ],
              )
            : title,
        trailing: trailing,
        iconColor: iconColor,
        backgroundColor: backgroundColor,
        childrenPadding: childrenPadding,
        children: children,
      ),
    );
  }
}
