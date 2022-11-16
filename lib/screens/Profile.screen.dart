import 'dart:math';

import 'package:appchat/stores/AuthStore.dart';
import 'package:appchat/widgets/ImageUpload.dart';
import 'package:flutter/material.dart';
import '../utils/data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.bottomRight,
                child: buildSettingButton(context),
              ),
              TextButton(
                  onPressed: () => {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const ImageUpload();
                            },
                          ),
                        )
                      },
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: AuthStore.photoUrl != null
                            ? NetworkImage(AuthStore.photoUrl as String)
                            : const AssetImage(
                                    'assets/images/noImageAvailable.png')
                                as ImageProvider,
                        radius: 50,
                      )
                    ],
                  )),
              const SizedBox(height: 10),
              Text(
                AuthStore.displayName != null
                    ? AuthStore.displayName as String
                    : 'username',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                "Status should be here",
                style: TextStyle(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey)),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                    child: const Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildCategory("Posts"),
                    _buildCategory("Friends"),
                    _buildCategory("Groups"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                padding: const EdgeInsets.all(5),
                itemCount: 15,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 200 / 200,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      "assets/images/cm${random.nextInt(2) + 1}.jpg",
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildSettingButton(BuildContext context) {
    const List<String> list = <String>[
      'Sign Out',
    ];
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        value: "signout",
        onTap: () {
          AuthStore.signOut(context);
        },
        child: const Text("Sign Out"),
      ),
    ];
    String dropdownValue = list.first;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            icon: const Icon(Icons.settings),
            elevation: 16,
            onChanged: (String? value) {},
            items: menuItems,
          ),
        ));
  }

  Widget _buildCategory(String title) {
    return Column(
      children: <Widget>[
        Text(
          random.nextInt(10000).toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(),
        ),
      ],
    );
  }
}
