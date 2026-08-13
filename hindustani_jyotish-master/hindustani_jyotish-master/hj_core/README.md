# hj_core

Shared core for the Hindustani Jyotish Flutter apps (User & Astrologer).

Contains the brand **theme** (colours, typography, dark theme), data **models**
(`AppUser`, `Astrologer`, `Consultation`, `Wallet`, …), the **network** layer
(Dio `ApiClient` with bearer auth + transparent refresh), secure **storage**
(`TokenStore`), and the **auth** session (`AuthRepository`, `AuthCubit`).

Consumed via a path dependency:

```yaml
dependencies:
  hj_core:
    path: ../hj_core
```
