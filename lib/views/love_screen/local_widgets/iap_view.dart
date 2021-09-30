import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../../globals.dart' as globals;
import '../../../models/app_model.dart';
import '../../../views/all_widgets/card_view.dart';

class IAPView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IAPViewState();
  }
}

class _IAPViewState extends State<IAPView> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> _products = [];

  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print(error);
    });
    initStoreInfo();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        setState(() {
          _purchasePending = true;
        });
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          print('purchased');
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
        setState(() {
          _purchasePending = false;
        });
      }
    });
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    Set<String> _kProductIds =
        globals.productDict.entries.map((e) => e.key).toSet();
    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchasePending = false;
      _loading = false;
    });
  }

  Future<void> loadProducts() async {
    Set<String> _kIds = globals.productDict.entries.map((e) => e.key).toSet();
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
    }
    List<ProductDetails> products = response.productDetails;

    setState(() {
      _products = products;
      _loading = false;
    });
  }

  CardView _buildProductList(appTheme, textColor) {
    if (_loading) {
      return CardView(
        child: ListTile(
          leading: CircularProgressIndicator(),
          title: Text(
            'Fetching products...',
            style: TextStyle(color: textColor),
          ),
        ),
      );
    }
    if (!_isAvailable) {
      return CardView(
        child: ListTile(
          title: Text('Error: $_queryProductError'),
        ),
      );
    }
    List<Column> productList = <Column>[];

    _products.asMap().forEach((i, ProductDetails productDetails) {
      bool lastItem = i + 1 == _products.length;

      productList.add(Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.favorite,
              size: 40,
              color: Colors.pink,
            ),
            title: Text(
              globals.productDict[productDetails.id]['title'],
              style: TextStyle(
                color: textColor,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              globals.productDict[productDetails.id]['description'],
              style: TextStyle(
                color: textColor,
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
            trailing: _purchasePending
                ? CircularProgressIndicator()
                : TextButton(
                    child: Text(productDetails.price),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.pink,
                      primary: Colors.white,
                    ),
                    onPressed: () {
                      late PurchaseParam purchaseParam;

                      purchaseParam = PurchaseParam(
                        productDetails: productDetails,
                        applicationUserName: null,
                      );
                      _inAppPurchase.buyConsumable(
                        purchaseParam: purchaseParam,
                        autoConsume: true,
                      );
                    },
                  ),
          ),
          lastItem
              ? Container()
              : Divider(
                  height: 1,
                  color: textColor,
                  indent: 60,
                ),
        ],
      ));
    });

    return CardView(
      headTitle: Text(
        AppLocalizations.of(context)!.consumable_items,
        style: TextStyle(
          color: textColor,
        ),
      ),
      child: Column(
        children: productList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;

    return _buildProductList(appTheme, textColor);
  }
}
