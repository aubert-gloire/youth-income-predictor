import 'package:flutter/material.dart';
import 'prediction_page.dart';

// Neumorphic color palette
const kBgStart = Color(0xFF181A24); // Very dark gradient start
const kBgEnd = Color(0xFF23242A);   // Very dark gradient end
const kCard = Color(0xFF23242A);    // Card color
const kPrimary = Color(0xFF7B4FFF); // Vibrant purple (for buttons)
const kAccent = Color(0xFFFF9100);  // Orange accent for glow
const kText = Colors.white;
const kTextSecondary = Color(0xFFB0B0C3);

// Icon colors
const kIconTrending = kAccent; // Orange for trending
const kIconGraph = Color(0xFF2979FF); // Blue
const kIconBulb = Color(0xFFFFD600); // Yellow
const kIconPerson = Color(0xFF7B4FFF); // Purple

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youth Income Predictor',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBgEnd, // fallback
        cardColor: kCard,
        primaryColor: kPrimary,
        colorScheme: ColorScheme.dark(
          primary: kPrimary,
          secondary: kAccent,
          surface: kCard,
        ),
                textTheme: const TextTheme(
                    bodyLarge: TextStyle(color: kText, fontSize: 15),
                    bodyMedium: TextStyle(color: kTextSecondary, fontSize: 13),
                ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: kText,
          elevation: 0,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: kText),
      ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimary,
            foregroundColor: Colors.white,
            shape: StadiumBorder(),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: kPrimary,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      home: const HomePage(),
      routes: {
        '/predict': (context) => PredictionPage(),
        '/about': (context) => AboutPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kCard,
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: kIconPerson.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.emoji_people, color: kIconPerson, size: 32),
            ),
            const SizedBox(width: 14),
            Text(
              'YouthPredict',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: kText),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kBgStart, kBgEnd],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _FeatureCard(
                  icon: Icons.trending_up,
                  iconBg: kIconTrending.withValues(alpha: 0.18),
                  iconColor: kIconTrending,
                  glow: true,
                  title: 'Smart Youth Income Predictions',
                  description: 'Harness the power of machine learning to predict youth monthly income with high accuracy.',
                ),
                const SizedBox(height: 28),
                _FeatureCard(
                  icon: Icons.auto_graph,
                  iconBg: kIconGraph.withValues(alpha: 0.18),
                  iconColor: kIconGraph,
                  glow: true,
                  title: 'ML Predictions',
                  description: 'Advanced linear regression and ensemble models for reliable results.',
                ),
                const SizedBox(height: 28),
                _FeatureCard(
                  icon: Icons.lightbulb,
                  iconBg: kIconBulb.withValues(alpha: 0.18),
                  iconColor: kIconBulb,
                  glow: true,
                  title: 'Empowering Youth',
                  description: 'Support informed decisions about education, skills, and career planning.',
                ),
                const SizedBox(height: 44),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                        side: const BorderSide(
                          color: Colors.white12,
                          width: 1.2,
                        ),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black.withValues(alpha: 0.4),
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/predict'),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF44464A), Color(0xFF181A24)], // darker grey gradient
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.analytics, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Start Prediction',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: kCard,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/about'),
                  child: const Text('About'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final bool glow;
  final String title;
  final String description;
  const _FeatureCard({required this.icon, required this.iconBg, required this.iconColor, required this.title, required this.description, this.glow = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 28),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          // Outer shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.7),
            blurRadius: 16,
            offset: const Offset(8, 8),
          ),
          // Soft highlight
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(-6, -6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
              boxShadow: glow
                  ? [
                      BoxShadow(
                        color: (iconColor == kIconGraph ? kIconGraph : kAccent).withValues(alpha: 0.18),
                        blurRadius: 18,
                        spreadRadius: 4,
                      ),
                    ]
                  : [],
            ),
            child: Icon(icon, color: iconColor, size: 38),
          ),
          const SizedBox(height: 28),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: kText,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: kTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: kCard,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Container(
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.analytics, color: kPrimary, size: 48),
                const SizedBox(height: 18),
                Text(
                  'Youth Income Predictor',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Text(
                  'How it works:',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kAccent),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Enter your age, education, region, and other details.\n• The app uses a machine learning model trained on real Rwandan youth data.\n• Instantly get a predicted monthly income based on your profile.',
                  style: const TextStyle(fontSize: 12, color: kTextSecondary),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 18),
                Text(
                  'Why is this important?',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kAccent),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Empowers youth to make informed decisions about education and career.\n• Highlights the impact of skills and training on income.\n• Supports policymakers and organizations in addressing youth unemployment.',
                  style: const TextStyle(fontSize: 12, color: kTextSecondary),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 18),
                Text(
                  'Solving Real Problems:',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kAccent),
                ),
                const SizedBox(height: 8),
                Text(
                  'This app bridges the gap between data and opportunity, helping youth and stakeholders understand and improve economic outcomes.',
                  style: const TextStyle(fontSize: 12, color: kTextSecondary),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
