import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/cv_model.dart';

class CVPdfService {
  static Future<Uint8List> generateCV(CVData data) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) => [
          // Header
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(data.fullName.toUpperCase(),
                  style: pw.TextStyle(font: fontBold, fontSize: 24, color: PdfColors.blue900)),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(data.email, style: pw.TextStyle(font: font, fontSize: 10)),
                  pw.Text(data.phone, style: pw.TextStyle(font: font, fontSize: 10)),
                  pw.Text(data.address, style: pw.TextStyle(font: font, fontSize: 10)),
                ],
              ),
              pw.Divider(thickness: 2, color: PdfColors.blue900),
            ],
          ),
          pw.SizedBox(height: 20),

          // Summary
          if (data.summary.isNotEmpty) ...[
            pw.Text("PROFESSIONAL SUMMARY", style: pw.TextStyle(font: fontBold, fontSize: 14)),
            pw.SizedBox(height: 5),
            pw.Text(data.summary, style: pw.TextStyle(font: font, fontSize: 11)),
            pw.SizedBox(height: 20),
          ],

          // Experience
          if (data.experience.isNotEmpty) ...[
            pw.Text("WORK EXPERIENCE", style: pw.TextStyle(font: fontBold, fontSize: 14)),
            pw.SizedBox(height: 5),
            ...data.experience.map((exp) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(exp.jobTitle, style: pw.TextStyle(font: fontBold, fontSize: 12)),
                          pw.Text(exp.duration, style: pw.TextStyle(font: font, fontSize: 10)),
                        ],
                      ),
                      pw.Text(exp.company, style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.grey700)),
                      pw.SizedBox(height: 3),
                      pw.Text(exp.description, style: pw.TextStyle(font: font, fontSize: 10)),
                    ],
                  ),
                )),
            pw.SizedBox(height: 20),
          ],

          // Education
          if (data.education.isNotEmpty) ...[
            pw.Text("EDUCATION", style: pw.TextStyle(font: fontBold, fontSize: 14)),
            pw.SizedBox(height: 5),
            ...data.education.map((edu) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(edu.degree, style: pw.TextStyle(font: fontBold, fontSize: 11)),
                          pw.Text(edu.school, style: pw.TextStyle(font: font, fontSize: 11)),
                        ],
                      ),
                      pw.Text(edu.year, style: pw.TextStyle(font: font, fontSize: 11)),
                    ],
                  ),
                )),
            pw.SizedBox(height: 20),
          ],

          // Skills
          if (data.skills.isNotEmpty) ...[
            pw.Text("SKILLS", style: pw.TextStyle(font: fontBold, fontSize: 14)),
            pw.SizedBox(height: 5),
            pw.Wrap(
              spacing: 10,
              runSpacing: 5,
              children: data.skills
                  .map((skill) => pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey200,
                          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                        ),
                        child: pw.Text(skill, style: pw.TextStyle(font: font, fontSize: 10)),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );

    return pdf.save();
  }
}
