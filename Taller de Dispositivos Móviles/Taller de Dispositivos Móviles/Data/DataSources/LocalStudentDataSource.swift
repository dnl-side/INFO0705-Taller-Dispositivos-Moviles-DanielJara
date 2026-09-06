final class LocalStudentDataSource {
    private var students: [Student] = [
        Student(name: "Camila Soto", technicalLevel: .intermediate),
        Student(name: "Martín Rojas", technicalLevel: .advanced),
        Student(name: "Sofía Pérez", technicalLevel: .initial)
    ]

    func getStudents() -> [Student] {
        students
    }

    func saveStudents(_ students: [Student]) {
        self.students = students
    }
}
