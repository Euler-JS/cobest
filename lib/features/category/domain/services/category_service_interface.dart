
import 'package:cobes_marketplace/common/enums/data_source_enum.dart';
import 'package:cobes_marketplace/data/model/api_response.dart';

abstract class CategoryServiceInterface {

  Future<dynamic> getSellerWiseCategoryList(int sellerId);
  Future<ApiResponseModel<T>> getList<T>({required DataSourceEnum source});


}