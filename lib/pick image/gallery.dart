import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<ImageFile> images = [];

  @override
  void initState() {
    super.initState();
    loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Handle selection
              List<ImageFile> selectedImages =
                  images.where((image) => image.isSelected).toList();
              Navigator.pop(context, selectedImages);
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              // Handle long press to select image
              setState(() {
                // Toggle selection state
                images[index].isSelected = !images[index].isSelected;
              });
            },
            child: Stack(
              children: [
                Image.file(
                  File(images[index].path),
                  fit: BoxFit.cover,
                ),
                if (images[index].isSelected)
                  Positioned(
                    top: 4.0,
                    right: 4.0,
                    child: Icon(
                      Icons.check_circle,
                      color: const Color.fromARGB(255, 92, 76, 175),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> loadAssets() async {
    try {
      final List<XFile>? result = await ImagePicker().pickMultiImage();
      if (result != null) {
        setState(() {
          // Initialize images list and set isSelected property to false for each image
          images = result
              .map((file) => ImageFile(path: file.path, isSelected: false))
              .toList();
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class ImageFile {
  final String path;
  bool isSelected;

  ImageFile({required this.path, required this.isSelected});
}

//code 2

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Gallery',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: GalleryPage(),
//     );
//   }
// }

// class GalleryPage extends StatefulWidget {
//   @override
//   _GalleryPageState createState() => _GalleryPageState();
// }

// class _GalleryPageState extends State<GalleryPage> {
//   List<File> _assets = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchAssets();
//   }

//   Future<void> _fetchAssets() async {
//     try {
//       // Fetch all images from the device's gallery
//       final List<XFile>? images = await ImagePicker().pickMultiImage();

//       if (images != null) {
//         List<File> imageFiles =
//             images.map((image) => File(image.path)).toList();
//         setState(() {
//           _assets = imageFiles;
//         });
//       }
//     } catch (e) {
//       print('Error fetching assets: $e');
//       // Handle the error (e.g., show a snackbar, display an error message)
//     }
//   }

//   void _onAssetTap(File asset) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FullScreenView(asset: asset),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Gallery'),
//       ),
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           crossAxisSpacing: 4.0,
//           mainAxisSpacing: 4.0,
//         ),
//         itemCount: _assets.length,
//         itemBuilder: (BuildContext context, int index) {
//           final asset = _assets[index];
//           return GestureDetector(
//             onTap: () => _onAssetTap(asset),
//             child: AssetThumbnail(asset: asset),
//           );
//         },
//       ),
//     );
//   }
// }

// class AssetThumbnail extends StatelessWidget {
//   final File asset;

//   const AssetThumbnail({required this.asset});

//   @override
//   Widget build(BuildContext context) {
//     return Image.file(
//       asset,
//       fit: BoxFit.cover,
//     );
//   }
// }

// class FullScreenView extends StatelessWidget {
//   final File asset;

//   const FullScreenView({required this.asset});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Full Screen View'),
//       ),
//       body: Center(
//         child: Hero(
//           tag: 'asset',
//           child: Image.file(asset),
//         ),
//       ),
//     );
//   }
// }

/// test code 3
///
///import 'dart:io';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Media Gallery',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MediaGallery(),
//     );
//   }
// }

// class MediaGallery extends StatefulWidget {
//   @override
//   _MediaGalleryState createState() => _MediaGalleryState();
// }

// class _MediaGalleryState extends State<MediaGallery> {
//   late List<FileSystemEntity> _mediaFiles;

//   @override
//   void initState() {
//     super.initState();
//     _mediaFiles = [];
//     _loadMediaFiles();
//   }

//   Future<void> _loadMediaFiles() async {
//     try {
//       final picturesDir = Directory('/storage/emulated/0/DCIM/Camera');
//       final videosDir = Directory('/storage/emulated/0/DCIM/Camera');

//       if (!await picturesDir.exists() || !await videosDir.exists()) {
//         throw FileSystemException("Directory not found");
//       }

//       final pictureFiles = picturesDir.listSync(recursive: true);
//       final videoFiles = videosDir.listSync(recursive: true);

//       setState(() {
//         _mediaFiles.addAll(pictureFiles);
//         _mediaFiles.addAll(videoFiles);
//       });
//     } catch (e) {
//       print("Error loading media files: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Media Gallery'),
//       ),
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           crossAxisSpacing: 4.0,
//           mainAxisSpacing: 4.0,
//         ),
//         itemCount: _mediaFiles.length,
//         itemBuilder: (context, index) {
//           return MediaTile(file: _mediaFiles[index]);
//         },
//       ),
//     );
//   }
// }

// class MediaTile extends StatelessWidget {
//   final FileSystemEntity file;

//   MediaTile({required this.file});

//   @override
//   Widget build(BuildContext context) {
//     if (file.path.endsWith('.mp4')) {
//       return VideoTile(videoFile: file);
//     } else if (file.path.endsWith('.jpg') || file.path.endsWith('.png')) {
//       return ImageTile(imageFile: file);
//     } else {
//       return Container(); // Handle other file types if needed
//     }
//   }
// }

// class ImageTile extends StatelessWidget {
//   final FileSystemEntity imageFile;

//   ImageTile({required this.imageFile});

//   @override
//   Widget build(BuildContext context) {
//     return GridTile(
//       child: Image.file(
//         File(imageFile.path),
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }

// class VideoTile extends StatefulWidget {
//   final FileSystemEntity videoFile;

//   VideoTile({required this.videoFile});

//   @override
//   _VideoTileState createState() => _VideoTileState();
// }

// class _VideoTileState extends State<VideoTile> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.file(File(widget.videoFile.path))
//       ..initialize().then((_) {
//         setState(() {});
//       }).catchError((error) {
//         print("Error initializing video player: $error");
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GridTile(
//       child: _controller.value.isInitialized
//           ? AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             )
//           : Container(),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }
