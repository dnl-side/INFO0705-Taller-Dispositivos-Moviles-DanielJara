import Foundation

#if canImport(FirebaseAnalytics)
import FirebaseAnalytics
#endif

final class FirebaseUnit3AnalyticsTracker: Unit3AnalyticsTracking {
    func track(
        _ event: Unit3AnalyticsEvent,
        parameters: [String: String] = [:]
    ) {
        #if canImport(FirebaseAnalytics)
        let payload = parameters.reduce(into: [String: Any]()) { result, item in
            result[item.key] = item.value
        }

        Analytics.logEvent(
            event.rawValue,
            parameters: payload.isEmpty ? nil : payload
        )
        #endif
    }
}
