import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var passwordInVisible = true.obs;
  var showLoading = false.obs;
  SMITrigger? trigSuccess;
  SMITrigger? trigFail;
  SMIBool? isChecking;
  SMIBool? isHandsUp;
  SMINumber? lookAtNumber;

  //* Art Board & Controller
  Artboard? artboard;
  late StateMachineController? stateMachineController;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void onInit() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.onInit();
  }

  void onRiveInit(Artboard artboard) {
    final smName = artboard.stateMachines
        .firstWhere(
          (element) =>
              element.name == "Login Machine" ||
              element.name == "State Machine 1",
          orElse: () => artboard.stateMachines.first,
        )
        .name;
    stateMachineController = StateMachineController.fromArtboard(
      artboard,
      smName,
    );

    if (stateMachineController != null) {
      artboard.addController(stateMachineController!);
      isChecking =
          stateMachineController!.findInput<bool>("isChecking") as SMIBool?;
      isHandsUp =
          stateMachineController!.findInput<bool>("isHandsUp") as SMIBool?;
      trigSuccess =
          stateMachineController!.findInput<bool>("trigSuccess") as SMITrigger?;
      trigFail =
          stateMachineController!.findInput<bool>("trigFail") as SMITrigger?;
      lookAtNumber =
          stateMachineController!.findInput<double>("numLook") as SMINumber? ??
          stateMachineController!.findInput<double>("lookAtNumber")
              as SMINumber?;
    }
  }

  @override
  void onClose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void emailFocus() {
    isChecking?.value = emailFocusNode.hasFocus;
  }

  void passwordFocus() {
    isHandsUp?.value = passwordFocusNode.hasFocus;
  }

  Future<bool> login() async {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    
    isChecking?.value = false;
    isHandsUp?.value = false;

    showLoading.value = true;
    
    await Future.delayed(const Duration(seconds: 2));
    
    showLoading.value = false;

    if (emailController.text == 'testing@gmail.com' && passwordController.text == "testing") {
      trigSuccess?.fire();
      await Future.delayed(const Duration(seconds: 2));
      return true; 
    } else {
      trigFail?.fire();
      return false; 
    }
  }
}
