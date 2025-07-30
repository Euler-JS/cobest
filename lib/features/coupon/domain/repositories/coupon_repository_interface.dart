import 'package:cobes_marketplace/interface/repo_interface.dart';

abstract class CouponRepositoryInterface<T> extends RepositoryInterface{

  Future<dynamic> getAvailableCouponList();

  Future<dynamic> getSellerCouponList(int sellerId, int offset);

}