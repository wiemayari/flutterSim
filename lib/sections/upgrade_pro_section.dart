import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fintech_dashboard_clone/responsive.dart';
import 'package:fintech_dashboard_clone/styles/styles.dart';

class UpgradeProSection extends StatelessWidget {
  const UpgradeProSection({Key? key}) : super(key: key);

  // Récupérer les prédictions depuis l'API
  Future<List<dynamic>> _fetchPredictions() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/predictions'));
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Echec de chargement des prédictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Styles.defaultYellowColor,
        borderRadius: Styles.defaultBorderRadius,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth < 600 ? 8.0 : Styles.defaultPadding,
        vertical: screenWidth < 600 ? 8.0 : Styles.defaultPadding,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section de texte
              Expanded(
                flex: isMobile ? 3 : 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: isMobile ? 14 : 18,
                          ),
                          children: [
                            const TextSpan(
                              text: "Surveillez l'état de santé de votre ",
                            ),
                            TextSpan(
                              text: "bébé",
                              style: TextStyle(
                                color: Styles.defaultRedColor,
                              ),
                            ),
                            const TextSpan(
                              text: " en toute sécurité.",
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Visibility(
                      visible: !isMobile,
                      child: Text(
                        "Avec cette fonctionnalité, obtenez des prédictions précises sur les états de risque pour la santé de votre bébé.",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: isMobile ? 12 : 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: isMobile ? 8 : 16),
              // Section image
              if (!isMobile)
                Expanded(
                  child: Image.asset(
                    "assets/astranaut.png",
                    height: 100,
                  ),
                ),
              // Section bouton icône
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                height: 50,
                width: 50,
                child: IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () async {
                    await _showPredictionsDialog(context);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showPredictionsDialog(BuildContext context) async {
    try {
      List<dynamic> predictions = await _fetchPredictions();
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section titre
                  Text(
                    'Toutes les prédictions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  Expanded(
                    child: predictions.isNotEmpty
                        ? ListView.builder(
                            itemCount: predictions.length,
                            itemBuilder: (context, index) {
                              var prediction = predictions[index];
                              return PredictionCard(prediction: prediction);
                            },
                          )
                        : Center(child: Text("Aucune prédiction trouvée.")),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.defaultRedColor,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Fermer'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Echec de chargement des prédictions: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fermer'),
            ),
          ],
        ),
      );
    }
  }
}

class PredictionCard extends StatefulWidget {
  final dynamic prediction;

  const PredictionCard({Key? key, required this.prediction}) : super(key: key);

  @override
  _PredictionCardState createState() => _PredictionCardState();
}

class _PredictionCardState extends State<PredictionCard> {
  bool _isIdHidden = true;

  void _toggleIdVisibility(BuildContext context) async {
    if (_isIdHidden) {
      String? password = await showDialog<String>(
        context: context,
        builder: (context) {
          TextEditingController _passwordController = TextEditingController();
          return AlertDialog(
            title: Text('Mot de passe requis'),
            content: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Entrez le mot de passe'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(_passwordController.text),
                child: Text('Confirmer'),
              ),
            ],
          );
        },
      );

      if (password == "777") {
        setState(() {
          _isIdHidden = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mot de passe incorrect.')),
        );
      }
    } else {
      setState(() {
        _isIdHidden = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _toggleIdVisibility(context),
              child: Row(
                children: [
                  Text(
                    "ID de prédiction:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          _isIdHidden ? "********" : widget.prediction['_id'],
                          style: TextStyle(
                            color: Colors.pink,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          _isIdHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.pink,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildAttributeRow("Age:", widget.prediction['age'].toString()),
            _buildAttributeRow("Tension systolique:", widget.prediction['systolicBP'].toString()),
            _buildAttributeRow("Tension diastolique:", widget.prediction['diastolicBP'].toString()),
            _buildAttributeRow("Glycémie:", widget.prediction['bs'].toString()),
            _buildAttributeRow("Température corporelle:", widget.prediction['bodyTemp'].toString()),
            _buildAttributeRow("Fréquence cardiaque:", widget.prediction['heartRate'].toString()),
            _buildAttributeRow("Niveau de risque:", widget.prediction['riskLevel']),
            _buildAttributeRow("Créé le:", widget.prediction['createdAt']),
          ],
        ),
      ),
    );
  }
  // Helper pour créer des lignes d'attributs
  Widget _buildAttributeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
