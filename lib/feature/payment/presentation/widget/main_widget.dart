import 'package:flutter/material.dart';

import '../../../../shared/constants/colors.dart';
import '../../../../shared/widgets/picture_handler_widget.dart';
import '../../domain/model/response/payment_category.dart';
import '../../domain/model/response/payment_method.dart';

Widget itemWidget({
  required String title,
  required String subTitle,
  Widget? endWidget,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: ColorConstants.surfaceMuted,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: ColorConstants.border, width: 0.8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.textSecondary,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subTitle.isEmpty ? '-' : subTitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (endWidget != null)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: endWidget,
          ),
      ],
    ),
  );
}

Widget paymentMethodWidget({
  required PaymentCategory paymentCategory,
  required Function(PaymentResponse) callback,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 10, top: 12),
        child: Text(
          paymentCategory.title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: ColorConstants.textPrimary,
            letterSpacing: 0.1,
          ),
        ),
      ),
      ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: paymentCategory.paymentMethods.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = paymentCategory.paymentMethods[index];
          final imgSource = item.imageUrl ?? item.image;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => callback(item),
              child: Ink(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorConstants.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ColorConstants.border, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x060F172A),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 48,
                      width: 56,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: ColorConstants.surfaceMuted,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: ColorConstants.border,
                          width: 0.8,
                        ),
                      ),
                      child: Center(
                        child: PictureHandlerWidget().pictureHandler(
                          imgSource,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name ?? item.key ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            paymentCategory.detail.isEmpty
                                ? 'Tanpa Biaya Layanan'
                                : paymentCategory.detail,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: ColorConstants.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 22,
                      color: ColorConstants.textTertiary,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 8),
    ],
  );
}
