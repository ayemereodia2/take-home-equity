
```markdown
# Equity App - Test App

This is an app for Equity. It interacts with a public API, retrieves paginated data, and presents the results in a filterable and searchable table view.

## Project Instructions

1. **Clone the project from GitHub:**
   ```bash
   git clone https://github.com/ayemereodia2/take-home-equity.git
   ```

2. **Install dependencies using Swift Package Manager:**
   SVGKit and Chart are integrated into the project using Swift Package Manager. To install the dependencies:
   - Open your project in Xcode.
   - Navigate to `File > Swift Packages > Update to Latest Package Versions` to ensure SVGKit and Chart are fetched properly.

## MVVM-C Pattern

I used **Model-View-ViewModel-Coordinator (MVVM-C) pattern** for both UIKit (`CoinListViewController`, `FilterViewController`) and SwiftUI (`FavoritesCoinsView`, `CryptoDetailView`) components to separate concerns, improve testability, and align with modern iOS practices.

- I used **Combine** for reactive networking and state management 
- Implemented a **generic fetch method** to support multiple endpoints (e.g., `CoinResponse`), assuming a RESTful API with JSON responses.
- **Mocking network responses** with `MockNetworkSession` conforming to a `NetworkSession` protocol for dependency injection.
- Used **UserDefaults** with a `GenericUserDefaultsRepository` to store `CryptoItems` and `FilterOptions` (lightweight local storage).

## UI and Features

- **Filter Persistence**: The selected filter persists across app sessions by storing it in **UserDefaults** with title-based matching.
- **Charting**: Used the **Charts** library (iOS-Charts) for sparkline visualization, assuming a basic line chart meets requirements.
- **Favorites**: Implemented swipe actions for favoriting/unfavoriting, a common UX pattern for list interactions.

## Internationalization
- Added a localized file to handle strings and support internationalization (i18n). This allows the app to be easily adapted for multiple languages, improving accessibility and usability for users in different region

## Assumptions

- **API Response**: I assumed `CoinResponse` matches the provided structure, with optional fields (e.g., `sparkline`) handled gracefully.
- **Single Environment**: Assumed a single API environment (development) for simplicity, though `Config` supports multiple environments via `Config.json`.
- **No Real-Time Updates**: Assumed static data fetches suffice with no WebSocket or polling requirements.
- **Concurrent Update of Favorites: I assumed possible concurrent updates of the favorites UserDefault storage, so I used Thread-safe access by relying on Concurrent DispatchQueues for data safety and consistency.

## Challenges Encountered

1. **Persisting Filter Selection State**  
   The `FilterViewController`’s selected filter state reset on each presentation because `FilterViewModel` was recreated, losing the selected filter.  
   - I made `FilterOption` **Codable** and stored it in **UserDefaults** via `GenericUserDefaultsRepository`. The saved filter is loaded by matching the title and reattached actions from a dictionary in `FilterViewModel`.

2. **Generic Repository Design**  
   Duplicating repository logic for `CryptoItem` and `FilterOption` violated DRY principles, and `FilterOption`'s UUID ID conflicted with `GenericUserDefaultsRepository`'s String ID constraint.  
   - I initially aligned `FilterOption` with String IDs (e.g., "highestPrice") to match `CryptoItem`, ensuring compatibility with the generic repository.

3. **Mocking Network Responses**  
   The original `MockNetworkSession` didn’t correctly mimic `URLSession.DataTaskPublisher`, causing test failures due to type mismatches and missing data emission.  
   - I rewrote `MockNetworkSession` with a custom `DataTaskMockPublisher` and `DataTaskMockSubscription`, ensuring it emits `(data, response)` or fails with `URLError`.

4. **Chart Performance with Historical Data**  
   Plotting large sparkline datasets (e.g., hourly crypto prices) could degrade performance in the **Charts** library.

5. **SwiftUI/UIKit Integration**  
   Mixing SwiftUI (`FavoritesCoinsView`) and UIKit (`CoinListViewController`, `FilterViewController`) required consistent state management and navigation.

6. **Loading SVG Images from URLs**  
   Initially, I tried using `WKWebView` for rendering SVG images from URLs but encountered scaling issues.  
   - I opted for **SVGKit**, a lightweight third-party library that efficiently converts remote SVGs into UIImages, ensuring proper scaling and integration with the app's UI.

7. **Implementing Performance Filters**  
   Filters like `absoluteChange`, `percentageChange`, `highestPrice`, and `lowestPrice` returned single values sometimes, causing chart issues.  
   -  I ensured filters like `absoluteChange` and `percentageChange` returned multiple values, preventing the graph from disappearing. Filters like `Highest Price` and `Lowest Price` now return a horizontal line (all points at the max or min price).

## Scalability and Simplicity

- **Scalability**: The `FavoritesRepository` protocol allows for future swapping of `UserDefaults` with **Core Data**, **Realm**, or a web service (e.g., `WebServiceFavoritesRepository`).
- **Simplicity**: **UserDefaults** handles the test’s scope without database overhead.
- **Architecture**: Demonstrates dependency injection (`favoritesRepository` in `CoinListViewModel`) and separation of concerns, impressing reviewers.
- **Persistence**: Favorites persist across launches, meeting the requirement.
```
