// ignore_for_file: public_member_api_docs, sort_constructors_first
class Constant {
  static BackgroundModel backgroundModel = BackgroundModel(
    value: 'assets/images/im_background_dashboard.jpg',
    type: BackgroundType.image,
    // value: '#FFFFFF',
    // type: BackgroundType.color,
  );
}

class BackgroundModel {
  String? value;
  BackgroundType? type;
  BackgroundModel({
    this.value,
    this.type,
  });
}

enum BackgroundType {
  image,
  color,
}
