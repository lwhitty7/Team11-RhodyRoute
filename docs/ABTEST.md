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





### A/B TEST 2

A/B Test Name: Start Navigation Button With vs. Without Arrow Icon

User Story Number: US4 – Golden Path

Metrics (HEART Framework)

Task Success: Navigation start rate.

Task Success: Golden Path click-through rate (CTR).

Task Success: Route selection rate.

Hypothesis

Some students might select a route but not press the Start Navigation button. This could prevent them from getting directions to their destination.

We want to test if adding an arrow icon to the button makes it easier for students to notice and use.

Our hypothesis is that adding an arrow icon to the Start Navigation button will increase the number of students who start navigation after selecting a route.

We will only change the arrow icon so we can see if that one change makes a difference.

Experiment

We will use Firebase Remote Config and Firebase A/B Testing to randomly divide eligible users into two groups.

Group A (Control): Start Navigation button with text only.

Group B (Variant): Start Navigation button with text and an arrow icon.

We will include 50% of eligible users in the experiment. Half of those users will see Group A and the other half will see Group B. The remaining users will continue seeing the original button. This allows us to test the change without affecting everyone.

Firebase Remote Config will determine which button version users see.

Firebase Analytics Tracking

route_searched – Tracks when users search for a destination.

route_selected – Tracks when users select a route.

navigation_started – Tracks when users press the Start Navigation button.

These custom events will be added in FlutterFlow and recorded in Firebase Analytics. We will compare the events between both groups to see which version works better.

Primary Success Metric

Navigation start rate will measure the percentage of users who select a route and successfully start navigation.

Golden Path CTR will measure the percentage of users who select a route and click the Start Navigation button.

We will compare these metrics between both groups to see which button performs better.

Variations

Variation A – Text Only (Control)

The Start Navigation button will only display the words Start Navigation.

Variation B – Text With Arrow Icon (Variant)

The Start Navigation button will display Start Navigation with an arrow icon next to the text.

Both versions will use the same button size, color, location, and text. The only difference will be the arrow icon.

Design Work

We will use the same navigation screen for both versions. The screen will show the selected destination, route information, and the Start Navigation button.

In Variation A, the button will only have text. In Variation B, the button will have the same text with an arrow icon next to it.

We will compare both designs to see if the arrow icon helps students recognize the button and start navigation more easily.

Expected Outcome

We expect the button with the arrow icon to get more clicks and lead to more students starting navigation. If Group B performs better, we may keep the arrow icon in the final app. If there is little difference, we may keep the original button.

### A/B TEST 4

**A/B Test Name:** Enter as Guest Text Link vs. Outlined Button

**User Story Number:** US3 – Guest Access / US1 – Account Creation

**Metrics** (HEART Framework)

- **Adoption:** Total new users entering the app via account sign-up or guest mode.
- **Engagement:** Daily Active Users (DAU) and Weekly Active Users (WAU) opening the URI map.
- **Retention:** Percentage of users who return to the app after their first 7 days.
- **Task Success:** Percentage of first-time users who reach the URI map screen and start navigation.

**Hypothesis**

First-time users who open the app right before class may not want to spend time creating an account before seeing the URI campus map. However, if the "Enter as Guest" option is styled as a small, hard-to-notice text link at the bottom of the screen, users who do not want to sign up may close the app entirely instead of entering as a guest.

**Hypothesis:** Changing the "Enter as Guest" option from a plain text link to a clearly visible outlined button will reduce first-screen drop-off and increase the total number of users who reach the URI map and complete the Golden Path.

We will only change the styling of the "Enter as Guest" button so we know that single variable caused any change in conversion.

**Experiment**

We will use **Firebase Remote Config and Firebase A/B Testing** to randomly divide new, unauthenticated users into two groups.

- **Group A (Control):** Authentication screen where "Enter as Guest" is displayed as plain text at the bottom.
- **Group B (Variant):** Authentication screen where "Enter as Guest" is displayed as a full-width outlined secondary button.

We will include 30% of eligible new users in the experiment, split equally between Groups A and B (15% each). This allows us to monitor how guest button visibility affects both immediate map adoption and 7-day retention without impacting most new sign-ups.

**Firebase Analytics Tracking:**

- `auth_screen_viewed` – Tracks when users land on the initial login/sign-up screen (`screen_view`).
- `guest_login_clicked` – Tracks when users tap the "Enter as Guest" option (Anonymous Auth).
- `sign_up_completed` – Tracks when users create a registered account.
- `start_building_navigation` – Tracks when users reach the map and start navigating to a building.

Each event will include a `button_variant` parameter identifying Group A or Group B.

**Primary Success Metric:** Onboarding-to-Map completion rate, measuring the percentage of new users who view the authentication screen and successfully enter the URI map (either as a registered student or as a guest).

We will compare onboarding completion rates and 7-day retention between both groups to see if the outlined button improves overall adoption.

**Variations**

**Variation A – Guest Text Link (Control)**

The authentication screen includes email and password fields, a primary Login/Sign-Up button, and a small plain text "Enter as Guest" link at the bottom.

**Variation B – Guest Outlined Button (Variant)**

The authentication screen has the same fields and primary Login/Sign-Up button, but "Enter as Guest" is styled as a full-width outlined button directly below the primary button.

**Design Work:** Create two versions of the authentication screen in Figma and FlutterFlow. Both versions will use identical colors, text, and input fields. The only difference will be the border and button styling applied to the "Enter as Guest" option in Variation B.

**Expected Outcome**

We expect the outlined "Enter as Guest" button in Group B to reduce drop-off on the initial screen and increase the number of students who reach the URI map and use the Golden Path. If Group B increases adoption without hurting account sign-ups or retention, we will keep the outlined button design.
