import 'package:flutter_easyloading/flutter_easyloading.dart';

class Utils{
  static void showLoader({String status = "loading ....."}) async {
    await Future.delayed(const Duration(milliseconds: 1));
    EasyLoading.show(status: status);
  }

  static void hideLoader() {
    EasyLoading.dismiss();
  }
}