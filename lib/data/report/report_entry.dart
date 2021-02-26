import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scientisst_db/scientisst_db.dart';
import 'package:scientisst_journal/utils/database/database.dart';

part 'text_entry.dart';
part 'image_entry.dart';
part 'video_entry.dart';

abstract class ReportEntry {
  DocumentReference _reference;
  DateTime timestamp;
  String _text;
  String _type;

  ReportEntry(
      {@required DocumentReference reference,
      @required this.timestamp,
      @required String text,
      @required String type}) {
    this._reference = reference;
    this._text = text;
    this._type = type;
  }

  static String _getEntryType(DocumentSnapshot doc) =>
      (doc.data["type"] as String).toLowerCase();

  static dynamic getEntry(DocumentSnapshot doc) {
    switch (_getEntryType(doc)) {
      case "image":
        return ImageEntry.fromDocument(doc);
      case "video":
        return VideoEntry.fromDocument(doc);
      default: // text
        return TextEntry.fromDocument(doc);
    }
  }

  bool get isImage => _type == "image";
  bool get isVideo => _type == "video";
  bool get isText => _type == "text";

  Future<void> delete() async => await _reference.delete();
}
