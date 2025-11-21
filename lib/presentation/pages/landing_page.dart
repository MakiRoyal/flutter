import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF1A1F3A),
              Color(0xFF2A2F4A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header avec logo et boutons
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.sports_esports, 
                            color: const Color(0xFF6C63FF), size: 32),
                          const SizedBox(width: 12),
                          const Text(
                            'GameZone',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () => context.push('/login'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Connexion'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () => context.push('/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Inscription'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Hero Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
                  child: Column(
                    children: [
                      const Text(
                        'Votre boutique gaming de référence',
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Découvrez notre sélection exclusive de produits Sony',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[300],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      ElevatedButton(
                        onPressed: () => context.push('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 20),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Commencer'),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Features Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
                  child: Column(
                    children: [
                      const Text(
                        'Pourquoi choisir GameZone ?',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Wrap(
                        spacing: 32,
                        runSpacing: 32,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildFeatureCard(
                            icon: Icons.verified_user,
                            title: 'Produits authentiques',
                            description: '100% officiels et garantis',
                          ),
                          _buildFeatureCard(
                            icon: Icons.local_shipping,
                            title: 'Livraison rapide',
                            description: 'Recevez vos produits en 48h',
                          ),
                          _buildFeatureCard(
                            icon: Icons.support_agent,
                            title: 'Support 24/7',
                            description: 'Une équipe à votre écoute',
                          ),
                          _buildFeatureCard(
                            icon: Icons.lock,
                            title: 'Paiement sécurisé',
                            description: 'Vos données protégées',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Products Preview
                Container(
                  color: const Color(0xFF1A1F3A).withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
                  child: Column(
                    children: [
                      const Text(
                        'Nos produits phares',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildProductPreview(
                            'DualSense PS5',
                            '74,99 €',
                            Icons.gamepad,
                          ),
                          _buildProductPreview(
                            'INZONE H9',
                            '299,99 €',
                            Icons.headset,
                          ),
                          _buildProductPreview(
                            'PlayStation VR2',
                            '599,99 €',
                            Icons.vrpano,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // CTA Final
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
                  child: Column(
                    children: [
                      const Text(
                        'Prêt à commencer ?',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Inscrivez-vous dès maintenant et profitez de nos offres exclusives',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[300],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => context.push('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 20),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Créer un compte'),
                      ),
                    ],
                  ),
                ),
                
                // Footer
                Container(
                  color: const Color(0xFF0F0F23),
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.sports_esports, 
                            color: const Color(0xFF6C63FF), size: 24),
                          const SizedBox(width: 8),
                          const Text(
                            'GameZone',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '© 2025 GameZone. Tous droits réservés.',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: const Color(0xFF6C63FF)),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductPreview(String name, String price, IconData icon) {
    return Container(
      width: 220,
      height: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2F4A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 64, color: const Color(0xFF6C63FF)),
          ),
          const SizedBox(height: 24),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C63FF),
            ),
          ),
        ],
      ),
    );
  }
}
