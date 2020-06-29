/**
 * Created by Amon Apolonio
 * https://github.com/AmonApolonio
 */

import 'package:flutter/material.dart';
import 'package:zoomerstore/models/user_model.dart';
import 'package:zoomerstore/screens/login_screen.dart';
import 'package:zoomerstore/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 203, 236, 241),
                Colors.white,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 10.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8,
                      left: 0.0,
                      child: Text(
                        "Zoomer's\nClothing",
                        style: TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]} ",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if(!model.isLoggedIn())
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 500),
                                        transitionsBuilder:
                                            (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation,
                                                Widget child) {
                                          return SlideTransition(
                                            position: new Tween<Offset>(
                                              begin: const Offset(1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: new SlideTransition(
                                              position: new Tween<Offset>(
                                                begin: Offset.zero,
                                                end: const Offset(1.0, 0.0),
                                              ).animate(secondaryAnimation),
                                              child: child,
                                            ),
                                          );
                                        },
                                        pageBuilder: (
                                          BuildContext context,
                                          Animation<double> animation,
                                          Animation<double> secAnimation,
                                        ) {
                                          return LoginScreen();
                                        }),
                                  );
                                  else
                                    model.signOut();
                                },
                                child: Text(
                                  !model.isLoggedIn() ?
                                  "Entre ou cadastre-se >" : "Sair",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(Icons.list, "Produtos", pageController, 1),
              DrawerTile(Icons.location_on, "Lojas", pageController, 2),
              DrawerTile(
                  Icons.playlist_add_check, "Meus Pedidos", pageController, 3),
            ],
          ),
        ],
      ),
    );
  }
}
