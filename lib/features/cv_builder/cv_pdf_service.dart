import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/cv_model.dart';

class CvPdfService {
  /// Generates a visually styled CV PDF from structured data.
  static Future<File> generateStyledCv(CvModel data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) => [
          _buildStyledHeader(data, font, fontBold),
          pw.SizedBox(height: 20),
          if (data.personalStatement.isNotEmpty) ...[
            _buildSection("PROFESSIONAL SUMMARY", data.personalStatement, font, fontBold),
          ],
          if (data.experience.isNotEmpty) ...[
            _buildExperienceSection(data.experience, font, fontBold),
          ],
          if (data.education.isNotEmpty) ...[
            _buildEducationSection(data.education, font, fontBold),
          ],
          if (data.skills.isNotEmpty) ...[
            _buildSkillsSection(data.skills, font, fontBold),
          ],
        ],
      ),
    );

    return _savePdf(pdf, 'Styled_CV_${data.fullName}');
  }

  /// Generates a plain-text, ATS-friendly CV PDF.
  static Future<File> createAtsCv(CvModel data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Text(
            data.personalStatement, // The full text is stored here
            style: pw.TextStyle(font: font, fontSize: 11, height: 1.5),
          );
        },
      ),
    );

    return _savePdf(pdf, 'ATS_CV_${DateTime.now().millisecondsSinceEpoch}');
  }

  static Future<File> _savePdf(pw.Document pdf, String fileName) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  // --- Helper methods for Styled CV ---

  static pw.Widget _buildStyledHeader(CvModel data, pw.Font font, pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(data.fullName.toUpperCase(), style: pw.TextStyle(font: fontBold, fontSize: 24, color: PdfColors.blueGrey800)),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            if (data.email.isNotEmpty) pw.Text(data.email, style: pw.TextStyle(font: font, fontSize: 10)),
            if (data.phoneNumber.isNotEmpty) pw.Text(data.phoneNumber, style: pw.TextStyle(font: font, fontSize: 10)),
          ],
        ),
        pw.Divider(thickness: 2, color: PdfColors.blueGrey800),
      ],
    );
  }

  static pw.Widget _buildSection(String title, String content, pw.Font font, pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.blueGrey700)),
        pw.SizedBox(height: 5),
        pw.Text(content, style: pw.TextStyle(font: font, fontSize: 11), textAlign: pw.TextAlign.justify),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildExperienceSection(List<Experience> experiences, pw.Font font, pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("WORK EXPERIENCE", style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.blueGrey700)),
        pw.SizedBox(height: 5),
        ...experiences.map((exp) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(exp.jobTitle, style: pw.TextStyle(font: fontBold, fontSize: 12)),
                  pw.Text(exp.company, style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.grey700)),
                  pw.SizedBox(height: 3),
                  pw.Text(exp.description, style: pw.TextStyle(font: font, fontSize: 10)),
                ],
              ),
            )),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildEducationSection(List<Education> educations, pw.Font font, pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("EDUCATION", style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.blueGrey700)),
        pw.SizedBox(height: 5),
        ...educations.map((edu) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(edu.degree, style: pw.TextStyle(font: fontBold, fontSize: 11)),
                  pw.Text(edu.school, style: pw.TextStyle(font: font, fontSize: 10)),
                ],
              ),
            )),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildSkillsSection(List<String> skills, pw.Font font, pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("SKILLS", style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.blueGrey700)),
        pw.SizedBox(height: 5),
        pw.Wrap(
          spacing: 8,
          runSpacing: 5,
          children: skills.map((skill) => pw.Text("• $skill", style: pw.TextStyle(font: font, fontSize: 10))).toList(),
        ),
      ],
    );
  }
}
