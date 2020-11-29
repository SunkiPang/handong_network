import 'package:Shrine/src/models/posts.dart';
import 'package:Shrine/src/providers/post_provider.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddScreen extends StatefulWidget {
  final Post post;

  AddScreen({this.post});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final imageController = TextEditingController();

  String imageUrl;

//  final picker = ImagePicker();

  void titleDispose() {
    titleController.dispose();
    super.dispose();
  }

  void disposeContent() {
    contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    if (widget.post != null) {
      //Edit
      titleController.text = widget.post.title;
      contentController.text = widget.post.content;
      imageController.text = widget.post.imageUrl;
      postProvider.loadAll(widget.post);
    } else {
      //Add
      postProvider.loadAll(null);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: (widget.post != null)
            ? Text(
                "Edit",
                style: TextStyle(color: Colors.white),
              )
            : Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
        actions: [
          FlatButton(
            child: Text('Save', style: TextStyle(color: Colors.white)),
            onPressed: () {
              postProvider.changeUserUid = auth.currentUser.uid;
              postProvider.savePost();
              Navigator.of(context).pop();
            },
          ),
        ],
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              postProvider.imageUrl == null
                  ? Padding(
                      padding: const EdgeInsets.all(80.0),
                      child: Image.asset("assets/logo.png"),
                    )
                  : Image.network(postProvider.imageUrl),
              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => uploadImage(postProvider),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Title',
//                  border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (String value) =>
                          postProvider.changeTitle = value,
                      controller: titleController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Content',
//                        border: InputBorder.none,
                      ),
                      maxLines: 6,
                      minLines: 1,
                      onChanged: (String value) =>
                          postProvider.changeContent = value,
                      controller: contentController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadImage(postProvider) async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if (image != null) {
        //Upload to Firebase
        var snapshot = await _storage
            .ref()
            .child('folderName/${file.absolute}')
            .putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
        });
        postProvider.changeImageUrl = downloadUrl;
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }
}
