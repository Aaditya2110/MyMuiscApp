import 'dart:io'; // Needed for FileImage
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Top-level widget now holds theme state.
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initially use light theme.
  bool _isDarkMode = false;

  // Toggle the theme.
  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  // Define the light theme: white background with purple accents.
  ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      secondary: Colors.purple,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    ),
    bottomAppBarColor: Colors.white,
  );

  // Define the dark theme: black background with purple accents.
  ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(
      primary: Colors.black,
      secondary: Colors.purple,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    bottomAppBarColor: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      // Use our state to decide which theme to display.
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // Pass the current theme state and callback to the home wrapper.
      home: DashboardWrapper(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

// Wrapper that contains bottom navigation and three pages.
class DashboardWrapper extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  const DashboardWrapper({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });
  
  @override
  State<DashboardWrapper> createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  int _selectedIndex = 0;
  
  // Return the current page based on selected index.
  Widget _getPage() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardPage();
      case 1:
        return const LibraryPage();
      case 2:
        return SettingsPage(
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
        );
      default:
        return const DashboardPage();
    }
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? 'Music'
              : _selectedIndex == 1
                  ? 'Library'
                  : 'Settings',
        ),
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Implement search action here.
                  },
                )
              ]
            : null,
      ),
      body: _getPage(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Music',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Dashboard page shows a header and grid of playlist cards.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Good Evening',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // A grid of playlist cards. Later you may populate this from your database.
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: List.generate(6, (index) {
              // For demo, we use a file URL if available; here we use a sample network URL.
              // When you add songs from your database, imageUrl may be a local file path.
              String imageUrl = index % 2 == 0
                  ? 'https://blog.spoongraphics.co.uk/wp-content/uploads/2017/album-art/17.jpg'
                  : '/storage/emulated/0/Music/album_thumbnail_$index.jpg';
              return PlaylistCard(
                title: 'Playlist ${index + 1}',
                imageUrl: imageUrl,
              );
            }),
          ),
        ],
      ),
    );
  }
}

// PlaylistCard displays a thumbnail image and a title.
// It checks whether the imageUrl starts with 'http'. If not, it uses FileImage.
class PlaylistCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  const PlaylistCard({
    super.key,
    required this.title,
    required this.imageUrl,
  });
  
  @override
  Widget build(BuildContext context) {
   
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // image: DecorationImage(
        //   image: imageProvider,
        //   fit: BoxFit.cover,
        // ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Colors.black87,
              offset: Offset(0, 2),
            )
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// A simple placeholder for Library page.
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Library Page',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

// Settings page now contains a switch to toggle dark/light mode.
class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        leading: Icon(
          isDarkMode ? Icons.brightness_3 : Icons.wb_sunny,
          color: Colors.purple,
        ),
        title: Text(
          isDarkMode ? "Dark Mode" : "Light Mode",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        trailing: Switch(
          activeColor: Colors.purple,
          value: isDarkMode,
          onChanged: onThemeChanged,
        ),
      ),
    );
  }
}
