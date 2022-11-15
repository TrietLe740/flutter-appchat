import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/PostItem.dart';
import '../utils/data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (details) =>
          {FocusScope.of(context).requestFocus(FocusNode())},
      child: Scaffold(
        appBar: AppBar(
          title: const TextField(
            decoration: InputDecoration.collapsed(
              hintText: 'Tìm kiếm',
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.filter_list,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            Map post = posts[index];
            return PostItem(
              img: post['img'],
              name: post['name'],
              dp: post['dp'],
              time: post['time'],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Upload Your Story '),
                    ),
                    body: Center(
                      child: TextButton(
                        child: const Text('Upload'),
                        onPressed: () {
                          _pickImage();
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  void _pickImage() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      print("up");
    } catch (e) {
      print("Image picker error ");
    }
  }
}
