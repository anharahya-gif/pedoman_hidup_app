class TajwidRule {
  final String key;
  final String name;
  final String definition;
  final String instruction;
  final List<String> generalExamples;

  const TajwidRule({
    required this.key,
    required this.name,
    required this.definition,
    required this.instruction,
    required this.generalExamples,
  });
}

class AyahTajwidOccurrence {
  final String ruleKey;
  final String phrase;
  final String reason;
  final List<int> characterRange;

  const AyahTajwidOccurrence({
    required this.ruleKey,
    required this.phrase,
    required this.reason,
    required this.characterRange,
  });

  Map<String, dynamic> toJson() {
    return {
      'rule_key': ruleKey,
      'phrase': phrase,
      'reason': reason,
      'range': characterRange,
    };
  }

  factory AyahTajwidOccurrence.fromJson(Map<String, dynamic> json) {
    return AyahTajwidOccurrence(
      ruleKey: json['rule_key'] as String,
      phrase: json['phrase'] as String,
      reason: json['reason'] as String,
      characterRange: List<int>.from(json['range'] as List),
    );
  }
}
