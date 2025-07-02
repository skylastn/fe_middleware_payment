import 'dart:convert';

class DuitkuOrder {
  DuitkuOrderRequest? request;
  DuitkuOrderResponse? response;
  DuitkuOrderCallback? callback;
  DuitkuOrder({
    this.request,
    this.response,
    this.callback,
  });

  factory DuitkuOrder.fromMap(Map<String, dynamic> json) => DuitkuOrder(
        request: json['request'] == null
            ? null
            : DuitkuOrderRequest.fromMap(json['request']),
        response: json['response'] == null
            ? null
            : DuitkuOrderResponse.fromMap(json['response']),
        callback: json['callback'],
      );

  Map<String, dynamic> toMap() => {
        'request': request?.toMap(),
        'response': response?.toMap(),
        'callback': callback,
      };
}

DuitkuOrderResponse duitkuOrderResponseFromMap(String str) =>
    DuitkuOrderResponse.fromMap(json.decode(str));

String duitkuOrderResponseToMap(DuitkuOrderResponse data) =>
    json.encode(data.toMap());

class DuitkuOrderResponse {
  String? merchantCode;
  String? reference;
  String? paymentUrl;
  String? qrString;
  String? vaNumber;
  String? amount;
  String? statusCode;
  String? statusMessage;

  DuitkuOrderResponse({
    this.merchantCode,
    this.reference,
    this.paymentUrl,
    this.qrString,
    this.vaNumber,
    this.amount,
    this.statusCode,
    this.statusMessage,
  });

  DuitkuOrderResponse copyWith({
    String? merchantCode,
    String? reference,
    String? paymentUrl,
    String? qrString,
    String? vaNumber,
    String? amount,
    String? statusCode,
    String? statusMessage,
  }) =>
      DuitkuOrderResponse(
        merchantCode: merchantCode ?? this.merchantCode,
        reference: reference ?? this.reference,
        paymentUrl: paymentUrl ?? this.paymentUrl,
        qrString: qrString ?? this.qrString,
        vaNumber: vaNumber ?? this.vaNumber,
        amount: amount ?? this.amount,
        statusCode: statusCode ?? this.statusCode,
        statusMessage: statusMessage ?? this.statusMessage,
      );

  factory DuitkuOrderResponse.fromMap(Map<String, dynamic> json) =>
      DuitkuOrderResponse(
        merchantCode: json['merchantCode'],
        reference: json['reference'],
        paymentUrl: json['paymentUrl'],
        qrString: json['qrString'],
        vaNumber: json['vaNumber'],
        amount: json['amount'],
        statusCode: json['statusCode'],
        statusMessage: json['statusMessage'],
      );

  Map<String, dynamic> toMap() => {
        'merchantCode': merchantCode,
        'reference': reference,
        'paymentUrl': paymentUrl,
        'qrString': qrString,
        'vaNumber': vaNumber,
        'amount': amount,
        'statusCode': statusCode,
        'statusMessage': statusMessage,
      };
}

DuitkuOrderRequest duitkuOrderRequestFromMap(String str) =>
    DuitkuOrderRequest.fromMap(json.decode(str));

String duitkuOrderRequestToMap(DuitkuOrderRequest data) =>
    json.encode(data.toMap());

class DuitkuOrderRequest {
  String? merchantCode;
  String? signature;
  int? paymentAmount;
  String? merchantOrderId;
  String? productDetails;
  String? additionalParam;
  String? merchantUserInfo;
  String? customerVaName;
  String? email;
  String? phoneNumber;
  List<ItemDetail>? itemDetails;
  CustomerDetail? customerDetail;
  String? callbackUrl;
  String? returnUrl;
  int? expiryPeriod;
  String? paymentMethod;

  DuitkuOrderRequest({
    this.merchantCode,
    this.signature,
    this.paymentAmount,
    this.merchantOrderId,
    this.productDetails,
    this.additionalParam,
    this.merchantUserInfo,
    this.customerVaName,
    this.email,
    this.phoneNumber,
    this.itemDetails,
    this.customerDetail,
    this.callbackUrl,
    this.returnUrl,
    this.expiryPeriod,
    this.paymentMethod,
  });

  DuitkuOrderRequest copyWith({
    String? merchantCode,
    String? signature,
    int? paymentAmount,
    String? merchantOrderId,
    String? productDetails,
    String? additionalParam,
    String? merchantUserInfo,
    String? customerVaName,
    String? email,
    String? phoneNumber,
    List<ItemDetail>? itemDetails,
    CustomerDetail? customerDetail,
    String? callbackUrl,
    String? returnUrl,
    int? expiryPeriod,
    String? paymentMethod,
  }) =>
      DuitkuOrderRequest(
        merchantCode: merchantCode ?? this.merchantCode,
        signature: signature ?? this.signature,
        paymentAmount: paymentAmount ?? this.paymentAmount,
        merchantOrderId: merchantOrderId ?? this.merchantOrderId,
        productDetails: productDetails ?? this.productDetails,
        additionalParam: additionalParam ?? this.additionalParam,
        merchantUserInfo: merchantUserInfo ?? this.merchantUserInfo,
        customerVaName: customerVaName ?? this.customerVaName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        itemDetails: itemDetails ?? this.itemDetails,
        customerDetail: customerDetail ?? this.customerDetail,
        callbackUrl: callbackUrl ?? this.callbackUrl,
        returnUrl: returnUrl ?? this.returnUrl,
        expiryPeriod: expiryPeriod ?? this.expiryPeriod,
        paymentMethod: paymentMethod ?? this.paymentMethod,
      );

  factory DuitkuOrderRequest.fromMap(Map<String, dynamic> json) =>
      DuitkuOrderRequest(
        merchantCode: json['merchantCode'],
        signature: json['signature'],
        paymentAmount: json['paymentAmount'],
        merchantOrderId: json['merchantOrderId'],
        productDetails: json['productDetails'],
        additionalParam: json['additionalParam'],
        merchantUserInfo: json['merchantUserInfo'],
        customerVaName: json['customerVaName'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        itemDetails: json['itemDetails'] == null
            ? []
            : List<ItemDetail>.from(
                json['itemDetails']!.map((x) => ItemDetail.fromMap(x))),
        customerDetail: json['customerDetail'] == null
            ? null
            : CustomerDetail.fromMap(json['customerDetail']),
        callbackUrl: json['callbackUrl'],
        returnUrl: json['returnUrl'],
        expiryPeriod: json['expiryPeriod'],
        paymentMethod: json['paymentMethod'],
      );

  Map<String, dynamic> toMap() => {
        'merchantCode': merchantCode,
        'signature': signature,
        'paymentAmount': paymentAmount,
        'merchantOrderId': merchantOrderId,
        'productDetails': productDetails,
        'additionalParam': additionalParam,
        'merchantUserInfo': merchantUserInfo,
        'customerVaName': customerVaName,
        'email': email,
        'phoneNumber': phoneNumber,
        'itemDetails': itemDetails == null
            ? []
            : List<dynamic>.from(itemDetails!.map((x) => x.toMap())),
        'customerDetail': customerDetail?.toMap(),
        'callbackUrl': callbackUrl,
        'returnUrl': returnUrl,
        'expiryPeriod': expiryPeriod,
        'paymentMethod': paymentMethod,
      };
}

class CustomerDetail {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  IngAddress? billingAddress;
  IngAddress? shippingAddress;

  CustomerDetail({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.billingAddress,
    this.shippingAddress,
  });

  CustomerDetail copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    IngAddress? billingAddress,
    IngAddress? shippingAddress,
  }) =>
      CustomerDetail(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        billingAddress: billingAddress ?? this.billingAddress,
        shippingAddress: shippingAddress ?? this.shippingAddress,
      );

  factory CustomerDetail.fromMap(Map<String, dynamic> json) => CustomerDetail(
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        billingAddress: json['billingAddress'] == null
            ? null
            : IngAddress.fromMap(json['billingAddress']),
        shippingAddress: json['shippingAddress'] == null
            ? null
            : IngAddress.fromMap(json['shippingAddress']),
      );

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'billingAddress': billingAddress?.toMap(),
        'shippingAddress': shippingAddress?.toMap(),
      };
}

class IngAddress {
  String? firstName;
  String? lastName;
  dynamic address;
  String? city;
  String? postalCode;
  String? phone;
  String? countryCode;

  IngAddress({
    this.firstName,
    this.lastName,
    this.address,
    this.city,
    this.postalCode,
    this.phone,
    this.countryCode,
  });

  IngAddress copyWith({
    String? firstName,
    String? lastName,
    dynamic address,
    String? city,
    String? postalCode,
    String? phone,
    String? countryCode,
  }) =>
      IngAddress(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        address: address ?? this.address,
        city: city ?? this.city,
        postalCode: postalCode ?? this.postalCode,
        phone: phone ?? this.phone,
        countryCode: countryCode ?? this.countryCode,
      );

  factory IngAddress.fromMap(Map<String, dynamic> json) => IngAddress(
        firstName: json['firstName'],
        lastName: json['lastName'],
        address: json['address'],
        city: json['city'],
        postalCode: json['postalCode'],
        phone: json['phone'],
        countryCode: json['countryCode'],
      );

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'city': city,
        'postalCode': postalCode,
        'phone': phone,
        'countryCode': countryCode,
      };
}

class ItemDetail {
  String? name;
  int? price;
  int? quantity;

  ItemDetail({
    this.name,
    this.price,
    this.quantity,
  });

  ItemDetail copyWith({
    String? name,
    int? price,
    int? quantity,
  }) =>
      ItemDetail(
        name: name ?? this.name,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
      );

  factory ItemDetail.fromMap(Map<String, dynamic> json) => ItemDetail(
        name: json['name'],
        price: json['price'],
        quantity: json['quantity'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'quantity': quantity,
      };
}

DuitkuOrderCallback duitkuOrderCallbackFromMap(String str) =>
    DuitkuOrderCallback.fromMap(json.decode(str));

String duitkuOrderCallbackToMap(DuitkuOrderCallback data) =>
    json.encode(data.toMap());

class DuitkuOrderCallback {
  String? merchantCode;
  String? reference;
  String? paymentUrl;
  String? qrString;
  String? amount;
  String? statusCode;
  String? statusMessage;

  DuitkuOrderCallback({
    this.merchantCode,
    this.reference,
    this.paymentUrl,
    this.qrString,
    this.amount,
    this.statusCode,
    this.statusMessage,
  });

  DuitkuOrderCallback copyWith({
    String? merchantCode,
    String? reference,
    String? paymentUrl,
    String? qrString,
    String? amount,
    String? statusCode,
    String? statusMessage,
  }) =>
      DuitkuOrderCallback(
        merchantCode: merchantCode ?? this.merchantCode,
        reference: reference ?? this.reference,
        paymentUrl: paymentUrl ?? this.paymentUrl,
        qrString: qrString ?? this.qrString,
        amount: amount ?? this.amount,
        statusCode: statusCode ?? this.statusCode,
        statusMessage: statusMessage ?? this.statusMessage,
      );

  factory DuitkuOrderCallback.fromMap(Map<String, dynamic> json) =>
      DuitkuOrderCallback(
        merchantCode: json['merchantCode'],
        reference: json['reference'],
        paymentUrl: json['paymentUrl'],
        qrString: json['qrString'],
        amount: json['amount'],
        statusCode: json['statusCode'],
        statusMessage: json['statusMessage'],
      );

  Map<String, dynamic> toMap() => {
        'merchantCode': merchantCode,
        'reference': reference,
        'paymentUrl': paymentUrl,
        'qrString': qrString,
        'amount': amount,
        'statusCode': statusCode,
        'statusMessage': statusMessage,
      };
}
