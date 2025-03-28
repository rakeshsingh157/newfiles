import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:convert';
import 'dart:io';

class UploadsScreen extends StatefulWidget {
  @override
  _UploadsScreenState createState() => _UploadsScreenState();
}

class _UploadsScreenState extends State<UploadsScreen> {
  List<dynamic> uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    fetchUploads();
  }

  Future<void> fetchUploads() async {
    try {
      final uri = Uri.parse('https://fetch-the-files.vercel.app/');
      final request = await HttpClient().getUrl(uri);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        setState(() {
          uploadedFiles = json.decode(responseBody);
        });
      } else {
        print('Failed to load uploads: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching uploads: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101820),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FadeInDown(
          duration: Duration(milliseconds: 700),
          child: Text(
            'My Uploads',
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: uploadedFiles.isEmpty
          ? Center(
        child: ZoomIn(
          duration: Duration(milliseconds: 800),
          child: Text(
            'No uploads found!',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[400]),
          ),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: uploadedFiles.length,
        itemBuilder: (context, index) {
          final file = uploadedFiles[index];
          return FadeInLeft(
            duration: Duration(milliseconds: 700),
            child: Card(
              color: Colors.blueGrey[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text(
                  file['filename'],
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
                subtitle: Text(
                  "Uploaded: ${file['uploadDate']}",
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
                ),
                leading: Icon(Icons.file_present, color: Colors.blueAccent),
              ),
            ),
          );
        },
      ),
    );
  }
}
