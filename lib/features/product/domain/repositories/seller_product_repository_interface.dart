import 'package:cobes_marketplace/common/enums/data_source_enum.dart';
import 'package:cobes_marketplace/data/model/api_response.dart';
import 'package:cobes_marketplace/interface/repo_interface.dart';

abstract class SellerProductRepositoryInterface implements RepositoryInterface{

  Future<dynamic> getSellerProductList(String sellerId, String offset, String productId, {String search = '', String? categoryIds, String? brandIds, String? authorIds, String? publishingIds, String? productType});

  Future<dynamic> getSellerWiseBestSellingProductList(String sellerId, String offset);

  Future<dynamic> getSellerWiseFeaturedProductList(String sellerId, String offset);

  Future<dynamic> getSellerWiseRecommendedProductList(String sellerId, String offset);

  Future<ApiResponseModel<T>> getShopAgainFromRecentStore<T>({required DataSourceEnum source});
}
