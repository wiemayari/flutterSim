import 'package:fintech_dashboard_clone/models/enums/transaction_type.dart';

class User {
  final String id;
  final String nom;
  final String prenom;
  final String mail;
  final String number;
  final String sexe;
  final String role;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.mail,
    required this.number,
    required this.sexe,
    required this.role,
  });
}

