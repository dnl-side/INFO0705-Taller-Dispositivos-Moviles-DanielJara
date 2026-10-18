import Combine
import Foundation

@MainActor
final class DanceDashboardViewModel: ObservableObject {
    @Published private(set) var students: [Student] = []
    @Published private(set) var classes: [DanceClass] = []
    @Published private(set) var attendance: [AttendanceRecord] = []
    @Published private(set) var progress: [StudentProgress] = []
    @Published private(set) var feedback: [ArtisticFeedback] = []
    @Published private(set) var media: [MediaRecord] = []
    @Published private(set) var isLoading = false
    @Published private(set) var statusMessage: String?

    private let studentRepository: StudentRepository
    private let danceRepository: DanceRepository

    /// Función de inicialización empleada para recibir los repositorios que abastecen la información mostrada en seguimiento.
    init(
        studentRepository: StudentRepository,
        danceRepository: DanceRepository
    ) {
        self.studentRepository = studentRepository
        self.danceRepository = danceRepository
    }

    /// Propiedad empleada para obtener la primera clase disponible y utilizarla como clase activa del seguimiento.
    var currentClass: DanceClass? {
        classes.first
    }

    /// Función empleada para cargar estudiantes, clases, asistencia, progreso, retroalimentación y registros audiovisuales.
    func loadDashboard() async {
        guard !isLoading else { return }

        isLoading = true
        statusMessage = nil

        defer {
            isLoading = false
        }

        do {
            students = try await studentRepository.getStudents()
            classes = try await danceRepository.getClasses()

            if let currentClass {
                attendance = await danceRepository.getAttendance(for: currentClass.id)
                media = await danceRepository.getMedia(for: currentClass.id)
            }

            if let student = students.first,
               let currentClass {
                progress = try await danceRepository.getProgress(
                    for: student.id,
                    discipline: currentClass.discipline
                )
                feedback = await danceRepository.getFeedback(for: student.id)
            }
        } catch {
            statusMessage = "No fue posible actualizar todos los datos. Se mostrará la información disponible localmente."
        }
    }

    /// Función empleada para consultar el estado de asistencia actualmente registrado para un estudiante.
    func attendanceStatus(for student: Student) -> AttendanceStatus? {
        attendance.first(where: { $0.studentID == student.id })?.status
    }

    /// Función empleada para registrar una asistencia y actualizar la información visible después de guardarla.
    func setAttendance(_ status: AttendanceStatus, for student: Student) async {
        guard let currentClass else { return }

        let record = AttendanceRecord(
            studentID: student.id,
            classID: currentClass.id,
            status: status
        )

        do {
            try await danceRepository.saveAttendance(record)
            attendance = await danceRepository.getAttendance(for: currentClass.id)
            statusMessage = "Asistencia guardada. Los datos pendientes se sincronizarán cuando exista conexión."
        } catch {
            statusMessage = "La asistencia quedó guardada localmente y pendiente de sincronización."
        }
    }

    /// Función empleada para solicitar la sincronización de asistencias pendientes y refrescar los datos de la clase activa.
    func synchronize() async {
        await danceRepository.synchronizePendingAttendance()

        if let currentClass {
            attendance = await danceRepository.getAttendance(for: currentClass.id)
        }

        statusMessage = "Sincronización finalizada."
    }
}
