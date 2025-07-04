# flutter_excercise

A base Flutter project used for pairing scenarios

## Getting Started

This repo contains a take home exercise. Below is the scenario that was used to generate the attached Flutter application. Please do the following:

1) Review the scenario and note the requirements
2) Get the project running on your local machine (use whichever IDE you prefer).
   - Navigate to the root directory of the project
   - In the terminal execute "flutter pub get"
   - Ensure you have your Android Emulator or iOS Simulator running
   - In the terminal execute "flutter run"
   - Ensure the application you're running matches the scenario described below - If it doesn't you may be running a Flutter demo application and not the supplied project.
3) Be prepared during the interview to discuss how you would develop both manual and automated testing processes for this project.

## Scenario

The application fetches search results from an API and renders a list of assets.
The asset list is shown with description, image, location, event name and formatted event start date.
Location data is formatted city, state, country inside the USA and city, country outside the USA.
The asset list is paginated so the user can see more results as they scroll.
When tapped an asset renders an item details screen.