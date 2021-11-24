import 'dart:io';
import 'package:firebase_app/models/product_dao.dart';
import 'package:firebase_app/providers/firebase_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AddProduct extends StatefulWidget {
  AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  //
  late FirebaseProvider _firebaseProvider;
  //Bandera del imagePícker
  bool imagePickerFlag = false;

  //Capturar la información de los TextFieds
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  TextEditingController _controllerIdProduct = TextEditingController();
   


  //Image
  File? imgpicker;
  File? _image;
  //ImagePath
  String? imagePath;
  UploadTask? task;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseProvider = FirebaseProvider();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _image != null
          ? Image(image: Image.file(_image!).image)
          :Image(image: Image.asset('assets/SelectImage.png').image),
        _TxtFields(),
        _btnSelectImage(),
        Divider(height: 30),
        _btnSave()
      ],
    );
  }


  Widget _TxtFields() {
    return Padding(
      padding: const EdgeInsets.all(10),      
      child: Column(
        children: [
          _TextFielIdProduct(),
          Divider(),
          _TextFielName(),
          Divider(),
          _TextFielDescription(),
        ],
      ),
    );
  }

  Widget _TextFielIdProduct() {
    return TextField(
      controller: _controllerIdProduct ,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "Id Product",
      ),
      onChanged: (value) {},
    );
  }
  Widget _TextFielName() {
    return TextField(
      controller: _controllerName ,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "Nombre",
      ),
      onChanged: (value) {},
    );
  }
  Widget _TextFielDescription() {
    return TextField(
      controller: _controllerDescription,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "Description",
      ),
      onChanged: (value) {},
    );
  }

  Widget _btnSave() {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
      onPressed: () => _insertProduct(), 
      child: Text('Guardar Informacion'));
  }
  Widget _btnSelectImage() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
        padding: MaterialStateProperty.all(EdgeInsets.all(10)),        
      ),
      onPressed: () => _imageFromGallery(ImageSource.gallery), 
      child: Text('Seleccionar Imagen de la galeria'));
  }
  

  // Method to Select a image from gallery or camera
  _imageFromGallery(ImageSource source) async {    
    final image = await ImagePicker().pickImage(source: source);
    if(image == null) {
      return;
    } else {
      final imageTemp = File(image.path);
      final imgName = path.basename(image.path);
      setState(() {        
        _image = imageTemp;
        imagePath = imgName;
      });
    }    
    return;
  }

  //Method to insert to Database in FireStore
  _insertProduct() async {
    if(_controllerIdProduct.text != '' && _controllerDescription.text != "" && _controllerName.text != "" && imagePath != null) {
      final imagePath = await _uploadImage();
      ProductDAO newProduct = ProductDAO(
        idproduct: _controllerIdProduct.text ,
        description: _controllerDescription.text,
        imagepath: imagePath,     
      );
      await _firebaseProvider.saveProduct(newProduct);
      await Future.delayed(const Duration(milliseconds: 200));
      Navigator.pop(context);
    } else {
      return showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Debe Llenar todos los campos'),
          );
        });
    }
    
  }
  Future _uploadImage() async {
    if(_image == null)
    {
      return;    
    } else {
      final destination = 'images/$imagePath';
      task = _firebaseProvider.uploadImage(destination,_image!);
      setState(() {});
      if(task == null) {
        return;
      }
      else {
        final snapshot = await task!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        return urlDownload;
      }
    }
  }
}
