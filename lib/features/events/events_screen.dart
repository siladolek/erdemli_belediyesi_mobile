import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'event_service.dart';

class EtkinliklerScreen extends StatefulWidget {
  const EtkinliklerScreen({super.key});

  @override
  State<EtkinliklerScreen> createState() => _EtkinliklerScreenState();
}

class _EtkinliklerScreenState extends State<EtkinliklerScreen> {
  late Future<List<EventModel>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = EventService.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryDark = const Color(0xFF102841);
    final Color accentCyan = const Color(0xFF00C4D4);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Etkinlikler',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
        ),
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: FutureBuilder<List<EventModel>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: accentCyan),
                  const SizedBox(height: 16),
                  Text(
                    'Etkinlik takvimi yukleniyor...',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Etkinlikler şu anda yüklenemiyor.',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          _eventsFuture = EventService.fetchEvents();
                        });
                      },
                      child: Text('Tekrar Dene', style: GoogleFonts.inter(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          final eventsList = snapshot.data!;

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: eventsList.length,
            itemBuilder: (context, index) {
              final event = eventsList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventDetailScreen(event: event)),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (event.imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: Image.network(
                            event.imageUrl,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: accentCyan.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    event.category,
                                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: accentCyan),
                                  ),
                                ),
                                Text(
                                  event.date,
                                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event.title,
                              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark),
                            ),
                            if (event.location.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      event.location,
                                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final Color primaryDark = const Color(0xFF102841);
    final Color accentCyan = const Color(0xFF00C4D4);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        title: Text(
          'Etkinlik Detayı',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
        ),
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  event.imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const SizedBox.shrink(),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: accentCyan.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    event.category,
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: accentCyan),
                  ),
                ),
                Text(
                  event.date,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              event.title,
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: primaryDark),
            ),
            if (event.location.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.location,
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              event.description.isNotEmpty ? event.description : 'Detaylı bilgi için web sitesini ziyaret edebilirsiniz.',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}