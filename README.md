# Household Expense Tracker

## Task Overview

You are working on a shared household expense tracking app where multiple users within a household collaboratively log and view expenses in real time. The app uses Firebase Authentication for login and Firestore as the data layer, organized with a `households` root collection where each household owns an `expenses` subcollection. The current codebase has two categories of architectural problems: auth state is managed without any context or custom hook abstraction, causing screens to render before auth resolves; and the Firestore read and write operations target incorrect collection paths, meaning no expense data is ever loaded or saved correctly. Your job is to identify these issues, redesign the relevant data and auth layers with production-quality patterns, and verify the results both in the app and in the Firebase Emulator UI.

## Firebase Emulator Access

- **Firestore Emulator:** `http://<DROPLET_IP>:8080`
- **Auth Emulator:** `http://<DROPLET_IP>:9099`
- **Emulator UI:** `http://<DROPLET_IP>:4000`
- The app is already configured to connect to the emulators — you do not need to change `src/config/firebase.js` except to confirm the droplet IP is set.


## Objectives

- Implement a `useAuth` custom hook that encapsulates Firebase auth state and exposes a consistent `{ user, loading }` interface to the rest of the app.
- Create an `AuthContext` provider that makes auth state available app-wide and drives conditional navigation so unauthenticated users cannot access protected screens.
- Fix the Firestore read path in `HouseholdDashboard` to target the correct subcollection and switch to a real-time listener that updates the UI as data changes, showing only unsettled expenses.
- Fix the Firestore write path in `AddExpense` to target the correct subcollection and perform an atomic operation that both creates the expense document and updates a count field on the parent household document.
- Ensure listener cleanup is handled correctly to prevent memory leaks during screen unmounts and navigation transitions.

## Helpful Tips

- Consider how auth state flows through the app and where a single source of truth for the current user should live.
- Think about what happens between the moment the app launches and the moment Firebase resolves the auth state — what should the UI show?
- Explore the Firestore Emulator UI at port 4000 to understand the actual data structure before writing any queries.
- Review the difference between a one-time Firestore fetch and a real-time listener, and think about when each is appropriate and how listeners should be cleaned up.
- Consider what it means for two Firestore writes to be atomic and when that guarantee matters in a collaborative app.

## How to Verify

- After login, the dashboard should populate immediately with unsettled expenses for the logged-in user's household — confirm the data exists in the correct subcollection in the Emulator UI at port 4000.
- Add a new expense and confirm it appears on the dashboard in real time without a manual refresh, and verify the document exists under `households/{householdId}/expenses` in the Emulator UI.
- Confirm the parent household document's `expenseCount` field increments correctly each time an expense is added — this should be visible in the Emulator UI.
- Refresh or background the app and confirm auth state is preserved correctly without a flash of the login screen or a race condition rendering the dashboard with a null user.
- Check that navigating between screens does not accumulate dangling Firestore listeners — the app should not make redundant reads after the dashboard is revisited.
