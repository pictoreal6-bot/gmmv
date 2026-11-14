PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS classes (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 academic_year INTEGER NOT NULL,
 grade INTEGER NOT NULL CHECK(grade BETWEEN 1 AND 13),
 division TEXT NOT NULL CHECK(division IN ('A','B','C')),
 UNIQUE(academic_year,grade,division)
);
CREATE TABLE IF NOT EXISTS students (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 class_id INTEGER NOT NULL REFERENCES classes(id),
 admission_no TEXT NOT NULL,
 name TEXT NOT NULL,
 active INTEGER NOT NULL DEFAULT 1,
 UNIQUE(class_id,admission_no)
);
CREATE TABLE IF NOT EXISTS subjects (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 class_id INTEGER NOT NULL REFERENCES classes(id),
 name TEXT NOT NULL,
 active INTEGER NOT NULL DEFAULT 1,
 UNIQUE(class_id,name)
);
CREATE TABLE IF NOT EXISTS marks (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 student_id INTEGER NOT NULL REFERENCES students(id),
 subject_id INTEGER NOT NULL REFERENCES subjects(id),
 academic_year INTEGER NOT NULL,
 term INTEGER NOT NULL CHECK(term IN (1,2,3)),
 mark INTEGER CHECK(mark BETWEEN 0 AND 100),
 updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE(student_id,subject_id,academic_year,term)
);
CREATE TABLE IF NOT EXISTS teacher_links (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 token_hash TEXT NOT NULL UNIQUE,
 class_id INTEGER NOT NULL REFERENCES classes(id),
 subject_id INTEGER NOT NULL REFERENCES subjects(id),
 academic_year INTEGER NOT NULL,
 grade INTEGER NOT NULL,
 division TEXT NOT NULL,
 term INTEGER NOT NULL CHECK(term IN (1,2,3)),
 label TEXT,
 revoked INTEGER NOT NULL DEFAULT 0,
 expires_at INTEGER,
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_students_class ON students(class_id);
CREATE INDEX IF NOT EXISTS idx_marks_student ON marks(student_id,academic_year,term);
CREATE INDEX IF NOT EXISTS idx_marks_subject ON marks(subject_id,academic_year,term);
