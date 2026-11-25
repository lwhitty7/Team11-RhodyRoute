Here is the link to the Heart Framework:  [Team 11 Heart Framework](https://docs.google.com/presentation/d/1bKRPlXHDblmHVr76YB9bcq9W6l-wUO0UTRuKLAv40Ek/edit?usp=sharing).

* Happiness - Collected through a short in-app prompt after a trip. Users rate the app from 1 to 5 and answer “Did this help you get to class on time?” yes/no. Both responses are saved to Firestore and logged as satisfaction_submitted and trip_feedback_submitted events with the search_position parameter. We compare the average rating (target 4.2 or higher) and the percentage of “yes” answers (target 80% or higher) between Groups A and B.

* Engagement - Collected with Firebase Analytics custom events. Searches per session is route_searched divided by session_start, and search bar tap rate is search_bar_tapped divided by map_screen_viewed. Both are compared by search_position. DAU and WAU come from the Firebase Analytics active users reports, filtered by the A/B test’s experiment user property.

* Adoption - We can collect and track data using Google Play Store Analytics
* Retention - Collected automatically via the Firebase Analytics Retention Cohort dashboard (comparing `first_open` cohorts against `session_start` events after Day 7) and explicitly in our Firestore `users` collection. On the URI Map page's On Page Load action flow, we execute a Firestore Update Document call on the Authenticated User's document setting `last_active_at` to `Current Time`. We then compare `last_active_at` against `created_time` to determine the percentage of users active $\ge 7$ days after registration.

* Task Success – Golden Path CTR: Use Firebase Analytics custom events to track when a user views a route and clicks the Start Navigation button. Calculate the percentage of route viewers who click Start Navigation.
