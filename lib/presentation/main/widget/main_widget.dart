import '../payment/controllers/payment.state.dart';
import 'package:flutter/material.dart';

import '../../../shared/widget/picture_handler_widget.dart';

Widget itemWidget({
  required String title,
  required String subTitle,
  Widget? endWidget,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 6),
      Row(
        mainAxisAlignment: endWidget == null
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              subTitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          if (endWidget != null) endWidget,
        ],
      ),
      const SizedBox(height: 6),
      const Divider(thickness: 1),
      const SizedBox(height: 8),
    ],
  );
}

Widget paymentMethodWidget({
  required PaymentCategory paymentCategory,
  required Function(PaymentMethod) callback,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        paymentCategory.title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 6),
      const Divider(thickness: 1),
      const SizedBox(height: 6),
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: paymentCategory.paymentMethod.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () => callback(paymentCategory.paymentMethod[index]),
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
            height: 40,
            width: 50,
            child: PictureHandlerWidget().pictureHandler(
              paymentCategory.paymentMethod[index].imageUrl,
            ),
          ),
          title: Text(
            paymentCategory.paymentMethod[index].name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(paymentCategory.paymentMethod[index].description),
          trailing: const Icon(
            Icons.arrow_forward_ios_sharp,
          ),
        ),
      ),
      const SizedBox(height: 6),
      const Divider(thickness: 1),
      const SizedBox(height: 8),
    ],
  );
}
