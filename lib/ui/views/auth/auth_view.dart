import 'package:flutter_svg/svg.dart';
import 'package:limpia/ui/common/app_colors.dart';
import 'package:limpia/ui/views/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login.dart';


/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///


class AuthView extends StatefulWidget {
  final bool isLogin;
  const AuthView({Key? key, required this.isLogin}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _AuthViewState();
  }
}

class _AuthViewState extends State<AuthView> with TickerProviderStateMixin {
  late TabController tabController;
  late bool isLogin;


  @override
  void initState() {
    super.initState();
    print('init value of islogin is: ${widget.isLogin}');
    isLogin = widget.isLogin;
    tabController = TabController(length: 2, vsync: this);
  }

  void updateIsLogin(bool value) {
    setState(() {
      isLogin = value;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 150,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0), // Adjust the padding to move the image down
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/limpiador_logo.png",
                            height: 90, // Adjust the height to make the image smaller
                            fit: BoxFit.fitHeight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      height: MediaQuery.of(context).size.height,  // Set a specific height constraint
                      child: Column(
                        children:  [
                          Flexible(
                            child: SingleChildScrollView(
                              child: isLogin ? Login(updateIsLogin: (value) {
                                setState(() {
                                  isLogin = value;
                                });
                              })
                                  : Register(updateIsLogin: (value) {
                                setState(() {
                                  isLogin = value;
                                });
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
