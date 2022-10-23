import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //application state
  bool isDarkMode = false;
  bool isImageSelected = false;
  late Uint8List selectedImage;


  // methods
  setDarkMode(bool preferred_mode) async {
    setState(() {
      isDarkMode = preferred_mode;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("isDarkMode", preferred_mode);
  }

  getUserPreferences() async {
    print("=====++GETTTING prefs");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var selectedMode = prefs.getBool("isDarkMode");

    if (selectedMode != null) {
      setState(() {
        isDarkMode = selectedMode;
      });
    }

    String selectedImageByteString = prefs.getString("selectedImage")!;

    if (selectedImageByteString != null) {
      //converting to byte array

      List<int> byteArray = [];
      List StringArray = selectedImageByteString.split(",");
      for (var x in StringArray) {
        byteArray.add(int.parse(x));
      }

      Uint8List parsedByteArray = Uint8List.fromList(byteArray);

      setState(() {
        selectedImage = parsedByteArray;
        isImageSelected = true;
      });
    }
  }

  selectImage() async {
    print("===============SLECTING FILE");
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        selectedImage = file.bytes!;
        isImageSelected = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String byteString = file.bytes!.toList().join(",");
      prefs.setString("selectedImage", byteString);

      print(byteString);
    } else {
      // User canceled the picker
    }
  }

// it will be automatically called on pageload
  @override
  void initState() {
    super.initState();

    getUserPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: isDarkMode == true ? Colors.black : Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Welcome",
                style: TextStyle(
                    color: isDarkMode == true ? Colors.white : Colors.black),
              ),
              ElevatedButton(
                  onPressed: () {
                    setDarkMode(true);
                  },
                  child: Text("Dark Mode")),
              ElevatedButton(
                  onPressed: () {
                    setDarkMode(false);
                  },
                  child: Text("Light Mode")),
              ElevatedButton(
                  onPressed: () {
                    selectImage();
                  },
                  child: Text("Select Image")),
              Container(
                child: isImageSelected == true
                    ? Image.memory(
                        selectedImage,
                        height: 150,
                      )
                    : Text("no image selected"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
