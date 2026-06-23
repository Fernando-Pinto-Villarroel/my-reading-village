import { motion } from "motion/react";

export default function Privacy() {
  return (
    <main
      className="min-h-screen pt-24 pb-20 px-4 sm:px-6 lg:px-8"
      style={{ background: "var(--color-cream)" }}
    >
      <div className="max-w-3xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 22 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          <span
            className="inline-block font-heading font-semibold text-sm tracking-widest uppercase mb-3"
            style={{ color: "var(--color-dark-lavender)" }}
          >
            Legal
          </span>
          <h1 className="font-heading font-extrabold text-4xl md:text-5xl text-dark-text mb-2">
            Privacy Policy
          </h1>
          <p className="font-body text-sm text-dark-text/50 mb-10">
            <em>Last updated: June 20, 2026</em>
          </p>
        </motion.div>

        <motion.div
          className="bg-soft-white rounded-3xl shadow-kawaii p-7 md:p-10 prose-custom"
          initial={{ opacity: 0, y: 18 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.15, duration: 0.5 }}
        >
          <PolicyContent />
        </motion.div>
      </div>
    </main>
  );
}

function Section({
  title,
  children,
}: {
  title: string;
  children: React.ReactNode;
}) {
  return (
    <section className="mb-8">
      <h2 className="font-heading font-bold text-lg md:text-xl text-dark-text mb-3 pb-2 border-b border-pink/30">
        {title}
      </h2>
      <div className="font-body text-sm md:text-base leading-relaxed text-dark-text/75 space-y-3">
        {children}
      </div>
    </section>
  );
}

function PolicyContent() {
  return (
    <div>
      <p className="font-body text-sm md:text-base leading-relaxed text-dark-text/75 mb-8">
        My Reading Village ("the app", "we", "our") is developed by Fernando
        Pinto Villarroel ("the developer"). This Privacy Policy explains what
        information the app collects, how it is used, and your choices regarding
        it.
      </p>

      <Section title="1. Information We Collect">
        <p>
          <strong className="font-semibold text-dark-text">
            Information you provide directly
          </strong>
        </p>
        <ul className="list-disc list-inside space-y-1 ml-2">
          <li>
            The username and village name you choose during setup — stored only
            on your device.
          </li>
          <li>
            Reading data you log: book titles, authors, page counts, reading
            sessions, dates, time spent, tags, and favorite quotes or authors —
            stored only on your device in a local database.
          </li>
          <li>
            Photos: if you choose to add a cover photo to a book using your
            camera or photo gallery, that photo is stored only on your device.
            If you use the village photo feature to capture a screenshot of your
            village, that image is saved only to your device gallery.
          </li>
        </ul>
        <p>
          None of the above is transmitted to us or to any server of ours. My
          Reading Village stores all of your personal data locally on your
          device using a local SQLite database.
        </p>
        <p>
          <strong className="font-semibold text-dark-text">
            Information collected automatically — only with your consent
          </strong>
          <br />
          The first time you open the app, right after the welcome tour, you are
          shown a consent screen that explains, in plain language, what usage
          analytics are and asks you to accept or decline them — with a separate
          checkbox for this Privacy Policy and for the Terms &amp; Conditions.{" "}
          <strong className="font-semibold text-dark-text">
            If you decline, or leave a box unchecked, no analytics or
            crash-reporting library is ever started and no usage data is ever
            collected or sent anywhere; the app works exactly the same either
            way.
          </strong>
        </p>
        <p>
          If you do accept, the app uses{" "}
          <strong className="font-semibold text-dark-text">
            Google Analytics for Firebase
          </strong>{" "}
          to send us anonymous, aggregate counters about how the game is used —
          for example, that a reading session was logged and how many pages it
          covered, that a building was placed or upgraded, that a villager of a
          certain rarity was unlocked, or that a minigame was played. These
          events never include your username, your village's name, book titles,
          authors, quotes, photos, or anything else that could identify you.
          Firebase Analytics may also collect basic technical information (such
          as an installation identifier, app version, and general device/locale
          info) needed to produce that aggregate reporting, governed by{" "}
          <a
            href="https://policies.google.com/privacy"
            target="_blank"
            rel="noopener noreferrer"
            className="underline"
            style={{ color: "var(--color-dark-lavender)" }}
          >
            Google's Privacy Policy
          </a>
          .
        </p>
        <p>
          With your consent, the app also uses{" "}
          <strong className="font-semibold text-dark-text">
            Firebase Crashlytics
          </strong>{" "}
          to automatically collect crash reports and error logs. This helps us
          identify and fix bugs that might affect your experience. Crash reports
          include technical information such as the device model, OS version,
          app version, and the stack trace of the error — they never include
          your personal reading data, username, or village name.
        </p>
        <p>
          You can change your mind at any time from{" "}
          <strong className="font-semibold text-dark-text">
            Settings → Data Management → Analytics &amp; Privacy
          </strong>{" "}
          — turning analytics off immediately stops all future collection.
        </p>
      </Section>

      <Section title="2. Device Permissions We Request">
        <p>
          The app may request the following permissions. All of them are
          optional — the core game works without any of them. Granting them
          simply enables additional convenience features.
        </p>
        <ul className="list-disc list-inside space-y-1 ml-2">
          <li>
            <strong className="font-semibold text-dark-text">Internet</strong>{" "}
            — required only when you actively use the optional book search
            feature (Open Library API), make an in-app purchase (Google Play
            Billing), watch a rewarded ad, or if you have consented to
            analytics. The core reading and village gameplay is fully offline.
          </li>
          <li>
            <strong className="font-semibold text-dark-text">
              Camera &amp; Photo Library
            </strong>{" "}
            — requested only if you choose to add a cover photo to a book entry.
            Photos are stored only on your device and never uploaded.
          </li>
          <li>
            <strong className="font-semibold text-dark-text">
              Media / Storage
            </strong>{" "}
            — requested to allow you to export or import backup files and to
            save your village photo to the device gallery. No files are uploaded
            or accessed beyond what you explicitly select.
          </li>
          <li>
            <strong className="font-semibold text-dark-text">
              Notifications
            </strong>{" "}
            — requested to deliver local reminders such as construction
            completion alerts, seasonal event notifications, and daily reading
            reminders. These notifications are generated entirely on your device
            — no external push server is used.
          </li>
        </ul>
        <p>
          You can revoke any permission at any time through your device's
          Settings without affecting your saved game data.
        </p>
      </Section>

      <Section title="3. Third-Party Services">
        <p>
          <strong className="font-semibold text-dark-text">Book search.</strong>{" "}
          When you search for a book by title, author, or ISBN using the "Search
          Online" feature, your search query is sent to the{" "}
          <a
            href="https://openlibrary.org"
            target="_blank"
            rel="noopener noreferrer"
            className="underline"
            style={{ color: "var(--color-dark-lavender)" }}
          >
            Open Library
          </a>{" "}
          API, a free service operated by the Internet Archive, in order to
          retrieve book details and cover images. Books can always be added
          manually without an internet connection. Please refer to Open
          Library's own privacy policy for how they handle that request.
        </p>
        <p>
          <strong className="font-semibold text-dark-text">
            In-App Purchases.
          </strong>{" "}
          Optional purchases (gem packs, item packs, and species unlocks) are
          processed exclusively through{" "}
          <strong className="font-semibold text-dark-text">
            Google Play Billing
          </strong>
          . We never see or store your payment information — all billing is
          handled directly by Google. By making a purchase, you also agree to
          Google Play's Terms of Service and payment policies.
        </p>
        <p>
          <strong className="font-semibold text-dark-text">Advertising.</strong>{" "}
          The app displays optional rewarded video ads through a third-party
          advertising network. Ads are always user-initiated — you choose to
          watch one in exchange for an in-game reward, and you are never shown
          interstitial or banner ads. To serve and measure ads, the advertising
          network may collect and process information such as advertising
          identifiers, IP address, and device information, in accordance with
          their own privacy policy.{" "}
          <strong className="font-semibold text-dark-text">
            When the app may be used by children under 13, ads are served in a
            non-personalized, contextual-only manner and no personal data is
            collected from those users for advertising purposes.
          </strong>{" "}
          You can opt out of personalized advertising at any time through your
          device settings (typically{" "}
          <strong className="font-semibold text-dark-text">
            Settings → Privacy → Ads
          </strong>
          ).
        </p>
        <p>
          <strong className="font-semibold text-dark-text">
            Analytics &amp; Crash Reporting (only if you consent).
          </strong>{" "}
          As described in Section 1, if — and only if — you accept analytics on
          the consent screen, the app uses Google Analytics for Firebase to
          collect anonymous, aggregate usage events, and Firebase Crashlytics to
          collect crash reports and error logs. Neither library is ever
          initialized, and no data is ever sent, unless you have actively opted
          in.
        </p>
        <p>
          <strong className="font-semibold text-dark-text">
            Local notifications.
          </strong>{" "}
          The app schedules notifications (construction complete, event
          start/end, reading reminders) directly on your device. These are
          generated locally and are never routed through an external
          push-notification server.
        </p>
      </Section>

      <Section title="4. Data Storage & Backups">
        <p>
          All of your game and reading data lives locally on your device in a
          local SQLite database. The app's "Export Backup" / "Import Backup"
          feature lets you save your data to a file that you control — for
          example, to move it to a new device. You create and manage these files
          yourself; My Reading Village never uploads them anywhere.
        </p>
        <p>
          Your data is retained on your device for as long as the app is
          installed. You can delete all data at any time from{" "}
          <strong className="font-semibold text-dark-text">
            Settings → Data Management → Reset All Data
          </strong>
          , or by uninstalling the app.
        </p>
      </Section>

      <Section title="5. Data Sharing & Sale">
        <p>
          We do not sell your personal information. The only data that ever
          leaves your device is: (a) book search queries sent to Open Library
          when you use that feature, (b) information collected by our
          third-party advertising network to serve ads, (c) purchase tokens
          processed by Google Play Billing when you make an in-app purchase, and
          (d) — only if you have explicitly consented — the anonymous, aggregate
          analytics events and crash reports described in Section 1, sent via
          Google Analytics for Firebase and Firebase Crashlytics.
        </p>
      </Section>

      <Section title="6. Children's Privacy">
        <p>
          My Reading Village is suitable for readers of all ages, including
          children. We take children's privacy seriously and comply with
          applicable laws including the Children's Online Privacy Protection Act
          (COPPA).
        </p>
        <ul className="list-disc list-inside space-y-1 ml-2">
          <li>
            We do not knowingly collect personal information from children under
            13 beyond what is described in this policy (username and village
            name, stored locally on device only).
          </li>
          <li>
            Analytics are strictly opt-in and off by default. When enabled, they
            are configured for child-directed treatment — no ad-personalization
            signals are derived from analytics data.
          </li>
          <li>
            When the app may be used by children, advertising is served in a
            non-personalized, contextual-only manner with no behavioral
            targeting.
          </li>
          <li>
            Rewarded ads are user-initiated and clearly labeled — children or
            parents can simply decline to watch them; all rewards are also
            achievable through normal gameplay.
          </li>
          <li>
            If you are a parent or guardian and believe your child has provided
            personal information beyond what is described here, please contact
            us at{" "}
            <a
              href="mailto:myreadingvillage@gmail.com"
              className="underline"
              style={{ color: "var(--color-dark-lavender)" }}
            >
              myreadingvillage@gmail.com
            </a>{" "}
            and we will promptly address your concern.
          </li>
        </ul>
      </Section>

      <Section title="7. Your Choices & Rights">
        <ul className="list-disc list-inside space-y-1 ml-2">
          <li>
            Accept or decline analytics collection on first launch, and change
            that choice at any time from{" "}
            <strong className="font-semibold text-dark-text">
              Settings → Data Management → Analytics &amp; Privacy
            </strong>
            .
          </li>
          <li>
            Delete all of your data at any time from{" "}
            <strong className="font-semibold text-dark-text">
              Settings → Data Management → Reset All Data
            </strong>
            .
          </li>
          <li>
            Export your data at any time using{" "}
            <strong className="font-semibold text-dark-text">
              Export Backup
            </strong>
            .
          </li>
          <li>
            Revoke any device permission (camera, storage, notifications) at any
            time from your device Settings without losing your saved data.
          </li>
          <li>
            Manage ad personalization through your device's privacy settings.
          </li>
        </ul>
        <p>
          If you are located in the European Economic Area (EEA) or United
          Kingdom, you may also have rights under the GDPR or UK GDPR — including
          the right to access, correct, or delete personal data we hold about
          you. Because all personal data is stored locally on your device and
          never transmitted to our servers, you can exercise these rights
          directly through the app (Reset All Data, Export Backup). For any
          questions, contact us at the address in Section 9.
        </p>
      </Section>

      <Section title="8. Changes to This Policy">
        <p>
          We may update this Privacy Policy from time to time. Any changes will
          be posted on this page with a new "Last updated" date.
        </p>
      </Section>

      <Section title="9. Contact Us">
        <p>
          Questions about this Privacy Policy can be sent to:{" "}
          <a
            href="mailto:myreadingvillage@gmail.com"
            className="font-semibold underline"
            style={{ color: "var(--color-dark-lavender)" }}
          >
            myreadingvillage@gmail.com
          </a>
        </p>
      </Section>
    </div>
  );
}
