import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../domain/model/state_status.dart';
import '../constants/colors.dart';

class StateWidget {
  Widget initial({
    required StateStatus stateStatus,
    required body,
    String? emptyMsg,
    String? errorMsg,
  }) {
    if (stateStatus == StateStatus.loading) {
      return loadingWidget();
    }
    if (stateStatus == StateStatus.empty) {
      return emptyWidget(msg: emptyMsg);
    }
    if (stateStatus == StateStatus.error) {
      return errorWidget(msg: 'Empty Field');
    }
    if (stateStatus == StateStatus.success) {
      return body;
    }
    return Container();
  }

  Widget emptyWidget({String? msg}) {
    return Center(child: Text(msg ?? 'Empty'));
  }

  Widget errorWidget({String? msg}) {
    return Center(child: Text(msg ?? 'Error'));
  }

  Widget loadingWidget(
      {double? height, BorderRadius? borderRadius, String loadingText = ''}) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          customLoadingWidget(
            text: (loadingText.isNotEmpty) ? loadingText : '',
            color: ColorConstants.secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget customLoadingWidget({String text = '', Color color = Colors.blue}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
          child: SpinKitDoubleBounce(
            color: color,
            // size: 50.0,
          ),
        ),
        if (text.isNotEmpty)
          const SizedBox(
            height: 15,
          ),
        if (text.isNotEmpty)
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 16,
              // fontFamily: Global.font,
            ),
          )
      ],
    );
  }
}
