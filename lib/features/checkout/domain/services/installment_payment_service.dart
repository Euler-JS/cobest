import 'package:cobes_marketplace/data/model/api_response.dart';
import 'package:cobes_marketplace/features/checkout/domain/services/checkout_service_interface.dart';

class InstallmentPaymentService {
  final CheckoutServiceInterface checkoutService;
  InstallmentPaymentService({required this.checkoutService});

  Future<ApiResponseModel> getInstallmentOptions({
    required double amount,
    required int quantity,
    String? addressId,
    String? billingAddressId,
  }) async {
    return await checkoutService.getInstallmentOptions(
      amount: amount,
      quantity: quantity,
      addressId: addressId,
      billingAddressId: billingAddressId,
    );
  }
}