import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navigation_assignment_2/contacts.dart';
import 'package:navigation_assignment_2/pick%20image/gallery.dart';
import 'package:navigation_assignment_2/login_screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerNavigation extends StatefulWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;
  final GoogleSignInAccount? user;

  const DrawerNavigation({
    required this.onItemSelected,
    required this.selectedIndex,
    required this.user,
  });

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  Uint8List? _image;
  File? selectedImage;
  final String imageKey = 'selected_image';

  @override
  void initState() {
    super.initState();
    loadPersistedData(); // Load profile picture from SharedPreferences
  }

  Future<void> loadPersistedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imageString = prefs.getString(imageKey);

    if (imageString != null) {
      setState(() {
        selectedImage = File(imageString);
      });
    }
  }

  Future<void> persistSelectedImage() async {
    if (selectedImage != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(imageKey, selectedImage!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userName = widget.user?.displayName;
    String? userEmail = widget.user?.email;

    return Drawer(
      width: 300.0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userName ?? ''),
            accountEmail: Text(userEmail ?? ''),
            currentAccountPicture: imageProfile(),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 22, 168, 80),
            ),
          ),
          _buildListTile('Home', Icons.home, 0),
          _buildListTile('Calculator', Icons.calculate, 1),
          _buildListTile('About', Icons.info, 2),
          // _buildListTile('Logout', Icons.logout, 5),
          _buildListTile('Contacts', Icons.contact_emergency, 3),
          _buildListTile('Gallery', Icons.photo_album, 4),
        ],
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          selectedImage != null
              ? CircleAvatar(
                  radius: 100.0,
                  backgroundImage: FileImage(selectedImage!),
                )
              : CircleAvatar(
                  radius: 100.0,
                  backgroundImage: AssetImage('assets/images/bg2.jpg'),
                ),
          Positioned(
            bottom: -5.0,
            right: -5.0,
            child: IconButton(
              onPressed: () {
                showImagePickerOption(context);
              },
              icon: const Icon(
                Icons.add_a_photo,
                color: Color.fromARGB(255, 18, 1, 67),
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 150, 0, 42),
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromGallery();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text("Gallery")
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromCamera();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 70,
                          ),
                          Text("Camera")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnImage == null) {
      return;
    }

    try {
      final imageFile = File(returnImage.path);
      if (imageFile.existsSync()) {
        setState(() {
          selectedImage = imageFile;
        });
        persistSelectedImage();
      }
    } catch (e) {
      print('Error reading image file: $e');
    }

    Navigator.of(context).pop();
  }

  Future<void> _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnImage == null) {
      return;
    }

    try {
      final imageFile = File(returnImage.path);
      if (imageFile.existsSync()) {
        setState(() {
          selectedImage = imageFile;
        });
        persistSelectedImage();
      }
    } catch (e) {
      print('Error reading image file: $e');
    }

    Navigator.of(context).pop();
  }

  Widget _buildListTile(String title, IconData icon, int index) {
    bool isSelected = widget.selectedIndex == index;
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: () {
        if (title == 'Logout') {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
          );
        } else if (title == 'Contacts') {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Contacts()),
          );
        } else if (title == 'Gallery') {
          Navigator.pop(context);
          // Handle Gallery navigation
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GalleryPage()),
          );
        } else {
          widget.onItemSelected(index);
          // Navigator.pop(context);
        }
      },
      selected: isSelected,
      tileColor: isSelected ? Colors.green.withOpacity(0.2) : null,
      selectedTileColor: Colors.green.withOpacity(0.2),
    );
  }
}
