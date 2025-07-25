import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mdw/core/services/app_function_services.dart';
import 'package:mdw/features/auth/models/login_user_model.dart';
import 'package:mdw/features/delivery/models/orders_model.dart' as current;
import 'package:mdw/features/delivery/models/prev_orders_model.dart'
    as previousart;

class OrderDetailsController extends ChangeNotifier {
  final current.Order? order;
  final previousart.PreviousOrder? prevOrder;

  OrderDetailsController({this.order, this.prevOrder}) {
    _init();
  }

  bool isPinVerified = false;
  bool isLoading = false;
  List<XFile> selectedImages = [];

  bool get isCurrentOrder => order != null;

  LoginUserModel? rider;

  String get orderId => isCurrentOrder ? order!.orderId : prevOrder!.orderId;

  DateTime get orderDate {
    if (isCurrentOrder) {
      return order!.orderDate;
    } else {
      return DateFormat("dd-MM-yyyy hh:mm a").parse(prevOrder!.orderDate);
    }
  }

  String get customerName =>
      isCurrentOrder ? order!.customer.name : prevOrder!.customer.name;

  String get customerPhone => isCurrentOrder
      ? order!.customer.phoneNumber.toString()
      : prevOrder!.customer.phoneNumber.toString();

  String get formattedPhoneNumber =>
      "+91 ${customerPhone.substring(0, 5)} ${customerPhone.substring(5)}";

  String get customerAddress => isCurrentOrder
      ? order!.customer.address.toString().replaceAll(", ", "\n")
      : prevOrder!.customer.address.toString().replaceAll(", ", "\n");

  String get bin =>
      (isCurrentOrder ? order!.binNumber : prevOrder!.binNumber).toString();

  String get binColor => isCurrentOrder ? order!.binColor : prevOrder!.binColor;

  List<dynamic> get items => isCurrentOrder ? order!.items : prevOrder!.items;

  Future<void> viewOnMap(BuildContext context) async {
    final address = isCurrentOrder
        ? order!.customer.address.toString()
        : prevOrder!.customer.address.toString();
    await AppFunctions.launchMap(context, address);
  }

  Future<void> _init() async {
    isLoading = true;
    notifyListeners();

    // Add init logic here if needed.

    isLoading = false;
    notifyListeners();
  }
}
