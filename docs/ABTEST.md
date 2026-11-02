### A/B TEST 1

**A/B Test Name:** Login and Sign-Up With vs. Without SSO

**User Story Number:** US1 – Account Creation / US2 – User Login

**Metrics** (HEART Framework)

- **Happiness:** User satisfaction with the login and sign-up experience.
- **Engagement:** Click-Through Rate (CTR) on the SSO login button.
- **Adoption:** Percentage of new users who successfully create an account.
- **Retention:** Percentage of users who return to the app after registering.
- **Task Success:** Percentage of users who successfully complete login or sign-up.

**Hypothesis**

Requiring users to manually enter their email and password may discourage them from creating an account or logging into the campus navigation app.

**Hypothesis:** Adding a Single Sign-On (SSO) button, such as "Continue with Google," will increase successful registrations and logins by providing a faster and more convenient authentication option.

The goal is to determine whether implementing an SSO button improves the authentication experience enough to justify including it in the app.

**Experiment**

We will use **Firebase Remote Config and Firebase A/B Testing** to randomly divide users into two groups.

- **Group A (Control):** Traditional email and password login/sign-up only.
- **Group B (Variant):** Traditional email and password login/sign-up with an additional SSO button.

Initially, 20% of eligible users will participate in the experiment, split equally between Groups A and B. This allows us to test the feature without affecting the majority of users.

**Firebase Analytics Tracking:**

- `login_started` – Tracks when users begin logging in.
- `login_completed` – Tracks successful logins.
- `sign_up_completed` – Tracks successful account creation.
- `sso_clicked` – Tracks how frequently users select the SSO button.

Each event will include a `screen_variant` parameter identifying Group A or Group B.

**Primary Success Metric:** Authentication completion rate, measuring the percentage of users who successfully log in or register after starting the process.

We will compare completion rates between both groups to determine whether SSO significantly improves authentication success.

**Variations**

**Variation A – Traditional Login (Control)**

Users log in or register using their email and password. The screen includes email and password fields, a Login button, and an option to create an account.

**Variation B – Login With SSO (Variant)**

Users have the same traditional login options, with an additional "Continue with Google" button that allows them to authenticate using their Google account.

**Design Work:** Create two login screen designs in Figma. Both screens will use identical layouts, colors, and traditional login fields. The only difference will be the addition of the SSO button in Variation B.

**Expected Outcome**

We expect the SSO button to increase authentication completion rates and reduce login friction. If Group B performs significantly better, the team will consider keeping SSO as a permanent feature. If there is little or no improvement, the team may decide that traditional authentication is sufficient.
