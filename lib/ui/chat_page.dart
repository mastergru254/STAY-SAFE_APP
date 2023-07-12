import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stay_safe/const/message_bubble.dart';

class ChatPage extends StatefulWidget {
  static const String id = 'chat_page';

  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _messageTextController = TextEditingController();
  User? _activeUser;
  final ImagePicker _imagePicker = ImagePicker();
  String imageUrl = '';

  Future<void> sendLocation() async {
    if (await _requestLocationPermission()) {
      try {
        final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        print(placemarks);
        final String address =
            "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}";

        _firestore.collection('messages').add({
          'text': address,
          'sender': _activeUser?.email,
          'dateCreated': Timestamp.now(),
        });
      } catch (e) {
        print('Error getting location: $e');
      }
    } else {
      print('Location permission denied');
    }
  }

  Future<bool> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    return status.isGranted;
  }

  Future<void> selectImage() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Get a reference to storage root
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      //Create a reference for the image to be stored
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);
      try {
        await referenceImageToUpload.putFile(File(pickedImage.path));
        imageUrl = await referenceImageToUpload.getDownloadURL();
        print(imageUrl);
      } catch (e) {
        print(e);
      }
      _firestore.collection('messages').add({
        'text': '',
        'imageUrl': imageUrl,
        'sender': _activeUser?.email,
        'dateCreated': Timestamp.now(),
      });
    }
  }

  Future<void> captureImage() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Get a reference to storage root
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      //Create a reference for the image to be stored
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);
      try {
        await referenceImageToUpload.putFile(File(pickedImage.path));
        imageUrl = await referenceImageToUpload.getDownloadURL();
        print(imageUrl);
      } catch (e) {
        print(e);
      }
      _firestore.collection('messages').add({
        'text': '',
        'imageUrl': imageUrl,
        'sender': _activeUser?.email,
        'dateCreated': Timestamp.now(),
      });
    }
  }

  void getCurrentUser() async {
    try {
      _activeUser = _auth.currentUser;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
    _messageTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Chat Page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: [
        //   IconButton(
        //       icon: const Icon(Icons.close),
        //       tooltip: 'Logout',
        //       onPressed: () async {
        //         final navigator = Navigator.of(context);
        //         await _auth.signOut();
        //         //navigator.pushReplacementNamed(LoginPage.id);
        //       })
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore
                    .collection("messages")
                    .orderBy('dateCreated', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      children: snapshot.data!.docs.map((document) {
                        final data = document.data();
                        final String messageText = data['text'];
                        final String messageSender = data['sender'];
                        final String? imageUrl = data['imageUrl'];
                        return MessageBubble(
                          sender: messageSender,
                          text: messageText,
                          imageUrl: imageUrl,
                          isMyChat: messageSender == _activeUser?.email,
                        );
                      }).toList());
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageTextController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'text': _messageTextController.text,
                        'sender': _activeUser?.email,
                        'dateCreated': Timestamp.now(),
                        'imageUrl': null,
                      });
                      _messageTextController.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.green,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
