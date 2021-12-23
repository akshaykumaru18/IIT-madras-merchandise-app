import 'package:flutter/material.dart';
import 'package:iit_madras_merchandise/Screens/CartPage.dart';
import 'package:iit_madras_merchandise/providers/StoreProvider.dart';
import 'package:provider/provider.dart';
 
class ProductCatalog extends StatelessWidget {
  const ProductCatalog({ Key key }) : super(key: key);

 
  @override
  Widget build(BuildContext context) {
    return Consumer<StoreProvider>(
        builder: (context,storeProvider,child){
          return Scaffold(
      appBar: AppBar(
        title: Text(
          'Merchandise Store',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xffD7A74F)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (_)=> BasketPage()));
          }, icon: Icon(Icons.shopping_bag))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Image.asset(
                    "assets/Icons/Sale Banner.png",
                    fit: BoxFit.fill,
                  ),
                  //Image.network("https://t3.ftcdn.net/jpg/02/16/64/76/360_F_216647609_BMqe8lbGazVmaRoR74QmvgBSNhRyTnaU.jpg")
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Featured Products',
                style: TextStyle(fontSize: 22),
              ),
            ),
            ),
          ),
         SliverList(
            
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Product featuredProduct = storeProvider.products[index];
                return featuredProduct.featured ? Card(
                        elevation: 20,
                        shadowColor: Color(0xffD7A74F),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.18,
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Image.asset(
                                  featuredProduct.image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      featuredProduct.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      featuredProduct.description,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Text(
                                      'RS. ' + featuredProduct.price.toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons.shopping_bag),
                                            onPressed: () {}),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Color(0xff79201B)),
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.symmetric(
                                                            vertical: 15,
                                                            horizontal: 10)),
                                                shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40))),
                                                side: MaterialStateProperty.all(
                                                    BorderSide(width: 2, color: Colors.white))),
                                            onPressed: () async {},
                                            child: Text('Buy Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                        IconButton(
                                            icon: Icon(Icons.share),
                                            onPressed: () {
                                              debugPrint('Share logic');
                                            }),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ) : Container();
              },
              childCount: storeProvider.products.length,
            ),
          ),
          SliverToBoxAdapter(
            child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'All Products',
                style: TextStyle(fontSize: 22),
              ),
            ),
            ),
          ),
            SliverList(
            
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Product product = storeProvider.products[index];
                return Card(
                        elevation: 20,
                        shadowColor: Color(0xffD7A74F),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.18,
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Image.asset(
                                  product.image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      product.description,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Text(
                                      'RS. ' + product.price.toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            icon: !product.addedToCart ?  Icon(Icons.shopping_cart,size: 40,) : Icon(Icons.delete,size: 40,color: Colors.red,),
                                            onPressed: () {
                                              print('Clicking cart');
                                              storeProvider.updateCart(product);
                                            }),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Color(0xff79201B)),
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.symmetric(
                                                            vertical: 15,
                                                            horizontal: 10)),
                                                shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40))),
                                                side: MaterialStateProperty.all(
                                                    BorderSide(width: 2, color: Colors.white))),
                                            onPressed: () async {},
                                            child: Text('Buy Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                        IconButton(
                                            icon: Icon(Icons.share),
                                            onPressed: () {
                                              debugPrint('Share logic');
                                            }),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
              },
              childCount: storeProvider.products.length,
            ),
          ),
        ],
      ),

    ); 
        },
      );
    
  }
}

