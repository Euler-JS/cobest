import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cobes_marketplace/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:cobes_marketplace/data/local/cache_response.dart';
import 'package:cobes_marketplace/data/model/api_response.dart';
import 'package:cobes_marketplace/features/maintenance/maintenance_screen.dart';
import 'package:cobes_marketplace/features/splash/domain/models/business_pages_model.dart';
import 'package:cobes_marketplace/features/splash/domain/models/config_model.dart';
import 'package:cobes_marketplace/features/splash/domain/services/splash_service_interface.dart';
import 'package:cobes_marketplace/helper/api_checker.dart';
import 'package:cobes_marketplace/main.dart';
import 'package:cobes_marketplace/utill/app_constants.dart';

class SplashController extends ChangeNotifier {
  final SplashServiceInterface? splashServiceInterface;
  SplashController({required this.splashServiceInterface});

  ConfigModel? _configModel;
  BaseUrls? _baseUrls;
  CurrencyList? _myCurrency;
  CurrencyList? _usdCurrency;
  CurrencyList? _defaultCurrency;
  int? _currencyIndex;
  bool _hasConnection = true;
  bool _fromSetting = false;
  bool _firstTimeConnectionCheck = true;
  bool _onOff = true;
  bool get onOff => _onOff;
  bool isConfigCall = false;

  ConfigModel? get configModel => _configModel;
  BaseUrls? get baseUrls => _baseUrls;
  CurrencyList? get myCurrency => _myCurrency;
  CurrencyList? get usdCurrency => _usdCurrency;
  CurrencyList? get defaultCurrency => _defaultCurrency;
  int? get currencyIndex => _currencyIndex;
  bool get hasConnection => _hasConnection;
  bool get fromSetting => _fromSetting;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  BuildContext? _buildContext;

  List<BusinessPageModel>? _defaultBusinessPages;
  List<BusinessPageModel>? get defaultBusinessPages => _defaultBusinessPages;

  List<BusinessPageModel>? _businessPages;
  List<BusinessPageModel>? get businessPages => _businessPages;

  Future<bool> initConfig(
    BuildContext context,
      Function(ConfigModel? configModel)? onLocalDataReceived,
      Function(ConfigModel? configModel)? onApiDataReceived,
      ) async {
    // final ThemeController themeController = Provider.of<ThemeController>(context, listen: false);

   var configLocalData =  await database.getCacheResponseById(AppConstants.configUri);

   bool localMaintainanceMode = false;

   isConfigCall = false;

   if(configLocalData != null) {
     _configModel = ConfigModel.fromJson(jsonDecode(configLocalData.response));

     localMaintainanceMode = (_configModel?.maintenanceModeData?.maintenanceStatus == 1 && _configModel?.maintenanceModeData?.selectedMaintenanceSystem?.customerApp == 1);

     String? currencyCode = splashServiceInterface!.getCurrency();

     for(CurrencyList currencyList in _configModel!.currencyList!) {
       if(currencyList.id == _configModel!.systemDefaultCurrency) {
         if(currencyCode == null || currencyCode.isEmpty) {
           currencyCode = currencyList.code;
         }
         _defaultCurrency = currencyList;
       }
       if(currencyList.code == 'USD') {
         _usdCurrency = currencyList;
       }
     }
     getCurrencyData(currencyCode);

     if(onLocalDataReceived != null) {
       onLocalDataReceived(configModel);
     }

   }

    _hasConnection = true;
    ApiResponseModel apiResponse = await splashServiceInterface!.getConfig();

    // _configModel = ConfigModel.fromJson(apiResponse.response!.data);
    bool isSuccess;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      isSuccess = true;
      _configModel = ConfigModel.fromJson(apiResponse.response!.data);
      isConfigCall = true;

      _baseUrls = ConfigModel.fromJson(apiResponse.response!.data).baseUrls;

      _configModel?.hasLocaldb = configLocalData != null;

      _configModel?.localMaintenanceMode = localMaintainanceMode;

      if(onApiDataReceived != null) {
        onApiDataReceived(configModel);
      }


      String? currencyCode = splashServiceInterface!.getCurrency();

      try{
        await FirebaseMessaging.instance.getToken();
        await FirebaseMessaging.instance.subscribeToTopic(AppConstants.maintenanceModeTopic);
      }catch (e) {
        debugPrint("====FirebaseException===>>$e");
      }

      // themeController.setThemeColor(
      //   primaryColor: ColorHelper.hexCodeToColor(_configModel?.primaryColorCode),
      //   secondaryColor: ColorHelper.hexCodeToColor(_configModel?.secondaryColorCode),
      // );


      for(CurrencyList currencyList in _configModel!.currencyList!) {
        if(currencyList.id == _configModel!.systemDefaultCurrency) {
          if(currencyCode == null || currencyCode.isEmpty) {
            currencyCode = currencyList.code;
          }
          _defaultCurrency = currencyList;
        }
        if(currencyList.code == 'USD') {
          _usdCurrency = currencyList;
        }
      }
      getCurrencyData(currencyCode);

      if(_configModel?.maintenanceModeData?.maintenanceStatus == 0){
        if(_configModel?.maintenanceModeData?.selectedMaintenanceSystem?.customerApp == 1 ) {
          if(_configModel?.maintenanceModeData?.maintenanceTypeAndDuration?.maintenanceDuration == 'customize') {

            DateTime now = DateTime.now();
            DateTime specifiedDateTime = DateTime.parse(_configModel!.maintenanceModeData!.maintenanceTypeAndDuration!.startDate!);

            Duration difference = specifiedDateTime.difference(now);

            if(difference.inMinutes > 0 && (difference.inMinutes < 60 || difference.inMinutes == 60)){
              _startTimer(specifiedDateTime);
            }

          }
        }
      }

      if(configLocalData != null) {
        await database.updateCacheResponse(AppConstants.configUri, CacheResponseCompanion(
          endPoint: const Value(AppConstants.configUri),
          header: Value(jsonEncode(apiResponse.response!.headers.map)),
          response: Value(jsonEncode(apiResponse.response!.data)),
        ));
      } else {
        await database.insertCacheResponse(
          CacheResponseCompanion(
            endPoint: const Value(AppConstants.configUri),
            header: Value(jsonEncode(apiResponse.response!.headers.map)),
            response: Value(jsonEncode(apiResponse.response!.data)),
          ),
        );
      }
      _configModel = ConfigModel.fromJson(apiResponse.response!.data);

      isSuccess = true;
    } else {
      isSuccess = false;
      ApiChecker.checkApi(apiResponse);
      if(apiResponse.error.toString() == 'Connection to API server failed due to internet connection') {
        _hasConnection = false;
      }else{
        showCustomSnackBar(apiResponse.error.toString(), Get.context!);
      }
    }
    notifyListeners();

    return isSuccess;
  }


// Substitua seu método _createMockConfig() por este corrigido:
ConfigModel _createMockConfig() {
  return ConfigModel.fromJson({
    "company_name": "Cobes Marketplace",
    "company_email": "support@cobes.com", 
    "company_phone": "+1234567890",
    "primary_color": "#1455AC",
    "secondary_color": "#7FBCD3",
    "system_default_currency": 1,
    "currency_list": [
      {
        "id": 1,
        "name": "USD",
        "symbol": "\$",
        "code": "USD", 
        "exchange_rate": "1.00000000",
        "status": true
      }
    ],
    "unit": ["kg", "pc", "gm", "ltr"],
    "base_urls": {
      "product_image_url": "https://via.placeholder.com/300x300",
      "product_thumbnail_url": "https://via.placeholder.com/150x150",
      "brand_image_url": "https://via.placeholder.com/100x100",
      "customer_image_url": "https://via.placeholder.com/100x100",
      "banner_image_url": "https://via.placeholder.com/800x400",
      "category_image_url": "https://via.placeholder.com/200x200",
      "shop_image_url": "https://via.placeholder.com/300x200"
    },
    "maintenance_mode": {
      "maintenance_status": 0,
      "selected_maintenance_system": {
        "customer_app": 0
      }
    },
    "customer_verification": {"status": 0},
    "customer_login": {  // Estrutura corrigida
      "login_option": {
        "manual_login": 1,
        "otp_login": 0,
        "social_login": 0
      },
      "social_media_for_login": {
        "google": {
          "status": 0,
          "client_id": ""
        },
        "facebook": {
          "status": 0,
          "app_id": "",
          "app_secret": ""
        },
        "apple": {
          "status": 0,
          "client_id": "",
          "team_id": "",
          "key_id": "",
          "service_file": ""
        }
      }
    },
    "user_app_version_control": {
      "for_android": {"status": 0, "version": "1.0.0"},
      "for_ios": {"status": 0, "version": "1.0.0"}
    },
    "has_local_db": false,
    "local_m_mode": false,
    "guest_checkout": 1,
    "wallet_status": 1,
    "ref_earning_status": "0"
  });
}

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void getCurrencyData(String? currencyCode) {
    for (var currency in _configModel!.currencyList!) {
      if(currencyCode == currency.code) {
        _myCurrency = currency;
        _currencyIndex = _configModel!.currencyList!.indexOf(currency);
        continue;
      }
    }
  }

  Future<void> getBusinessPagesList(String type) async {
    ApiResponseModel apiResponse = await splashServiceInterface!.getBusinessPages(type);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      if(type == 'default') {
        _defaultBusinessPages = [];
        apiResponse.response?.data.forEach((data) { _defaultBusinessPages?.add(BusinessPageModel.fromJson(data));});
      } else {
        _businessPages = [];
        apiResponse.response?.data.forEach((data) { _businessPages?.add(BusinessPageModel.fromJson(data));});
      }

    } else {
      ApiChecker.checkApi( apiResponse);
    }

    notifyListeners();
  }



  void setCurrency(int index) {
    splashServiceInterface!.setCurrency(_configModel!.currencyList![index].code!);
    getCurrencyData(_configModel!.currencyList![index].code);
    notifyListeners();
  }

  void initSharedPrefData() {
    splashServiceInterface!.initSharedData();
  }

  void setFromSetting(bool isSetting) {
    _fromSetting = isSetting;
  }

  bool? showIntro() {
    return splashServiceInterface!.showIntro();
  }

  void disableIntro() {
    splashServiceInterface!.disableIntro();
  }

  void changeAnnouncementOnOff(bool on){
    _onOff = !_onOff;
    notifyListeners();
  }


  void _startTimer (DateTime startTime) {
    Timer.periodic(const Duration(seconds: 30), (Timer timer) {

      DateTime now = DateTime.now();

      if (now.isAfter(startTime) || now.isAtSameMomentAs(startTime)) {
        timer.cancel();
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const MaintenanceScreen(),
          settings: const RouteSettings(name: 'MaintenanceScreen'),
        ));
      }

    });
  }

  void setMaintenanceContext(BuildContext context) {
    _buildContext = context;
  }

  void removeMaintenanceContext() {
    _buildContext = null;
  }

  bool isMaintenanceModeScreen() {
    if (_buildContext == null || configModel?.maintenanceModeData?.maintenanceStatus == 1) {
      return false;
    }
    return ModalRoute.of(_buildContext!)?.settings.name == 'MaintenanceScreen';
  }


}
