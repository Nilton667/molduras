import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:molduras/app/util/global.dart';
import 'colapseItem.dart';
import 'custom_menu_icon_button.dart';
import 'user_profile.dart';

class SideMenu extends StatefulWidget {
  SideMenu({
    required Key key,
    required TabController tabController,
  })  : _tabController = tabController,
        super(key: key);

  final TabController _tabController;

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool isClienteLinkHover = false;
  bool isEncomendaLinkHover = false;
  bool isProdutosLinkHover = false;
  bool isRelatoriosLinkHover = false;
  String userName = "";
  int indexLinkActive = 0;

  getUserData() async {
    if (mounted) {
      setState(() {
        userName = '${userData[0]['nome']} ${userData[0]['sobrenome']}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getUserData();
    return Container(
      color: Color(0xFF1e282c),
      width: 240,
      child: Theme(
        data: ThemeData(highlightColor: Colors.red),
        child: Scrollbar(
          child: ListView(
            children: [
              SizedBox(height: 15),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: UserProfile(
                  userName: userName,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  CustomMenuIconButton(
                    title: 'Início',
                    icon: Icons.home,
                    onTap: () {
                      setState(
                        () {
                          widget._tabController.animateTo((0));
                          indexLinkActive = 0;
                        },
                      );
                    },
                    titleStyle: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                color: Color(0xFF1a2226),
                child: Row(
                  children: [
                    Text(
                      "Menu principal",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              buildMenuPrincipalItens(),
              Container(
                color: Color(0xFF1e282c),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: ExpandablePanel(
                  theme: ExpandableThemeData(
                    iconColor: Colors.white,
                    iconSize: 14,
                  ),
                  header: Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Definiçōes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  collapsed: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            loginOff();
                          },
                          child: ColaspeItem(
                            label: "Logout",
                            icon: Icons.logout,
                          ),
                        ),
                      ],
                    ),
                  ),
                  expanded: Center(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildMenuPrincipalItens() {
    return Container(
      color: Color(0xFF1e282c),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: ExpandablePanel(
        theme: ExpandableThemeData(
          iconColor: Colors.white,
          iconSize: 14,
        ),
        header: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.yellow.shade800,
                width: 2,
              ),
            ),
          ),
          child: InkWell(
            onTap: () {
              setState(
                () {
                  widget._tabController.animateTo((0));
                },
              );
            },
            child: Row(
              children: [
                SizedBox(
                  width: 3,
                ),
                Icon(
                  Icons.dashboard,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(
                  width: 7,
                ),
                Text(
                  "Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        collapsed: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 7,
          ),
          child: Column(
            children: [
              MouseRegion(
                onExit: (_) {
                  setState(
                    () {
                      isClienteLinkHover = false;
                    },
                  );
                },
                onHover: (_) {
                  setState(
                    () {
                      isClienteLinkHover = true;
                    },
                  );
                },
                child: InkWell(
                  onTap: () {
                    setState(
                      () {
                        Future.delayed(
                          Duration(seconds: 0),
                          () {
                            widget._tabController.animateTo((1));
                            indexLinkActive = 1;
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    color: indexLinkActive == 1
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.transparent,
                    child: Container(
                      color: isClienteLinkHover
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.transparent,
                      child: ColaspeItem(
                        label: "Clientes",
                        icon: Icons.people,
                      ),
                    ),
                  ),
                ),
              ),
              MouseRegion(
                onExit: (_) {
                  setState(
                    () {
                      isProdutosLinkHover = false;
                    },
                  );
                },
                onHover: (_) {
                  setState(
                    () {
                      isProdutosLinkHover = true;
                    },
                  );
                },
                child: InkWell(
                  onTap: () {
                    setState(
                      () {
                        widget._tabController.animateTo((2));
                        indexLinkActive = 2;
                      },
                    );
                  },
                  child: Container(
                    color: indexLinkActive == 2
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.transparent,
                    child: Container(
                      color: isProdutosLinkHover
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.transparent,
                      child: ColaspeItem(
                        label: "Produtos",
                        icon: Icons.shopping_bag_outlined,
                      ),
                    ),
                  ),
                ),
              ),
              MouseRegion(
                onExit: (_) {
                  setState(
                    () {
                      isRelatoriosLinkHover = false;
                    },
                  );
                },
                onHover: (_) {
                  setState(
                    () {
                      isRelatoriosLinkHover = true;
                    },
                  );
                },
                child: InkWell(
                  onTap: () {
                    setState(
                      () {
                        indexLinkActive = 4;
                        widget._tabController.animateTo((4));
                      },
                    );
                  },
                  child: Container(
                    color: indexLinkActive == 4
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.transparent,
                    child: Container(
                      color: isRelatoriosLinkHover
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.transparent,
                      child: ColaspeItem(
                        label: "Matérias Primas",
                        icon: Icons.bar_chart,
                      ),
                    ),
                  ),
                ),
              ),
              MouseRegion(
                onExit: (_) {
                  setState(
                    () {
                      isEncomendaLinkHover = false;
                    },
                  );
                },
                onHover: (_) {
                  setState(
                    () {
                      isEncomendaLinkHover = true;
                    },
                  );
                },
                child: InkWell(
                  onTap: () {
                    setState(
                      () {
                        indexLinkActive = 3;
                        widget._tabController.animateTo((3));
                      },
                    );
                  },
                  child: Container(
                    color: indexLinkActive == 3
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.transparent,
                    child: Container(
                      color: isEncomendaLinkHover
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.transparent,
                      child: ColaspeItem(
                        label: "Encomendas",
                        icon: Icons.delivery_dining,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        expanded: Center(),
      ),
    );
  }
}

class CustomSideMenuItem extends StatelessWidget {
  const CustomSideMenuItem({
    Key? key,
    required this.icon,
    this.iconSize = 18,
    this.iconColor = Colors.white,
    required this.title,
    required this.titleStyle,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;
  final Color iconColor;

  final String title;
  final TextStyle titleStyle;

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        color: Color(0xFF1a2226),
        child: Row(
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              title,
              style: titleStyle,
            ),
          ],
        ),
      ),
    );
  }
}
