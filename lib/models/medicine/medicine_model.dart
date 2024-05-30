// ignore_for_file: public_member_api_docs, sort_constructors_first
class MedicineModels {
  String title;
  int dosage;
  String effect;
  bool prescription;
  bool supplement;
  MedicineModels({
    required this.title,
    required this.dosage,
    required this.effect,
    required this.prescription,
    required this.supplement,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    map['title'] = title;
    map['dosage'] = dosage;
    map['effect'] = effect;
    map['prescription'] = prescription;
    map['supplement'] = supplement;
    return map;
  }
}
