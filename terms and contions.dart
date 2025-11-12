import 'package:flutter/material.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.info_outline, color: Colors.white),
        title: Text(
          "TERMS AND CONDITIONS",
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Icon(Icons.info_outline, color: Colors.white),
        ],
        backgroundColor: Color(0xFF1A237E),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white,
              Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1. Introduction",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              Text(
                "This app connects blood donors with those in need of blood, facilitating the donation and search process. By using this app, you agree to abide by these Terms and Conditions.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                "2. Eligibility",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              Text(
                "To use this app, users must meet the following eligibility criteria:\n"
                    "- Users must be at least 18 years old to donate blood.\n"
                    "- Blood donors should meet specific health requirements, such as minimum weight and hemoglobin levels.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                "3. User Responsibilities",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              Text(
                "Users of this app agree to:\n"
                    "- Provide accurate, truthful, and complete information during the registration process.\n"
                    "- Use the app for lawful purposes only and not engage in fraudulent activity or any form of abuse.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                "4. Blood Donation Process",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              Text(
                "To participate in blood donation:\n"
                    "- Users must undergo a health screening to ensure eligibility.\n"
                    "- Blood donors and recipients are matched based on blood type and location.\n"
                    "Please note that medical professionals will conduct necessary evaluations during the donation process.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                "5. Privacy and Data Protection",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              Text(
                "We value your privacy. We collect personal and health information solely to facilitate the donation process. Your information is kept secure and will only be shared with medical institutions or recipients when necessary. We will never sell or misuse your personal data.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                "6. Blood Search Feature",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              Text(
                "Users can search for blood donors or recipients by entering criteria such as blood type, location, and urgency. The app facilitates connections but cannot guarantee the availability of blood or the success of a match.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                "7. Limitation of Liability",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              Text(
                "By using the app, you acknowledge that we are not responsible for any medical issues that may arise during or after the blood donation process. We are also not responsible for the success or failure of blood donation or search attempts.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                "8. Termination of Use",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              Text(
                "We reserve the right to suspend or terminate your account if you violate any of the Terms and Conditions or misuse the app in any way.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                "9. Updates to Terms",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              Text(
                "We reserve the right to update these Terms and Conditions at any time. Any changes will be communicated to users via the app or email. Continued use of the app after updates signifies your acceptance of the modified terms.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                "10. Contact Information",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              Text(
                "If you have any questions about these Terms and Conditions, please contact us at:\n"
                    "- Email: support@yourapp.com\n"
                    "- Phone: +123 456 7890",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {

                      Navigator.pop(context);
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Terms accepted!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1A237E),
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
