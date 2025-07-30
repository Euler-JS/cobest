import 'package:cobes_marketplace/interface/repo_interface.dart';

abstract class FlashDealRepositoryInterface implements RepositoryInterface{

  Future<dynamic> getFlashDeal();
}