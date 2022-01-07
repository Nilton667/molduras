class SampleDataRow {
  SampleDataRow._({
    this.id,
    this.renderingEngine,
    this.browser,
    this.platform,
    this.engineVersion,
    this.cssGrade,
    this.dateTime,
  });

  factory SampleDataRow.fromList(List<String> values) {
    return SampleDataRow._(
      id: values[0],
      renderingEngine: values[1],
      browser: values[2],
      platform: values[3],
      engineVersion: values[4],
      cssGrade: values[5],
      dateTime: DateTime.parse(values[6]),
    );
  }

  final String? id;
  final String? renderingEngine;
  final String? browser;
  final String? platform;
  final String? engineVersion;
  final String? cssGrade;
  final DateTime? dateTime;

  Map<String, dynamic> get values {
    return {
      'id': id,
      'renderingEngine': renderingEngine,
      'browser': browser,
      'platform': platform,
      'engineVersion': engineVersion,
      'cssGrade': cssGrade,
      'dateTime': dateTime,
    };
  }
}
