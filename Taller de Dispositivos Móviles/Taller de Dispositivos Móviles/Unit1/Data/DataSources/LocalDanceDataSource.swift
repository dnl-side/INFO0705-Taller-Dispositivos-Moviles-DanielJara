import Foundation

final class LocalDanceDataSource {
    private var classes: [DanceClass] = DanceSampleData.classes
    private var attendanceRecords: [AttendanceRecord] = []
    private var progressRecords: [StudentProgress] = DanceSampleData.progress
    private var feedbackRecords: [ArtisticFeedback] = DanceSampleData.feedback
    private var mediaRecords: [MediaRecord] = DanceSampleData.media

    /// Función empleada para obtener las clases almacenadas en la fuente de datos local.
    func getClasses() -> [DanceClass] {
        classes
    }

    /// Función empleada para actualizar la copia local de las clases disponibles.
    func saveClasses(_ classes: [DanceClass]) {
        self.classes = classes
    }

    /// Función empleada para obtener los registros de asistencia asociados a una clase.
    func getAttendance(for classID: UUID) -> [AttendanceRecord] {
        attendanceRecords.filter { $0.classID == classID }
    }

    /// Función empleada para guardar o actualizar una asistencia evitando duplicados del mismo estudiante, clase y día.
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

    /// Función empleada para obtener las asistencias que todavía se encuentran pendientes de sincronización.
    func pendingAttendance() -> [AttendanceRecord] {
        attendanceRecords.filter { $0.syncState == .pending }
    }

    /// Función empleada para marcar un registro de asistencia local como sincronizado.
    func markAttendanceSynced(id: UUID) {
        guard let index = attendanceRecords.firstIndex(where: { $0.id == id }) else {
            return
        }

        attendanceRecords[index] = attendanceRecords[index].markingSynced()
    }

    /// Función empleada para obtener el progreso de un estudiante en una disciplina y ordenarlo por semana.
    func getProgress(for studentID: UUID, discipline: String) -> [StudentProgress] {
        progressRecords
            .filter { $0.studentID == studentID && $0.discipline == discipline }
            .sorted { $0.week < $1.week }
    }

    /// Función empleada para incorporar nuevos registros de progreso sin repetir identificadores existentes.
    func saveProgress(_ progress: [StudentProgress]) {
        for item in progress where !progressRecords.contains(where: { $0.id == item.id }) {
            progressRecords.append(item)
        }
    }

    /// Función empleada para obtener la retroalimentación artística registrada para un estudiante.
    func getFeedback(for studentID: UUID) -> [ArtisticFeedback] {
        feedbackRecords.filter { $0.studentID == studentID }
    }

    /// Función empleada para obtener los registros audiovisuales asociados a una clase.
    func getMedia(for classID: UUID) -> [MediaRecord] {
        mediaRecords.filter { $0.classID == classID }
    }
}
