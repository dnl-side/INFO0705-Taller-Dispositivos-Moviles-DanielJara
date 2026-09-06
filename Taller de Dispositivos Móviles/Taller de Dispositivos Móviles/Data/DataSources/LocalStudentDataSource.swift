final class LocalStudentDataSource {
    private var students: [Student] = Array(DanceSampleData.students.prefix(3))

    /// Función empleada para obtener los estudiantes almacenados en la fuente de datos local.
    func getStudents() -> [Student] {
        students
    }

    /// Función empleada para actualizar la copia local de la lista de estudiantes.
    func saveStudents(_ students: [Student]) {
        self.students = students
    }
}
