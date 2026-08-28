class Constant {
  static BackgroundModel backgroundModel = BackgroundModel(
    value: 'assets/images/im_background_dashboard.jpg',
    type: BackgroundType.image,
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
