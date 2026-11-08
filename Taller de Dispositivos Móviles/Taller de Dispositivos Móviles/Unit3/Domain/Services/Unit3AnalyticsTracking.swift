import Foundation

enum Unit3AnalyticsEvent: String {
    case orientationStarted = "u3_orientation_started"
    case classificationAccepted = "u3_classification_accepted"
    case classificationCorrected = "u3_classification_corrected"
    case resourceLoaded = "u3_resource_loaded"
    case cacheUsed = "u3_cache_used"
    case historySaved = "u3_history_saved"
    case historyUnlocked = "u3_history_unlocked"
    case orientationCompleted = "u3_orientation_completed"
}

protocol Unit3AnalyticsTracking {
    func track(
        _ event: Unit3AnalyticsEvent,
        parameters: [String: String]
    )
}
