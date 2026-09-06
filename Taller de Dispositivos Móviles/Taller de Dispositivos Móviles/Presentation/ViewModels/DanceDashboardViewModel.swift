import Combine
import Foundation

@MainActor
final class DanceDashboardViewModel: ObservableObject {
    @Published private(set) var students: [Student] = []
    @Published private(set) var classes: [DanceClass] = []
    @Published private(set) var attendance: [AttendanceRecord] = []
    @Published private(set) var progress: [StudentProgress] = []
    @Published private(set) var isLoading = false
    @Published private(set) var statusMessage: String?

    private let studentRepository: StudentRepository
    private let danceRepository: DanceRepository

    init(
        studentRepository: StudentRepository,
        danceRepository: DanceRepository
    ) {
        self.studentRepository = studentRepository
        self.danceRepository = danceRepository
    }

    var currentClass: DanceClass? {
        classes.first
    }

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
            }

            if let student = students.first,
               let currentClass {
                progress = try await danceRepository.getProgress(
                    for: student.id,
                    discipline: currentClass.discipline
                )
            }
        } catch {
            statusMessage = "No fue posible actualizar todos los datos. Se mostrará la información disponible localmente."
        }
    }

    func attendanceStatus(for student: Student) -> AttendanceStatus? {
        attendance.first(where: { $0.studentID == student.id })?.status
    }

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

    func synchronize() async {
        await danceRepository.synchronizePendingAttendance()

        if let currentClass {
            attendance = await danceRepository.getAttendance(for: currentClass.id)
        }

        statusMessage = "Sincronización finalizada."
    }
}
