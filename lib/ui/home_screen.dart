import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_styles.dart';
import 'participants_screen.dart';
import 'configuration_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.background,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF1C1C1E),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Icon(Icons.sports, color: Colors.white, size: 30),
                const SizedBox(height: 24),
                IconButton(
                  icon: const Icon(Icons.people, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                  onPressed: () {},
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.grey[800]),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppStyles.padding * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Hola, Emiliano!',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: AppStyles.darkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vamos a comenzar con la gestión de tu competencia',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppStyles.lightText,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Botones principales
                  Row(
                    children: [
                      _OptionCard(
                        title: 'Registro de Participantes',
                        icon: Icons.people,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ParticipantsScreen()),
                          );
                        },
                      ),
                      const SizedBox(width: 24),
                      _OptionCard(
                        title: 'Comenzar Competencia',
                        icon: Icons.play_arrow_rounded,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ConfigurationScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            color: AppStyles.card,
            borderRadius: BorderRadius.circular(AppStyles.cardRadius),
            boxShadow: [AppStyles.shadow],
          ),
          padding: const EdgeInsets.all(AppStyles.padding * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: AppStyles.accent),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppStyles.cardTitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
