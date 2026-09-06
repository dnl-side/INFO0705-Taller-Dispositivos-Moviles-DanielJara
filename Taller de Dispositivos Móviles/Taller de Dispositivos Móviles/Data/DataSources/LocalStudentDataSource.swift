final class LocalStudentDataSource {
    private var students: [Student] = Array(DanceSampleData.students.prefix(3))

    func getStudents() -> [Student] {
        students
    }

    func saveStudents(_ students: [Student]) {
        self.students = students
    }
}
