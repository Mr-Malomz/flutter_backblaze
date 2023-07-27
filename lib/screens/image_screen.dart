import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_backblaze/image_service.dart';
import 'package:flutter_backblaze/utils.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late XFile file;
  late List<ImageModel> _images;
  var _service = ImageService();
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    _getImageList();
    super.initState();
  }

  _getImageList() {
    setState(() {
      _isLoading = true;
    });
    _service
        .getImages()
        .then((value) => {
              setState(() {
                _isLoading = false;
                _images = value;
              })
            })
        .catchError((_) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    });
  }

  _saveImage(XFile selectedFile) {
    _service.saveImage(selectedFile).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully!')),
      );
      _getImageList();
    }).catchError((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error uploading image!')),
      );
    });
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      _saveImage(image);
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.black,
          ))
        : _isError
            ? const Center(
                child: Text(
                  'Error getting images',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Appwrite + Backblaze'),
                  backgroundColor: Colors.black,
                ),
                body: _images.isNotEmpty
                    ? ListView.builder(
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: .5, color: Colors.grey),
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 45,
                                        width: 45,
                                        child: FutureBuilder(
                                          future: _service.getImagePreview(
                                              _images[index].$id),
                                          builder: (context, snapshot) {
                                            return snapshot.hasData &&
                                                    snapshot.data != null
                                                ? Image.memory(
                                                    snapshot.data,
                                                  )
                                                : const CircularProgressIndicator();
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        _images[index].$id,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No images uploaded yet. Click "+" button to upload',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _pickImage();
                  },
                  tooltip: 'upload image',
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.black,
                ),
              );
  }
}
