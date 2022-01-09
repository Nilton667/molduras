import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molduras/app/controllers/homeController.dart';
import 'package:molduras/app/tabs/encomendaTab.dart';
import 'package:molduras/app/tabs/materiaPrimaTab.dart';
import 'package:molduras/app/tabs/produtosTab.dart';
import 'package:molduras/app/util/global.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../tabs/homeTab.dart';
import '../tabs/ClientesTab.dart';
import '../widgets/side_menu.dart';
import 'package:animate_do/animate_do.dart';

class Home extends StatelessWidget {
  final c = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      initState: (_) {
        c.init();
      },
      builder: (_) {
        return Scaffold(
          drawer: Platform.isAndroid
              ? Drawer(
                  child: ListView(
                    children: [
                      new UserAccountsDrawerHeader(
                        decoration: BoxDecoration(color: Colors.yellow[900]),
                        currentAccountPicture: new CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.black,
                          child: Text(
                            '${userData[0]['nome'][0]}${userData[0]['sobrenome'][0]}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        accountEmail: Text('${userData[0]['email']}'),
                        accountName: Text(
                          '${userData[0]['nome']} ${userData[0]['sobrenome']}',
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Perfil'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Definiçōes'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.logout_outlined),
                        title: Text('Terminar sessão'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          loginOff();
                        },
                      ),
                    ],
                  ),
                )
              : null,
          appBar: Platform.isAndroid
              ? AppBar(
                  backgroundColor: Colors.yellow[900],
                  title: Text("Aphit Molduras"),
                  elevation: 0,
                )
              : null,
          body: ResponsiveBuilder(
            builder: (context, sizingInformation) {
              if (sizingInformation.isDesktop) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    c.isMenuVisible
                        ? SlideInLeft(
                            duration: Duration(milliseconds: 100),
                            child: SideMenu(
                              tabController: c.tabController,
                              key: c.key,
                            ),
                          )
                        : SizedBox(),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              controller: c.tabController,
                              children: [
                                HomeTab(
                                  sidemenuTabController: c.tabController,
                                ),
                                UserTab(),
                                ProdutosTab(),
                                EncomendaTab(),
                                MateriaPrimaTab()
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  c.isMenuVisible
                      ? SlideInLeft(
                          duration: Duration(milliseconds: 100),
                          child: SideMenu(
                            tabController: c.tabController,
                            key: c.key,
                          ),
                        )
                      : SizedBox(),
                  Expanded(
                    child: Column(
                      children: [
                        Platform.isAndroid
                            ? Center()
                            : AppBar(
                                elevation: 1,
                                backgroundColor: Colors.yellow.shade800,
                                leading: IconButton(
                                  icon: Icon(Icons.menu),
                                  onPressed: () {
                                    c.isMenuVisible = !c.isMenuVisible;
                                    c.update();
                                  },
                                ),
                                title: Text(
                                  "Aphit Molduras",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                        Flexible(
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: c.tabController,
                            children: [
                              HomeTab(
                                sidemenuTabController: c.tabController,
                              ),
                              UserTab(),
                              ProdutosTab(),
                              EncomendaTab(),
                              MateriaPrimaTab()
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
                //Outras Tabs
              );
            },
          ),
        );
      },
    );
  }
}
