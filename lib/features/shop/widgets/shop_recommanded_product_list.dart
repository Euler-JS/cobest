import 'package:flutter/material.dart';
import 'package:cobes_marketplace/common/basewidget/paginated_list_view_widget.dart';
import 'package:cobes_marketplace/common/basewidget/product_shimmer_widget.dart';
import 'package:cobes_marketplace/common/basewidget/product_widget.dart';
import 'package:cobes_marketplace/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ShopRecommandedProductViewList extends StatefulWidget {
  final ScrollController scrollController;
  final int sellerId;
  const ShopRecommandedProductViewList({super.key, required this.scrollController, required this.sellerId});

  @override
  State<ShopRecommandedProductViewList> createState() => _ShopRecommandedProductViewListState();
}

class _ShopRecommandedProductViewListState extends State<ShopRecommandedProductViewList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SellerProductController>(
        builder: (context, productController, _) {
          return productController.sellerWiseRecommendedProduct != null?
          (productController.sellerWiseRecommendedProduct != null && productController.sellerWiseRecommendedProduct!.products != null &&
              productController.sellerWiseRecommendedProduct!.products!.isNotEmpty)?
          PaginatedListView(scrollController: widget.scrollController,
              onPaginate: (offset) async => await productController.getSellerProductList(widget.sellerId.toString(), offset!, ""),
              totalSize: productController.sellerWiseRecommendedProduct?.totalSize,
              offset: productController.sellerWiseRecommendedProduct?.offset,
              itemView: RepaintBoundary(
                child: MasonryGridView.count(
                  itemCount: productController.sellerWiseRecommendedProduct?.products?.length,
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductWidget(productModel: productController.sellerWiseRecommendedProduct!.products![index]);
                  },
                ),
              )) : const SizedBox() : ProductShimmer(isEnabled: productController.sellerWiseRecommendedProduct == null, isHomePage: false);
        }
    );
  }
}
