import 'package:flutter/cupertino.dart';
import 'package:cobes_marketplace/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:cobes_marketplace/data/model/api_response.dart';
import 'package:cobes_marketplace/features/contact_us/domain/models/contact_us_body.dart';
import 'package:cobes_marketplace/features/contact_us/domain/services/contact_us_service_interface.dart';
import 'package:cobes_marketplace/helper/api_checker.dart';
import 'package:cobes_marketplace/localization/language_constrants.dart';
import 'package:cobes_marketplace/main.dart';

class ContactUsController extends ChangeNotifier{
  ContactUsServiceInterface contactUsServiceInterface;
  ContactUsController({required this.contactUsServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> contactUs(ContactUsBody contactUsBody) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await contactUsServiceInterface.add(contactUsBody);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      showCustomSnackBar('${getTranslated('message_sent_successfully', Get.context!)}', Get.context!, isError: false);
    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();

    return apiResponse.response?.statusCode == 200;
  }

}