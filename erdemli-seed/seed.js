const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const axios = require('axios');
const serviceAccount = require('./serviceAccountKey.json');

// Firebase Bağlantısı
initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();

// API ANAHTARIN
const GOOGLE_API_KEY = 'AIzaSyD86BqLxgKfw0XMOViDMozaZLIFfU5J5OY';

// 1. VIP MEKANLAR (Saklı cennetler ve nokta atışları)
let searchQueries = [
  { keyword: 'Cennet Cehennem Mağaraları', category: 'Tarihi Yerler' },
  { keyword: 'Astım Mağarası', category: 'Tarihi Yerler' },
  { keyword: 'Adamkayalar Erdemli', category: 'Tarihi Yerler' },
  { keyword: 'Kanlıdivane Antik Kenti', category: 'Tarihi Yerler' },
  { keyword: 'Kayacı Vadisi Lamos Kanyonu', category: 'Parklar & Doğa' },
  { keyword: 'Talat Göktepe Tabiat Parkı (Erdemli Çamlığı)', category: 'Parklar & Doğa' },
  { keyword: 'Kırmızı Tantuni Erdemli', category: 'Restoranlar' },
  { keyword: 'Novacity AVM Erdemli', category: 'Kafeler' }
];

// 2. ERDEMLİ'NİN 15 POPÜLER BÖLGESİ
const regions = [
  'Kızkalesi', 'Ayaş', 'Yemişkumu', 'Kumkuyu', 'Limonlu',
  'Kocahasanlı', 'Arpaçbahşiş', 'Tömük', 'Kargıpınarı', 'Çeşmeli',
  'Alata', 'Erdemli Merkez', 'Akdeniz Mahallesi', 'Koyuncu', 'Türbe'
];

const categoryMappings = [
  { name: 'Kafeler', searchSuffix: 'kafeler ve kahveciler' },
  { name: 'Restoranlar', searchSuffix: 'restoranlar ve lokantalar' },
  { name: 'Kamp Alanları', searchSuffix: 'kamp alanları' },
  { name: 'Parklar & Doğa', searchSuffix: 'parklar ve mesire alanları' },
  { name: 'Tarihi Yerler', searchSuffix: 'tarihi yerler' },
  { name: 'Plajlar', searchSuffix: 'plajları' }
];

// 98 Aramalık Listeyi Otomatik Oluştur
regions.forEach(region => {
  categoryMappings.forEach(cat => {
    searchQueries.push({ keyword: `${region} ${cat.searchSuffix} Erdemli`, category: cat.name });
  });
});

async function fetchFromMapsAndSeed() {
  try {
    console.log('🧹 Eski veriler temizleniyor...');
    const snapshot = await db.collection('places').get();
    if (!snapshot.empty) {
      let deleteBatch = db.batch();
      let count = 0;
      for (const doc of snapshot.docs) {
        deleteBatch.delete(doc.ref);
        count++;
        // Firebase sınırını (500) aşmamak için 400'de bir silme işlemini onayla
        if (count % 400 === 0) {
          await deleteBatch.commit();
          deleteBatch = db.batch();
        }
      }
      await deleteBatch.commit();
      console.log('✅ Eski veriler başarıyla silindi!');
    }

    console.log('\n🌍 YENİ SİSTEM: Google Maps API ile mekan galerileri (FARKLI FOTOĞRAFLAR) taranıyor...');
    console.log('⏳ DİKKAT: Her mekanın galerisine özel olarak girileceği için bu işlem 5-10 dakika sürebilir.\n');

    let insertBatch = db.batch();
    let totalAdded = 0;
    let currentBatchCount = 0;

    for (let i = 0; i < searchQueries.length; i++) {
      const item = searchQueries[i];
      try {
        const url = `https://maps.googleapis.com/maps/api/place/textsearch/json?query=${encodeURIComponent(item.keyword)}&key=${GOOGLE_API_KEY}`;
        const response = await axios.get(url);
        const results = response.data.results || [];

        for (const place of results) {
          let photoUrls = [];

          // --- CAN ALICI NOKTA: GALERİDEN 3 FARKLI FOTOĞRAF ÇEKME ---
          if (place.place_id) {
            try {
              const detailsUrl = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${place.place_id}&fields=photos&key=${GOOGLE_API_KEY}`;
              const detailsResponse = await axios.get(detailsUrl);
              const detailedPhotos = detailsResponse.data.result?.photos || [];

              if (detailedPhotos.length > 0) {
                const maxPhotos = Math.min(detailedPhotos.length, 3);
                for (let p = 0; p < maxPhotos; p++) {
                  const photoRef = detailedPhotos[p].photo_reference;
                  photoUrls.push(`https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photo_reference=${photoRef}&key=${GOOGLE_API_KEY}`);
                }
                // Uygulama çökmesin diye eksik fotoğrafı son resimle doldur
                while (photoUrls.length < 3) photoUrls.push(photoUrls[photoUrls.length - 1]);
              }
            } catch (err) {
              console.log(`Fotoğraf hatası: ${place.name}`);
            }
          }

          const newPlace = {
            name: place.name,
            category: item.category,
            description: place.formatted_address || 'Erdemli sınırları içerisinde popüler bir mekan.',
            latitude: place.geometry.location.lat,
            longitude: place.geometry.location.lng,
            imageUrls: photoUrls,
            rating: place.rating || 0
          };

          const docRef = db.collection('places').doc();
          insertBatch.set(docRef, newPlace);
          totalAdded++;
          currentBatchCount++;

          // 400 Mekana ulaştıkça veritabanına gönderip rahatlatıyoruz
          if (currentBatchCount === 400) {
            await insertBatch.commit();
            insertBatch = db.batch(); // Yeni temiz bir paket aç
            currentBatchCount = 0;
            console.log(`[BİLGİ] 400 mekan Firebase'e işlendi, devam ediliyor...`);
          }
        }

        console.log(`[${i + 1}/${searchQueries.length}] ${item.keyword} bitti.`);

      } catch (error) {
        console.error(`Ağ hatası (${item.keyword}):`, error.message);
      }
    }

    // Geride kalan son partiyi de gönderiyoruz
    if (currentBatchCount > 0) {
      await insertBatch.commit();
    }

    console.log(`\n🎉 MUHTEŞEM İŞ! Toplam ${totalAdded} gerçek mekan BİRBİRİNDEN FARKLI FOTOĞRAFLARIYLA Firebase'e başarıyla eklendi!`);

  } catch (error) {
    console.error('Genel bir hata oluştu:', error);
  }
}

fetchFromMapsAndSeed();