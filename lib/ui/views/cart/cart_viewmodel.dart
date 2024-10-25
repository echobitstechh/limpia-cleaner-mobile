import 'package:limpia/app/app.locator.dart';
import 'package:limpia/app/app.logger.dart';
import 'package:limpia/core/data/models/cart_item.dart';
import 'package:limpia/core/data/models/raffle_cart_item.dart';
import 'package:limpia/core/data/repositories/repository.dart';
import 'package:limpia/core/network/api_response.dart';
import 'package:limpia/core/utils/config.dart';
import 'package:limpia/core/utils/local_store_dir.dart';
import 'package:limpia/core/utils/local_stotage.dart';
import 'package:limpia/state.dart';
import 'package:limpia/ui/views/cart/raffle_reciept.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/app.dialogs.dart';
import '../../../app/app.router.dart';
//import '../../../app/flutter_paystack/lib/flutter_paystack.dart';
import '../../../core/data/models/order_info.dart';
import '../../../utils/binance_pay.dart';
import '../../../utils/money_util.dart';
import 'custom_reciept.dart';


/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///



class CartViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final snackBar = locator<SnackbarService>();
  final log = getLogger("CartViewModel");
  List<RaffleCartItem> itemsToDeleteRaffle = [];
  int shopSubTotal = 0;
  int raffleSubTotal = 0;
  int deliveryFee = 0;
  final refferalCode = TextEditingController();

  ValueNotifier<PaymentMethod> selectedPaymentMethod = ValueNotifier(PaymentMethod.flutterwave);
  ValueNotifier<bool> isPaymentProcessing = ValueNotifier(false);


  PaymentMethod get selectedMethod => selectedPaymentMethod.value;

  final bool _isDisposed = false;

  @override
  void dispose() {
    selectedPaymentMethod.dispose();
    super.dispose();
  }


  void selectMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
    notifyListeners(); // Notify overall ViewModel listeners
  }


  void addRemoveDeleteRaffle(RaffleCartItem item) {
    itemsToDeleteRaffle.contains(item)
        ? itemsToDeleteRaffle.remove(item)
        : itemsToDeleteRaffle.add(item);
    rebuildUi();
  }


  // void clearRaffleCart() async{
  //   for (var element in itemsToDeleteRaffle) {
  //     raffleCart.value.remove(element);
  //   }
  //   itemsToDelete.clear();
  //   raffleCart.notifyListeners();
  //   List<Map<String, dynamic>> storedList =
  //   raffleCart.value.map((e) => e.toJson()).toList();
  //   await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
  //   rebuildUi();
  //   getRaffleSubTotal();
  // }

  void clearRaffleCart() async {
    setBusy(true);
    try {
      print('about to clear cart');
      // Remove from the online cart
      ApiResponse res = await repo.clearCart();
      if (res.statusCode == 200) {
        // Clear the local cart
        raffleCart.value.clear(); // Use clear() with parentheses
        print('cleared cart');
        raffleCart.notifyListeners(); // Notify listeners to update the UI
        List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
        await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);

        getRaffleSubTotal();
        rebuildUi(); // Ensure UI rebuilds properly
      } else {
        snackBar.showSnackbar(message: "Failed to delete items from cart: ${res.data['message']}");
      }
    } catch (e) {
      log.e(e);
      snackBar.showSnackbar(message: "An error occurred while clearing the cart: $e");
    } finally {
      setBusy(false);
    }
  }


  void getRaffleSubTotal() {
    int total = 0;
    for (var element in raffleCart.value) {
      final raffle = element.raffle;
      total += (raffle?.ticketPrice ?? 0) * element.quantity!;
    }

    raffleSubTotal = total;
    rebuildUi();
  }

  void checkoutRaffle(BuildContext context) async {
    if (raffleCart.value.isEmpty) {
      return null;
    }
    isPaymentProcessing.value = true;
    setBusy(true);
    try {
      ApiResponse res = await repo.saveOrder({
        "payment_method": selectedMethod.name
      });
      if (res.statusCode == 201) {
        // String paymentLink = res.data['data']['payment_link'];
        String orderId = res.data['data']['order']['_id'];
        print('oder id $orderId');
        // final Uri toLaunch = Uri.parse(paymentLink);

        // if (!await launchUrl(toLaunch, mode: LaunchMode.inAppBrowserView)) {
        //   snackBar.showSnackbar(message: "Could not launch payment link");
        //   throw Exception('Could not launch $paymentLink');
        // }
         processPayment(selectedMethod, context, AppModules.raffle, orderId);

      } else {
        snackBar.showSnackbar(message: res.data["message"]);
        isPaymentProcessing.value = false;
        notifyListeners();
      }
    } catch (e) {
      log.e(e);
      snackBar.showSnackbar(message: 'network error, try again');
      isPaymentProcessing.value = false;
      notifyListeners();
    }
  }

  processPayment(PaymentMethod paymentMethod, BuildContext context, AppModules module, String orderId) async {
    // Calculate the amount
    int amount = raffleSubTotal;


    try{
      ApiResponse res = await MoneyUtils().chargeCardUtil(paymentMethod, context, amount, orderId);

      if (res.statusCode == 200) {
        Navigator.pop(context);
        showReceipt(module, context);
      } else {
        Navigator.pop(context);
        locator<SnackbarService>().showSnackbar(message: res.data["message"]);
        locator<NavigationService>().replaceWithHomeView();
      }
    }catch(e){
      log.e(e);
    }finally{
     
      isPaymentProcessing.value = false;
      setBusy(false);
    }


  }


  Future<void> showReceipt(AppModules module, BuildContext context) async {

    if(module == AppModules.raffle){
      List<RaffleCartItem> receiptCart = List<RaffleCartItem>.from(raffleCart.value);



      raffleCart.notifyListeners();
      List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
      locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);


      showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return RaffleReceiptPage(cart:receiptCart);
        },
      );
      raffleCart.value.clear();
      clearRaffleCart();
      await repo.clearCart();
    }
  }

  Future<void> fetchOnlineCart() async {
    setBusy(true);
    try {
      ApiResponse res = await repo.cartList();
      if (res.statusCode == 200) {
        // Access the 'items' from the response 'data'
        List<dynamic> items = res.data["data"]["items"];

        print('online cart is:  $items');

        // Map the items list to List<RaffleCartItem>
        List<RaffleCartItem> onlineItems = items
            .map((item) => RaffleCartItem.fromJson(Map<String, dynamic>.from(item)))
            .toList();

        // Sync online items with the local cart
        raffleCart.value = onlineItems;

        // Update local storage
        List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
        await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
      } else {
        snackBar.showSnackbar(message: res.data["message"]);
      }
    } catch (e) {
      log.e(e);
      snackBar.showSnackbar(message: "Failed to load cart from server: $e");
    } finally {
      setBusy(false);
    }
  }


  Future<void> loadPayStackPlugin() async{
    // final plugin = PaystackPlugin();
    // plugin.initialize(publicKey: AppConfig.paystackApiKeyTest);
  }


}
