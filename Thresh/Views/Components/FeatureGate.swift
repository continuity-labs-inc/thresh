import SwiftUI

// MARK: - Feature Gate
/// A view modifier that gates features behind subscription tiers
struct FeatureGate<Content: View>: View {
    let requiredTier: SubscriptionTier
    let content: Content
    let lockedContent: AnyView?

    @State private var subscriptionService = SubscriptionService.shared
    @State private var showPaywall = false

    init(
        requiredTier: SubscriptionTier,
        @ViewBuilder content: () -> Content,
        @ViewBuilder lockedContent: () -> some View = { EmptyView() }
    ) {
        self.requiredTier = requiredTier
        self.content = content()
        self.lockedContent = AnyView(lockedContent())
    }

    private var isUnlocked: Bool {
        switch requiredTier {
        case .free:
            return true
        case .plus:
            return subscriptionService.currentTier == .plus || subscriptionService.currentTier == .pro
        case .pro:
            return subscriptionService.currentTier == .pro
        }
    }

    var body: some View {
        if isUnlocked {
            content
        } else if let lockedContent = lockedContent {
            lockedContent
        } else {
            defaultLockedView
        }
    }

    private var defaultLockedView: some View {
        Button {
            showPaywall = true
        } label: {
            HStack {
                Image(systemName: "lock.fill")
                Text("\(requiredTier.displayName) Feature")
            }
            .font(.subheadline)
            .foregroundStyle(Color.thresh.textSecondary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.thresh.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .sheet(isPresented: $showPaywall) {
            PaywallScreen()
        }
    }
}

// MARK: - Feature Gate Button
/// A button that shows a paywall when tapped if the feature is locked
struct FeatureGateButton<Label: View>: View {
    let requiredTier: SubscriptionTier
    let action: () -> Void
    let label: Label

    @State private var subscriptionService = SubscriptionService.shared
    @State private var showPaywall = false

    init(
        requiredTier: SubscriptionTier,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.requiredTier = requiredTier
        self.action = action
        self.label = label()
    }

    private var isUnlocked: Bool {
        switch requiredTier {
        case .free:
            return true
        case .plus:
            return subscriptionService.currentTier == .plus || subscriptionService.currentTier == .pro
        case .pro:
            return subscriptionService.currentTier == .pro
        }
    }

    var body: some View {
        Button {
            if isUnlocked {
                action()
            } else {
                showPaywall = true
            }
        } label: {
            HStack {
                label
                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundStyle(Color.thresh.textSecondary)
                }
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallScreen()
        }
    }
}

// MARK: - Extraction Gate
/// Special gate for AI extractions with usage tracking
struct ExtractionGate<Content: View, LockedContent: View>: View {
    let content: Content
    let lockedContent: LockedContent

    @State private var subscriptionService = SubscriptionService.shared
    @State private var showPaywall = false

    init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder lockedContent: () -> LockedContent
    ) {
        self.content = content()
        self.lockedContent = lockedContent()
    }

    var body: some View {
        if subscriptionService.canExtract {
            content
        } else {
            VStack(spacing: 16) {
                lockedContent

                Button {
                    showPaywall = true
                } label: {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Upgrade for Unlimited Extractions")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.thresh.synthesis)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallScreen()
            }
        }
    }
}

// MARK: - Extraction Counter Badge
/// Shows remaining extractions for free tier
struct ExtractionCounterBadge: View {
    @State private var subscriptionService = SubscriptionService.shared

    var body: some View {
        if subscriptionService.currentTier == .free,
           let remaining = subscriptionService.remainingExtractions {
            HStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.caption2)
                Text("\(remaining) left")
                    .font(.caption2)
            }
            .foregroundStyle(remaining > 0 ? Color.thresh.capture : .red)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                (remaining > 0 ? Color.thresh.capture : .red)
                    .opacity(0.15)
            )
            .clipShape(Capsule())
        }
    }
}

// MARK: - Pro Feature Badge
/// A small badge indicating a Pro feature
struct ProFeatureBadge: View {
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
                .font(.system(size: 8))
            Text("PRO")
                .font(.system(size: 9, weight: .bold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(Color.thresh.synthesis)
        .clipShape(Capsule())
    }
}

// MARK: - Plus Feature Badge
struct PlusFeatureBadge: View {
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "plus")
                .font(.system(size: 8, weight: .bold))
            Text("PLUS")
                .font(.system(size: 9, weight: .bold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(Color.thresh.capture)
        .clipShape(Capsule())
    }
}

// MARK: - View Extension for Feature Gating
extension View {
    /// Gates this view behind a subscription tier
    func requiresSubscription(_ tier: SubscriptionTier) -> some View {
        FeatureGate(requiredTier: tier) {
            self
        }
    }

    /// Gates this view with custom locked content
    func requiresSubscription<LockedContent: View>(
        _ tier: SubscriptionTier,
        @ViewBuilder lockedContent: () -> LockedContent
    ) -> some View {
        FeatureGate(requiredTier: tier) {
            self
        } lockedContent: {
            lockedContent()
        }
    }
}

// MARK: - Preview
#Preview("Feature Gate") {
    VStack(spacing: 20) {
        Text("Free Content")
            .requiresSubscription(.free)

        Text("Plus Content")
            .requiresSubscription(.plus)

        Text("Pro Content")
            .requiresSubscription(.pro)

        ExtractionCounterBadge()

        HStack {
            ProFeatureBadge()
            PlusFeatureBadge()
        }
    }
    .padding()
}
