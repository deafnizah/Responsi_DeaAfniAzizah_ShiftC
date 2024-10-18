class CatatanKehamilan {
  int? id;
  String? patientName;
  int? gestationalWeek;
  int? babyWeight;

  CatatanKehamilan({this.id, this.patientName, this.gestationalWeek, this.babyWeight});

  // Factory method to create an instance from a JSON object
  factory CatatanKehamilan.fromJson(Map<String, dynamic> obj) {
    return CatatanKehamilan(
      id: obj['id'],
      patientName: obj['patient_name'],
      gestationalWeek: obj['gestational_week'],
      babyWeight: obj['baby_weight'],
    );
  }
}
