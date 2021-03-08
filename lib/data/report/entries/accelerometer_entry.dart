part of 'report_entry.dart';

class AccelerometerEntry extends TimeSeriesEntry {
  AccelerometerEntry.fromDocument(DocumentSnapshot doc, String reportID)
      : super(
          reportID: reportID,
          id: doc.id,
          created: doc.data["created"],
          modified: doc.data["modified"],
          text: doc.data["text"],
          type: "accelerometer",
          path: doc.data["path"],
          labels: doc.data["labels"],
        );
}
