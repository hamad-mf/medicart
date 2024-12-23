import 'package:flutter/material.dart';
import 'package:medicart/Controller/profile_selection_controller.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Admin%20Screens/Admin%20Login%20Screen/admin_login_screen.dart';
import 'package:medicart/View/Customer%20Screens/Login%20Screen/login_screen.dart';
import 'package:medicart/View/Doctor%20Screens/Doctor%20Login%20Screen/doctor_login_screen.dart';
import 'package:provider/provider.dart';

class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProfileSelectionController>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.mainbg,
        body: Column(
          children: [
            const SizedBox(height: 120),
            const Center(
              child: Text(
                "Who Are You?",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildRoleContainer(context, "Customer"),
                const SizedBox(width: 30),
                buildRoleContainer(context, "Doctor"),
              ],
            ),
            const SizedBox(height: 20),
            buildRoleContainer(context, "Admin"),
            const SizedBox(height: 30),
            if (controller.isRoleSelected)
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(ColorConstants.mainblack),
                    minimumSize: WidgetStatePropertyAll(Size(300, 50)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)))),
                onPressed: () {
                  // Navigate to the appropriate screen based on the selected role
                  switch (controller.selectedRole) {
                    case "Customer":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                      controller.clearSelection();
                      break;
                    case "Doctor":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DoctorLoginScreen()),
                      );
                      controller.clearSelection();
                      break;
                    case "Admin":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminLoginScreen()),
                      );
                      controller.clearSelection();
                      break;
                    default:
                      break;
                  }
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildRoleContainer(BuildContext context, String role) {
    final controller = Provider.of<ProfileSelectionController>(context);
    final isSelected = controller.selectedRole == role;

    return GestureDetector(
      onTap: () {
        controller.selectRole(role); // Update selection
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 120,
            height: 100,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[100] : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.black,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                role,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: -10,
              right: -10,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.blue,
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
