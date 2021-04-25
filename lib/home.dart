
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

//Tflite library allows us to use tensorflow models on our devices

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool _loading = true;
  File _image;

  //In this list we will fetch all the data from the neural network and store the data required data in the list
  List _output;

  final picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    loadModel().then((value){
      setState(() {

      });
    });
  }


  detectImage(File image) async{
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5
    );

    //set a state for its output variable
    setState(() {
      _output = output;
      _loading = false;
    });
  }


  loadModel() async{
    await Tflite.loadModel(model: 'Asset/model_unquant.tflite', labels: 'Asset/labels.txt');
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  pickImage()async{
    var image = await picker.getImage(source: ImageSource.camera);

    if(image == null) return null;

    setState(() {
      _image = File(image.path);

    });

    detectImage(_image);
  }

  pickGalleryImage()async{
    var image = await picker.getImage(source: ImageSource.gallery);

    if(image == null) return null;

    setState(() {
      _image = File(image.path);

    });

    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50,),
            Text('Raghavendra Dubey',
              style: TextStyle(color: Colors.white,
                  fontSize: 20),

            ),
            SizedBox(height: 5,),
            Text('Cats and Dogs Detector App',
              style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 30
              ),
            ),
            SizedBox(height: 50,),
            Center(child: _loading ?
            Container(
              //if loading is true
              width: 250,
              child: Column(children: <Widget>[
                Image.asset('Asset/cat_dog_icon.png'),
                SizedBox(height: 50,)
              ],),
            ) : Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    child: Image.file(_image),  //it will display the image that user selects
                  ),
                  SizedBox(height: 20,),
                  _output != null ? Text('${_output[0]['label']}',
                    style: TextStyle(
                        color: Colors.white, fontSize: 15),
                  )
                      : Container(),
                  SizedBox(height: 10,)
                ],
              ),
            ),
            ),
            Container(
              //this is the way to get device width
              width: MediaQuery.of(context).size.width,
              child: Column(children: <Widget>[
                GestureDetector(
                  onTap: (){
                    pickImage();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width-250,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6)
                    ),
                    child: Text(
                      'Capture a Picture',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                GestureDetector(
                  onTap: (){
                    pickGalleryImage();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width-250,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6)
                    ),
                    child: Text(
                      'Select a Picture',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

              ],),
            )
          ],
        ),
      ),
    );
  }
}
