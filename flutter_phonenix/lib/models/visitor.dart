import 'package:equatable/equatable.dart';

class Visitor extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String purpose;
  final String hostName;
  final DateTime entryTime;
  final DateTime? exitTime;
  final String status; // 'inside' or 'exited'
  final String companyName;
  final String documentType; // 'passport', 'id_card', 'driving_license'
  final String documentNumber;

  const Visitor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.purpose,
    required this.hostName,
    required this.entryTime,
    this.exitTime,
    required this.status,
    required this.companyName,
    required this.documentType,
    required this.documentNumber,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      purpose: json['purpose'] ?? '',
      hostName: json['hostName'] ?? '',
      entryTime: json['entryTime'] != null
          ? DateTime.parse(json['entryTime'].toString())
          : DateTime.now(),
      exitTime: json['exitTime'] != null
          ? DateTime.parse(json['exitTime'].toString())
          : null,
      status: json['status'] ?? 'inside',
      companyName: json['companyName'] ?? '',
      documentType: json['documentType'] ?? 'passport',
      documentNumber: json['documentNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'purpose': purpose,
      'hostName': hostName,
      'entryTime': entryTime.toIso8601String(),
      'exitTime': exitTime?.toIso8601String(),
      'status': status,
      'companyName': companyName,
      'documentType': documentType,
      'documentNumber': documentNumber,
    };
  }

  Visitor copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? purpose,
    String? hostName,
    DateTime? entryTime,
    DateTime? exitTime,
    String? status,
    String? companyName,
    String? documentType,
    String? documentNumber,
  }) {
    return Visitor(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      purpose: purpose ?? this.purpose,
      hostName: hostName ?? this.hostName,
      entryTime: entryTime ?? this.entryTime,
      exitTime: exitTime ?? this.exitTime,
      status: status ?? this.status,
      companyName: companyName ?? this.companyName,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        purpose,
        hostName,
        entryTime,
        exitTime,
        status,
        companyName,
        documentType,
        documentNumber,
      ];
}
