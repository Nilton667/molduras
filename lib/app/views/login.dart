import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:molduras/app/controllers/authController.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:molduras/app/models/widget.dart';
import 'package:molduras/app/util/global.dart';
import 'package:molduras/app/views/recoverPass.dart';
import 'package:molduras/app/views/register.dart';

class LoginScreen extends StatelessWidget {
  final c = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      initState: (_) {
        c.isUserAuth();
      },
      init: AuthController(),
      builder: (_) {
        return Scaffold(
          body: ModalProgressHUD(
            progressIndicator: progressIndicator(),
            inAsyncCall: c.isLoading,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1573164574572-cb89e39749b4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",
                    headers: {
                      "Access-Control-Allow-Origin": "*",
                      'Access-Control-Allow-Methods': 'GET',
                      'Access-Control-Allow-Headers': 'Content-Type',
                      'Access-Control-Max-Age': '3600'
                    },
                  ),
                ),
              ),
              child: Center(
                child: ScrollConfiguration(
                  behavior: NoGlowBehavior(),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: c.formKey,
                          child: Center(
                            child: Container(
                              margin: Platform.isWindows
                                  ? EdgeInsets.only(top: 100)
                                  : EdgeInsets.only(top: 25.0, bottom: 25.0),
                              width: 400,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 30,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 6),
                                  Image.asset(
                                    "assets/aphit.jpg",
                                    width: 75,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Aphit Molduras',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.yellow.shade800,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                            color: Colors.red,
                                          ),
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                          fillColor: Colors.grey[100],
                                          filled: true,
                                          prefixIcon: Icon(Icons.mail_outline),
                                          hintText: 'Endereço de email',
                                          border: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "O campo email é requerido";
                                          }
                                        },
                                        controller: c.email,
                                      ),
                                      SizedBox(height: 9),
                                      TextFormField(
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        obscureText: c.isPasswordVisible,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                          errorStyle: TextStyle(
                                            color: Colors.red,
                                          ),
                                          fillColor: Colors.grey[100],
                                          filled: true,
                                          prefixIcon: Icon(Icons.lock_outline),
                                          suffixIcon: IconButton(
                                            icon: Icon(c.isPasswordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              c.isPasswordVisible =
                                                  !c.isPasswordVisible;
                                              c.update();
                                            },
                                          ),
                                          hintText: 'Senha',
                                          border: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Preencha a senha";
                                          }
                                          if (value.length < 8) {
                                            return 'A senha deve ter pelo menos 8 dígitos';
                                          }
                                        },
                                        controller: c.password,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          minimumSize:
                                              Size(double.infinity, 50),
                                          backgroundColor: Colors.yellow[900],
                                        ),
                                        onPressed: () {
                                          c.formSubmit(context);
                                        },
                                        child: Text(
                                          'Entrar no sistema',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              width: 100,
                                              height: 1,
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            child: Text("OU"),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              width: 100,
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          minimumSize: Size(
                                            double.infinity,
                                            50.0,
                                          ),
                                          backgroundColor: Colors.black,
                                        ),
                                        onPressed: () {
                                          Get.to(() => Register());
                                        },
                                        child: Text(
                                          'Criar conta',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          minimumSize: Size(
                                            double.infinity,
                                            50.0,
                                          ),
                                          backgroundColor: Colors.black,
                                        ),
                                        onPressed: () {
                                          Get.to(Recover());
                                        },
                                        child: Text(
                                          'Esqueceu a senha?',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
