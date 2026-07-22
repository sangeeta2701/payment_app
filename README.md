# 💳 UPI-Inspired Fintech & Payment App

A secure, high-performance, full-stack financial payment application built using **Flutter** and **Firebase**. Engineered with a zero-trust security architecture, this app enables seamless QR code payments, direct contact transfers, group expense splitting, and dynamic bank balance querying—all managed reactively using **Riverpod**.

---

##  Core Features

###  Payments & Transfers
* **QR Code Scanner:** Fast and accurate QR code parsing for instant merchant and peer-to-peer payments.
* **Pay Anyone & Bank Transfer:** Direct mobile transfers using user input or device contact picking (`fast_contacts`), alongside dedicated bank transfer flows.
* **Mobile Recharge:** Dedicated flows for prepaid and postpaid mobile recharges across major telecom operators.
* **Split Bills & Group Expenses:** Real-time group expense splitting with live payback status tracking powered by **Cloud Firestore**.

###  Account & Transaction Engine
* **Dynamic Balance Querying:** Real-time bank balance state management with loading, fetched, and error states using custom PIN verification routing.
* **Transaction History:** Real-time transaction streams with dynamic category icons, search filtering, and safe UI formatting.

###  Enterprise-Grade Security
* **Hardware Biometric Auth:** Native Fingerprint and Face ID authentication checks via `local_auth` prior to sensitive transaction execution.
* **Data Leak Prevention (DLP):** Hardware-level screen protection (`screen_protector`) blocking screenshots and video recording on sensitive payment flows.
* **Encrypted Storage:** Secure local token and PIN storage via `flutter_secure_storage`.
* **Backend Authorization:** Strict **Cloud Firestore Security Rules** enforcing the principle of least privilege.

###  Smart Notifications
* **Cloud & Local Alerts:** Real-time push notifications powered by **Firebase Cloud Messaging (FCM)** paired with native Android high-importance channels (`flutter_local_notifications`).

---

##  Project Structure

This project adopts a feature-first architecture organized under `lib/features/`. Each feature contains its dedicated screens, state providers, data models, and UI components.

```text
PAYMENT_APP/
└── lib/
    ├── core/                   # Shared utilities, services, & global components
    └── features/               # Feature-Based Architecture
        ├── Add Bank/           # Bank linking & account setup
        │   ├── models/
        │   ├── providers/
        │   ├── screen/
        │   └── widgets/
        ├── Amount/             # Custom payment amount inputs & validation
        │   ├── providers/
        │   ├── screen/
        │   └── widgets/
        ├── Auth/               # Phone OTP Authentication & verification
        │   ├── screens/
        │   └── widgets/
        ├── Bank Transfer/      # Direct account transfer flows
        │   ├── screen/
        │   └── widgets/
        ├── biometrics/         # Hardware biometric authentication logic
        ├── BottomBar/          # Navigation bar & root layout
        │   └── screens/
        ├── History/            # Transaction history & search filtering
        ├── Home/               # Main dashboard & quick action entry points
        ├── Mobile Recharge/    # Telecom operator recharges
        ├── Notifications/      # FCM Push alerts & notification list
        ├── Pay Anyone/         # Direct contact payment flow
        ├── Payment Details/    # Receipt view & transaction breakdown
        ├── Pin/                # PIN verification & purpose-based routing
        └── Profile/            # User profile, app settings, & security preferences