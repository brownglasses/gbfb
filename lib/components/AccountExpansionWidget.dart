import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AccountExpansionWidget extends StatefulWidget {
  final List<String> options;
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final bool isSingleLine; // 한 줄로 표시할지 여러 줄로 표시할지 결정
  final Function(int)? onSelectionChanged;

  const AccountExpansionWidget({
    super.key,
    required this.options,
    this.title = 'Options',
    this.icon = Icons.settings,
    this.iconColor = Colors.blue,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.white,
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = Colors.grey,
    this.isSingleLine = true,
    this.onSelectionChanged,
  });

  @override
  AccountExpansionWidgetState createState() => AccountExpansionWidgetState();
}

class AccountExpansionWidgetState extends State<AccountExpansionWidget> {
  bool mIsExpanded = false;
  int mIsSelect = 0;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      animationDuration: const Duration(seconds: 1),
      expansionCallback: (int index, bool isExpanded) {
        mIsExpanded = !mIsExpanded;
        setState(() {});
      },
      children: [
        ExpansionPanel(
          headerBuilder: (_, bool isExpanded) {
            return Row(
              children: [
                8.width,
                Icon(widget.icon, color: widget.iconColor),
                12.width,
                Text(widget.title, style: primaryTextStyle()),
              ],
            );
          },
          body: widget.isSingleLine
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _buildOptions(),
                  ),
                )
              : Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _buildOptions(),
                ),
          isExpanded: mIsExpanded,
        )
      ],
    );
  }

  List<Widget> _buildOptions() {
    return widget.options
        .asMap()
        .map(
          (index, option) {
            return MapEntry(
              index,
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: mIsSelect == index
                      ? widget.selectedColor
                      : widget.unselectedColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: mIsSelect == index
                        ? widget.selectedTextColor
                        : widget.unselectedTextColor,
                  ),
                ),
                child: Text(option,
                    style: primaryTextStyle(
                        color: mIsSelect == index
                            ? widget.selectedTextColor
                            : widget.unselectedTextColor)),
              ).onTap(() {
                setState(() {
                  mIsSelect = index;
                });
                if (widget.onSelectionChanged != null) {
                  widget.onSelectionChanged!(index);
                }
              },
                  highlightColor: widget.unselectedColor,
                  splashColor: widget.unselectedColor),
            );
          },
        )
        .values
        .toList();
  }
}
