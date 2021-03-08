import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scientisst_db/scientisst_db.dart';
import 'package:scientisst_journal/data/sensors/sensor_value.dart';
import 'package:scientisst_journal/utils/database/database.dart';
import 'package:scientisst_journal/utils/utils.dart';

part 'text_entry.dart';
part 'image_entry.dart';
part 'video_entry.dart';
part 'file_entry.dart';
part 'timeseries_entry.dart';
part 'accelerometer_entry.dart';

abstract class ReportEntry {
  String reportID;
  String id;
  DateTime created;
  DateTime modified;
  String _text;
  String _type;

  ReportEntry(
      {@required this.reportID,
      @required this.id,
      @required this.created,
      @required this.modified,
      @required String text,
      @required String type}) {
    this._text = text;
    this._type = type;
  }

  static String _getEntryType(DocumentSnapshot doc) =>
      (doc.data["type"] as String).toLowerCase();

  static dynamic getEntry(DocumentSnapshot doc, String reportID) {
    switch (_getEntryType(doc)) {
      case "image":
        return ImageEntry.fromDocument(doc, reportID);
      case "video":
        return VideoEntry.fromDocument(doc, reportID);
      case "accelerometer":
        return AccelerometerEntry.fromDocument(doc, reportID);
      default: // text
        return TextEntry.fromDocument(doc, reportID);
    }
  }

  Future<void> delete() async =>
      await ReportFunctions.deleteEntry(reportID, id);
}
