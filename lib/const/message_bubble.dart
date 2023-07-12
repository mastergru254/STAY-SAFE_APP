import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMyChat;
  final String? imageUrl;

  const MessageBubble({
    Key? key,
    required this.sender,
    required this.text,
    required this.isMyChat,
    this.imageUrl,
  }) : super(key: key);

  final bubbleBorderRadius = const BorderRadius.only(
    topRight: Radius.circular(20),
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  );

  final senderBorderRadius = const BorderRadius.only(
    topLeft: Radius.circular(20),
    bottomLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMyChat ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   sender,
          //   style: const TextStyle(
          //     fontSize: 12.0,
          //     color: Colors.black54,
          //   ),
          // ),
          Material(
            color: isMyChat ? Colors.green : Colors.white,
            borderRadius: isMyChat ? senderBorderRadius : bubbleBorderRadius,
            elevation: 5.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isMyChat ? Colors.white : Colors.black54,
                      fontSize: 15.0,
                    ),
                  ),
                  // Check if there is an imageUrl
                  if (imageUrl != null)
                    // Display the image using the imageUrl
                    Image.network(
                      imageUrl!,
                      width: 200,
                      height: 200,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
