import Foundation
import StoreKit

// MARK: - Subscription Tier
enum SubscriptionTier: String, Codable {
    case free = "free"
    case plus = "plus"
    case pro = "pro"
    case founder = "founder"

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .plus: return "Plus"
        case .pro: return "Pro"
        case .founder: return "Founder"
        }
    }

    var monthlyExtractionLimit: Int? {
        switch self {
        case .free: return 3
        case .plus, .pro, .founder: return nil // Unlimited
        }
    }

    /// Whether this tier includes Pro-level features (connections, PDF export, observation gaps)
    var hasProFeatures: Bool {
        self == .pro || self == .founder
    }
}

// MARK: - Product IDs
enum SubscriptionProduct: String, CaseIterable {
    case plusMonthly = "com.continuitylabs.thresh.plus.monthly"
    case plusYearly = "com.continuitylabs.thresh.plus.yearly"
    case proMonthly = "com.continuitylabs.thresh.pro.monthly"
    case proYearly = "com.continuitylabs.thresh.pro.yearly"
    case founderLifetime = "com.continuitylabs.thresh.founder.lifetime"

    var tier: SubscriptionTier {
        switch self {
        case .plusMonthly, .plusYearly: return .plus
        case .proMonthly, .proYearly: return .pro
        case .founderLifetime: return .founder
        }
    }

    var isYearly: Bool {
        switch self {
        case .plusYearly, .proYearly: return true
        case .plusMonthly, .proMonthly, .founderLifetime: return false
        }
    }

    /// Whether this is a recurring subscription (vs one-time purchase)
    var isSubscription: Bool {
        self != .founderLifetime
    }
}

// MARK: - Subscription Service
@MainActor
@Observable
final class SubscriptionService {
    static let shared = SubscriptionService()

    // MARK: - Debug Pro Mode Toggle (persisted)
    @ObservationIgnored
    private let debugProModeKey = "debug_pro_mode_enabled"

    /// Simple Pro mode toggle for development/testing - persisted across launches
    var debugProModeEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: debugProModeKey) }
        set { UserDefaults.standard.set(newValue, forKey: debugProModeKey) }
    }

    /// Toggle debug Pro mode on/off
    func toggleDebugProMode() {
        debugProModeEnabled.toggle()
        print("🔧 Debug Pro Mode: \(debugProModeEnabled ? "ENABLED" : "DISABLED")")
    }

    // MARK: - Published State
    private(set) var _actualTier: SubscriptionTier = .free

    var currentTier: SubscriptionTier {
        // Debug Pro mode overrides actual subscription status
        if debugProModeEnabled {
            return .pro
        }
        return _actualTier
    }

    private(set) var products: [Product] = []
    private(set) var purchasedProductIDs: Set<String> = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Extraction Tracking (stored in UserDefaults)
    @ObservationIgnored
    private let extractionsKey = "extractionsThisMonth"
    @ObservationIgnored
    private let resetDateKey = "extractionResetDate"

    var extractionsThisMonth: Int {
        get { UserDefaults.standard.integer(forKey: extractionsKey) }
        set { UserDefaults.standard.set(newValue, forKey: extractionsKey) }
    }

    var extractionResetDate: Date? {
        get { UserDefaults.standard.object(forKey: resetDateKey) as? Date }
        set { UserDefaults.standard.set(newValue, forKey: resetDateKey) }
    }

    var remainingExtractions: Int? {
        guard let limit = currentTier.monthlyExtractionLimit else { return nil }
        return max(0, limit - extractionsThisMonth)
    }

    var canExtract: Bool {
        guard let remaining = remainingExtractions else { return true }
        return remaining > 0
    }

    // MARK: - Transaction Updates Task
    private var updateListenerTask: Task<Void, Error>?

    // MARK: - Initialization
    private init() {
        checkAndResetMonthlyCounter()
        updateListenerTask = listenForTransactions()
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }

    nonisolated func cancelUpdateListener() {
        Task { @MainActor in
            updateListenerTask?.cancel()
        }
    }

    // MARK: - Monthly Reset Logic
    func checkAndResetMonthlyCounter() {
        let calendar = Calendar.current
        let now = Date()

        if let resetDate = extractionResetDate {
            // Check if we're in a new month
            if !calendar.isDate(resetDate, equalTo: now, toGranularity: .month) {
                print("📅 New month detected, resetting extraction counter")
                extractionsThisMonth = 0
                extractionResetDate = now
            }
        } else {
            // First time - set the reset date
            extractionResetDate = now
        }
    }

    // MARK: - Record Extraction
    func recordExtraction() {
        guard currentTier == .free else { return }
        extractionsThisMonth += 1
        print("📊 Extraction recorded: \(extractionsThisMonth)/\(currentTier.monthlyExtractionLimit ?? 0)")
    }

    // MARK: - Load Products
    func loadProducts() async {
        isLoading = true
        errorMessage = nil

        let productIDs = SubscriptionProduct.allCases.map { $0.rawValue }
        print("🛒 Loading products: \(productIDs)")

        do {
            products = try await Product.products(for: productIDs)
            print("✅ Loaded \(products.count) products")
            for product in products {
                print("   - \(product.id): \(product.displayName) - \(product.displayPrice)")
            }
        } catch {
            print("❌ Failed to load products: \(error)")
            errorMessage = "Failed to load subscription options: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // MARK: - Purchase
    func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
        print("💳 Attempting purchase: \(product.id)")
        errorMessage = nil

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updatePurchasedProducts()
                await transaction.finish()
                print("✅ Purchase successful: \(product.id)")
                return transaction

            case .userCancelled:
                print("⚠️ User cancelled purchase")
                return nil

            case .pending:
                print("⏳ Purchase pending")
                errorMessage = "Purchase is pending approval"
                return nil

            @unknown default:
                print("❓ Unknown purchase result")
                return nil
            }
        } catch {
            // Check for specific StoreKit error types
            let errorString = String(describing: error)

            if errorString.contains("userCancelled") {
                print("⚠️ User cancelled purchase")
                return nil
            } else if errorString.contains("networkError") {
                print("❌ Network error during purchase")
                errorMessage = "Network error. Please check your connection and try again."
            } else if errorString.contains("notAvailable") || errorString.contains("notEntitled") {
                print("❌ In-App Purchases not available")
                errorMessage = "In-App Purchases are not available on this device"
            } else {
                print("❌ Purchase failed: \(error)")
                errorMessage = "Purchase failed: \(error.localizedDescription)"
            }
            throw error
        }
    }

    // MARK: - Restore Purchases
    func restorePurchases() async {
        print("🔄 Restoring purchases...")
        isLoading = true

        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
            print("✅ Purchases restored")
        } catch {
            print("❌ Failed to restore purchases: \(error)")
            errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // MARK: - Update Purchased Products
    func updatePurchasedProducts() async {
        var purchased: Set<String> = []
        var highestTier: SubscriptionTier = .free

        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)

                if transaction.revocationDate == nil {
                    purchased.insert(transaction.productID)

                    // Determine tier from product ID
                    if let product = SubscriptionProduct(rawValue: transaction.productID) {
                        // Founder trumps everything - lifetime purchase
                        if product.tier == .founder {
                            highestTier = .founder
                        } else if product.tier == .pro && highestTier != .founder {
                            highestTier = .pro
                        } else if product.tier == .plus && highestTier != .pro && highestTier != .founder {
                            highestTier = .plus
                        }
                    }
                }
            } catch {
                print("⚠️ Failed to verify transaction: \(error)")
            }
        }

        purchasedProductIDs = purchased
        _actualTier = highestTier
        print("📱 Current tier: \(currentTier.displayName), purchased: \(purchased)")
    }

    // MARK: - Listen for Transactions
    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self = self else { return }
                do {
                    let transaction = try await self.checkVerifiedAsync(result)
                    await self.updatePurchasedProducts()
                    await transaction.finish()
                } catch {
                    print("⚠️ Transaction update failed verification: \(error)")
                }
            }
        }
    }

    // Non-isolated version of checkVerified for background tasks
    private nonisolated func checkVerifiedAsync<T>(_ result: VerificationResult<T>) async throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    // MARK: - Verify Transaction
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    // MARK: - Helper Methods
    func product(for subscriptionProduct: SubscriptionProduct) -> Product? {
        products.first { $0.id == subscriptionProduct.rawValue }
    }

    func plusProducts() -> [Product] {
        products.filter {
            $0.id == SubscriptionProduct.plusMonthly.rawValue ||
            $0.id == SubscriptionProduct.plusYearly.rawValue
        }
    }

    func proProducts() -> [Product] {
        products.filter {
            $0.id == SubscriptionProduct.proMonthly.rawValue ||
            $0.id == SubscriptionProduct.proYearly.rawValue
        }
    }
}

// MARK: - Store Error
enum StoreError: Error {
    case failedVerification
    case productNotFound
    case purchaseFailed
}

extension StoreError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "Transaction verification failed"
        case .productNotFound:
            return "Product not found"
        case .purchaseFailed:
            return "Purchase failed"
        }
    }
}
