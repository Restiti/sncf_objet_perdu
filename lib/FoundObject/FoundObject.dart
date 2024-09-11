class FoundObject {
  final String date;
  final String? gcOboDateHeureRestitutionC;
  final String gcOboGareOrigineRName;
  final String gcOboGareOrigineRCodeUicC;
  final String gcOboNatureC;
  final String gcOboTypeC;
  final String gcOboNomRecordtypeScC;

  FoundObject({
    required this.date,
    this.gcOboDateHeureRestitutionC,
    required this.gcOboGareOrigineRName,
    required this.gcOboGareOrigineRCodeUicC,
    required this.gcOboNatureC,
    required this.gcOboTypeC,
    required this.gcOboNomRecordtypeScC,
  });

  factory FoundObject.fromJson(Map<String, dynamic> json) {
    return FoundObject(
      date: json['date'],
      gcOboDateHeureRestitutionC: json['gc_obo_date_heure_restitution_c'],
      gcOboGareOrigineRName: json['gc_obo_gare_origine_r_name'],
      gcOboGareOrigineRCodeUicC: json['gc_obo_gare_origine_r_code_uic_c'],
      gcOboNatureC: json['gc_obo_nature_c'],
      gcOboTypeC: json['gc_obo_type_c'],
      gcOboNomRecordtypeScC: json['gc_obo_nom_recordtype_sc_c'],
    );
  }
}
