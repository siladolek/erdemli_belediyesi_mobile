# -*- coding: utf-8 -*-
import re
import time
import hashlib
import datetime
import requests
from bs4 import BeautifulSoup
import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("serviceAccountKey.json")
if not firebase_admin._apps:
    firebase_admin.initialize_app(cred)
db = firestore.client()

BASE_URL = "https://www.erdemli.bel.tr"
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36"
}
REQUEST_DELAY = 0.5
MAX_PAGES_PER_CATEGORY = 3 # 3 sayfa tarar, kategori başına ortalama 20-25 veri getirir

def stable_doc_id(link: str) -> str:
    return hashlib.md5(link.encode("utf-8")).hexdigest()

def resolve_url(href: str) -> str:
    if not href: return ""
    if href.startswith("http"): return href
    if href.startswith("/"): return BASE_URL + href
    return BASE_URL + "/" + href

def extract_date_from_url(url: str) -> str:
    match = re.search(r"-(\d{2})(\d{2})(\d{4})\.html", url)
    if match: return f"{match.group(1)}.{match.group(2)}.{match.group(3)}"
    return "Güncel"

def fetch_soup(url: str):
    try:
        response = requests.get(url, headers=HEADERS, timeout=15)
        response.encoding = "utf-8"
        if response.status_code == 200: return BeautifulSoup(response.text, "html.parser")
    except Exception: pass
    return None

# YENİ SAYFALAMA MANTIĞI: Kesin çalışması için doğrudan ?sayfa= parametresini ekler
def paginated_urls(base_page_url: str, max_pages: int = MAX_PAGES_PER_CATEGORY):
    yield base_page_url
    for page_num in range(2, max_pages + 1):
        yield f"{base_page_url}?sayfa={page_num}"

def split_duplicated_title(raw_text: str):
    raw_text = raw_text.strip()
    half = len(raw_text) // 2
    first_half = raw_text[:half]
    if len(first_half) >= 3 and raw_text.startswith(first_half * 2):
        return first_half, raw_text[len(first_half) * 2:].strip()
    return raw_text, ""

def extract_clean_title(a_tag):
    heading = a_tag.find(["h1", "h2", "h3", "h4", "h5", "h6", "strong"])
    if heading:
        text = heading.get_text(strip=True)
        if len(text) >= 4: return text
    title, _ = split_duplicated_title(a_tag.get_text(strip=True))
    return title

def fetch_detail(url: str):
    time.sleep(REQUEST_DELAY)
    soup = fetch_soup(url)
    if not soup: return "", ""

    content_div = soup.find("div", class_=re.compile(r"icerik|detay|content|post", re.I))
    search_area = content_div if content_div else soup
    image_url = ""
    for img in search_area.find_all("img"):
        src = img.get("src") or img.get("data-src") or ""
        lower_src = src.lower()
        if src and not any(b in lower_src for b in ["logo", "icon", "flags", "baskan"]):
            image_url = resolve_url(src)
            break

    clean_paragraphs = []
    blacklist = ["merkez mahallesi", "pk. 33730", "telefon:", "444 5 609", "iletişim buton",
                 "yurtta sulh", "anasayfa", "hizmetlerimiz", "kurumsal", "iletisim",
                 "fotoğraf galerisi", "video galeri", "haberler", "duyurular", "etkinlikler",
                 "e-belediye", "hızlı menü", "detaylı bilgi için", "sözü söyleyen", "gazi mustafa kemal",
                 "sayfayı yazdır", "hizmet detayı", "kolay menü", "güncel ilanlar", "menü ve araçlar", "tamamlanan projeler"]

    date_spam_pattern = re.compile(r"^\d{1,2}\s+[A-Za-zÇĞİÖŞÜçğıöşü]+\s+\d{4}\s+\d{2}:\d{2}")

    for p in soup.find_all("p"):
        text = p.get_text(strip=True)
        if len(text) < 15: continue
        lower_text = text.lower()

        if date_spam_pattern.search(text) or any(b in lower_text for b in blacklist):
            continue

        if text not in clean_paragraphs:
            clean_paragraphs.append(text)

    if not clean_paragraphs and content_div:
        for text in content_div.stripped_strings:
            if len(text) > 60 and not date_spam_pattern.search(text) and not any(b in text.lower() for b in blacklist) and text not in clean_paragraphs:
                clean_paragraphs.append(text)

    full_text = "\n\n".join(clean_paragraphs[:5])
    return full_text, image_url

def save_batch(collection_name: str, items: list):
    if not items: return
    batch = db.batch()
    for item in items:
        doc_id = stable_doc_id(item.get("link", item.get("detailUrl", item["title"])))
        item["scrapedAt"] = datetime.datetime.utcnow().isoformat()
        batch.set(db.collection(collection_name).document(doc_id), item, merge=True)
    batch.commit()
    print(f"  [{collection_name}] {len(items)} kayıt başarıyla güncellendi.")

def scrape_news():
    print("\n=== HABERLER çekiliyor ===")
    items = []
    seen_links = set()
    # DÜZELTME: Yanlış link yerine gerçek haberler linki eklendi!
    for page_url in paginated_urls(f"{BASE_URL}/haber-kategori/genel-haberler.html"):
        soup = fetch_soup(page_url)
        if not soup: break
        for a in soup.select('a[href*="haber/"]'):
            href = resolve_url(a.get("href", ""))
            if not href or href in seen_links: continue
            title = extract_clean_title(a)
            if len(title) < 6: continue
            img = a.find("img")
            listing_image = resolve_url(img.get("src") or img.get("data-src") or "") if img else ""
            full_text, detail_image = fetch_detail(href)
            items.append({"title": title, "summary": full_text, "imageUrl": listing_image if listing_image else detail_image, "date": extract_date_from_url(href), "link": href, "category": "Belediye Haberleri"})
            seen_links.add(href)
    save_batch("news", items)

def scrape_announcements():
    print("\n=== DUYURULAR çekiliyor ===")
    items = []
    seen_links = set()
    for page_url in paginated_urls(f"{BASE_URL}/duyurular"):
        soup = fetch_soup(page_url)
        if not soup: break
        for a in soup.find_all("a"):
            href = resolve_url(a.get("href", ""))
            if not href or href in seen_links or href == BASE_URL or href == BASE_URL + "/": continue
            link_text = a.get_text(strip=True).lower()
            if "detayı aç" in link_text or "detayi ac" in link_text or "duyuru/" in href.lower():
                title = ""
                parent = a.find_parent("div", class_=re.compile(r"item|card|post", re.I)) or a.parent.parent
                if parent:
                    heading = parent.find(["h1", "h2", "h3", "h4", "h5", "h6", "strong"])
                    if heading: title = heading.get_text(strip=True)
                if not title:
                    title = extract_clean_title(a)
                if len(title) < 5 or "detayı aç" in title.lower():
                    detail_soup = fetch_soup(href)
                    if detail_soup:
                        h1 = detail_soup.find("h1")
                        if h1: title = h1.get_text(strip=True)
                if len(title) < 5 or "detayı aç" in title.lower(): continue

                cat = "Meclis Kararı" if "MECLİS" in title.upper() else ("İhale" if "İHALE" in title.upper() else "Duyuru")
                date = "Güncel"
                if parent:
                    date_match = re.search(r"(\d{1,2}\s+[A-Za-zÇĞİÖŞÜçğıöşü]+\s+\d{4})", parent.get_text(" ", strip=True))
                    if date_match: date = date_match.group(1)
                if date == "Güncel": date = extract_date_from_url(href)

                full_text, detail_image = fetch_detail(href)
                if not full_text:
                    full_text = "Bu duyuru bir ek dosya (PDF/Word vb.) içeriyor olabilir. Lütfen detaylar için resmi web sitesini ziyaret edin."

                items.append({"title": title, "summary": full_text, "imageUrl": detail_image, "date": date, "link": href, "category": cat})
                seen_links.add(href)
    save_batch("announcements", items)

def scrape_projects():
    print("\n=== PROJELER çekiliyor ===")
    category_urls = {"Tamamlanan Projeler": f"{BASE_URL}/proje-kategori/tamamlanan-projeler.html", "Planlanan Projeler": f"{BASE_URL}/proje-kategori/planlanan-projeler.html", "Devam Eden Projeler": f"{BASE_URL}/proje-kategori/devam-eden-projeler.html"}
    items = []
    seen_links = set()
    for status_label, base_url in category_urls.items():
        for page_url in paginated_urls(base_url):
            soup = fetch_soup(page_url)
            if not soup: break
            for a in soup.select('a[href*="proje/"]'):
                href = resolve_url(a.get("href", ""))
                if not href or href in seen_links: continue
                title = extract_clean_title(a)
                if len(title) < 4: continue
                img = a.find("img")
                listing_image = resolve_url(img.get("src") or img.get("data-src") or "") if img else ""
                full_text, detail_image = fetch_detail(href)
                items.append({"title": title, "description": full_text, "imageUrl": listing_image if listing_image else detail_image, "status": status_label, "link": href, "category": status_label, "location": "Erdemli", "date": "Güncel"})
                seen_links.add(href)
    save_batch("projects", items)

def scrape_events():
    print("\n=== ETKİNLİKLER çekiliyor ===")
    items = []
    seen_links = set()
    date_pattern = re.compile(r"Etkinlik\s+([0-9]{1,2}\s+[A-Za-zÇĞİÖŞÜçğıöşü]+\s+[0-9]{4},\s+[0-9]{2}:[0-9]{2})")
    for page_url in paginated_urls(f"{BASE_URL}/etkinlikler.html"):
        soup = fetch_soup(page_url)
        if not soup: break
        for h2 in soup.find_all("h2"):
            title_anchor = h2.find("a", href=re.compile(r"etkinlik/"))
            if not title_anchor: continue
            href = resolve_url(title_anchor.get("href", ""))
            if not href or href in seen_links: continue
            title = extract_clean_title(title_anchor)
            if len(title) < 4: continue

            card = h2.parent
            listing_image = resolve_url(card.find("img").get("src", "")) if card and card.find("img") else ""
            date_match = date_pattern.search(card.get_text(" ", strip=True)) if card else None
            date = date_match.group(1) if date_match else ""

            full_text, detail_image = fetch_detail(href)
            cat = "Konser" if "konser" in title.lower() else ("Tiyatro" if "tiyatro" in title.lower() else "Kültür Sanat")
            items.append({"title": title, "date": date, "location": "Erdemli", "description": full_text, "imageUrl": listing_image if listing_image else detail_image, "detailUrl": href, "category": cat})
            seen_links.add(href)
    save_batch("events", items)

if __name__ == "__main__":
    scrape_news()
    scrape_announcements()
    scrape_projects()
    scrape_events()