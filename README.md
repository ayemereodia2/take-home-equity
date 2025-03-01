This is an test app for Equity App. It interacts with a public API, retrieves paginated data, and presents the results in a table view.


Project Instructions

1. clone the project from github by: git clone https://github.com/ayemereodia2/take-home-equity.git

2. Install dependencies using Swift Package Manager: SVGKit is integrated into the project using Swift Package Manager. To install the dependencies:

Open your project in Xcode.
Navigate to File > Swift Packages > Update to Latest Package Versions to ensure SVGKit is fetched properly.

/*
Scalability: The FavoritesRepository protocol allows swapping UserDefaults for Core Data, Realm, or a web service later (e.g., WebServiceFavoritesRepository).

Simplicity: UserDefaults handles the test’s scope without database overhead.

Architecture: Demonstrates dependency injection (favoritesRepository in CoinListViewModel) and separation of concerns, impressing reviewers.

Persistence: Favorites persist across launches, meeting the requirement.
*/
