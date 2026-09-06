import Foundation

enum DanceSampleData {
    static let camilaID = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    static let martinID = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!
    static let sofiaID = UUID(uuidString: "33333333-3333-3333-3333-333333333333")!
    static let valentinaID = UUID(uuidString: "44444444-4444-4444-4444-444444444444")!

    static let teacherID = UUID(uuidString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")!
    static let jazzClassID = UUID(uuidString: "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB")!
    static let balletClassID = UUID(uuidString: "CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCCC")!

    static let students: [Student] = [
        Student(id: camilaID, name: "Camila Soto", technicalLevel: .intermediate, classHistory: [jazzClassID]),
        Student(id: martinID, name: "Martín Rojas", technicalLevel: .advanced, classHistory: [jazzClassID, balletClassID]),
        Student(id: sofiaID, name: "Sofía Pérez", technicalLevel: .initial, classHistory: [balletClassID]),
        Student(id: valentinaID, name: "Valentina Díaz", technicalLevel: .intermediate, classHistory: [jazzClassID])
    ]

    static let teacher = Teacher(
        id: teacherID,
        name: "Paula Herrera",
        specialty: "Jazz lírico",
        availableSchedules: ["Jueves 18:00", "Viernes 17:00"]
    )

    static let classes: [DanceClass] = [
        DanceClass(
            id: jazzClassID,
            discipline: "Jazz lírico",
            durationMinutes: 90,
            room: "Sala 203",
            teacherID: teacherID,
            schedule: "Jueves 18:00"
        ),
        DanceClass(
            id: balletClassID,
            discipline: "Ballet",
            durationMinutes: 90,
            room: "Sala 201",
            teacherID: teacherID,
            schedule: "Martes 17:00"
        )
    ]

    static let progress: [StudentProgress] = [
        StudentProgress(
            studentID: camilaID,
            discipline: "Jazz lírico",
            week: 8,
            trainingHours: 3.0,
            summary: "Presentó problemas de eje en piruetas."
        ),
        StudentProgress(
            studentID: camilaID,
            discipline: "Jazz lírico",
            week: 9,
            trainingHours: 3.5,
            summary: "Mostró progresión en equilibrio."
        ),
        StudentProgress(
            studentID: camilaID,
            discipline: "Jazz lírico",
            week: 10,
            trainingHours: 4.0,
            summary: "Mejoró el control de centro."
        )
    ]

    static let feedback: [ArtisticFeedback] = [
        ArtisticFeedback(
            studentID: camilaID,
            classID: jazzClassID,
            technicalCorrection: "Mantener el eje durante la pirueta.",
            projectionNote: "Proyectar la mirada antes del giro.",
            postureNote: "Evitar elevar los hombros.",
            expressiveNote: "Dar continuidad al movimiento entre frases.",
            syncState: .synced
        )
    ]

    static let media: [MediaRecord] = [
        MediaRecord(
            classID: jazzClassID,
            studentID: camilaID,
            localFileName: "jazz_semana_10_camila.mov",
            tags: ["piruetas", "equilibrio", "semana 10"],
            syncState: .synced
        )
    ]
}
