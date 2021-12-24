import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iit_madras_merchandise/providers/StoreProvider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({Key key}) : super(key: key);

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  Razorpay _razorpay = new Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    storeProvider.products.forEach((element) {
      if (element.addedToCart == true) {
        setState(() {
          amount += element.price;
        });
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    debugPrint('Payment Got Success ${response.paymentId}');
    debugPrint('Create Order Called');
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    List<String> products = [];
   // storeProvider.fetchProducts()
    var orderData = {
      "paymentDate": new DateTime.now(),
      "paymentId": response.paymentId,
      "amount": amount,
      "products":
          storeProvider.products.map((element) {
              if(element.addedToCart)
              {
                return element.name;
              }
          } ).toList(),
      "email": FirebaseAuth.instance.currentUser.email
    };
    await FirebaseFirestore
     .instance.collection('Orders')
    .add(orderData).then((value) => print('Order Created'));
    Navigator.pop(context);
   
    storeProvider.products.forEach((element) {
      if (element.addedToCart) storeProvider.updateCart(element);
    });
  }



  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    debugPrint('Payment Got failure ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  double amount = 0.0;

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('basket Page'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ListView(
              shrinkWrap: true,
              children: storeProvider.products.map((e) {
                return e.addedToCart == true
                    ? ListTile(
                        leading: Image.asset(e.image),
                        title: Text('${e.name}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${e.description}'),
                            Text(
                              'RS. ${e.price}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                            icon: e.addedToCart == false
                                ? Icon(
                                    Icons.shopping_bag,
                                    color: Colors.black,
                                  )
                                : Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              storeProvider.updateCart(e);
                            }),
                      )
                    : Container();
              }).toList(),
            ),
            Positioned(
              bottom: 30,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Total Amount : ${amount} \t Qty: ${storeProvider.products.where((element) => element.addedToCart == true).length}',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff79201B)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40))),
                          side: MaterialStateProperty.all(
                              BorderSide(width: 2, color: Colors.white))),
                      onPressed: () async {
                        var options = {
                          'key': 'rzp_test_FCoieWlhoowMoc',
                          'amount': amount * 100,
                          'name': 'IIT Madras BSc Merchandise Store',
                          'description': 'Swags',
                          'prefill': {
                            'contact': '8888888888',
                            'email': 'test@razorpay.com'
                          }
                        };

                        try {
                           _razorpay.open(options);
                        } catch (e) {}
                      },
                      child: Text('Purchase',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
