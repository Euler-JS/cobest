import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cobes_marketplace/common/basewidget/product_widget.dart';
import 'package:cobes_marketplace/common/basewidget/slider_product_shimmer_widget.dart';
import 'package:cobes_marketplace/common/basewidget/title_row_widget.dart';
import 'package:cobes_marketplace/features/product/controllers/product_controller.dart';
import 'package:cobes_marketplace/features/product/domain/models/product_model.dart';
import 'package:cobes_marketplace/features/product/enums/product_type.dart';
import 'package:cobes_marketplace/features/home/screens/view_all_product_screen.dart';
import 'package:cobes_marketplace/helper/responsive_helper.dart';
import 'package:cobes_marketplace/localization/language_constrants.dart';
import 'package:cobes_marketplace/utill/dimensions.dart';
import 'package:provider/provider.dart';

class FeaturedProductWidget extends StatelessWidget {
  const FeaturedProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ProductController, ProductModel?>(
      selector: (ctx, productController)=> productController.featuredProductModel,
        builder: (context, featuredProductModel, _) {
      return (featuredProductModel?.products?.isNotEmpty ?? false)  ? Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraSmall,
            vertical: Dimensions.paddingSizeExtraSmall,
          ),
          child: TitleRowWidget(
            title: getTranslated('featured_products', context),
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewAllProductScreen(productType: ProductType.featuredProduct))),
          ),
        ),

        SizedBox(
          height: ResponsiveHelper.isTab(context)? MediaQuery.of(context).size.width * .58 : 320,
          child: CarouselSlider.builder(
            options: CarouselOptions(
              viewportFraction: ResponsiveHelper.isTab(context)? .5 :.65,
              autoPlay: false,
              pauseAutoPlayOnTouch: true,
              pauseAutoPlayOnManualNavigate: true,
              enlargeFactor: 0.2,
              enlargeCenterPage: true,
              pauseAutoPlayInFiniteScroll: true,
              disableCenter: true,
            ),
            itemCount: featuredProductModel?.products?.length ?? 0,
            itemBuilder: (context, index, next) {
              return ProductWidget(productModel: featuredProductModel!.products![index], productNameLine: 1);
            },
          ),
        ),
      ]) : featuredProductModel == null ? const SliderProductShimmerWidget() : const SizedBox();
    });
  }
}
