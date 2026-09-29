import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/carousel_item_model.dart';
import '../../news/models/news_model.dart';
import '../../../core/services/firestore_service.dart';

/// Ana Sayfa Controller — MVVM ChangeNotifier
///
/// Firestore'dan carousel, haberler ve kullanıcı verilerini yönetir.
/// Offline-First: Firestore cache otomatik devrede.
class HomeController extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────
  String userName = '';
  bool isLoadingUser = true;

  List<CarouselItemModel> carouselItems = [];
  bool isLoadingCarousel = true;

  List<NewsModel> latestNews = [];
  bool isLoadingNews = true;

  String? errorMessage;

  HomeController() {
    _init();
  }

  Future<void> _init() async {
    await Future.wait([
      _fetchUserData(),
      _fetchCarouselItems(),
      _fetchLatestNews(),
    ]);
  }

  // ── Kullanıcı Verisi ───────────────────────────────────────
  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirestoreService.getUserProfile(user.uid);
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          userName = data['name'] ?? '';
        }
      }
    } catch (e) {
      debugPrint('[HomeController] Kullanıcı verisi hatası: $e');
    } finally {
      isLoadingUser = false;
      notifyListeners();
    }
  }

  // ── Carousel ───────────────────────────────────────────────
  Future<void> _fetchCarouselItems() async {
    try {
      FirestoreService.getCarouselStream().listen((snapshot) {
        carouselItems = snapshot.docs
            .map((doc) => CarouselItemModel.fromFirestore(doc))
            .toList();
        isLoadingCarousel = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('[HomeController] Carousel hatası: $e');
      isLoadingCarousel = false;
      notifyListeners();
    }
  }

  // ── Son Haberler ───────────────────────────────────────────
  Future<void> _fetchLatestNews() async {
    try {
      FirestoreService.getNewsStream(limit: 10).listen((snapshot) {
        latestNews = snapshot.docs
            .map((doc) => NewsModel.fromFirestore(doc))
            .toList();
        isLoadingNews = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('[HomeController] Haber hatası: $e');
      isLoadingNews = false;
      notifyListeners();
    }
  }

  // ── Yenile ─────────────────────────────────────────────────
  Future<void> refresh() async {
    isLoadingCarousel = true;
    isLoadingNews = true;
    errorMessage = null;
    notifyListeners();
    await _init();
  }
}
