# Google Play Store — Complete Publishing Guide for My Reading Village

This guide walks you through every step needed to go from zero to a published app with real in-app purchases on the Google Play Store. Follow the steps in order.

---

## PART 1 — Create a Google Play Developer Account

### Step 1.1 — Sign in to Google Play Console

1. Open https://play.google.com/console
2. Sign in with the Google account you want to use as your developer identity (use a permanent account, not a temporary one).

### Step 1.2 — Pay the One-Time Registration Fee

1. Click **"Get started"** or **"Create developer account"**.
2. You will be asked to pay a **one-time $25 USD registration fee**.
3. Pay with a credit or debit card (Google Pay is accepted).
4. The fee is non-refundable and grants you a permanent developer account.

### Step 1.3 — Complete Your Account Profile

1. Fill in:
   - **Developer name** — this appears publicly on the Play Store (e.g., "Fernando Pinto Studios").
   - **Email address** — visible to users who contact you (use a real one).
   - **Website** (optional but recommended).
   - **Phone number** (required for 2-factor authentication).
2. Accept the **Google Play Developer Distribution Agreement**.
3. Your account is now active. It may take up to 48 hours before you can publish apps.

---

## PART 2 — Prepare the App for the Play Store

### Step 2.1 — Configure App Identity

Edit `my_reading_village/pubspec.yaml`:

```yaml
name: my_reading_village
version: 1.0.0+1 # format: version_name+version_code
```

- `version_name` (e.g., `1.0.0`) is shown to users.
- `version_code` (e.g., `1`) is an integer used internally by Google. It must increase with every upload.

Edit `my_reading_village/android/app/build.gradle` and set:

```gradle
android {
    defaultConfig {
        applicationId "com.ferchostudiodev.my_reading_village"   // CHANGE THIS — must be unique on the Play Store
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

**Important:** `applicationId` must be globally unique. Reverse-domain notation is standard (e.g., `com.ferchostudiodev.my_reading_village`).

### Step 2.2 — Generate a Signing Key

You must sign your release APK/AAB with a keystore file. Run this **once** and keep the file safe:

```bash
keytool -genkey -v \
  -keystore ~/my-reading-village-release.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias my-reading-village
```

You will be asked for a password and your name/organization. **Never lose this file** — you cannot update your app without it.

### Step 2.3 — Configure Signing in Flutter

Create `my_reading_village/android/key.properties`:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=my-reading-village
storeFile=/home/youruser/my-reading-village-release.jks
```

Edit `my_reading_village/android/app/build.gradle` to use the keystore:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

**Add `key.properties` to `.gitignore`** — never commit it.

### Step 2.4 — Build the Release AAB

Google Play requires an **Android App Bundle (.aab)**, not an APK:

```bash
cd my_reading_village
flutter build appbundle --release
```

The output file will be at:
`my_reading_village/build/app/outputs/bundle/release/app-release.aab`

---

## PART 3 — Create the App in Play Console

### Step 3.1 — Create a New App

1. In Play Console, click **"Create app"**.
2. Fill in:
   - **App name**: My Reading Village
   - **Default language**: English (United States)
   - **App or game**: Game
   - **Free or paid**: Free (you earn through in-app purchases)
3. Accept the declarations and click **"Create app"**.

### Step 3.2 — Complete the Store Listing (copy-paste ready, per language)

Play Console lets you create one **store listing per language** (Grow > Store presence > Main store listing > **Manage translations** > **Add your own translation**). Add all five languages below — each block is ready to paste directly into its matching fields.

**Keep the App name identical in every language: `My Reading Village`.** This is a deliberate ASO call: a consistent brand name keeps reviews, word-of-mouth and cross-market search recognition intact, and the 30-character title field is too short to fit a meaningful localized keyword anyway. All the keyword work below happens in the short and full descriptions, where you actually have room for it (80 and 4000 characters).

#### ASO strategy notes (why the copy is written this way)

- **First 1–2 lines of the full description are the most important.** Play Store truncates the description preview there, and that snippet is also what search engines and the "similar apps" carousel index most heavily — so the hook states the core promise (reading habit + village builder + cute collectibles) immediately, in the user's language.
- **Each description front-loads its category keywords** in the user's native search vocabulary instead of literal translations of the English terms — e.g. Spanish players search for "hábito de lectura" / "diario de lectura" / "juego de pueblo", Portuguese players for "hábito de leitura" / "vila" / "colecionar", French players for "suivi de lecture" / "gestion de village", Italian players for "abitudine alla lettura" / "gestione del villaggio". These phrases appear naturally in the running text (not as a stuffed list), which is what Google Play's algorithm rewards and what real users respond to.
- **Every feature section doubles as a keyword cluster**: reading tracker / book log, village & city builder, animal collector with rarity tiers, trivia minigames, daily rewards ("lucky wheel"), seasonal live-ops events, and missions/achievements. These map to the five distinct audiences most likely to search for and convert on this app: reading-habit builders, parents of young readers, cozy/builder-game fans, collectors, and casual daily-spin players.
- **Emoji section markers** (📚 🏘️ 🐾 🎮 🎰 🎉 🎯 🌍) mirror the tone already used in the app's own onboarding tour text (`tour_*` strings in `assets/messages/*/[locale].json`) — they break up the wall of text on a phone screen, increase scannability/conversion in the listing, and stay consistent with the kawaii voice players will recognize once they open the app.
- **The closing line is a call-to-action with an emotional payoff** ("turns every page into a little piece of magic" / equivalents), aimed at improving listing-to-install conversion rather than just informing.

---

#### English (en-US)

**App name**
```
My Reading Village
```

**Short description** (75/80 chars)
```
Every page you read grows your cozy village and brings home animal friends!
```

**Full description** (2,269/4,000 chars)
```
🌸 Turn your reading habit into the cutest village adventure! 🌸

My Reading Village is a cozy reading-tracker game that transforms every page you read into real progress for your very own cute little village. Log your reading sessions, watch your resources grow, and build a home for dozens of adorable animal villagers — all while building a reading habit that actually sticks.

📚 YOUR READING, YOUR VILLAGE
Every page you log earns coins, gems, wood and metal. Track your books, reading sessions and favorite quotes, then spend your rewards to build, decorate and expand a charming village that grows alongside your bookshelf.

🏘️ BUILD & CUSTOMIZE
Place homes, parks, schools, libraries, hospitals and more. Upgrade buildings, unlock new land, design walking paths, and decorate with cute monuments and seasonal items. Snap a photo of your village anytime and share your progress with friends.

🐾 COLLECT ADORABLE VILLAGERS
Welcome dozens of lovable animal species to your village — from common critters to legendary and godly rarities. Keep them happy, give them books to read, and grow your collection one page at a time.

🎮 PLAY LITERARY MINIGAMES
Put your book knowledge to the test! Guess the author, match characters to their roles, spot the real book title, and identify famous opening and closing lines — all while earning bonus rewards.

🎰 SPIN THE DAILY LUCKY WHEEL
Every day brings a free spin with surprise prizes — gems, coins, resources, and even rare animal species.

🎉 SEASONAL EVENTS ALL YEAR ROUND
Celebrate Halloween, Christmas, Carnival, Easter, Earth Day, Friendship Day, Literacy Day and more with limited-time missions and exclusive collectible species.

🎯 MISSIONS & MILESTONES
Complete reading and building goals to earn rewards and watch your village level up — there's always something new to work toward.

🌍 AVAILABLE IN 5 LANGUAGES
English, Spanish, Portuguese, French and Italian — read and play in the language you love.

Whether you're trying to build a daily reading habit, raise your kids as book lovers, or just want a relaxing village builder with a literary twist, My Reading Village turns every page into a little piece of magic.

Download now and start building your story — one page, one villager, one building at a time! 🌸📖
```

---

#### Spanish (es-ES / es-419)

**App name**
```
My Reading Village
```

**Short description** (75/80 chars)
```
Cada página que lees hace crecer tu acogedora aldea y trae amigos animales.
```

**Full description** (2,493/4,000 chars)
```
🌸 ¡Convierte tu hábito de lectura en la aventura más tierna! 🌸

My Reading Village es un juego de seguimiento de lectura que transforma cada página que lees en progreso real para tu propia aldea acogedora. Registra tus sesiones de lectura, observa cómo crecen tus recursos y construye un hogar para decenas de adorables vecinos animales — todo mientras formas un hábito de lectura que perdura.

📚 TU LECTURA, TU ALDEA
Cada página que registras te da monedas, gemas, madera y metal. Lleva el control de tus libros, sesiones de lectura y citas favoritas, y luego usa tus recompensas para construir, decorar y expandir una aldea encantadora que crece junto a tu biblioteca.

🏘️ CONSTRUYE Y PERSONALIZA
Coloca casas, parques, escuelas, bibliotecas, hospitales y mucho más. Mejora edificios, desbloquea nuevos terrenos, diseña caminos y decora con monumentos tiernos y artículos de temporada. Toma una foto de tu aldea cuando quieras y compártela con tus amigos.

🐾 COLECCIONA VECINOS ADORABLES
Da la bienvenida a decenas de especies de animales — desde criaturas comunes hasta rarezas legendarias y divinas. Mantenlos felices, dales libros para leer y haz crecer tu colección página a página.

🎮 JUEGA MINIJUEGOS LITERARIOS
¡Pon a prueba tu conocimiento de libros! Adivina al autor, relaciona personajes con sus roles, identifica si un título de libro es real o inventado, y reconoce las primeras y últimas líneas de obras famosas — todo mientras ganas recompensas extra.

🎰 GIRA LA RULETA DIARIA
Cada día tienes un giro gratis con premios sorpresa: gemas, monedas, recursos e incluso especies de animales poco comunes.

🎉 EVENTOS DE TEMPORADA TODO EL AÑO
Celebra Halloween, Navidad, Carnaval, Pascua, el Día de la Tierra, el Día de la Amistad, el Día de la Alfabetización y mucho más con misiones por tiempo limitado y especies exclusivas para coleccionar.

🎯 MISIONES Y LOGROS
Completa metas de lectura y construcción para ganar recompensas y ver cómo tu aldea sube de nivel — siempre hay algo nuevo por lograr.

🌍 DISPONIBLE EN 5 IDIOMAS
Inglés, español, portugués, francés e italiano — lee y juega en el idioma que prefieras.

Ya sea que quieras crear el hábito de leer todos los días, animar a tus hijos a amar los libros, o simplemente disfrutar de un relajante juego de construcción de aldeas con un toque literario, My Reading Village convierte cada página en un poco de magia.

¡Descárgalo ahora y empieza a construir tu historia — una página, un vecino y un edificio a la vez! 🌸📖
```

---

#### Portuguese (pt-BR / pt-PT)

**App name**
```
My Reading Village
```

**Short description** (78/80 chars)
```
Cada página lida faz crescer sua vila aconchegante e traz bichinhos adoráveis.
```

**Full description** (2,439/4,000 chars)
```
🌸 Transforme seu hábito de leitura na aventura mais fofa que existe! 🌸

My Reading Village é um joguinho de acompanhamento de leitura que transforma cada página lida em progresso real para a sua própria vila aconchegante. Registre suas sessões de leitura, veja seus recursos crescerem e construa um lar para dezenas de vizinhos animais adoráveis — tudo isso enquanto cria um hábito de leitura que realmente dura.

📚 SUA LEITURA, SUA VILA
Cada página registrada rende moedas, gemas, madeira e metal. Acompanhe seus livros, sessões de leitura e citações favoritas, e use suas recompensas para construir, decorar e expandir uma vila encantadora que cresce junto com a sua estante.

🏘️ CONSTRUA E PERSONALIZE
Posicione casas, parques, escolas, bibliotecas, hospitais e muito mais. Melhore construções, desbloqueie novos terrenos, desenhe caminhos e decore com monumentos fofos e itens sazonais. Tire uma foto da sua vila quando quiser e compartilhe com os amigos.

🐾 COLECIONE VIZINHOS ADORÁVEIS
Receba dezenas de espécies de animais — de criaturas comuns a raridades lendárias e divinas. Deixe-os felizes, dê livros para eles lerem e veja sua coleção crescer página após página.

🎮 JOGUE MINIJOGOS LITERÁRIOS
Teste seus conhecimentos sobre livros! Adivinhe o autor, combine personagens com seus papéis, descubra se um título de livro é real ou inventado e reconheça as primeiras e últimas frases de obras famosas — tudo isso ganhando recompensas extras.

🎰 GIRE A ROLETA DIÁRIA
Todos os dias você tem um giro grátis com prêmios surpresa: gemas, moedas, recursos e até espécies raras de animais.

🎉 EVENTOS SAZONAIS O ANO TODO
Comemore Halloween, Natal, Carnaval, Páscoa, o Dia do Meio Ambiente, o Dia da Amizade, o Dia da Alfabetização e muito mais com missões por tempo limitado e espécies exclusivas para colecionar.

🎯 MISSÕES E CONQUISTAS
Complete metas de leitura e construção para ganhar recompensas e ver sua vila subir de nível — sempre tem algo novo para conquistar.

🌍 DISPONÍVEL EM 5 IDIOMAS
Inglês, espanhol, português, francês e italiano — leia e jogue no idioma que preferir.

Seja para criar o hábito de ler todos os dias, incentivar seus filhos a amarem livros, ou simplesmente curtir um joguinho relaxante de construção de vila com toque literário, My Reading Village transforma cada página em um pouquinho de magia.

Baixe agora e comece a construir a sua história — uma página, um vizinho e uma construção de cada vez! 🌸📖
```

---

#### French (fr-FR)

**App name**
```
My Reading Village
```

**Short description** (80/80 chars)
```
Chaque page lue agrandit votre village et vous amène des amis animaux adorables.
```

**Full description** (2,777/4,000 chars)
```
🌸 Transformez votre habitude de lecture en la plus adorable des aventures ! 🌸

My Reading Village est un jeu de suivi de lecture qui transforme chaque page lue en progrès bien réel pour votre propre village chaleureux. Notez vos séances de lecture, regardez vos ressources grandir et construisez un foyer pour des dizaines de voisins animaux attachants — tout en bâtissant une habitude de lecture qui dure vraiment.

📚 VOTRE LECTURE, VOTRE VILLAGE
Chaque page enregistrée rapporte des pièces, des gemmes, du bois et du métal. Suivez vos livres, vos séances de lecture et vos citations préférées, puis utilisez vos récompenses pour construire, décorer et agrandir un village charmant qui grandit avec votre bibliothèque.

🏘️ CONSTRUISEZ ET PERSONNALISEZ
Placez des maisons, des parcs, des écoles, des bibliothèques, des hôpitaux et bien plus encore. Améliorez vos bâtiments, débloquez de nouveaux terrains, dessinez des chemins et décorez avec des monuments tout mignons et des objets saisonniers. Prenez une photo de votre village à tout moment et partagez-la avec vos amis.

🐾 COLLECTIONNEZ DES VOISINS ATTACHANTS
Accueillez des dizaines d'espèces animales — des créatures communes aux raretés légendaires et divines. Rendez-les heureux, offrez-leur des livres à lire et faites grandir votre collection page après page.

🎮 JOUEZ À DES MINI-JEUX LITTÉRAIRES
Testez vos connaissances en littérature ! Devinez l'auteur, associez les personnages à leur rôle, repérez si un titre de livre est vrai ou inventé, et reconnaissez les premières et dernières lignes d'œuvres célèbres — tout en gagnant des récompenses bonus.

🎰 TOURNEZ LA ROUE QUOTIDIENNE
Chaque jour, un tour gratuit vous attend avec des prix surprises : gemmes, pièces, ressources et même des espèces animales rares.

🎉 DES ÉVÉNEMENTS SAISONNIERS TOUTE L'ANNÉE
Célébrez Halloween, Noël, le Carnaval, Pâques, la Journée de l'environnement, la Journée de l'amitié, la Journée de l'alphabétisation et bien plus encore, avec des missions limitées dans le temps et des espèces exclusives à collectionner.

🎯 MISSIONS ET OBJECTIFS
Accomplissez des objectifs de lecture et de construction pour gagner des récompenses et voir votre village monter de niveau — il y a toujours quelque chose de nouveau à accomplir.

🌍 DISPONIBLE EN 5 LANGUES
Anglais, espagnol, portugais, français et italien — lisez et jouez dans la langue de votre choix.

Que vous souhaitiez prendre l'habitude de lire chaque jour, donner à vos enfants le goût des livres, ou simplement profiter d'un jeu de gestion de village relaxant à la saveur littéraire, My Reading Village transforme chaque page en un petit moment de magie.

Téléchargez-le dès maintenant et commencez à écrire votre histoire — une page, un voisin et un bâtiment à la fois ! 🌸📖
```

---

#### Italian (it-IT)

**App name**
```
My Reading Village
```

**Short description** (78/80 chars)
```
Ogni pagina letta fa crescere il villaggio e accoglie amici animali adorabili.
```

**Full description** (2,583/4,000 chars)
```
🌸 Trasforma la tua abitudine alla lettura nell'avventura più dolce di sempre! 🌸

My Reading Village è un gioco di monitoraggio della lettura che trasforma ogni pagina letta in progressi reali per il tuo villaggio accogliente. Registra le tue sessioni di lettura, guarda crescere le tue risorse e costruisci una casa per decine di adorabili vicini animali — il tutto mentre costruisci un'abitudine di lettura che dura davvero.

📚 LA TUA LETTURA, IL TUO VILLAGGIO
Ogni pagina registrata ti fa guadagnare monete, gemme, legno e metallo. Tieni traccia dei tuoi libri, delle sessioni di lettura e delle tue citazioni preferite, poi usa le ricompense per costruire, decorare ed espandere un villaggio incantevole che cresce insieme alla tua libreria.

🏘️ COSTRUISCI E PERSONALIZZA
Posiziona case, parchi, scuole, biblioteche, ospedali e molto altro. Potenzia gli edifici, sblocca nuovi terreni, progetta sentieri e decora con monumenti tenerissimi e oggetti di stagione. Scatta una foto al tuo villaggio quando vuoi e condividila con gli amici.

🐾 COLLEZIONA VICINI ADORABILI
Accogli decine di specie animali — da creature comuni a rarità leggendarie e divine. Rendili felici, regala loro libri da leggere e guarda crescere la tua collezione pagina dopo pagina.

🎮 GIOCA A MINIGIOCHI LETTERARI
Metti alla prova la tua conoscenza dei libri! Indovina l'autore, abbina i personaggi al loro ruolo, scopri se un titolo è reale o inventato e riconosci le prime e le ultime righe di opere famose — il tutto guadagnando ricompense extra.

🎰 GIRA LA RUOTA QUOTIDIANA
Ogni giorno hai un giro gratuito con premi a sorpresa: gemme, monete, risorse e persino specie animali rare.

🎉 EVENTI STAGIONALI TUTTO L'ANNO
Festeggia Halloween, Natale, Carnevale, Pasqua, la Giornata della Terra, la Giornata dell'amicizia, la Giornata dell'alfabetizzazione e molto altro con missioni a tempo limitato e specie esclusive da collezionare.

🎯 MISSIONI E TRAGUARDI
Completa obiettivi di lettura e costruzione per guadagnare ricompense e vedere il tuo villaggio salire di livello — c'è sempre qualcosa di nuovo da raggiungere.

🌍 DISPONIBILE IN 5 LINGUE
Inglese, spagnolo, portoghese, francese e italiano — leggi e gioca nella lingua che preferisci.

Che tu voglia costruire l'abitudine di leggere ogni giorno, far innamorare i tuoi figli dei libri, o semplicemente goderti un rilassante gioco di gestione del villaggio con un tocco letterario, My Reading Village trasforma ogni pagina in un po' di magia.

Scaricalo ora e inizia a costruire la tua storia — una pagina, un vicino e un edificio alla volta! 🌸📖
```

---

#### Graphics assets (same for every language)

- **Screenshots**: At least 2 phone screenshots (1080×1920 px recommended). Capture the village view, the reading tracker, the species collection and a minigame — these map directly to the four feature blocks above and reinforce what the description promises.
- **Feature graphic**: 1024×500 px banner image.
- **App icon**: 512×512 px PNG (already set up via flutter_launcher_icons).

### Step 3.3 — Content Rating

Go to **Policy > App content > Content rating**:

1. Click **"Start questionnaire"**.
2. Answer questions about your app's content (no violence, no explicit content).
3. You will likely receive a **"Everyone"** or **"Everyone 10+"** rating.

### Step 3.4 — Target Audience

Go to **Policy > App content > Target audience and content**:

- Select age ranges your app targets (e.g., 13+, or if suitable for children, you must comply with COPPA).
- If children are included in your target audience, double check that **Google Analytics for Firebase is configured for child-directed treatment** before declaring this — see Step 3.6 below. The in-app analytics consent banner (shown right after onboarding) keeps collection strictly opt-in either way, but the Families/COPPA declarations here still depend on your audience selection.

### Step 3.5 — Privacy Policy & Terms

The app's Privacy Policy and Terms & Conditions are published on the official marketing website (see `WEBSITE.md` — both pages ship with the site, in sync with what the in-app consent banner links to):

1. Privacy Policy: `https://<your-domain>/privacy`
2. Terms & Conditions: `https://<your-domain>/terms`
3. Paste the Privacy Policy URL in **Policy > App content > Privacy policy**.

> Both pages must stay in sync with the in-app consent banner copy and with the **Data safety** declaration in Step 3.6 — if you ever change what the app collects, update the website pages and the Play Console form together.

### Step 3.6 — Data Safety

Go to **Policy > App content > Data safety** and declare data collection accurately based on what the app actually does:

**Data collected only with explicit user consent (Analytics):**
- The app shows a consent banner right after onboarding, asking the player to accept or decline anonymous usage analytics (and, separately, to accept the Privacy Policy and Terms & Conditions). If the player declines or leaves a checkbox unticked, **Google Analytics for Firebase is never initialized and no analytics data is ever collected or transmitted**.
- If the player accepts, declare:
  - **App activity → App interactions**: collected, used for *Analytics*, shared with Google (Firebase) for processing, marked as **optional / user can choose whether this is collected** (the consent banner), and **can be deleted** by the user at any time (toggle off in **Settings → Data Management → Analytics & Privacy**, which calls `setAnalyticsCollectionEnabled(false)`).
  - **Device or other IDs**: collected (Firebase installation identifier, required for aggregate reporting), same optional/consent-gated and deletable status as above.
  - Mark this data as **encrypted in transit** (the Firebase SDK uses HTTPS).
  - In the purpose field, describe it as: *"Anonymous, aggregate counters about how the game is used (e.g., reading sessions logged, buildings placed, villagers unlocked) — never usernames, village names, book titles, authors, quotes, or photos."*

**Data collected regardless of consent (existing, unrelated to analytics):**
- **Advertising IDs / device info** via Unity Ads, for serving and measuring rewarded ads — declare per Unity Ads' own Data safety guidance.
- **App info and performance** (e.g., crash logs) if you have Play Console's automatic crash reporting enabled.
- Book search queries are sent to Open Library only when the player actively uses "Search Online" — declare as **App activity → Search history**, *not* required to function, *not* shared for advertising.

**Data the app does NOT collect:**
- No account/sign-in data, no personal identifiers (name, email, phone), no location, no contacts, no financial info beyond what Google Play's own purchase flow handles. The reading log, village data, and photos the player adds all stay strictly on-device (local SQLite + local files) and are never transmitted.

---

## PART 4 — Register In-App Products

This is critical for the store to work. All products sold with real money must be registered here.

### Step 4.1 — Enable In-App Purchases

Go to **Monetize > Products > In-app products**.

If this section is greyed out, you may need to:

1. Upload at least one APK/AAB to a testing track first (see Part 5).
2. Have a valid payment profile linked to your Play Console account.

To set up a payment profile: click your account name > **Payments profile** and add a bank account.

### Step 4.2 — Register Gems Products (Consumable)

For each gem pack, click **"Create product"**:

| Product ID  | Name      | Description             | Price  |
| ----------- | --------- | ----------------------- | ------ |
| `gems_50`   | 50 Gems   | 50 gems for your village   | $0.99  |
| `gems_100`  | 100 Gems  | 100 gems for your village  | $1.79  |
| `gems_200`  | 200 Gems  | 200 gems for your village  | $3.29  |
| `gems_500`  | 500 Gems  | 500 gems for your village  | $7.99  |
| `gems_1000` | 1000 Gems | 1000 gems for your village | $14.99 |
| `gems_2000` | 2000 Gems | 2000 gems for your village | $29.99 |

For each product:

1. Set **Product ID** exactly as shown (must match the `productId` in `store_rules.dart`).
2. Set **Type** to **"Consumable"** (gems can be bought multiple times).
3. Set **Status** to **Active**.
4. Set the price.
5. Click **Save**.

### Step 4.3 — Register Pack Products (Consumable)

| Product ID     | Name         | Description                                                       | Price  |
| -------------- | ------------ | ----------------------------------------------------------------- | ------ |
| `pack_starter` | Starter Pack | 200 coins + 100 wood + 60 metal + 2 sandwiches                    | $1.99  |
| `pack_builder` | Builder Pack | 400 coins + 200 wood + 120 metal + 3 hammers                      | $3.49  |
| `pack_reader`  | Reader Pack  | 200 coins + 50 gems + 3 books + 3 glasses                         | $4.99  |
| `pack_village` | Village Pack | 500 coins + 200 wood + 100 metal + 100 gems + powerups            | $9.99  |
| `pack_mega`    | Mega Pack    | 1000 coins + 500 wood + 200 metal + 200 gems + 10 of each powerup | $19.99 |

All packs are **Consumable** (can be repurchased).

**Important:** The `productId` values here must exactly match the `productId` fields in `StoreRules.packs` in `lib/domain/rules/store_rules.dart`.

### Step 4.4 — Register Species Products (Non-Consumable)

Species purchases are **Non-Consumable** (bought once; owning a species is permanent).

| Product ID             | Name         | Rarity        | Price  |
| ---------------------- | ------------ | ------------- | ------ |
| `species_grizzly_bear` | Grizzly Bear | Rare          | $1.99  |
| `species_polar_bear`   | Polar Bear   | Rare          | $1.99  |
| `species_panda_bear`   | Panda Bear   | Rare          | $1.99  |
| `species_red_panda`    | Red Panda    | Rare          | $1.99  |
| `species_sloth`        | Sloth        | Rare          | $1.99  |
| `species_hedgehog`     | Hedgehog     | Rare          | $1.99  |
| `species_capybara`     | Capybara     | Rare          | $1.99  |
| `species_cow`          | Cow          | Rare          | $1.99  |
| `species_sheep`        | Sheep        | Rare          | $1.99  |
| `species_bull`         | Bull         | Extraordinary | $4.99  |
| `species_otter`        | Otter        | Extraordinary | $4.99  |
| `species_kangaroo`     | Kangaroo     | Extraordinary | $4.99  |
| `species_reindeer`     | Reindeer     | Extraordinary | $4.99  |
| `species_ferret`       | Ferret       | Extraordinary | $4.99  |
| `species_mole`         | Mole         | Extraordinary | $4.99  |
| `species_bat`          | Bat          | Extraordinary | $4.99  |
| `species_donkey`       | Donkey       | Extraordinary | $4.99  |
| `species_turkey`       | Turkey       | Extraordinary | $4.99  |

| `species_monkey`       | Monkey       | Legendary     | $7.99  |
| `species_gorilla`      | Gorilla      | Legendary     | $7.99  |
| `species_zebra`        | Zebra        | Legendary     | $7.99  |
| `species_horse`        | Horse        | Legendary     | $7.99  |
| `species_skunk`        | Skunk        | Legendary     | $7.99  |
| `species_hyena`        | Hyena        | Legendary     | $7.99  |
| `species_mouse`        | Mouse        | Legendary     | $7.99  |
| `species_lion`         | Lion         | Godly         | $13.99 |
| `species_armadillo`    | Armadillo    | Godly         | $13.99 |
| `species_beaver`       | Beaver       | Godly         | $13.99 |
| `species_fox`          | Fox          | Godly         | $13.99 |
| `species_tiger`        | Tiger        | Godly         | $13.99 |
| `species_leopard`      | Leopard      | Godly         | $13.99 |

For each product:

1. Set **Product ID** exactly as shown (must match the `id` field in `SpeciesRules.allSpecies` in `lib/domain/rules/species_rules.dart`).
2. Set **Type** to **"Non-consumable"** (species cannot be bought twice — the app hides already-owned species from the store tab).
3. Set **Status** to **Active**.
4. Set the price.
5. Click **Save**.

**Important:** The `productId` values here must exactly match the `realPrice`-backed species IDs in `SpeciesRules.allSpecies` in `lib/domain/rules/species_rules.dart`.

---

## PART 5 — Testing Before Going Live

### Step 5.1 — Simulation Mode (No Play Store Required)

The app has a built-in simulation mode. In `lib/app_constants.dart`:

```dart
static const bool playStore = false;  // simulation mode
```

When `playStore = false`:

- Tapping buy buttons in the Gems and Packs tabs instantly grants the items.
- A dialog shows "Simulated Purchase — no real money charged".
- No Google account or Play Console needed.

Use this mode during development and testing.

### Step 5.2 — Internal Testing Track

Before publishing publicly, use Internal Testing:

1. In Play Console, go to **Testing > Internal testing**.
2. Click **"Create new release"**.
3. Upload your `app-release.aab` file.
4. Add testers by email (your own email, QA testers, etc.).
5. Testers install the app via the internal testing link.

Internal testers can make real in-app purchases without being charged (Google provides test payment methods).

### Step 5.3 — Enable Real Payments in the App

When you're ready to test real Play Store payments:

1. Set `playStore = true` in `lib/app_constants.dart`.
2. Build a new release AAB.
3. Upload to the Internal Testing track.
4. Add yourself as an internal tester.
5. Install via the testing link (not via `flutter run`).

**Note:** The `in_app_purchase` package only works in real Play Store builds, not in debug/`flutter run` sessions.

### Step 5.4 — License Testers (Free Purchases)

To test purchases without spending real money:

1. In Play Console, go to **Setup > License testing**.
2. Add your Google account email.
3. Set **License response** to **"RESPOND_NORMALLY"**.
4. License testers can make purchases that are charged but immediately refunded.

### Step 5.5 — Closed/Open Testing

After internal testing:

1. **Closed Testing (Alpha)**: Small group of real users.
2. **Open Testing (Beta)**: Anyone can join.
3. Move through these stages before production.

---

## PART 6 — Implement Purchase Verification (Server-Side, Optional but Recommended)

For production, you should verify purchases server-side to prevent fraud. The basic flow:

1. User buys a product → Play Store returns a `purchaseToken`.
2. Send `purchaseToken` + `productId` to your backend server.
3. Your server calls the Google Play Developer API to verify the purchase.
4. Only then grant the items.

This is optional for a small indie app but recommended to prevent cheating.

---

## PART 7 — Publish to Production

### Step 7.1 — Production Release

1. Go to **Testing > Production**.
2. Click **"Create new release"**.
3. Upload the `app-release.aab`.
4. Write release notes (what's new in this version).
5. Click **"Review release"**, then **"Start rollout to Production"**.

### Step 7.2 — Rollout Percentage

You can start with a partial rollout (e.g., 10% of users) to catch issues before full release:

- Start at 10% → 25% → 50% → 100% as you gain confidence.

### Step 7.3 — Review Time

Google typically reviews new apps in **1–3 days**. After approval, your app goes live on the Play Store.

---

## PART 8 — After Publishing

### Monitoring

- **Play Console Dashboard**: Daily installs, ratings, crashes.
- **Android Vitals**: ANRs (App Not Responding) and crash rates.
- **Revenue**: In **Monetize > Financial reports**.

### Updating the App

Every update requires:

1. Incrementing `versionCode` (e.g., `+2`, `+3`) in `pubspec.yaml`.
2. Building a new AAB.
3. Uploading to Play Console.
4. Creating a new release on the production track.

### Adding New Products

Add new in-app product IDs in Play Console **before** releasing the app version that references them. Products not yet in Play Console will fail to load.

---

## Quick Reference Checklist

- [ ] Pay $25 developer fee at https://play.google.com/console
- [ ] Complete developer profile
- [ ] Set unique `applicationId` in `build.gradle`
- [ ] Generate and configure signing keystore
- [ ] Run `flutter build appbundle --release`
- [ ] Create app in Play Console
- [ ] Complete store listing (screenshots, description, icon)
- [ ] Complete content rating questionnaire
- [ ] Add Privacy Policy URL (and Terms & Conditions URL alongside it on the website)
- [ ] Complete the **Data safety** form — declare consent-gated analytics (Firebase) plus existing Unity Ads/Open Library data flows
- [ ] Register all 15 in-app products (6 gem packs + 5 regular packs + 4 species)
- [ ] Upload AAB to Internal Testing track
- [ ] Test purchases with license testers
- [ ] Set `playStore = true` in `app_constants.dart`
- [ ] Build and upload production AAB
- [ ] Roll out to production
