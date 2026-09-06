import Foundation

final class DanceRepositoryImpl: DanceRepository {
    private let localDataSource: LocalDanceDataSource
    private let remoteDataSource: RemoteDanceDataSource

    /// Función de inicialización empleada para recibir las fuentes de datos local y remota utilizadas por el repositorio.
    init(
        localDataSource: LocalDanceDataSource,
        remoteDataSource: RemoteDanceDataSource
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    /// Función empleada para obtener las clases desde la fuente remota y usar la copia local si la operación falla.
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

    /// Función empleada para consultar localmente la asistencia registrada para una clase.
    func getAttendance(for classID: UUID) async -> [AttendanceRecord] {
        localDataSource.getAttendance(for: classID)
    }

    /// Función empleada para guardar primero la asistencia localmente e intentar sincronizarla con la fuente remota.
    func saveAttendance(_ record: AttendanceRecord) async throws {
        localDataSource.saveAttendance(record)

        do {
            try await remoteDataSource.uploadAttendance(record)
            localDataSource.markAttendanceSynced(id: record.id)
        } catch {
            return
        }
    }

    /// Función empleada para obtener el progreso desde la copia local o descargarlo cuando todavía no está disponible.
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

    /// Función empleada para consultar la retroalimentación artística almacenada para un estudiante.
    func getFeedback(for studentID: UUID) async -> [ArtisticFeedback] {
        localDataSource.getFeedback(for: studentID)
    }

    /// Función empleada para consultar los registros audiovisuales almacenados para una clase.
    func getMedia(for classID: UUID) async -> [MediaRecord] {
        localDataSource.getMedia(for: classID)
    }

    /// Función empleada para reintentar el envío de las asistencias que permanecen pendientes de sincronización.
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
