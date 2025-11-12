import 'package:blooddonation/userlist.dart';
import 'package:blooddonation/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Receiver extends StatefulWidget {
  const Receiver({super.key});

  @override
  State<Receiver> createState() => _ReceiverState();
}

class _ReceiverState extends State<Receiver> {
  final TextEditingController bloodtypeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  List<String> tamilNaduDistricts = [
    "Chennai", "Coimbatore", "Madurai", "Tiruchirappalli", "Salem",
    "Tirunelveli", "Erode", "Thoothukudi", "Vellore", "Tiruppur",
    "Dindigul", "Karur", "Nagapattinam", "Thanjavur", "Villupuram",
    "Cuddalore", "Kanchipuram", "Namakkal", "Perambalur", "Sivagangai",
    "Virudhunagar", "Tiruvarur", "Ramanathapuram", "Theni", "Krishnagiri",
    "Dharmapuri", "Pudukkottai", "Mayiladuthurai",
  ];

  List<String> bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];


  Widget buildAnimatedField({required Widget child, required int delay}) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin:  Offset(0, 0.3), end: Offset.zero),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOut,
      builder: (context, Offset offset, _) {
        return Transform.translate(
          offset: offset * 50,
          child: AnimatedOpacity(
            duration:  Duration(milliseconds: 500),
            opacity: 1.0,
            child: child,
          ),
        );
      },
    );
  }

  Widget _customDropdownField({
    required TextEditingController controller,
    required String hint,
    required List<String> list,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () async {
        String? selected = await showModalBottomSheet<String>(
          context: context,
          shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
          builder: (context) => Container(
            color: isDark ? Colors.grey[900] : Colors.white,
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: list.length,
              separatorBuilder: (_, __) =>  Divider(),
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  list[index],
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.redAccent : Colors.red,
                  ),
                ),
                onTap: () => Navigator.pop(context, list[index]),
              ),
            ),
          ),
        );
        if (selected != null) setState(() => controller.text = selected);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: isDark ? Colors.black87 : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color:
              (isDark ? Colors.redAccent : Colors.redAccent).withOpacity(0.3),
              blurRadius: 8,
              offset:  Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.text.isEmpty ? hint : controller.text,
              style: TextStyle(
                fontSize: 16,
                color: controller.text.isEmpty
                    ? (isDark ? Colors.grey : Colors.black54)
                    : Colors.redAccent,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() => controller.clear()),
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.clear, color: Colors.redAccent),
                    ),
                  ),
                 Icon(Icons.arrow_drop_down, color: Colors.redAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          "Find Blood",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor:
        isDarkMode ? Colors.redAccent.shade700 : Colors.redAccent,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image:  DecorationImage(
                  image: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSuH0SMS32msG8SASgsHCBiF3Oz7JKSkzip0A&s"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black45,
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
             SizedBox(height: 30),


            buildAnimatedField(
              delay: 50,
              child: Text(
                "Select your District and Blood Group to find donors nearby ❤️",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
             SizedBox(height: 25),


            buildAnimatedField(
              delay: 100,
              child: _customDropdownField(
                controller: locationController,
                hint: "Select District",
                list: tamilNaduDistricts,
                isDark: isDarkMode,
              ),
            ),
             SizedBox(height: 20),


            buildAnimatedField(
              delay: 200,
              child: _customDropdownField(
                controller: bloodtypeController,
                hint: "Select Blood Group",
                list: bloodGroups,
                isDark: isDarkMode,
              ),
            ),
             SizedBox(height: 35),


            buildAnimatedField(
              delay: 300,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon:  Icon(Icons.search),
                  label:  Text(
                    "Find Donors",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                  ),
                  onPressed: () {
                    final blood = bloodtypeController.text;
                    final location = locationController.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserListPage(
                          bloodType: blood,
                          location: location,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
             SizedBox(height: 20),


            buildAnimatedField(
              delay: 400,
              child: Text(
                "Your small step can save someone's life 💉",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
