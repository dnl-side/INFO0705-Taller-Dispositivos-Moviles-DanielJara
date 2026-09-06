import Foundation

final class DanceRepositoryImpl: DanceRepository {
    private let localDataSource: LocalDanceDataSource
    private let remoteDataSource: RemoteDanceDataSource

    init(
        localDataSource: LocalDanceDataSource,
        remoteDataSource: RemoteDanceDataSource
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func getClasses() async throws -> [DanceClass] {
        let cachedClasses = localDataSource.getClasses()

        do {
            let remoteClasses = try await remoteDataSource.fetchClasses()
            localDataSource.saveClasses(remoteClasses)
            return remoteClasses
        } catch {
            if !cachedClasses.isEmpty {
                return cachedClasses
            }

            throw error
        }
    }

    func getAttendance(for classID: UUID) async -> [AttendanceRecord] {
        localDataSource.getAttendance(for: classID)
    }

    func saveAttendance(_ record: AttendanceRecord) async throws {
        localDataSource.saveAttendance(record)

        do {
            try await remoteDataSource.uploadAttendance(record)
            localDataSource.markAttendanceSynced(id: record.id)
        } catch {
            return
        }
    }

    func getProgress(for studentID: UUID, discipline: String) async throws -> [StudentProgress] {
        let cachedProgress = localDataSource.getProgress(
            for: studentID,
            discipline: discipline
        )

        if !cachedProgress.isEmpty {
            return cachedProgress
        }

        do {
            let remoteProgress = try await remoteDataSource.fetchProgress(
                for: studentID,
                discipline: discipline
            )
            localDataSource.saveProgress(remoteProgress)
            return remoteProgress
        } catch {
            throw error
        }
    }

    func synchronizePendingAttendance() async {
        for record in localDataSource.pendingAttendance() {
            do {
                try await remoteDataSource.uploadAttendance(record)
                localDataSource.markAttendanceSynced(id: record.id)
            } catch {
                continue
            }
        }
    }
}
