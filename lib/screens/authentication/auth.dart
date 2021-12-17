// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectfolio/screens/authentication/cubit/get_user_data_cubit.dart';
import 'package:projectfolio/screens/bottom_nav_screen/bottom_nav_bar.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _handleUniLinks();
    super.initState();
  }

  void _handleUniLinks() {
    getLinksStream().listen((link) {
      try {
        if (link != null) {
          var code = link
              .replaceFirst(
                  "https://anshrathod.vercel.app/projectfolio?code=", "")
              .trim();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GetUserInfoPage(
                token: code,
              ),
            ),
          );
        }
      } on FormatException {}
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=464&q=80'),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Image.asset(
                              'assets/logo.png',
                              height: 80,
                              width: 80,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "ProjectFolio".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  shadows: kElevationToShadow[8],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Text(
                          "Make, Share & Grow. \nA Showcase for your projects.",
                          style: TextStyle(
                              color: Colors.white.withOpacity(.8),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ButtonTheme(
                        minWidth: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            launch(
                                "https://github.com/login/oauth/authorize?client_id=6cf411c3a4b0219a7fa5&redirect_uri=https://anshrathod.vercel.app/projectfolio&scope=user,gist,user:email&allow_signup=true");
                          },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(FontAwesomeIcons.github,
                                    color: Colors.black),
                                const SizedBox(width: 10),
                                Text(
                                  "Sign In With Github".toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class GetUserInfoPage extends StatelessWidget {
  final String token;
  const GetUserInfoPage({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetUserDataCubit()..init(code: token),
      child: Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=464&q=80'),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 10),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      boxShadow: kElevationToShadow[8],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: BlocConsumer<GetUserDataCubit, GetUserDataState>(
                      listener: (context, state) {
                        if (state.status == GetUserStatus.success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavBar(
                                uid: state.user['id'].toString(),
                              ),
                            ),
                          );
                        }
                        if (state.status == GetUserStatus.error) {
                          Scaffold.of(context).showSnackBar(const SnackBar(
                              content: Text('Something wents wrong!!')));
                        }
                      },
                      builder: (context, state) {
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 70,
                                width: 70,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey.shade400,
                                  strokeWidth: 3,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Getting user info..",
                                style: TextStyle(
                                    color: Colors.white, letterSpacing: 1),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
