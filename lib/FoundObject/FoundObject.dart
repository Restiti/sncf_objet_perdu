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


  String getColumnValue(String column) {
    switch (column) {
      case 'gcOboTypeC':
        return gcOboTypeC.toLowerCase();
      case 'gcOboGareOrigineRName':
        return gcOboGareOrigineRName.toLowerCase();
      case 'gcOboNatureC':
        return gcOboNatureC.toLowerCase();
      case 'gcOboNomRecordtypeScC':
        return gcOboNomRecordtypeScC.toLowerCase();
      default:
        return '';
    }
  }
  factory FoundObject.fromJson(Map<String, dynamic> json) {
    return FoundObject(
      date: json['date'] ?? 'Date inconnue',  // Valeur par défaut si la date est nulle
      gcOboDateHeureRestitutionC: json['gc_obo_date_heure_restitution_c'] ?? 'Non précisé',  // Valeur par défaut si c'est null
      gcOboGareOrigineRName: json['gc_obo_gare_origine_r_name'] ?? 'Gare inconnue',
      gcOboGareOrigineRCodeUicC: json['gc_obo_gare_origine_r_code_uic_c'] ?? '',
      gcOboNatureC: json['gc_obo_nature_c'] ?? 'Nature inconnue',
      gcOboTypeC: json['gc_obo_type_c'] ?? 'Type inconnu',
      gcOboNomRecordtypeScC: json['gc_obo_nom_recordtype_sc_c'] ?? '',
    );
  }

}
