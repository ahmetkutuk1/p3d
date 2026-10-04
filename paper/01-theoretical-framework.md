# Neden Üç Boyutlu Görselleştirme?

p-değeri, istatistiksel kanıtın sürekli bir ölçüsü olmasına rağmen, pratikte sıklıkla ikili bir karara indirgenir: "p < 0.05" anlamlı, "p ≥ 0.05" anlamsız. Bu ikili düşünme, bilimsel tekrarlanabilirlik krizinin önemli nedenlerinden biridir.
Mevcut görselleştirme araçları (pvaluefunctions, concurve, confMeta), p-değerini iki boyutlu düzlemde sunar. Bu araçlar, p-değerinin sürekli doğasını göstermede önemli bir adım olsa da, örneklem büyüklüğünün düzenleyici etkisini görünmez kılar. Aynı etki büyüklüğü (örneğin d = 0.5), n = 10'da anlamsızken, n = 100'de anlamlı olabilir. İki boyutlu bir grafik bu etkileşimi gösteremez.
Bu çalışmada, p-değerini üç boyutlu bir yüzey olarak modelleyen p3d paketini sunuyoruz. Paket, p-değerini etki büyüklüğü (d) ve örneklem büyüklüğünün (n) bir fonksiyonu olarak görselleştirir. Kullanıcı:
•	Anlamlılık sınırının bir nokta değil, bir eğri olduğunu görür
•	Örneklem büyüklüğünün p-değeri üzerindeki düzenleyici etkisini gözlemler
•	İkili düşünmenin görsel temelini kaybeder
Monte Carlo simülasyonlarımız, p-değerinin iki farklı yorumu olduğunu ortaya çıkarmıştır: (1) sabit bir etki büyüklüğü altında koşullu p-değeri ve (2) rastgele bir etki büyüklüğü altında beklenen p-değeri. Bu iki yaklaşım, Jensen eşitsizliği nedeniyle sistematik olarak farklı sonuçlar verir (bağıl fark %464). Bu çalışmada, güç analizi ve örneklem planlamada yaygın olarak kullanılan koşullu p-değeri yaklaşımı benimsenmiştir.
 
