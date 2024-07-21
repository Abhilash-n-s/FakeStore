import 'package:fake_store/view/profile_page.dart';
import 'package:fake_store/view/wishlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/color_extension.dart';
import 'cart_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _HomePageState();
}

class _HomePageState extends State<MainPage> with SingleTickerProviderStateMixin{
  TabController? controller;
  int selectTab = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    controller=TabController(length: 4, vsync: this);
    controller?.addListener(() {
      selectTab = controller?.index ?? 0;
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: controller, children: const [
        HomePage(),
        CartPage(),
        WishlistPage(),
        ProfilePage(),
      ]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            boxShadow:  [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, -2)
              )
            ]
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: TabBar(
              controller: controller,
              indicatorColor: Colors.transparent,
              indicatorWeight: 1,
              labelColor: KColor.primary,
              labelStyle: TextStyle(
                color: KColor.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelColor: KColor.primaryText,
              unselectedLabelStyle: TextStyle(
                color: KColor.primaryText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(
                  text: "Home",
                  icon: Icon(Icons.home,
                    size:20,
                    color: selectTab == 0 ? KColor.primary : KColor.primaryText,
                  )
                  ,
                ),
                Tab(
                  text: "Cart",
                  icon:Icon(Icons.shopping_cart_sharp,size: 20,color: selectTab == 1 ? KColor.primary : KColor.primaryText,)
                  ),
                Tab(
                  text: "Wishlist",
                  icon:Icon(Icons.favorite,size: 20,color: selectTab == 2 ? KColor.primary : KColor.primaryText,)
                  ),
                Tab(
                  text: "Profile",
                  icon:Icon(Icons.person,size: 20,color: selectTab == 3 ? KColor.primary : KColor.primaryText,)
                  )
              ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}
