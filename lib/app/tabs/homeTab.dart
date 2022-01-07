import 'dart:io';
import 'package:flutter/material.dart';
import 'package:molduras/app/controllers/homeController.dart';
import 'package:molduras/app/tabs/ClientesTab.dart';
import 'package:molduras/app/tabs/encomendaTab.dart';
import 'package:molduras/app/tabs/materiaPrimaTab.dart';
import 'package:molduras/app/tabs/produtosTab.dart';
import 'package:molduras/app/widgets/dashboardCard.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key? key, required this.sidemenuTabController}) : super(key: key);
  final TabController sidemenuTabController;
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late TooltipBehavior _tooltipBehavior;
  bool _isLoading = false;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //context.read<EncomendaController>().encomendas.length;
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Aphit Molduras ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  "Versão 1.0.0",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                )
              ],
            ),
            Platform.isWindows
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Dashboardcard(
                        icon: Icons.people,
                        color: Colors.yellow.shade900,
                        label: "CLIENTES",
                        value: 1,
                        onTap: () {
                          setState(() {
                            widget.sidemenuTabController.animateTo(1);
                          });
                        },
                      ),
                      Dashboardcard(
                        icon: Icons.shopping_bag_outlined,
                        color: Colors.blue,
                        label: "PRODUTOS",
                        value: 1,
                        onTap: () {
                          setState(() {
                            widget.sidemenuTabController.animateTo(2);
                          });
                        },
                      ),
                      Dashboardcard(
                        icon: Icons.bar_chart,
                        color: Colors.green,
                        label: "MATÉRIAS PRIMAS",
                        value: 1,
                        onTap: () {
                          setState(() {
                            widget.sidemenuTabController.animateTo(3);
                          });
                        },
                      ),
                      Dashboardcard(
                        icon: Icons.delivery_dining,
                        color: Colors.red.shade800,
                        label: "Encomendas",
                        value: 1,
                        onTap: () {},
                      ),
                    ],
                  )
                : Expanded(
                    child: Column(
                      children: [
                        Dashboardcard(
                          icon: Icons.people,
                          color: Colors.yellow.shade700,
                          label: "CLIENTES",
                          value: 1,
                          onTap: () {
                            if (Platform.isAndroid) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return UserTab();
                                  },
                                ),
                              );
                            } else {
                              setState(
                                () {
                                  widget.sidemenuTabController.animateTo(1);
                                },
                              );
                            }
                          },
                        ),
                        Dashboardcard(
                          icon: Icons.shopping_bag_outlined,
                          color: Colors.blue,
                          label: "PRODUTOS",
                          value: 1,
                          onTap: () {
                            if (Platform.isAndroid) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProdutosTab();
                                  },
                                ),
                              );
                            } else {
                              setState(
                                () {
                                  widget.sidemenuTabController.animateTo(2);
                                },
                              );
                            }
                          },
                        ),
                        Dashboardcard(
                          icon: Icons.bar_chart,
                          color: Colors.green,
                          label: "MATÉRIAS PRIMAS",
                          value: 1,
                          onTap: () {
                            if (Platform.isAndroid) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return MateriaPrimaTab();
                                  },
                                ),
                              );
                            } else {
                              setState(
                                () {
                                  widget.sidemenuTabController.animateTo(3);
                                },
                              );
                            }
                          },
                        ),
                        Dashboardcard(
                          icon: Icons.delivery_dining,
                          color: Colors.red.shade800,
                          label: "Encomendas",
                          value: 1,
                          onTap: () {
                            if (Platform.isAndroid) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return EncomendaTab();
                                  },
                                ),
                              );
                            } else {
                              setState(
                                () {
                                  widget.sidemenuTabController.animateTo(4);
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
            Platform.isAndroid
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Text("ESTATÍSTICAS DAS APLICAÇÃO"),
                  ),
            Platform.isAndroid
                ? SizedBox()
                : Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: SfCartesianChart(
                            tooltipBehavior: _tooltipBehavior,
                            primaryXAxis: CategoryAxis(),
                            series: <ChartSeries<SalesData, String>>[
                              ColumnSeries<SalesData, String>(
                                // Bind data source
                                dataSource: <SalesData>[
                                  SalesData(
                                      'Encomendas',
                                      /*context
                                        .watch<EncomendasController>()
                                        .encomendas
                                        .length
                                        .toDouble(),*/
                                      1),
                                  SalesData(
                                      'Produtos',
                                      /*context
                                        .watch<ProdutosController>()
                                        .produtos
                                        .length
                                        .toDouble(),*/
                                      1),
                                  SalesData(
                                      'Materias Primas',
                                      /*context
                                        .watch<MateriaPrimaController>()
                                        .produtos
                                        .length
                                        .toDouble(),*/
                                      1),
                                  SalesData(
                                      'Clientes',
                                      /*context
                                        .watch<ClientesController>()
                                        .clientes
                                        .length
                                        .toDouble(),*/
                                      1),
                                  SalesData('Usuarios', 2),
                                ],
                                xValueMapper: (SalesData sales, _) =>
                                    sales.year,
                                yValueMapper: (SalesData sales, _) =>
                                    sales.sales,
                                width: 0.8, // Width of the columns
                                spacing: 0.2,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          child: SfCartesianChart(
                            tooltipBehavior: _tooltipBehavior,
                            primaryXAxis: CategoryAxis(),
                            series: <LineSeries<SalesData, String>>[
                              LineSeries<SalesData, String>(
                                // Bind data source
                                dataSource: <SalesData>[
                                  SalesData(
                                      'Encomendas',
                                      /*context
                                          .watch<EncomendasController>()
                                          .encomendas
                                          .length
                                          .toDouble()),*/
                                      1),
                                  SalesData(
                                      'Produtos',
                                      /*context
                                          .watch<ProdutosController>()
                                          .produtos
                                          .length
                                          .toDouble())*/
                                      1),
                                  SalesData(
                                      'Materias Primas',
                                      /*context
                                        .watch<MateriaPrimaController>()
                                        .produtos
                                        .length
                                        .toDouble(),*/
                                      1),
                                  SalesData(
                                    'Clientes',
                                    /*context
                                        .watch<ClientesController>()
                                        .clientes
                                        .length
                                        .toDouble(),*/
                                    1,
                                  ),
                                  SalesData('Usuarios', 2),
                                ],
                                xValueMapper: (SalesData sales, _) =>
                                    sales.year,
                                yValueMapper: (SalesData sales, _) =>
                                    sales.sales,
                                width: 0.8, // Width of the columns
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
