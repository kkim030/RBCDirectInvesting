import Foundation

@MainActor
class PortfolioViewModel: ObservableObject {
    @Published var portfolio: PortfolioOverview?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadPortfolio() async {
        isLoading = true
        do {
            portfolio = try await APIService.shared.get("/accounts/portfolio")
        } catch {
            // Offline fallback with mock data
            portfolio = Self.mockPortfolio
        }
        isLoading = false
    }

    // MARK: - Offline Mock Data
    private static let tfsaId = UUID(uuidString: "00000000-0000-0000-0000-000000000010")!
    private static let rrspId = UUID(uuidString: "00000000-0000-0000-0000-000000000011")!
    private static let fhsaId = UUID(uuidString: "00000000-0000-0000-0000-000000000012")!

    static let mockPortfolio = PortfolioOverview(
        totalValue: 124541.83,
        totalCashBalance: 3200.00,
        totalHoldingsValue: 121341.83,
        totalGainLoss: 8157.19,
        totalGainLossPercent: 7.20,
        dayChange: 157.19,
        dayChangePercent: 0.20,
        accounts: [
            AccountSummary(id: tfsaId, accountNumber: "420-12345-1", accountType: .TFSA,
                           currency: "CAD", cashBalance: 1200, holdingsValue: 42300.20,
                           totalValue: 43500.20, totalGainLoss: 1407.20, totalGainLossPercent: 4.75),
            AccountSummary(id: rrspId, accountNumber: "420-12345-2", accountType: .RRSP,
                           currency: "CAD", cashBalance: 1000, holdingsValue: 28260,
                           totalValue: 29260.00, totalGainLoss: 1628.50, totalGainLossPercent: 8.43),
            AccountSummary(id: fhsaId, accountNumber: "420-12345-3", accountType: .FHSA,
                           currency: "CAD", cashBalance: 1000, holdingsValue: 50781.63,
                           totalValue: 51781.63, totalGainLoss: 5121.49, totalGainLossPercent: 6.15),
        ],
        holdings: mockHoldings
    )

    private static let mockHoldings: [Holding] = {
        func h(_ sym: String, _ ex: String, _ qty: Double, _ avg: Double, _ cur: Double, _ acc: UUID) -> Holding {
            Holding(id: UUID(), accountId: acc, symbol: sym, exchange: ex,
                    quantity: qty, avgCost: avg, bookValue: qty * avg, currency: "CAD",
                    currentPrice: cur, marketValue: qty * cur,
                    gainLoss: qty * (cur - avg), gainLossPercent: ((cur - avg) / avg) * 100,
                    dayChange: Double.random(in: -1.5...2.0), dayChangePercent: Double.random(in: -0.8...1.2))
        }
        return [
            // TFSA
            h("NVDA", "NASDAQ", 35, 105, 135.50, tfsaId),
            h("RY", "TSX", 80, 130, 142.30, tfsaId),
            h("MSFT", "NASDAQ", 20, 310, 415.20, tfsaId),
            h("ENB", "TSX", 150, 48, 54.10, tfsaId),
            // RRSP
            h("TD", "TSX", 100, 78, 85.30, rrspId),
            h("BMO", "TSX", 60, 110, 125.40, rrspId),
            h("CNR", "TSX", 40, 145, 162.50, rrspId),
            h("SU", "TSX", 90, 42, 48.75, rrspId),
            // FHSA
            h("GOOGL", "NASDAQ", 25, 120, 175.60, fhsaId),
            h("BNS", "TSX", 100, 62, 68.20, fhsaId),
            h("AAPL", "NASDAQ", 30, 155, 196.02, fhsaId),
            h("CP", "TSX", 50, 90, 102.80, fhsaId),
            h("BCE", "TSX", 120, 45, 49.15, fhsaId),
            h("AMZN", "NASDAQ", 15, 130, 186.50, fhsaId),
            h("T", "TSX", 200, 22, 24.80, fhsaId),
            h("SHOP", "TSX", 20, 75, 105.40, fhsaId),
        ]
    }()
}
