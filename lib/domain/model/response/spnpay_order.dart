// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

SpnPayOrderResponse spnPayOrderResponseFromJson(String str) =>
    SpnPayOrderResponse.fromJson(json.decode(str));

String spnPayOrderResponseToJson(SpnPayOrderResponse data) =>
    json.encode(data.toJson());

class SpnPayOrder {
  SpnPayOrderResponse? response;
  SpnPayOrderRequest? request;
  String? callback;
  SpnPayOrder({
    this.request,
    this.response,
    this.callback,
  });

  factory SpnPayOrder.fromJson(Map<String, dynamic> json) => SpnPayOrder(
        request: json["request"] == null
            ? null
            : SpnPayOrderRequest.fromJson(json["request"]),
        response: json["response"] == null
            ? null
            : SpnPayOrderResponse.fromJson(json["response"]),
        callback: json["callback"],
      );

  Map<String, dynamic> toJson() => {
        "request": request?.toJson(),
        "response": response?.toJson(),
        'callback': callback,
      };
}

class SpnPayOrderResponse {
  String id;
  String merchantRef;
  String status;
  String feePayer;
  String amount;
  int fee;
  int totalAmount;
  DateTime expiredDate;
  AdditionalInfo additionalInfo;
  VirtualAccount virtualAccount;
  Qris qris;
  EWallet eWallet;
  Retail retail;
  CreditCard creditCard;

  SpnPayOrderResponse({
    required this.id,
    required this.merchantRef,
    required this.status,
    required this.feePayer,
    required this.amount,
    required this.fee,
    required this.totalAmount,
    required this.expiredDate,
    required this.additionalInfo,
    required this.virtualAccount,
    required this.qris,
    required this.eWallet,
    required this.retail,
    required this.creditCard,
  });

  factory SpnPayOrderResponse.fromJson(Map<String, dynamic> json) =>
      SpnPayOrderResponse(
        id: json["id"],
        merchantRef: json["merchantRef"],
        status: json["status"],
        feePayer: json["feePayer"],
        amount: json["amount"],
        fee: json["fee"],
        totalAmount: json["totalAmount"],
        expiredDate: DateTime.parse(json["expiredDate"]),
        additionalInfo: AdditionalInfo.fromJson(json["additionalInfo"]),
        virtualAccount: VirtualAccount.fromJson(json["virtualAccount"]),
        qris: Qris.fromJson(json["qris"]),
        eWallet: EWallet.fromJson(json["eWallet"]),
        retail: Retail.fromJson(json["retail"]),
        creditCard: CreditCard.fromJson(json["creditCard"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "merchantRef": merchantRef,
        "status": status,
        "feePayer": feePayer,
        "amount": amount,
        "fee": fee,
        "totalAmount": totalAmount,
        "expiredDate": expiredDate.toIso8601String(),
        "additionalInfo": additionalInfo.toJson(),
        "virtualAccount": virtualAccount.toJson(),
        "qris": qris.toJson(),
        "eWallet": eWallet.toJson(),
        "retail": retail.toJson(),
        "creditCard": creditCard.toJson(),
      };
}

SpnPayOrderRequest spnPayOrderRequestFromJson(String str) =>
    SpnPayOrderRequest.fromJson(json.decode(str));

String spnPayOrderRequestToJson(SpnPayOrderRequest data) =>
    json.encode(data.toJson());

class SpnPayOrderRequest {
  bool singleUse;
  String type;
  String reference;
  int amount;
  int expiryMinutes;
  String viewName;
  AdditionalInfo additionalInfo;

  SpnPayOrderRequest({
    required this.singleUse,
    required this.type,
    required this.reference,
    required this.amount,
    required this.expiryMinutes,
    required this.viewName,
    required this.additionalInfo,
  });

  factory SpnPayOrderRequest.fromJson(Map<String, dynamic> json) =>
      SpnPayOrderRequest(
        singleUse: json["singleUse"],
        type: json["type"],
        reference: json["reference"],
        amount: json["amount"],
        expiryMinutes: json["expiryMinutes"],
        viewName: json["viewName"],
        additionalInfo: AdditionalInfo.fromJson(json["additionalInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "singleUse": singleUse,
        "type": type,
        "reference": reference,
        "amount": amount,
        "expiryMinutes": expiryMinutes,
        "viewName": viewName,
        "additionalInfo": additionalInfo.toJson(),
      };
}

class AdditionalInfo {
  String callback;

  AdditionalInfo({
    required this.callback,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
        callback: json["callback"],
      );

  Map<String, dynamic> toJson() => {
        "callback": callback,
      };
}

class CreditCard {
  String url;

  CreditCard({
    required this.url,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) => CreditCard(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}

class EWallet {
  String viewName;
  String channel;
  String url;

  EWallet({
    required this.viewName,
    required this.channel,
    required this.url,
  });

  factory EWallet.fromJson(Map<String, dynamic> json) => EWallet(
        viewName: json["viewName"],
        channel: json["channel"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "viewName": viewName,
        "channel": channel,
        "url": url,
      };
}

class Qris {
  String content;
  String url;

  Qris({
    required this.content,
    required this.url,
  });

  factory Qris.fromJson(Map<String, dynamic> json) => Qris(
        content: json["content"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "url": url,
      };
}

class Retail {
  String viewName;
  String channel;
  String paymentCode;

  Retail({
    required this.viewName,
    required this.channel,
    required this.paymentCode,
  });

  factory Retail.fromJson(Map<String, dynamic> json) => Retail(
        viewName: json["viewName"],
        channel: json["channel"],
        paymentCode: json["paymentCode"],
      );

  Map<String, dynamic> toJson() => {
        "viewName": viewName,
        "channel": channel,
        "paymentCode": paymentCode,
      };
}

class VirtualAccount {
  String bankCode;
  String vaNumber;
  String viewName;

  VirtualAccount({
    required this.bankCode,
    required this.vaNumber,
    required this.viewName,
  });

  factory VirtualAccount.fromJson(Map<String, dynamic> json) => VirtualAccount(
        bankCode: json["bankCode"],
        vaNumber: json["vaNumber"],
        viewName: json["viewName"],
      );

  Map<String, dynamic> toJson() => {
        "bankCode": bankCode,
        "vaNumber": vaNumber,
        "viewName": viewName,
      };
}
