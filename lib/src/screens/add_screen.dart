import 'package:Shrine/src/models/product.dart';
import 'package:Shrine/src/providers/product_provider.dart';
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
  final Product product;

  AddScreen({this.product});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();

  String imageUrl;

//  final picker = ImagePicker();

  void nameDispose() {
    nameController.dispose();
    super.dispose();
  }

  void disposeDescription() {
    descriptionController.dispose();
    super.dispose();
  }

  void priceDescription() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    if (widget.product != null) {
      //Edit
      nameController.text = widget.product.name;
      descriptionController.text = widget.product.description;
      priceController.text = widget.product.price.toString();
      imageController.text = widget.product.imageUrl;
      productProvider.loadAll(widget.product);
    } else {
      //Add
      productProvider.loadAll(null);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: (widget.product != null)
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
              productProvider.changeUserUid = auth.currentUser.uid;
              productProvider.saveProduct();
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
              productProvider.imageUrl == null
                  ? Padding(
                      padding: const EdgeInsets.all(80.0),
                      child: Image.asset("assets/logo.png"),
                    )
                  : Image.network(productProvider.imageUrl),
              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => uploadImage(productProvider),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Product Name',
//                  border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (String value) =>
                          productProvider.changeName = value,
                      controller: nameController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Price',
//                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          productProvider.changePrice = int.parse(value),
                      controller: priceController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Description',
//                        border: InputBorder.none,
                      ),
                      maxLines: 6,
                      minLines: 1,
                      onChanged: (String value) =>
                          productProvider.changeDescription = value,
                      controller: descriptionController,
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

  uploadImage(productProvider) async {
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
        var snapshot =
            await _storage.ref().child('folderName/${file.absolute}').putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
        });
        productProvider.changeImageUrl = downloadUrl;
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }
}
