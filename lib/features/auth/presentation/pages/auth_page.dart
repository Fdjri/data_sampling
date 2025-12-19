import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:go_router/go_router.dart';
import '../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());

    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 1. Header & Animation Layer (Animated Height)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: 0,
            left: 0,
            right: 0,
            height: size.height * (isKeyboardOpen ? 0.35 : 0.48),
            child: Column(
              children: [
                // Logo & Text (Hides when keyboard Open)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isKeyboardOpen ? 0 : 180,
                  curve: Curves.easeOut,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: FadeTransition(
                      opacity: AlwaysStoppedAnimation(
                        isKeyboardOpen ? 0.0 : 1.0,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.change_history,
                              size: 32,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Daspel",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            "Data Sampling Manager",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: RiveAnimation.asset(
                      "assets/rive/teddy.riv",
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                      stateMachines: const ["Login Machine"],
                      onInit: (artboard) =>
                          loginController.onRiveInit(artboard),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. White Bottom Sheet Layer (Animated Top Position)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: size.height * (isKeyboardOpen ? 0.30 : 0.45),
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: CurvedTopClipper(),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      const Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Email Field
                      _buildTextField(
                        controller: loginController.emailController,
                        focusNode: loginController.emailFocusNode,
                        label: "Email",
                        isUnseen: false,
                        onChanged: (value) {
                          loginController.lookAtNumber?.value = value.length
                              .toDouble();
                        },
                      ),

                      const SizedBox(height: 24),

                      // Password Field
                      Obx(
                        () => _buildTextField(
                          controller: loginController.passwordController,
                          focusNode: loginController.passwordFocusNode,
                          label: "Password",
                          isUnseen: true,
                          obscureText: loginController.passwordInVisible.value,
                          onToggleVisibility: () {
                            loginController.passwordInVisible.toggle();
                          },
                          onSubmitted: (_) async {
                            bool success = await loginController.login();
                            if (success && context.mounted) {
                              context.goNamed('sampling');
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Login Button
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool success = await loginController.login();
                            if (success && context.mounted) {
                              context.goNamed('sampling');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Obx(
                            () => loginController.showLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Log in",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      Center(
                        child: RichText(
                          text: const TextSpan(
                            text: "Don't have account? ",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Create now",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required bool isUnseen,
    bool obscureText = false,
    Function(String)? onChanged,
    VoidCallback? onToggleVisibility,
    Function(String)? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
            children: const [
              TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            suffixIcon: isUnseen
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 50);
    path.quadraticBezierTo(size.width / 2, -20, size.width, 50);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
