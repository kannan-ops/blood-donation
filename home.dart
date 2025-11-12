import 'dart:io';
import 'package:blooddonation/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'donation.dart';
import 'receiver.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username = "kannan_s";
  String bio = "PulseCare Volunteer";
  String gender = "male";
  File? avatarImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  /// ✅ Load profile from SharedPreferences
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "kannan_s";
      bio = prefs.getString('bio') ?? "PulseCare Volunteer";
      gender = prefs.getString('gender') ?? "male";
      String? imagePath = prefs.getString('avatarImage');
      if (imagePath != null && File(imagePath).existsSync()) {
        avatarImage = File(imagePath);
      }
    });
  }


  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('bio', bio);
    await prefs.setString('gender', gender);
    if (avatarImage != null) {
      await prefs.setString('avatarImage', avatarImage!.path);
    }
  }

  String get avatarUrl {
    if (avatarImage != null) {
      return avatarImage!.path;
    }
    return gender == "male"
        ? "https://i.pravatar.cc/150?img=3"
        : "https://i.pravatar.cc/150?img=5";
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        avatarImage = File(image.path);
      });
      _saveProfileData(); // save immediately when new image chosen
    }
    Navigator.pop(context);
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => SizedBox(
        height: 150,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text("Select Image", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera"),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo),
                  label: const Text("Gallery"),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showProfileSheet() {
    TextEditingController usernameController =
    TextEditingController(text: username);
    TextEditingController bioController = TextEditingController(text: bio);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  usernameController.text,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: avatarImage != null
                      ? FileImage(avatarImage!) as ImageProvider
                      : NetworkImage(avatarUrl),
                ),
                TextButton(
                  onPressed: _showImageSourceSheet,
                  child: const Text(
                    "Change Profile Picture",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: bioController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Bio",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () async {
                    setState(() {
                      username = usernameController.text;
                      bio = bioController.text;
                    });
                    await _saveProfileData(); // ✅ Save here
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onProfileMenuSelected(String value) async {
    if (value == 'logout') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else if (value == 'settings') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsPage()),
      );
    } else if (value == 'notifications') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotificationsPage()),
      );
    } else if (value == 'feedback') {
      _showFeedbackDialog();
    }
  }

  void _showFeedbackDialog() {
    TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "Feedback",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: feedbackController,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Write your feedback here...",
            hintStyle: TextStyle(color: Colors.white54),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
            const Text("Cancel", style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    feedbackController.text.isEmpty
                        ? "Feedback cannot be empty"
                        : "Thank you for your feedback ❤️",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            child: const Text("Submit",
                style: TextStyle(color: Colors.greenAccent)),
          ),
        ],
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
        backgroundColor: isDarkMode ? Colors.black : Colors.redAccent,
        elevation: 4,
        centerTitle: true,
        leading: GestureDetector(
          onTap: _showProfileSheet,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: avatarImage != null
                  ? FileImage(avatarImage!) as ImageProvider
                  : NetworkImage(avatarUrl),
            ),
          ),
        ),
        title: Text(
          "PulseCare",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,
                color: isDarkMode ? Colors.white : Colors.white),
            onSelected: _onProfileMenuSelected,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'notifications',
                child: Text('Notifications'),
              ),
              const PopupMenuItem<String>(
                value: 'feedback',
                child: Text('Feedback'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  "https://c1.wallpaperflare.com/preview/289/93/320/blood-blood-donation-health-donation.jpg",
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Save Lives with Every Drop ❤️",
                style: TextStyle(
                  fontSize: 20,
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 6,
                ),
                icon: const Icon(Icons.volunteer_activism, color: Colors.white),
                label: const Text(
                  "Donate Blood",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const Donation()));
                },
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 6,
                ),
                icon: const Icon(Icons.bloodtype, color: Colors.white),
                label: const Text(
                  "Find Blood",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const Receiver()));
                },
              ),
              const SizedBox(height: 40),
              Text(
                "Together, we can save lives 💪",
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ Settings Page
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: isDarkMode ? Colors.black : Colors.redAccent,
        elevation: 2,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.redAccent),
            title: const Text("Change Password"),
            subtitle: const Text("Update your login password"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Change Password Coming Soon")),
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            activeColor: Colors.redAccent,
            title: const Text("Enable Notifications"),
            subtitle: const Text("Get updates about blood requests"),
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() => notificationsEnabled = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? "Notifications Enabled 🔔"
                      : "Notifications Disabled 🔕"),
                ),
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            activeColor: Colors.redAccent,
            title: const Text("Dark Mode"),
            subtitle: const Text("Switch between light and dark themes"),
            value: isDarkMode,
            onChanged: (value) => themeProvider.setTheme(value),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ✅ Notifications Page
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> notifications = [];

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: notifications.isEmpty
          ? const Center(child: Text("No notifications yet 📭"))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(notifications[index]),
        ),
      ),
    );
  }
}
