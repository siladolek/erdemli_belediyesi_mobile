import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SendReportScreen extends StatefulWidget {
  const SendReportScreen({super.key});

  @override
  State<SendReportScreen> createState() => _SendReportScreenState();
}

class _SendReportScreenState extends State<SendReportScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  final TextEditingController _noteController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Report', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF154360),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _showPicker(context),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                    image: _selectedImage != null
                        ? DecorationImage(image: FileImage(File(_selectedImage!.path)), fit: BoxFit.cover)
                        : null
                ),
                child: _selectedImage == null
                    ? Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.camera_alt, size: 50, color: Colors.grey), Text('Add Photo')])
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe your issue or request...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2980B9)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Submitting your report...')));
                },
                child: Text('SUBMIT', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(context: context, builder: (BuildContext bc) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(leading: const Icon(Icons.photo_library), title: const Text('Gallery'), onTap: () { _pickImage(ImageSource.gallery); Navigator.of(context).pop(); }),
            ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Camera'), onTap: () { _pickImage(ImageSource.camera); Navigator.of(context).pop(); }),
          ],
        ),
      );
    });
  }
}