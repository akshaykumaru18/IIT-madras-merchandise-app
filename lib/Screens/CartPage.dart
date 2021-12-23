import 'package:flutter/material.dart';
import 'package:iit_madras_merchandise/providers/StoreProvider.dart';
import 'package:provider/provider.dart';

class BasketPage extends StatelessWidget {
  const BasketPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('basket Page'),
      ),
      body: ListView(
        children: storeProvider.products.map((e) {
          return e.addedToCart == true
              ? ListTile(
                leading: Image.asset(e.image),
                  title: Text('${e.name}'),
                  subtitle: Text('${e.description}'),
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
    );
  }
}
