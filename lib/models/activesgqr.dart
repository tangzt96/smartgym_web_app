import 'dart:convert';

/// activesg qr data
///
import 'package:intl/intl.dart';

class ActiveSgQR {
  String id;
  DateTime datetime;
  String? timestamp;
  ActiveSgQR({
    required this.id,
    required this.datetime,
    this.timestamp,
  });

  ActiveSgQR copyWith({
    String? id,
    DateTime? datetime,
    String? timestamp,
  }) {
    return ActiveSgQR(
      id: id ?? this.id,
      datetime: datetime ?? this.datetime,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'datetime': datetime.millisecondsSinceEpoch,
      'timestamp': timestamp,
    };
  }

  Map<String, dynamic> mapConvertedTime() {
    return {'id': id, 'timestamp': _formatISOTime(datetime)};
  }

  factory ActiveSgQR.fromMap(Map<String, dynamic> map) {
    return ActiveSgQR(
      id: map['id'] ?? '',
      datetime: DateTime.fromMillisecondsSinceEpoch(map['datetime']),
      timestamp: map['timestamp'],
    );
  }

  String toJson() => json.encode(toMap());

  String toJson2() => json.encode(mapConvertedTime());

  factory ActiveSgQR.fromJson(String source) =>
      ActiveSgQR.fromMap(json.decode(source));

  @override
  String toString() =>
      'ActiveSgQR(id: $id, datetime: $datetime, timestamp: $timestamp)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActiveSgQR &&
        other.id == id &&
        other.datetime == datetime &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => id.hashCode ^ datetime.hashCode ^ timestamp.hashCode;

  static String _formatISOTime(DateTime date) {
    //converts date into the following format:
    // or 2019-06-04T12:08:56.235-0700
    var duration = date.timeZoneOffset;
    if (duration.isNegative)
      return (DateFormat("yyyy-MM-ddTHH:mm:ss").format(date) +
          "-${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    else
      return (DateFormat("yyyy-MM-ddTHH:mm:ss").format(date) +
          "+${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
  }
}
