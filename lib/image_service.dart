import 'package:appwrite/appwrite.dart';
import 'package:flutter_backblaze/utils.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  Client _client = Client();
  late Storage _storage;
  final _appConstant = AppConstant();

  ImageService() {
    _init();
  }

  //initialize the application
  _init() async {
    _client
        .setEndpoint(_appConstant.endpoint)
        .setProject(_appConstant.projectId);

    _storage = Storage(_client);

    //get current session
    Account account = Account(_client);

    try {
      await account.get();
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        account
            .createAnonymousSession()
            .then((value) => value)
            .catchError((e) => e);
      }
    }
  }

  Future<List<ImageModel>> getImages() async {
    try {
      var data = await _storage.listFiles(bucketId: _appConstant.bucketId);

      var imageList = data.files
          .map((doc) => ImageModel($id: doc.$id, bucketId: doc.bucketId))
          .toList();
      return imageList;
    } catch (e) {
      throw Exception('Error getting list of images');
    }
  }

  Future saveImage(XFile file) async {
    try {
      var data = await _storage.createFile(
        bucketId: _appConstant.bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path, filename: file.name),
      );
      return data;
    } catch (e) {
      throw Exception('Error saving image');
    }
  }

  Future getImagePreview(String id) async {
    try {
      var data =
          _storage.getFilePreview(bucketId: _appConstant.bucketId, fileId: id);
      return data;
    } catch (e) {
      throw Exception('Error getting image preview');
    }
  }
}
