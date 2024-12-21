import 'package:flutter/material.dart';
import 'package:medicart/Controller/profile_selection_controller.dart';
import 'package:medicart/View/Admin%20Screens/product_adding.dart';
import 'package:medicart/View/Customer%20Screens/Home%20Screen/home_screen.dart';
import 'package:medicart/View/Customer%20Screens/Login%20Screen/login_screen.dart';
import 'package:medicart/View/Doctor%20Screens/Home%20Screen/doctor_home_screen.dart';
import 'package:provider/provider.dart';


class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProfileSelectionController>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
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
                onPressed: () {
                  // Navigate to the appropriate screen based on the selected role
                  switch (controller.selectedRole) {
                    case "Customer":
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                      break;
                    case "Doctor":
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DoctorHomeScreen()),
                      );
                      break;
                    case "Admin":
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProductAdding()),
                      );
                      break;
                    default:
                      break;
                  }
                },
                child: const Text("Continue"),
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
