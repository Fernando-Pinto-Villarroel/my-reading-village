import { motion } from "motion/react";
import { Link } from "react-router-dom";

export default function Terms() {
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
            Terms &amp; Conditions
          </h1>
          <p className="font-body text-sm text-dark-text/50 mb-10">
            <em>Last updated: June 20, 2026</em>
          </p>
        </motion.div>

        <motion.div
          className="bg-soft-white rounded-3xl shadow-kawaii p-7 md:p-10"
          initial={{ opacity: 0, y: 18 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.15, duration: 0.5 }}
        >
          <TermsContent />
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

function TermsContent() {
  return (
    <div>
      <p className="font-body text-sm md:text-base leading-relaxed text-dark-text/75 mb-8">
        Welcome to My Reading Village! These Terms &amp; Conditions ("Terms")
        govern your use of the My Reading Village mobile application ("the
        app"), developed by Fernando Pinto Villarroel ("the developer", "we",
        "our"). By installing or using the app, you agree to these Terms. If
        you do not agree, please do not use the app.
      </p>

      <Section title="1. The App">
        <p>
          My Reading Village is a free-to-play, cozy village-builder game that
          turns your real-world reading habit into in-game progress. Logging the
          books and pages you read earns in-game resources (coins, gems, wood,
          and metal) that you use to construct buildings, unlock collectible
          animal villagers, complete missions, and participate in seasonal
          events. The core gameplay is fully offline and requires no account or
          internet connection.
        </p>
      </Section>

      <Section title="2. Eligibility & Parental Consent">
        <p>
          The app is designed for readers of all ages. If you are under 13
          years of age (or the applicable age of digital consent in your
          country), you must have your parent's or legal guardian's permission
          before using the app, and a parent or guardian must review and agree
          to these Terms on your behalf.
        </p>
        <p>
          Parents and guardians are responsible for supervising their children's
          use of the app, including any in-app purchase decisions. All purchases
          require authentication through Google Play, but we recommend enabling
          purchase confirmation settings on your device to prevent accidental
          purchases.
        </p>
      </Section>

      <Section title="3. Your Account & Data">
        <p>
          The app does not require you to create an account or sign in. Your
          village, reading log, settings, and all other game data are stored
          locally on your device in a local database. You are responsible for
          keeping your device secure. Use the{" "}
          <strong className="font-semibold text-dark-text">Export Backup</strong>{" "}
          feature regularly if you want to preserve your progress, as we have no
          ability to recover data lost due to device loss, damage, or
          uninstallation.
        </p>
      </Section>

      <Section title="4. Device Permissions">
        <p>
          The app may request optional device permissions to enable additional
          features:
        </p>
        <ul className="list-disc list-inside space-y-1 ml-2">
          <li>
            <strong className="font-semibold text-dark-text">Internet</strong>{" "}
            — for optional book search, in-app purchases, rewarded ads, and
            analytics (if consented). The core game works offline.
          </li>
          <li>
            <strong className="font-semibold text-dark-text">
              Camera &amp; Photo Library
            </strong>{" "}
            — to add cover photos to your book entries. Entirely optional.
          </li>
          <li>
            <strong className="font-semibold text-dark-text">
              Media / Storage
            </strong>{" "}
            — to export or import backup files and save village photos to your
            gallery. Entirely optional.
          </li>
          <li>
            <strong className="font-semibold text-dark-text">
              Notifications
            </strong>{" "}
            — to receive local reminders (construction complete, event alerts,
            reading reminders). Entirely optional. You can disable notifications
            at any time from your device settings.
          </li>
        </ul>
        <p>
          Declining or revoking any permission does not delete your saved data
          and does not prevent you from using the rest of the app.
        </p>
      </Section>

      <Section title="5. In-App Purchases">
        <p>
          The app offers optional in-app purchases through{" "}
          <strong className="font-semibold text-dark-text">
            Google Play Billing
          </strong>
          . No purchase is required to progress — all content is also
          obtainable through normal gameplay. Current purchase categories are:
        </p>
        <ul className="list-disc list-inside space-y-1 ml-2">
          <li>
            <strong className="font-semibold text-dark-text">Gem packs</strong>{" "}
            (consumable) — bundles of gems used to speed up construction, spin
            the lucky wheel, or unlock species. Prices range from $0.99 to
            $29.99.
          </li>
          <li>
            <strong className="font-semibold text-dark-text">Item packs</strong>{" "}
            (consumable) — bundles of in-game consumable items. Prices range
            from $1.49 to $19.99.
          </li>
          <li>
            <strong className="font-semibold text-dark-text">
              Species unlocks
            </strong>{" "}
            (non-consumable) — permanent unlocks for individual villager species.
            Prices range from $0.99 to $19.99.
          </li>
        </ul>
        <p>
          All purchases are processed exclusively by Google Play. We do not
          store or access your payment information. Prices are shown at the
          point of purchase and may vary by region based on Google Play's
          regional pricing.
        </p>
        <p>
          <strong className="font-semibold text-dark-text">Refunds.</strong>{" "}
          Consumable items (gem packs, item packs) are delivered immediately
          upon successful purchase. Non-consumable purchases (species unlocks)
          are permanently associated with your device. For refund requests,
          please contact Google Play support directly — their refund policy
          applies to all transactions.
        </p>
        <p>
          <strong className="font-semibold text-dark-text">
            In-game items have no real-world value.
          </strong>{" "}
          Coins, gems, wood, metal, villagers, buildings, and other in-game
          items cannot be exchanged for cash, transferred between devices, or
          redeemed outside the app.
        </p>
      </Section>

      <Section title="6. Advertising">
        <p>
          The app contains optional rewarded video ads. Watching a rewarded ad
          is always your choice — you initiate it by tapping a clearly labeled
          button in exchange for a specific in-game reward (such as speeding up
          construction, earning a free lucky wheel spin, or receiving free gems).
          We do not display banner ads, interstitial ads, or any ads that
          interrupt your gameplay.
        </p>
        <p>
          Ads are served through a third-party advertising network. When the app
          may be used by children under 13, ads are served in a
          non-personalized, contextual-only manner. You can limit ad
          personalization at any time through your device's privacy settings.
        </p>
      </Section>

      <Section title="7. Acceptable Use">
        <p>You agree not to:</p>
        <ul className="list-disc list-inside space-y-1 ml-2">
          <li>
            Reverse-engineer, decompile, or attempt to extract the source code
            of the app.
          </li>
          <li>
            Exploit bugs, use cheats, or use automated tools to manipulate
            in-game resources or progress.
          </li>
          <li>
            Interfere with or disrupt any third-party service the app relies on
            (Open Library, Google Play Billing, advertising networks, Firebase).
          </li>
          <li>
            Use the app for any commercial purpose without prior written
            authorization from the developer.
          </li>
          <li>
            Misuse the secret code system (promotional codes are one-time use
            per device; attempting to circumvent this is not permitted).
          </li>
        </ul>
      </Section>

      <Section title="8. Third-Party Services">
        <p>
          The app integrates with third-party services as described in our{" "}
          <Link
            to="/privacy"
            className="underline font-semibold"
            style={{ color: "var(--color-dark-lavender)" }}
          >
            Privacy Policy
          </Link>{" "}
          — Open Library (optional book search), a third-party advertising
          network (optional rewarded ads), Google Play Billing (optional
          purchases), and, only with your explicit consent, Google Analytics for
          Firebase (anonymous usage analytics) and Firebase Crashlytics (crash
          reporting). Your use of those services through the app is also subject
          to their own terms and policies.
        </p>
      </Section>

      <Section title="9. Analytics & Crash Reporting Consent">
        <p>
          As explained in our Privacy Policy, the app will only collect
          anonymous usage analytics and crash reports if you actively opt in via
          the consent screen shown after the welcome tour. Accepting these Terms
          does not, by itself, enable analytics or crash reporting — that
          requires a separate, explicit choice. You can change your preference
          at any time from{" "}
          <strong className="font-semibold text-dark-text">
            Settings → Data Management → Analytics &amp; Privacy
          </strong>
          .
        </p>
      </Section>

      <Section title="10. Intellectual Property">
        <p>
          All artwork, characters, music, names, and other creative assets in
          My Reading Village are the property of the developer and are protected
          by applicable intellectual-property laws. You may not copy,
          redistribute, or use them outside the app without prior written
          permission.
        </p>
      </Section>

      <Section title="11. Disclaimer & Limitation of Liability">
        <p>
          The app is provided "as is", without warranties of any kind. We do
          our best to keep it fun, cozy, and bug-free, but we cannot guarantee
          uninterrupted or error-free operation. In particular, we are not
          responsible for: loss of game data due to device failure or
          uninstallation; inability to use certain features due to declined
          permissions; or service interruptions to third-party APIs (Open
          Library, Google Play, advertising networks, Firebase).
        </p>
        <p>
          To the fullest extent permitted by applicable law, the developer is
          not liable for any indirect, incidental, special, or consequential
          damages arising from your use of — or inability to use — the app.
        </p>
      </Section>

      <Section title="12. App Changes & Termination">
        <p>
          We may update, modify, or discontinue features of the app at any time.
          If the app is removed from the Google Play Store, previously installed
          copies may continue to function, but we cannot guarantee ongoing
          compatibility or support. Your locally stored game data remains on
          your device regardless of any changes to the app's availability.
        </p>
      </Section>

      <Section title="13. Changes to These Terms">
        <p>
          We may update these Terms from time to time, for example as new
          features are added. Any changes will be posted on this page with a
          new "Last updated" date. Significant changes may also be highlighted
          in the app. Continued use of the app after an update constitutes
          acceptance of the revised Terms.
        </p>
      </Section>

      <Section title="14. Contact Us">
        <p>
          Questions about these Terms can be sent to:{" "}
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
