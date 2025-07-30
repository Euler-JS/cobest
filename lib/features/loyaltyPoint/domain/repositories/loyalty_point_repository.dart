import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:cobes_marketplace/data/datasource/remote/dio/dio_client.dart';
import 'package:cobes_marketplace/data/datasource/remote/exception/api_error_handler.dart';
import 'package:cobes_marketplace/data/model/api_response.dart';
import 'package:cobes_marketplace/features/loyaltyPoint/domain/repositories/loyalty_point_repository_interface.dart';
import 'package:cobes_marketplace/helper/date_converter.dart';
import 'package:cobes_marketplace/utill/app_constants.dart';

class LoyaltyPointRepository implements LoyaltyPointRepositoryInterface{
  final DioClient? dioClient;
  LoyaltyPointRepository({required this.dioClient});


  @override
  Future getList({int? offset = 1, String? filterBy, DateTime? startDate, DateTime? endDate, List<String>? transactionTypes}) async{

    // Build query parameters dynamically
    final Map<String, dynamic> queryParams = {
      'offset': offset,
      'limit': 10,
      if (filterBy != null && filterBy.isNotEmpty) 'filter_by': filterBy,
      if (startDate != null) 'start_date': DateConverter.durationDateTime(startDate),
      if (endDate != null) 'end_date': DateConverter.durationDateTime(endDate),
      if (transactionTypes != null && transactionTypes.isNotEmpty) 'transaction_types': jsonEncode(transactionTypes),
    };

    debugPrint('--------(loyalty_query)----$queryParams');

    try {
      Response response = await dioClient!.get(AppConstants.loyaltyPointUri, queryParameters: queryParams);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> convertPointToCurrency(int point) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loyaltyPointConvert,
        data: {"point": point},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }


  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}