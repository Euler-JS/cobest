import 'dart:io';
import 'package:cobes_marketplace/features/review/domain/models/review_body.dart';
import 'package:cobes_marketplace/interface/repo_interface.dart';

abstract class ReviewRepositoryInterface implements RepositoryInterface<ReviewBody>{
  Future<dynamic> submitReview(ReviewBody reviewBody, List<File> files, bool update);

  Future<dynamic> getOrderWiseReview(String productID, String orderId);

  Future<dynamic> deleteOrderWiseReviewImage(String id, String name);

  Future<dynamic> getDeliveryManReview(String orderId);

  Future<dynamic> submitDeliveryManReview(String orderId, String comment, String rating);

}