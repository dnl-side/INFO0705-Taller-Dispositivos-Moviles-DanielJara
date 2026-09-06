import Foundation

final class LocalDanceDataSource {
    private var classes: [DanceClass] = DanceSampleData.classes
    private var attendanceRecords: [AttendanceRecord] = []
    private var progressRecords: [StudentProgress] = DanceSampleData.progress
    private var feedbackRecords: [ArtisticFeedback] = DanceSampleData.feedback
    private var mediaRecords: [MediaRecord] = DanceSampleData.media

    func getClasses() -> [DanceClass] {
        classes
    }

    func saveClasses(_ classes: [DanceClass]) {
        self.classes = classes
    }

    func getAttendance(for classID: UUID) -> [AttendanceRecord] {
        attendanceRecords.filter { $0.classID == classID }
    }

    func saveAttendance(_ record: AttendanceRecord) {
        let calendar = Calendar.current

        if let index = attendanceRecords.firstIndex(where: {
            $0.studentID == record.studentID &&
            $0.classID == record.classID &&
            calendar.isDate($0.date, inSameDayAs: record.date)
        }) {
            attendanceRecords[index] = record
        } else {
            attendanceRecords.append(record)
        }
    }

    func pendingAttendance() -> [AttendanceRecord] {
        attendanceRecords.filter { $0.syncState == .pending }
    }

    func markAttendanceSynced(id: UUID) {
        guard let index = attendanceRecords.firstIndex(where: { $0.id == id }) else {
            return
        }

        attendanceRecords[index] = attendanceRecords[index].markingSynced()
    }

    func getProgress(for studentID: UUID, discipline: String) -> [StudentProgress] {
        progressRecords
            .filter { $0.studentID == studentID && $0.discipline == discipline }
            .sorted { $0.week < $1.week }
    }

    func saveProgress(_ progress: [StudentProgress]) {
        for item in progress where !progressRecords.contains(where: { $0.id == item.id }) {
            progressRecords.append(item)
        }
    }

    func getFeedback(for studentID: UUID) -> [ArtisticFeedback] {
        feedbackRecords.filter { $0.studentID == studentID }
    }

    func getMedia(for classID: UUID) -> [MediaRecord] {
        mediaRecords.filter { $0.classID == classID }
    }
}
