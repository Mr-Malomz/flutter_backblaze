class AppConstant {
  final String projectId = "PROJECT ID GOES HERE";
  final String bucketId = "BUCKET ID GOES HERE";
  final String endpoint = "http://<MACBOOK IP GOES HERE>/v1";
}

class ImageModel {
  String $id;
  String bucketId;

  ImageModel({
    required this.$id,
    required this.bucketId,
  });

  factory ImageModel.fromJson(Map<dynamic, dynamic> json) {
    return ImageModel($id: json['\$id'], bucketId: json['bucketId']);
  }
}
