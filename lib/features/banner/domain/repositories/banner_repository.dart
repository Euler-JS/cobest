import 'package:cobes_marketplace/common/enums/data_source_enum.dart';
import 'package:cobes_marketplace/data/datasource/remote/dio/dio_client.dart';
import 'package:cobes_marketplace/data/model/api_response.dart';
import 'package:cobes_marketplace/data/services/data_sync_service.dart';
import 'package:cobes_marketplace/features/banner/domain/repositories/banner_repository_interface.dart';
import 'package:cobes_marketplace/utill/app_constants.dart';

class BannerRepository extends DataSyncService implements BannerRepositoryInterface{
  final DioClient? dioClient;
  BannerRepository({required this.dioClient, required super.dataSyncRepoInterface});

  @override
  Future<ApiResponseModel<T>> getBannerList<T>({required DataSourceEnum source}) async {
    return await fetchData<T>(AppConstants.getBannerList,  source);

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
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }


  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }
}