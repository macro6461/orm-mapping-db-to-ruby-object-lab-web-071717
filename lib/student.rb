require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
  new_student = self.new  # self.new is the same as running Song.new
  new_student.id = row[0]
  new_student.name =  row[1]
  new_student.grade = row[2]
  new_student # return the newly created instance
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT *
    FROM students
    SQL

    students_arr = DB[:conn].execute(sql)
    students_arr.map do |row|
      # binding.pry
      self.new_from_db(row)
    end
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT COUNT(*)
    FROM students
    WHERE students.grade = 9
    SQL

    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT COUNT(*)
    FROM students
    WHERE students.grade < 12
    SQL

    DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE students.grade = 10
    LIMIT ?
    SQL

    DB[:conn].execute(sql, x)

  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE students.grade = 10
    ORDER BY students.id
    ASC LIMIT 1
    SQL

    grade_10_students = DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    grade_10_students.first
  end

  def self.all_students_in_grade_x(x)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE students.grade = ?
    SQL

    DB[:conn].execute(sql, x)
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE students.name = ?
    LIMIT 1
    SQL

    found = DB[:conn].execute(sql,name)
    found.map do |row|
      self.new_from_db(row)
    end.first
    # binding.pry
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
