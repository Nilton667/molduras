import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molduras/app/controllers/authController.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:molduras/app/models/widget.dart';
import 'package:molduras/app/util/global.dart';

class Register extends StatelessWidget {
  final c = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      init: RegisterController(),
      builder: (_) {
        return Scaffold(
          body: ModalProgressHUD(
            progressIndicator: progressIndicator(),
            inAsyncCall: c.isRegisterLoading,
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
                        child: FadeInDown(
                          child: Form(
                            key: c.formKeySingUp,
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
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
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
                                        hintText: 'Email ',
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "O campo email é requerido";
                                        }

                                        if (!c.emailValidate(value)) {
                                          return 'Por favor, insira um email válido';
                                        }
                                      },
                                      controller: c.email,
                                    ),
                                    SizedBox(height: 10),
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
                                        prefixIcon: Icon(Icons.account_box),
                                        hintText: 'Nome',
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "O nome de usuário é requerido";
                                        }
                                        if (value.length < 4) {
                                          return 'O nome de usuário não pode ser inferior a 4 caracteres';
                                        }
                                      },
                                      controller: c.nome,
                                    ),
                                    SizedBox(height: 10),
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
                                        prefixIcon: Icon(Icons.account_box),
                                        hintText: 'Sobrenome',
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "O sobrenome de usuário é requerido";
                                        }
                                        if (value.length < 4) {
                                          return 'O sobrenome de usuário não pode ser inferior a 4 caracteres';
                                        }
                                      },
                                      controller: c.sobrenome,
                                    ),
                                    SizedBox(height: 10),
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
                                        minimumSize: Size(double.infinity, 50),
                                        backgroundColor: Colors.yellow[900],
                                      ),
                                      onPressed: () {
                                        c.singUp(context);
                                      },
                                      child: Text(
                                        'Reistar usuário',
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
                                        minimumSize: Size(double.infinity, 50),
                                        backgroundColor: Colors.black,
                                      ),
                                      onPressed: () {
                                        c.nome.clear();
                                        c.sobrenome.clear();
                                        c.email.clear();
                                        c.password.clear();
                                        Get.back();
                                      },
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
