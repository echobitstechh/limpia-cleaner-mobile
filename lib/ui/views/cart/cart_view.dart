import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../utils/money_util.dart';
import 'cart_viewmodel.dart';

class CartView extends StackedView<CartViewModel> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CartViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "My Carts", style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: "Panchang"
        ),
        ),
        actions: [
          viewModel.itemsToDelete.isNotEmpty
              ? InkWell(
                  onTap: () {
                    viewModel.clearCart();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: raffleCart.value.isEmpty
          ? const EmptyState(
              animation: "empty_cart.json",
              label: "Cart Is Empty",
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ValueListenableBuilder<List<CartItem>>(
                  valueListenable: raffleCart,
                  builder: (context, value, child) => ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      CartItem item = value[index];
                      return GestureDetector(
                        onTap: () {
                          viewModel.addRemoveDelete(item);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: uiMode.value == AppUiModes.light
                                ? kcWhiteColor
                                : kcBlackColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      const Color(0xFFE5E5E5).withOpacity(0.4),
                                  offset: const Offset(8.8, 8.8),
                                  blurRadius: 8.8)
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: item.product!.pictures!.isEmpty
                                            ? null
                                            : DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            item.product!.raffle?[0].pictures?[0].location ?? 'https://via.placeholder.com/120',
                                          ),
                                          fit: BoxFit.cover,
                                        ),

                                      ),
                                    ),
                                    horizontalSpaceSmall,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Win!!!',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: uiMode.value == AppUiModes.light ? kcSecondaryColor : kcWhiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Panchang"
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            item.product!.raffle?[0].ticketName ?? 'Product Name',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Panchang"
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          verticalSpaceTiny,
                                          //TODO REMOVE STATE 5 VALUE AND REPLACE WITH RAFFLE PRICE
                                          Row(
                                            children: [
                                              Text(
                                                MoneyUtils().formatAmountToDollars(5 * item.quantity!),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                                                    fontFamily: "Satoshi",
                                                    fontWeight: FontWeight.w700
                                                ),
                                              ),
                                              horizontalSpaceSmall,
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300]?.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '~${MoneyUtils().formatAmount(MoneyUtils().getRate(5 * item.quantity!))}',
                                                  style: TextStyle(
                                                      color: uiMode.value == AppUiModes.light ? kcBlackColor.withOpacity(0.5) : kcWhiteColor,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "satoshi",
                                                  ),
                                                ),
                                              ),

                                            ],
                                          )

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  viewModel.itemsToDelete.contains(item)
                                      ? Container(
                                          height: 20,
                                          width: 20,
                                          decoration: const BoxDecoration(
                                            color: kcSecondaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.check,
                                              color: kcWhiteColor,
                                              size: 16,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border:
                                                Border.all(color: kcLightGrey),
                                          ),
                                        ),
                                  verticalSpaceSmall,
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (item.quantity! > 1) {
                                            item.quantity = item.quantity! - 1;
                                            raffleCart.notifyListeners();
                                            viewModel.getSubTotal();
                                            viewModel.getDeliveryTotal();
                                          }
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: kcLightGrey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Center(
                                            child: Icon(
                                              Icons.remove,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      horizontalSpaceSmall,
                                      Text("${item.quantity!}"),
                                      horizontalSpaceSmall,
                                      InkWell(
                                        onTap: () {
                                          item.quantity = item.quantity! + 1;
                                          raffleCart.notifyListeners();
                                          viewModel.getSubTotal();
                                          viewModel.getDeliveryTotal();
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: kcLightGrey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.add,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sub-total",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      MoneyUtils().formatAmount(viewModel.subTotal),
                      style: TextStyle(
                        fontSize: 16,
                        color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                        fontFamily: "satoshi",
                      ),)
                  ],
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Delivery-Fee",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      viewModel.deliveryFee == 0 ? "Free" : "N${viewModel.deliveryFee}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                verticalSpaceSmall,
                const Divider(
                  thickness: 2,
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      MoneyUtils().formatAmount(viewModel.subTotal + viewModel.deliveryFee),
                      style: TextStyle(
                        fontSize: 16,
                        color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                        fontFamily: "satoshi",
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                verticalSpaceLarge,
                SubmitButton(
                  isLoading: viewModel.isBusy,
                  label: "Checkout",
                  submit: viewModel.checkout,
                  color: kcPrimaryColor,
                  boldText: true,
                ),
                SafeArea(
                  child: _buildProceedToPayButton(context),
                )
              ],
            ),
    );
  }

  Widget _buildProceedToPayButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Implement the navigation or payment logic
      },
      style: ElevatedButton.styleFrom(
        primary: kcSecondaryColor, // Button color
        onPrimary: Colors.white, // Text color
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Button corner radius
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ensures the Row only takes up needed space
        children: [
          Text(
            "Proceed to Pay",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16, // Adjust the font size as needed
            ),
          ),
          Icon(
            Icons.arrow_forward, // Use the appropriate icon
            // Add any additional icon styling here
          ),
        ],
      ),
    );
  }



  @override
  void onViewModelReady(CartViewModel viewModel) {
    viewModel.getSubTotal();
    viewModel.getDeliveryTotal();
    super.onViewModelReady(viewModel);
  }

  @override
  CartViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CartViewModel();
}
