import 'package:flutter/material.dart';

class CollapseExpand extends StatefulWidget {
  const CollapseExpand({this.title, this.child, super.key});
  final String? title;
  final Widget? child;

  @override
  State<CollapseExpand> createState() => _CollapseExpandState();
}

class _CollapseExpandState extends State<CollapseExpand> {
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 3, bottom: 5, top: 2, right: 3),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          GestureDetector(
            child: ListTile(
              title: Text(
                widget.title!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                    _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    _showContent = !_showContent;
                  });
                },
              ),
            ),
            onTap: () {
              setState(() {
                _showContent = !_showContent;
              });
            },
          ),
          _showContent ? widget.child! : Container(),
        ],
      ),
    );
  }
}
