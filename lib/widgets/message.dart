import 'package:flutter/material.dart';

import '../constants.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  void initState() {
    // TODO: implement initStat
    print(widget.sender);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 24,
          right: widget.sentByMe ? 24 : 0),
      child: Container(
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
            color: widget.sentByMe ? mainColor : Colors.grey.shade700,
            borderRadius: widget.sentByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.2),
            ),
            height(8),
            Text(widget.message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
