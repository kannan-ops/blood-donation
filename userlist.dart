import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class UserListPage extends StatefulWidget {
  final String bloodType;
  final String location;

  const UserListPage({
    super.key,
    required this.bloodType,
    required this.location,
  });

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  Future<dynamic>? futureData;

  Future<dynamic> postdata() async {
    var res = await http.post(
      Uri.parse(
          "https://kannan-blood-donation.onrender.com/donation/get-by-type"),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        "bloodType": widget.bloodType,
        "location": widget.location,
      }),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to fetch data: ${res.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    futureData = postdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:  Text(
          "Blood Donors",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon:  Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                futureData = postdata();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(
                child: CircularProgressIndicator(color: Colors.redAccent),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style:  TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data;
              var results = data["donations"];

              if (results.isEmpty) {
                return  Center(
                  child: Text(
                    "No donors found nearby",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  var donor = results[index];
                  var user = donor["userDetails"] ?? {};

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black, // Card black background
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset:  Offset(4, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                   Icon(Icons.bloodtype,
                                      color: Colors.redAccent, size: 28),
                                   SizedBox(width: 8),
                                  Text(
                                    donor["bloodType"] ?? "",
                                    style:  TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent, // only blood type red
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon:  Icon(Icons.share,
                                    color: Colors.redAccent),
                                onPressed: () {
                                  final shareText = '''
🩸 Blood Donor Details:
Name: ${user["username"] ?? ""}
Blood Type: ${donor["bloodType"] ?? ""}
Phone: ${user["phoneno"] ?? ""}
Email: ${user["email"] ?? ""}
Location: ${donor["location"] ?? ""}
Shared via Blood Donation App ❤️
''';
                                  Share.share(shareText);
                                },
                              ),
                            ],
                          ),
                           Divider(color: Colors.white70, thickness: 1),


                          Row(
                            children: [
                               Icon(Icons.person,
                                  color: Colors.white70, size: 22),
                               SizedBox(width: 8),
                              Text(
                                user["username"] ?? "",
                                style:  TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: 8),


                          Row(
                            children: [
                               Icon(Icons.phone,
                                  color: Colors.green, size: 22),
                               SizedBox(width: 8),
                              Text(
                                user["phoneno"] ?? "",
                                style:  TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: 8),


                          Row(
                            children: [
                               Icon(Icons.email,
                                  color: Colors.blue, size: 22),
                               SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  user["email"] ?? "",
                                  style:  TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: 8),


                          GestureDetector(
                            onTap: () async {
                              final loc = donor["location"]?.toString();
                              if (loc != null && loc.isNotEmpty) {
                                final Uri mapUri = Uri.parse(
                                    "https://www.google.com/maps/search/?api=1&query=$loc");
                                if (await canLaunchUrl(mapUri)) {
                                  await launchUrl(mapUri,
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                     SnackBar(
                                        content:
                                        Text('Cannot open Google Maps')),
                                  );
                                }
                              }
                            },
                            child: Row(
                              children: [
                                 Icon(Icons.location_on,
                                    color: Colors.orange, size: 22),
                                 SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    donor["location"] ?? "",
                                    style:  TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                           SizedBox(height: 15),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  final phone = user["phoneno"]?.toString();
                                  if (phone != null && phone.isNotEmpty) {
                                    final Uri phoneUri =
                                    Uri(scheme: 'tel', path: phone);
                                    if (await canLaunchUrl(phoneUri)) {
                                      await launchUrl(phoneUri);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Cannot launch phone dialer')),
                                      );
                                    }
                                  }
                                },
                                icon:  Icon(Icons.phone, size: 18),
                                label:  Text("Call"),
                              ),
                               SizedBox(width: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  final email = user["email"]?.toString();
                                  if (email != null && email.isNotEmpty) {
                                    final Uri emailUri = Uri(
                                      scheme: 'mailto',
                                      path: email,
                                      queryParameters: {
                                        'subject':
                                        'Blood Donation Request',
                                        'body':
                                        'Hello, I would like to request your help for a blood donation.',
                                      },
                                    );
                                    if (await canLaunchUrl(emailUri)) {
                                      await launchUrl(emailUri,
                                          mode: LaunchMode
                                              .externalApplication);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Cannot open email app')),
                                      );
                                    }
                                  }
                                },
                                icon:  Icon(Icons.email, size: 18),
                                label:  Text("Email"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return  Center(
                child: Text(
                  "No data found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
