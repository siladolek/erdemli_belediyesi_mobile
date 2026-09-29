import 'package:cloud_firestore/cloud_firestore.dart';

/// Merkezi Firestore Servisi — Tüm koleksiyon okuma/yazma işlemleri
///
/// Offline-First mantığı:
/// Firestore SDK otomatik olarak yerel cache kullanır.
/// İnternet yoksa bile cache'den veri döner.
/// İnternet geldiğinde arka planda otomatik senkronize eder.
class FirestoreService {
  FirestoreService._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Haberler ───────────────────────────────────────────────
  /// Haberleri tarihe göre azalan sırada getirir.
  static Stream<QuerySnapshot> getNewsStream({int limit = 20}) {
    return _db
        .collection('news')
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots();
  }

  /// Haberleri tek seferlik çeker (pull-to-refresh için).
  static Future<QuerySnapshot> getNews({int limit = 20}) {
    return _db
        .collection('news')
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
  }

  // ── Duyurular ──────────────────────────────────────────────
  /// Duyuruları tarihe göre azalan sırada stream olarak dinler.
  static Stream<QuerySnapshot> getAnnouncementsStream({int limit = 30}) {
    return _db
        .collection('announcements')
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots();
  }

  /// Duyuruları tek seferlik çeker.
  static Future<QuerySnapshot> getAnnouncements({int limit = 30}) {
    return _db
        .collection('announcements')
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
  }

  // ── Carousel (Öne Çıkanlar) ────────────────────────────────
  /// Ana sayfa afiş/banner verilerini getirir.
  static Stream<QuerySnapshot> getCarouselStream() {
    return _db
        .collection('carousel_items')
        .orderBy('order', descending: false)
        .snapshots();
  }

  // ── Mekanlar (Keşfet) ──────────────────────────────────────
  /// Tüm mekanları veya kategoriye göre filtrelenmiş mekanları getirir.
  static Stream<QuerySnapshot> getPlacesStream({String? category}) {
    Query query = _db.collection('places');

    if (category != null && category.isNotEmpty && category != 'Tümü') {
      query = query.where('category', isEqualTo: category);
    }

    return query.orderBy('name').snapshots();
  }

  /// Mekanları tek seferlik çeker.
  static Future<QuerySnapshot> getPlaces({String? category}) {
    Query query = _db.collection('places');

    if (category != null && category.isNotEmpty && category != 'Tümü') {
      query = query.where('category', isEqualTo: category);
    }

    return query.orderBy('name').get();
  }

  // ── Kullanıcı Profili ──────────────────────────────────────
  /// Kullanıcı profilini UID ile getirir.
  static Future<DocumentSnapshot> getUserProfile(String uid) {
    return _db.collection('users').doc(uid).get();
  }
}
