import 'package:cobes_marketplace/common/enums/data_source_enum.dart';
import 'package:cobes_marketplace/data/model/api_response.dart';
import 'package:cobes_marketplace/interface/repo_interface.dart';

abstract class FeaturedDealRepositoryInterface implements RepositoryInterface {
  Future<ApiResponseModel<T>> getFeaturedDeal<T>({required DataSourceEnum source});
}
