import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';

class Donation extends StatefulWidget {
  const Donation({super.key});

  @override
  State<Donation> createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController phone = TextEditingController();
  TextEditingController bloodtype = TextEditingController();
  TextEditingController location = TextEditingController();

  String? userId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
      phone.text = (prefs.getString("phoneno") ?? "");
    });
  }

  Future<void> createDonation() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ No userId found")),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    var create = {
      "userId": userId,
      "bloodType": bloodtype.text.trim(),
      "location": location.text.trim(),
      "contactNumber": phone.text.trim(),
      "lastDonationDate": "",
    };

    try {
      var res = await http.post(
        Uri.parse(
          "https://kannan-blood-donation.onrender.com/donation/create-blood-donation",
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(create),
      );

      setState(() => isLoading = false);

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Donation submitted successfully")),
        );
        bloodtype.clear();
        location.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed: ${res.body}")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    }
  }

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
      duration:  Duration(milliseconds: 500),
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

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(120),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.grey.shade900, Colors.black]
                    : [Colors.redAccent, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:  BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            "Blood Donation",
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows:  [
                Shadow(
                  color: Colors.black54,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlaWV50Z0K6uGG_eXH9Ro_RDZ9SjmGHJyHqb_PNyem5HoYGLxYxSj8lSVqYzF2aSjNdQw&usqp=CAU",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 180, left: 16, right: 16, bottom: 30),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.85)
                    : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset:  Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Icon(Icons.bloodtype,
                        color: isDarkMode ? Colors.redAccent : Colors.redAccent,
                        size: 70),
                     SizedBox(height: 10),
                    Text(
                      "Donate Blood, Save Life ❤️",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.redAccent : Colors.redAccent,
                      ),
                    ),
                     SizedBox(height: 30),


                    buildAnimatedField(
                      delay: 100,
                      child: TextFormField(
                        controller: bloodtype,
                        readOnly: true,
                        style: TextStyle(
                            color: isDarkMode
                                ? Colors.redAccent
                                : Colors.redAccent),
                        validator: (value) =>
                        value!.isEmpty ? "Please select blood group" : null,
                        decoration: InputDecoration(
                          labelText: "Select Blood Group",
                          labelStyle: TextStyle(
                              color: isDarkMode
                                  ? Colors.redAccent
                                  : Colors.redAccent),
                          prefixIcon:
                           Icon(Icons.bloodtype, color: Colors.redAccent),
                          suffixIcon:  Icon(Icons.arrow_drop_down,
                              color: Colors.redAccent),
                          filled: true,
                          fillColor:
                          isDarkMode ? Colors.black87 : Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                             BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        onTap: () async {
                          String? selected =
                          await showModalBottomSheet<String>(
                            context: context,
                            shape:  RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25)),
                            ),
                            builder: (context) => Container(
                              color: Colors.white,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(20),
                                itemBuilder: (context, index) => ListTile(
                                  title: Text(
                                    bloodGroups[index],
                                    style:  TextStyle(
                                        fontSize: 18,
                                        color: Colors.redAccent),
                                  ),
                                  onTap: () => Navigator.pop(
                                      context, bloodGroups[index]),
                                ),
                                separatorBuilder: (_, __) =>  Divider(),
                                itemCount: bloodGroups.length,
                              ),
                            ),
                          );
                          if (selected != null)
                            setState(() => bloodtype.text = selected);
                        },
                      ),
                    ),
                     SizedBox(height: 20),


                    buildAnimatedField(
                      delay: 200,
                      child: TextFormField(
                        controller: location,
                        readOnly: true,
                        style: TextStyle(
                            color: isDarkMode
                                ? Colors.redAccent
                                : Colors.redAccent),
                        validator: (value) =>
                        value!.isEmpty ? "Please select location" : null,
                        decoration: InputDecoration(
                          labelText: "Select District",
                          labelStyle: TextStyle(
                              color: isDarkMode
                                  ? Colors.redAccent
                                  : Colors.redAccent),
                          prefixIcon:  Icon(Icons.location_on,
                              color: Colors.redAccent),
                          suffixIcon:  Icon(Icons.arrow_drop_down,
                              color: Colors.redAccent),
                          filled: true,
                          fillColor:
                          isDarkMode ? Colors.black87 : Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                             BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        onTap: () async {
                          String? selected =
                          await showModalBottomSheet<String>(
                            context: context,
                            shape:  RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25)),
                            ),
                            builder: (context) => Container(
                              color: Colors.white,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(20),
                                itemBuilder: (context, index) => ListTile(
                                  title: Text(
                                    tamilNaduDistricts[index],
                                    style:  TextStyle(
                                        fontSize: 18,
                                        color: Colors.redAccent),
                                  ),
                                  onTap: () => Navigator.pop(
                                      context, tamilNaduDistricts[index]),
                                ),
                                separatorBuilder: (_, __) =>  Divider(),
                                itemCount: tamilNaduDistricts.length,
                              ),
                            ),
                          );
                          if (selected != null)
                            setState(() => location.text = selected);
                        },
                      ),
                    ),
                    const SizedBox(height: 30),


                    buildAnimatedField(
                      delay: 300,
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : createDonation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor:
                            Colors.redAccent.withOpacity(0.5),
                          ),
                          child: isLoading
                              ?  CircularProgressIndicator(
                              color: Colors.white)
                              :  Text(
                            "Submit Donation",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                     SizedBox(height: 20),

                    buildAnimatedField(
                      delay: 400,
                      child:  Text(
                        "🩸 A drop of blood can make a huge difference 🩸",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
