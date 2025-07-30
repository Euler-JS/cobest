import 'package:cobes_marketplace/common/enums/data_source_enum.dart';
import 'package:cobes_marketplace/data/model/api_response.dart';
import 'package:cobes_marketplace/features/category/domain/repositories/category_repo_interface.dart';
import 'package:cobes_marketplace/features/category/domain/services/category_service_interface.dart';

class CategoryService implements CategoryServiceInterface{
  CategoryRepoInterface categoryRepoInterface;
  CategoryService({required this.categoryRepoInterface});

  @override
  Future<ApiResponseModel<T>> getList<T>({required DataSourceEnum source}) async{
    return await categoryRepoInterface.getCategoryList(source: source);
  }

  @override
  Future getSellerWiseCategoryList(int sellerId) async{
    return await categoryRepoInterface.getSellerWiseCategoryList(sellerId);
  }

}