# Swift & SwiftUI Temel Kavramlar

Bu belge, `firstapp` Todo uygulaması üzerinden Swift'in temel mantıklarını açıklar.

---

## 1. `@Model` — Veritabanı Modeli

```swift
@Model
final class Item {
    var title: String
    var isCompleted: Bool
    var timestamp: Date

    init(title: String) {
        self.title = title
        self.isCompleted = false
        self.timestamp = Date()
    }
}
```

`@Model` etiketi SwiftData'ya "bu sınıfı veritabanına kaydet" der.

- `final class` → bu sınıftan başka sınıf türetilemez
- `init(...)` → nesne oluşturulurken çalışan yapıcı fonksiyon
- `Date()` → o anki tarih/saat

**Benzetme:** `@Model` bir veritabanı tablosu gibidir. `Item` tablo adı, `title`/`isCompleted`/`timestamp` ise sütunlar.

---

## 2. `struct` ve `View` — Ekran Yapısı

```swift
struct ContentView: View {
    var body: some View {
        Text("Merhaba")
    }
}
```

- `struct` → veri + davranışı bir arada tutan yapı (class'a benzer ama daha hafif)
- `: View` → "bu struct bir ekrandır" demek (protokol)
- `body` → ekranda ne görüneceğini tanımlayan zorunlu alan
- `some View` → "bir tür View döndürür" (tam tipi belirtmeden)

**Kural:** SwiftUI'da her şey View'dır. `Text`, `Button`, `List` hepsi birer View.

---

## 3. `@State` — Geçici Ekran Durumu

```swift
@State private var newTitle = ""
```

`@State`, ekrana ait **geçici** bir değişkendir. Değer değişince ekran otomatik yenilenir.

```swift
TextField("Yeni görev ekle...", text: $newTitle)
```

`$newTitle` ifadesindeki `$` işareti **binding** oluşturur — TextField hem okur hem yazar.
`$` olmadan sadece okuma yapılır, `$` ile iki yönlü bağlantı kurulur.

**Ne zaman kullanılır:** Kullanıcı etkileşimiyle değişen, veritabanına kaydedilmesi gerekmeyen veriler için. Örnek: text field içeriği, açık/kapalı toggle, seçili sekme.

---

## 4. `@Query` — Veritabanından Otomatik Okuma

```swift
@Query private var items: [Item]
```

SwiftData'daki tüm `Item` kayıtlarını çeker. Veritabanına yeni kayıt eklenince veya silinince `items` listesi **otomatik güncellenir**, ekran yeniden çizilir.

Filtreleme ve sıralama da eklenebilir:
```swift
@Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]
```

---

## 5. `@Environment` — Çevre Değişkenleri

```swift
@Environment(\.modelContext) private var modelContext
```

`modelContext` veritabanına erişim kapısıdır. Bunu kullanarak kayıt eklenir veya silinir:

```swift
modelContext.insert(Item(title: "Alışveriş"))  // ekle
modelContext.delete(items[0])                  // sil
```

`@Environment` ile sistem tarafından sağlanan değerlere erişilir (veritabanı bağlantısı, renk şeması, yazı boyutu vb.).

---

## 6. Computed Property — Hesaplanan Alan

```swift
var completedCount: Int {
    items.filter { $0.isCompleted }.count
}
```

Her seferinde değer saklamak yerine, ihtiyaç duyulduğunda hesaplanan bir alan.

- `filter { }` → koşula uyan elemanları süzgeçten geçirir
- `$0` → closure içinde "mevcut eleman" anlamına gelir (kısa yazım)
- `.count` → kaç eleman kaldığını sayar

Uzun yazımı: `filter { item in item.isCompleted }`

---

## 7. Fonksiyonlar ve `private`

```swift
private func addItem() {
    let trimmed = newTitle.trimmingCharacters(in: .whitespaces)
    guard !trimmed.isEmpty else { return }
    withAnimation {
        modelContext.insert(Item(title: trimmed))
        newTitle = ""
    }
}
```

- `private` → bu fonksiyon sadece bu View içinden çağrılabilir
- `let` → değişmeyen değer (sabit), `var` → değişebilen değer
- `guard ... else { return }` → koşul sağlanmazsa fonksiyondan çık
- `withAnimation { }` → içindeki değişiklikler animasyonlu gerçekleşir

---

## 8. `ForEach` ve Liste

```swift
List {
    ForEach(items) { item in
        Text(item.title)
    }
    .onDelete(perform: deleteItems)
}
```

- `List` → kaydırılabilir liste bileşeni
- `ForEach` → dizideki her eleman için bir View üretir
- `.onDelete` → sola kaydırma ile silme özelliği ekler

---

## Genel Veri Akışı

```
Kullanıcı TextField'a yazar
    → @State newTitle güncellenir
        → "Ekle" butonuna basar
            → addItem() çalışır
                → modelContext.insert() veritabanına kaydeder
                    → @Query items listesi otomatik güncellenir
                        → List ekranda yeniden çizilir
```

---

## Özet Tablo

| Etiket | Ne işe yarar | Ne zaman kullanılır |
|---|---|---|
| `@Model` | Sınıfı veritabanı modeli yapar | Saklanacak veriler |
| `@State` | Ekrana özel geçici durum | UI etkileşimi |
| `@Query` | Veritabanından canlı okuma | Listelenecek veriler |
| `@Environment` | Sistem değerlerine erişim | modelContext, colorScheme vb. |
| `$` (binding) | İki yönlü veri bağlantısı | TextField, Toggle vb. |
| `guard` | Erken çıkış koşulu | Geçersiz durumlarda fonksiyon çıkışı |
| `withAnimation` | Animasyonlu değişiklik | Görsel geçişler |
