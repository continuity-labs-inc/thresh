import SwiftUI
import StoreKit

struct PaywallScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var subscriptionService = SubscriptionService.shared
    @State private var selectedTier: SubscriptionTier = .plus
    @State private var isYearly = true
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""

    /// Control Founder availability - flip to false when 500 sold
    /// TODO: Replace with Firebase Remote Config for instant control
    private var founderAvailable: Bool {
        true // Set to false or use RemoteConfig.remoteConfig().configValue(forKey: "founder_available").boolValue
    }

    /// Founder product from StoreKit
    private var founderProduct: Product? {
        subscriptionService.products.first { $0.id == SubscriptionProduct.founderLifetime.rawValue }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection

                    // Founder Card (prominent, at top) - only show if available
                    if founderAvailable {
                        founderCard

                        // Divider with "or subscribe" text
                        orSubscribeDivider
                    }

                    // Tier Toggle
                    tierToggle

                    // Billing Toggle
                    billingToggle

                    // Feature Comparison
                    featureComparison

                    // Subscribe Button
                    subscribeButton

                    // Restore Purchases
                    restoreButton

                    // Legal Text
                    legalText
                }
                .padding()
            }
            .background(Color.thresh.background)
            .navigationTitle("Upgrade Thresh")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    // MARK: - Founder Card
    private var founderCard: some View {
        Button {
            Task {
                await purchaseFounder()
            }
        } label: {
            VStack(spacing: 12) {
                // Scarcity Badge
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                    Text("FIRST 500 ONLY")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(0.5)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.orange, Color.red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )

                // Title
                Text("Founder's Edition")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.thresh.textPrimary)

                // Price
                HStack(spacing: 4) {
                    if let product = founderProduct {
                        Text(product.displayPrice)
                            .font(.title3)
                            .fontWeight(.semibold)
                    } else {
                        Text("$79.99")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    Text("one-time")
                        .font(.subheadline)
                        .foregroundStyle(Color.thresh.textSecondary)
                }
                .foregroundStyle(Color.thresh.textPrimary)

                // Features
                VStack(alignment: .leading, spacing: 6) {
                    founderFeature("All Pro features forever")
                    founderFeature("No recurring payments")
                    founderFeature("Lifetime updates included")
                    founderFeature("Support independent development")
                }
                .padding(.top, 4)

                // CTA
                HStack {
                    if isPurchasing {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Become a Founder")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color.orange, Color.thresh.synthesis],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top, 8)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.thresh.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [Color.orange.opacity(0.6), Color.thresh.synthesis.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(isPurchasing || subscriptionService.isLoading)
    }

    private func founderFeature(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14))
                .foregroundStyle(.green)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textPrimary)
        }
    }

    // MARK: - Or Subscribe Divider
    private var orSubscribeDivider: some View {
        HStack {
            Rectangle()
                .fill(Color.thresh.textSecondary.opacity(0.3))
                .frame(height: 1)
            Text("or subscribe")
                .font(.caption)
                .foregroundStyle(Color.thresh.textSecondary)
                .padding(.horizontal, 12)
            Rectangle()
                .fill(Color.thresh.textSecondary.opacity(0.3))
                .frame(height: 1)
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.thresh.capture, Color.thresh.synthesis],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Unlock Your Full Potential")
                .font(.title2)
                .fontWeight(.bold)

            Text("Get more from your reflections with AI-powered insights")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }

    // MARK: - Tier Toggle
    private var tierToggle: some View {
        HStack(spacing: 0) {
            tierButton(for: .plus)
            tierButton(for: .pro)
        }
        .background(Color.thresh.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func tierButton(for tier: SubscriptionTier) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTier = tier
            }
        } label: {
            VStack(spacing: 4) {
                Text(tier.displayName)
                    .font(.headline)
                Text(priceText(for: tier))
                    .font(.caption)
                    .foregroundStyle(Color.thresh.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(selectedTier == tier ? tierColor(for: tier).opacity(0.2) : Color.clear)
            .foregroundStyle(selectedTier == tier ? tierColor(for: tier) : Color.thresh.textPrimary)
        }
        .buttonStyle(.plain)
    }

    private func tierColor(for tier: SubscriptionTier) -> Color {
        switch tier {
        case .free: return Color.thresh.textSecondary
        case .plus: return Color.thresh.capture
        case .pro: return Color.thresh.synthesis
        case .founder: return Color.orange
        }
    }

    private func priceText(for tier: SubscriptionTier) -> String {
        // Founder is handled separately in founderCard
        guard tier == .plus || tier == .pro else {
            return tier == .free ? "Free" : ""
        }

        let product: SubscriptionProduct = tier == .plus
            ? (isYearly ? .plusYearly : .plusMonthly)
            : (isYearly ? .proYearly : .proMonthly)

        if let storeProduct = subscriptionService.product(for: product) {
            return storeProduct.displayPrice + (isYearly ? "/year" : "/mo")
        }

        // Fallback prices
        switch tier {
        case .free: return "Free"
        case .plus: return isYearly ? "$29.99/year" : "$2.99/mo"
        case .pro: return isYearly ? "$49.99/year" : "$4.99/mo"
        case .founder: return "$79.99"
        }
    }

    // MARK: - Billing Toggle
    private var billingToggle: some View {
        HStack {
            Text("Monthly")
                .foregroundStyle(isYearly ? Color.thresh.textSecondary : Color.thresh.textPrimary)

            Toggle("", isOn: $isYearly)
                .labelsHidden()
                .tint(tierColor(for: selectedTier))

            Text("Yearly")
                .foregroundStyle(isYearly ? Color.thresh.textPrimary : Color.thresh.textSecondary)

            if isYearly {
                Text("Save 17%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .foregroundStyle(.green)
                    .clipShape(Capsule())
            }
        }
        .font(.subheadline)
    }

    // MARK: - Feature Comparison
    private var featureComparison: some View {
        VStack(spacing: 16) {
            Text("What's Included")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                featureRow("AI Extractions", free: "3/month", plus: "Unlimited", pro: "Unlimited")
                featureRow("Stories, Ideas, Questions", free: "Unlimited", plus: "Unlimited", pro: "Unlimited")
                featureRow("Marinating/Holding", free: true, plus: true, pro: true)
                featureRow("JSON Export", free: false, plus: true, pro: true)
                featureRow("PDF Export", free: false, plus: false, pro: true)
                featureRow("AI Connections", free: false, plus: false, pro: true)
                featureRow("Observation Gap Analysis", free: false, plus: false, pro: true)
            }
        }
        .padding()
        .background(Color.thresh.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func featureRow(_ feature: String, free: Any, plus: Any, pro: Any) -> some View {
        HStack {
            Text(feature)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                if selectedTier == .plus {
                    featureValue(plus)
                } else {
                    featureValue(pro)
                }
            }
            .frame(width: 80)
        }
    }

    @ViewBuilder
    private func featureValue(_ value: Any) -> some View {
        if let boolValue = value as? Bool {
            Image(systemName: boolValue ? "checkmark.circle.fill" : "xmark.circle")
                .foregroundStyle(boolValue ? .green : Color.thresh.textSecondary.opacity(0.5))
        } else if let stringValue = value as? String {
            Text(stringValue)
                .font(.caption)
                .foregroundStyle(Color.thresh.textSecondary)
        }
    }

    // MARK: - Subscribe Button
    private var subscribeButton: some View {
        Button {
            Task {
                await purchase()
            }
        } label: {
            HStack {
                if isPurchasing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Subscribe to \(selectedTier.displayName)")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(tierColor(for: selectedTier))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(isPurchasing || subscriptionService.isLoading)
    }

    // MARK: - Restore Button
    private var restoreButton: some View {
        Button {
            Task {
                await subscriptionService.restorePurchases()
                if subscriptionService.currentTier != .free {
                    dismiss()
                }
            }
        } label: {
            Text("Restore Purchases")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)
        }
    }

    // MARK: - Legal Text
    private var legalText: some View {
        Text("Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current period. Manage subscriptions in Settings.")
            .font(.caption2)
            .foregroundStyle(Color.thresh.textSecondary)
            .multilineTextAlignment(.center)
    }

    // MARK: - Purchase Action
    private func purchase() async {
        let product: SubscriptionProduct = selectedTier == .plus
            ? (isYearly ? .plusYearly : .plusMonthly)
            : (isYearly ? .proYearly : .proMonthly)

        guard let storeProduct = subscriptionService.product(for: product) else {
            errorMessage = "Product not available. Please try again later."
            showError = true
            return
        }

        isPurchasing = true

        do {
            if let _ = try await subscriptionService.purchase(storeProduct) {
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

        isPurchasing = false
    }

    // MARK: - Purchase Founder Action
    private func purchaseFounder() async {
        guard let storeProduct = founderProduct else {
            errorMessage = "Founder's Edition not available. Please try again later."
            showError = true
            return
        }

        isPurchasing = true

        do {
            if let _ = try await subscriptionService.purchase(storeProduct) {
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

        isPurchasing = false
    }
}

// MARK: - Preview
#Preview {
    PaywallScreen()
}
