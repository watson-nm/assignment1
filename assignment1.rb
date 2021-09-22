#!/usr/bin/env ruby

# TODO make the code more efficient by
# Sorting students and courses in the arrays
# Using binary search

require 'csv'
# Course object
class Course
    # Initialize object with course id, number, and title
    def initialize(course_id, course_num, course_title)
        @course_id = course_id
        @course_num = course_num
        @course_title = course_title
        @rankings = Hash.new
        @num_students = 0
    end

    attr_reader :course_id
    attr_reader :course_num
    attr_reader :course_title
    attr_accessor :num_students
    attr_accessor :rankings
end

# Student object
class Student 
    def initialize(student_id)
        @student_id = student_id
        @ranked_courses = Array.new # Array of course ids in order of preference
        @chosen_course  # Course the student is enrolled in
        @chosen_id # The id of the course the student is enrolled in
        @chosen_rank # TODO get rank from array
        @enrolled = false
    end

    def find_course_index(course_id)
        if ranked_courses.length > 0
            i = 0
            @ranked_courses.each do |r|
                if r == course_id
                    return i
                end
                i += 1
            end

            return nil
        else
            return nil
        end
    end

    # This function adds a stuent to a course in their ranking list
    def enroll_in_ranked_course(course)
        @enrolled = true
        @chosen_course = course # Set chosen course object
        @chosen_id = @chosen_course.course_id # Set id of chosen course
        @chosen_rank = find_course_index(@chosen_id) # Get rank of course from array
        @chosen_course.rankings[@student_id] = @chosen_rank # Add the student and their ranking of the class
        @chosen_course.num_students += 1
    end

    # This function adds a student to a course not in thier ranking list
    def enroll_in_any_course(course)
        @enrolled = true
        @chosen_course = course # Set chosen course object
        @chosen_id = @chosen_course.course_id # Set id of chosen course
        @chosen_rank = nil # Set the chosen course rank to nil, since it wasn't in the list
        @chosen_course.rankings[@student_id] = nil # Add the student and their ranking of the class
        @chosen_course.num_students += 1
    end

    # This function will check the ranking of the course
    # If it is listed then you get the ranking of course
    # If not then you get nil
    def get_ranking(course)
        idx = @ranked_courses.find_index(course.course_id)
        return idx
    end

    attr_reader :student_id
    attr_reader :ranked_courses
    attr_reader :chosen_id
    attr_accessor :enrolled
    attr_accessor :chosen_course
end

# Array to find a student in the array by their id
def find_student_by_id(students_array, id)
    students_array.each do |student|
        if student.student_id == id
            return student
        end
    end

    return nil
end

# If the hash contains the specified value, return true
def rankings_has_value(ranks_hash, value)
    key = ranks_hash.key(value)
    if key.nil? == false
        return true
    else
        return false
    end
end

# Try and enroll student in class
def try_to_enroll(students_array, student, course)
    course_rank = student.get_ranking(course)

    if course.num_students < 18
        student.enroll_in_ranked_course(course)
    else # Replacement section
        # Check to see if this student ranked the course higher than another student
        # FIXME replace has_value
        #if course.rankings.has_value?(nil) == true # If there exists a student who didn't have this course in their ranking, replace them
        if rankings_has_value(course.rankings, nil) == true
            rank_key = course.rankings.key(nil)
            # Lines that remove a student from the course to make room
            #kicked_student = students_array.find {|stu| stu.student_id == rank_key} # Get the student to be removed DELETE
            kicked_student = find_student_by_id(students_array, rank_key)
            kicked_student.enrolled = false # Reset their enrollment status to false
            kicked_student.chosen_course = nil # Make sure that they don't retain the course

            course.rankings.delete(rank_key) # Delete the old student from the course hash map
        else
            lowest_rank = course.rankings.values.max # This should get the student who ranked the class lowest
            if lowest_rank > course_rank # Compare ranks FIXME is the course here an object or the id
                rank_key = course.rankings.key(lowest_rank)
    
                # Lines that remove a student from the course to make room
                #kicked_student = students_array.find {|stu| stu.student_id == rank_key} # Get the student to be removed DELETE
                kicked_student = find_student_by_id(students_array, rank_key)
                kicked_student.enrolled = false # Reset their enrollment status to false
                kicked_student.chosen_course = nil # Make sure that they don't retain the course
    
                course.rankings.delete(rank_key) # Delete the old student from the course hash map
                course.num_students -= 1 # This is here because enrollement functions increment num_students
    
                # Enrol the student
                student.enroll_in_ranked_course(course)
            end
        end        
    end
end

# Check if there are any unenrolled students
def check_if_unenrolled_students(students_array)
    students_array.each do |student|
        if student.enrolled == false
            return true
        end
    end

    return false
end

# Return an unenrolled student
def find_unenrolled_student(students_array)
    students_array.each do |student|
        if student.enrolled == false
            return student
        end
    end

    return nil
end

# Find and return a course by its id
def find_course_by_id(courses_array, id)
    courses_array.each do |course|
        if course.course_id == id
            return course
        end
    end
    return nil
end

# Find the course with the least number of students
def find_smallest_course(courses_array)
    num = courses_array[0].num_students
    smallest = courses_array[0]
    courses_array.each do |course|
        if num > course.num_students
            num = course.num_students
            smallest = course
        end
    end

    return smallest
end

# Check if a course exists in the array
def check_if_course_exists(courses_array, id)
    courses_array.each do |course|
        if course.course_id == id
            return true
        end
    end
    return false
end

# This is the important main loop
def fys_assignments

    # Get input from user
    print "Number of FYS courses/sections being offered: "
    num_FYS = gets.chomp.to_i

    print "Number of students are in the incoming class: "
    num_students = gets.chomp.to_i

    print "Name of the csv file with the list of FYS courses/sections: "
    while courses_file = gets.chomp # This will loop until user enters a valid file name
        if File.exist?(courses_file)
            ext = File.extname(courses_file)

            if ext.eql? ".csv"
                course_table = CSV.parse(File.read(courses_file), headers:true)
                break
            else
                print "Not a csv file, please try again: "
            end
        else
            print "File does not exist, please try again: "
        end
    end

    print "Name of the csv file with the list of incoming student and selections: "
    while students_file = gets.chomp # This will loop until user enters a valid file name
        if File.exist?(students_file)
            ext = File.extname(students_file)

            if ext.eql? ".csv"
                student_table = CSV.parse(File.read(students_file), headers:true)
                break
            else
                print "Not a csv file, please try again: "
            end
        else
            print "File does not exist, please try again: "
        end
    end

    # Create arrays for course and student objects
    courses_array = Array.new
    students_array = Array.new

    # Initialize array for course objects
    course_table.each do |row|
        courses_array.push(Course.new(row[0], row[1], row[2]))
    end

    # Initialize array for student objects
    student_table.each do |row|
        #temp = students_array.find {|stu| stu.student_id == row[0]} # This looks for a student object with a matching student id DELETE
        temp = find_student_by_id(students_array, row[0])
        # The variable temp acts as a pointer to the student object in the array
        if !temp.nil? # If temp is not nil
            # Check to make sure that the course actually exists
            #if courses_array.any? {|c| c.course_id == row[1]} == true
            if check_if_course_exists(courses_array, row[1]) == true
                temp.ranked_courses.push(row[1]) # Add the course id to student object's list
            end
        else
            new_student = Student.new(row[0]) # No student object was found in the array, so make one
            #if courses_array.any? {|c| c.course_id == row[1]} == true
            if check_if_course_exists(courses_array, row[1]) == true
                new_student.ranked_courses.push(row[1]) # Once the new student exists add the class to its list
            end
            students_array.push(new_student) # Add the new student to the array of students
        end
    end

    # Array of students who couldn't get into any classes
    lost = Array.new

    # The main loop
    while check_if_unenrolled_students(students_array) == true
        #student = students_array.find {|stu| stu.enrolled == false}
        student = find_unenrolled_student(students_array)

        # For every course the student has ranked try to enroll while not enrolled
        student.ranked_courses.each do |ranked_course_id|
            # This is so that the course object is being passed to the function, not the course id
            #ranked_course = courses_array.find {|c| c.course_id == ranked_course_id}
            ranked_course = find_course_by_id(courses_array, ranked_course_id)

            try_to_enroll(students_array, student, ranked_course)

            # If the student is enrolled, break the loop
            if student.enrolled == true
                break
            end
        end

        # This runs if the student wasn't able to make it into any of their preffered classes
        if student.enrolled == false
            #course_least_students = courses_array.min_by {|c| c.num_students} # The course with the least amount of students # FIXME min_by
            course_least_students = find_smallest_course(courses_array)
            if course_least_students.num_students < 18 # If the smallest amount of students in a class isn't 18, a student can be placed
                student.enroll_in_any_course(course_least_students) # TODO make sure this works
            end
        end

        ###### Place student in list of unenrolled students if they couldn't get into any class ######
        if student.enrolled == false
            student.enrolled = true # They are not actually enrolled; they're enrolled in the loser list
            student.chosen_course = nil # Just to make sure
            lost.push(student)
        end
        ############

    end

    # Output
    num_enrolled = 0
    num_not_enrolled = 0
    num_running = 0
    num_not_running = 0

    out1 = File.new("output-1.txt", "w+")
    if out1
        out1.syswrite("course id, student id")
        out1.syswrite("\n")
        students_array.each do |student|
            if student.chosen_course.nil? == false
                course_id = student.chosen_id
                student_id = student.student_id
                out1.syswrite("#{course_id}, #{student_id}")
                out1.syswrite("\n")
                num_enrolled += 1
            else
                num_not_enrolled += 1
            end
        end
    end

    out2 = File.new("output-2.txt", "w+")
    if out2
        out2.syswrite("course id, course number, course name")
        out2.syswrite("\n")
        courses_array.each do |course|
            if course.num_students < 10
                out2.syswrite("#{course.course_id}, #{course.course_num}, #{course.course_title}, # students < 10")
                out2.syswrite("\n")
                num_not_running += 1
            else
                out2.syswrite("#{course.course_id}, #{course.course_num}, #{course.course_title}")
                out2.syswrite("\n")
                num_running += 1
            end

            course.rankings.keys.each do |student_id|
                out2.syswrite("#{student_id}")
                out2.syswrite("\n")
            end
        end
    end

    out3 = File.new("output-3.txt", "w+")
    if out3
        out3.syswrite("Number of students enrolled in a course: #{num_enrolled}\n")
        out3.syswrite("Number of students who were not enrolled in a course: #{num_not_enrolled}\n")
        out3.syswrite("Number of courses that can run: #{num_running}\n")
        out3.syswrite("Number of courses that can not run: #{num_not_running}\n")
    end
end

fys_assignments