import Foundation

/// Caches AI-generated Phase 1 prompts to build a library over time.
/// Once enough prompts are cached per category, we can skip API calls entirely.
final class PromptCacheService {
    static let shared = PromptCacheService()

    /// Minimum prompts needed per category before we stop calling AI
    private let minPromptsPerCategory = 15

    /// Key for UserDefaults storage
    private let storageKey = "cached_phase1_prompts"

    /// In-memory cache, loaded from UserDefaults
    private var cache: [String: [String]] = [:]

    /// Track which prompts we've shown recently to avoid repetition
    private var recentlyShown: [String: [String]] = [:]
    private let recentHistoryLimit = 5

    private init() {
        loadCache()
    }

    // MARK: - Public API

    /// Returns a cached prompt if available and we have enough variety.
    /// Returns nil if we should call the AI instead.
    func getCachedPrompt(for category: PromptCategory?) -> String? {
        let key = cacheKey(for: category)
        guard let prompts = cache[key], prompts.count >= minPromptsPerCategory else {
            return nil
        }

        // Filter out recently shown prompts
        let recent = recentlyShown[key] ?? []
        let available = prompts.filter { !recent.contains($0) }

        // If we've shown all of them recently, reset and pick from all
        let pool = available.isEmpty ? prompts : available

        guard let selected = pool.randomElement() else {
            return nil
        }

        // Track as recently shown
        trackRecentlyShown(prompt: selected, for: key)

        return selected
    }

    /// Saves a new AI-generated prompt to the cache.
    func savePrompt(_ prompt: String, for category: PromptCategory?) {
        let key = cacheKey(for: category)
        var prompts = cache[key] ?? []

        // Don't save duplicates
        guard !prompts.contains(prompt) else { return }

        prompts.append(prompt)
        cache[key] = prompts

        persistCache()

        print("📚 Cached prompt for \(key). Total: \(prompts.count)")
    }

    /// Check if we have enough cached prompts to skip AI calls
    func hasEnoughPrompts(for category: PromptCategory?) -> Bool {
        let key = cacheKey(for: category)
        return (cache[key]?.count ?? 0) >= minPromptsPerCategory
    }

    /// Get stats about the cache
    func getCacheStats() -> [String: Int] {
        var stats: [String: Int] = [:]
        for (key, prompts) in cache {
            stats[key] = prompts.count
        }
        return stats
    }

    /// Get total number of cached prompts
    var totalCachedPrompts: Int {
        cache.values.reduce(0) { $0 + $1.count }
    }

    /// Clear all cached prompts (for debugging/reset)
    func clearCache() {
        cache = [:]
        recentlyShown = [:]
        persistCache()
    }

    // MARK: - Private

    private func cacheKey(for category: PromptCategory?) -> String {
        category?.rawValue ?? "open"
    }

    private func trackRecentlyShown(prompt: String, for key: String) {
        var recent = recentlyShown[key] ?? []
        recent.append(prompt)

        // Keep only the last N prompts
        if recent.count > recentHistoryLimit {
            recent.removeFirst()
        }

        recentlyShown[key] = recent
    }

    private func loadCache() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([String: [String]].self, from: data) else {
            return
        }
        cache = decoded
        print("📚 Loaded \(totalCachedPrompts) cached prompts across \(cache.count) categories")
    }

    private func persistCache() {
        guard let data = try? JSONEncoder().encode(cache) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
