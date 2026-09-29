import 'package:cloud_firestore/cloud_firestore.dart';

// DİKKAT: Model dosyasının yolu hata verirse Alt+Enter ile import et!
import '../home/models/mukhtar_model.dart';

class MukhtarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tüm muhtarlıkları alfabetik sırayla çeker
  Future<List<MukhtarModel>> getMukhtars() async {
    try {
      final snapshot = await _firestore
          .collection('muhtarliklar')
          .orderBy('mahalleAdi')
          .get();

      return snapshot.docs
          .map((doc) => MukhtarModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print("Muhtarlık verileri çekilirken hata oluştu: $e");
      return [];
    }
  }
}