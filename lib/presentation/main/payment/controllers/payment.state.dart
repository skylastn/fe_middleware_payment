// ignore_for_file: public_member_api_docs, sort_constructors_first
class PaymentState {
  String orderId = '';
}

class PaymentCategory {
  String title;
  PaymentType paymentType;
  List<PaymentMethod> paymentMethod;
  PaymentCategory({
    required this.title,
    required this.paymentType,
    required this.paymentMethod,
  });
}

class PaymentMethod {
  String name;
  String description;
  String imageUrl;
  String paymentCode;
  PaymentInstruction paymentInstruction;
  PaymentMethod({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.paymentCode,
    required this.paymentInstruction,
  });
}

class PaymentInstruction {
  String detail;
  List<StepPaymentInstruction> stepPaymentInstruction;
  PaymentInstruction({
    required this.detail,
    required this.stepPaymentInstruction,
  });
}

class StepPaymentInstruction {
  String title;
  List<String> step;
  StepPaymentInstruction({
    required this.title,
    required this.step,
  });
}

enum PaymentType { creditCard, bankTransfer, eWallet, qris, retail, eBanking }
