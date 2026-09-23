class ProjectBible {
  const ProjectBible({
    this.actors = const [],
    this.features = const [],
    this.businessRules = const [],
  });

  final List<String> actors;
  final List<Map<String, String>> features;
  final List<String> businessRules;

  factory ProjectBible.fromJson(Map<String, dynamic> json) {
    return ProjectBible(
      actors: (json['actors'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      features: (json['features'] as List<dynamic>?)?.map((e) {
        if (e is Map) {
          return e.map((k, v) => MapEntry(k.toString(), v.toString()));
        }
        return <String, String>{};
      }).toList() ?? [],
      businessRules: (json['business_rules'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'actors': actors,
        'features': features,
        'business_rules': businessRules,
      };

  bool get isEmpty => actors.isEmpty && features.isEmpty && businessRules.isEmpty;

  ProjectBible merge(ProjectBible other) {
    // Basic deduplication for features could be done here if needed
    return ProjectBible(
      actors: {...actors, ...other.actors}.toList(),
      features: [...features, ...other.features],
      businessRules: {...businessRules, ...other.businessRules}.toList(),
    );
  }
}
