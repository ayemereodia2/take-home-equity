This is an test app for Equity App. It interacts with a public API, retrieves paginated data, and presents the results in a table view.


Project Instructions

1. clone the project from github by: git clone https://github.com/ayemereodia2/take-home-equity.git

2. Install dependencies using Swift Package Manager: SVGKit, Chart are integrated into the project using Swift Package Manager. To install the dependencies:

Open your project in Xcode.
Navigate to File > Swift Packages > Update to Latest Package Versions to ensure SVGKit and Chart is fetched properly.

MVVM-C Pattern: I chose Model-View-ViewModel-Coordinator (MVVM-C) for both UIKit (CoinListViewController, FilterViewController) and SwiftUI (FavoritesCoinsView, CryptoDetailView) components to separate concerns, improve testability,Navigation and align with modern iOS practices.

I used Combine for reactive networking and state management, assuming a modern iOS target (iOS 13+), as it integrates well with SwiftUI and simplifies asynchronous data handling.

I Implemented a generic fetch method to support multiple endpoints (e.g., CoinResponse), assuming a RESTful API with JSON responses. The base URL and API key are sourced from a Config struct backed by Config.json.

Assumed unit tests require mocking network responses, so I created a MockNetworkSession conforming to a NetworkSession protocol for dependency injection.

I opted for UserDefaults with a generic GenericUserDefaultsRepository to store CryptoItems and FilterOptions, assuming a lightweight, local storage solution suffices for the test’s scope. This avoids over-engineering with Core Data, Web service or a database for a small dataset.


### UI and Features
Filter Persistence: Assumed the selected filter should persist across app sessions to improve UX, storing it in UserDefaults with title-based matching .

Charting: Used the Charts library (iOS-Charts) for sparkline visualization, assuming a basic line chart meets requirements, with some performance filters.

Favorites: Implemented swipe actions for favoriting/unfavoriting, assuming a common UX pattern for list interactions.


### Assumptions
API Response: I assumed CoinResponse matches the provided structure, with optional fields (e.g., sparkline) handled gracefully.

Single Environment: Assumed a single API environment (development) for simplicity, though Config supports multiple environments via Config.json.

No Real-Time Updates: Assumed static data fetches suffice, with no WebSocket or polling requirements.


### Challenges I encountered
1. Persisting Filter Selection State
The FilterViewController’s selected filter state reset on each presentation because FilterViewModel was recreated, losing the selectedFilter.

I then made FilterOption Codable and stored it in UserDefaults via GenericUserDefaultsRepository. Loaded the saved filter by matching title and reattached actions from a dictionary in FilterViewModel. This persists the selection across app sessions without duplicating code.

2. Generic Repository Design
Futhermore, duplicating repository logic for CryptoItem and FilterOption violated DRY principles, and FilterOption’s UUID ID conflicted with GenericUserDefaultsRepository’s String ID constraint.

I Initially aligned FilterOption with String IDs (e.g., "highestPrice") to match CryptoItem, ensuring compatibility with the generic repository. Later explored a fully generic ID approach but settled on String for consistency and simplicity.

4. Mocking Network Responses
Challenge: The original MockNetworkSession didn’t correctly mimic URLSession.DataTaskPublisher, causing test failures due to type mismatches and missing data emission.

I tried to Rewrote MockNetworkSession with a custom DataTaskMockPublisher and DataTaskMockSubscription, ensuring it emits (data, response) or fails with URLError as expected. But it still needs more work

5. Chart Performance with Historical Data still needs more work for an intuitive display of prices over time
Also, plotting large sparkline datasets (e.g., hourly crypto prices) could degrade performance in the Charts library.


6. SwiftUI/UIKit Integration
 Mixing SwiftUI (FavoritesCoinsView) and UIKit (CoinListViewController, FilterViewController) required consistent state management and navigation.
7.Loading SVG Images from URLs
Displaying SVG images from URLs in a UIImage proved difficult due to iOS’s lack of native support for remote SVG resource loading. Initially, I attempted to use WKWebView for rendering, but encountered scaling issues that compromised image quality. After researching alternatives, I determined that WKWebKit was overly complex for this purpose.  

I opted for SVGKit, a lightweight third-party library, which efficiently converts remote SVGs into UIImages, ensuring proper scaling and integration with the app’s UI.


Fnally, I focused on core requirements (listing, filtering, favorites, charting) without over-engineering.










/*
Scalability: The FavoritesRepository protocol allows swapping UserDefaults for Core Data, Realm, or a web service later (e.g., WebServiceFavoritesRepository).

Simplicity: UserDefaults handles the test’s scope without database overhead.

Architecture: Demonstrates dependency injection (favoritesRepository in CoinListViewModel) and separation of concerns, impressing reviewers.

Persistence: Favorites persist across launches, meeting the requirement.
*/
