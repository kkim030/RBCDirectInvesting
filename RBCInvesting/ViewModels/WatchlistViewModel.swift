import Foundation

@MainActor
class WatchlistViewModel: ObservableObject {
    @Published var watchlists: [WatchlistResponse] = []
    @Published var quotes: [String: Quote] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadWatchlists() async {
        isLoading = true
        do {
            watchlists = try await APIService.shared.get("/watchlists")
            await loadQuotes()
        } catch {
            // Offline fallback
            watchlists = Self.mockWatchlists
            quotes = Self.mockQuotes
        }
        isLoading = false
    }

    // MARK: - Offline Mock Data
    private static let mockWatchlists: [WatchlistResponse] = [
        WatchlistResponse(id: UUID(), name: "My Watchlist", items: [
            WatchlistItemResponse(id: UUID(), symbol: "AAPL", exchange: "NASDAQ"),
            WatchlistItemResponse(id: UUID(), symbol: "SHOP", exchange: "TSX"),
            WatchlistItemResponse(id: UUID(), symbol: "XEQT", exchange: "TSX"),
            WatchlistItemResponse(id: UUID(), symbol: "ENB", exchange: "TSX"),
        ])
    ]

    private static let mockQuotes: [String: Quote] = [
        "AAPL": Quote(symbol: "AAPL", currentPrice: 196.02, change: 0.82, changePercent: 0.42,
                      high: 197.10, low: 194.50, open: 195.20, previousClose: 195.20, volume: 54_000_000, timestamp: nil),
        "SHOP": Quote(symbol: "SHOP", currentPrice: 105.40, change: -1.20, changePercent: -1.13,
                      high: 107.50, low: 104.80, open: 106.60, previousClose: 106.60, volume: 3_200_000, timestamp: nil),
        "XEQT": Quote(symbol: "XEQT", currentPrice: 40.45, change: 0.05, changePercent: 0.12,
                       high: 40.55, low: 40.30, open: 40.40, previousClose: 40.40, volume: 1_800_000, timestamp: nil),
        "ENB": Quote(symbol: "ENB", currentPrice: 54.10, change: 0.35, changePercent: 0.65,
                     high: 54.30, low: 53.60, open: 53.75, previousClose: 53.75, volume: 5_600_000, timestamp: nil),
    ]

    func loadQuotes() async {
        let symbols = Set(watchlists.flatMap { $0.items?.map(\.symbol) ?? [] })
        for symbol in symbols {
            do {
                let q: Quote = try await APIService.shared.get("/quotes/\(symbol)")
                quotes[symbol] = q
            } catch {}
        }
    }

    func createWatchlist(name: String) async {
        do {
            let _: WatchlistResponse = try await APIService.shared.post("/watchlists",
                body: ["name": name])
            await loadWatchlists()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addItem(watchlistId: UUID, symbol: String, exchange: String = "TSX") async {
        do {
            let body = ["symbol": symbol, "exchange": exchange]
            let _: WatchlistItemResponse = try await APIService.shared.post("/watchlists/\(watchlistId)/items", body: body)
            await loadWatchlists()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func removeItem(watchlistId: UUID, itemId: UUID) async {
        do {
            try await APIService.shared.delete("/watchlists/\(watchlistId)/items/\(itemId)")
            await loadWatchlists()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteWatchlist(_ id: UUID) async {
        do {
            try await APIService.shared.delete("/watchlists/\(id)")
            await loadWatchlists()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
