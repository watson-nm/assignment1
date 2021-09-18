#!/usr/bin/env ruby

# TODO make sure that the classes aren't overloaded

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

    # This function adds a stuent to a course in their ranking list
    def enroll_in_ranked_course(course)
        @enrolled = true
        @chosen_course = course # Set chosen course object
        @chosen_id = @chosen_course.course_id # Set id of chosen course
        @chosen_rank = @ranked_courses.find_index(@chosen_id) # Get rank of course from array
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

# Get input from user
print "What is the number of FYS courses/sections being offered? "
num_FYS = gets.chomp.to_i

print "How many students are in the incoming class? "
num_students = gets.chomp.to_i

print "What is the name of the csv file with the list of FYS courses/sections? "
courses_file = gets.chomp

print "What is the name of the csv file with the list of incoming students? "
students_file = gets.chomp

# Read from the CSV files
course_table = CSV.parse(File.read(courses_file), headers:true)
student_table = CSV.parse(File.read(students_file), headers:true)

# Create arrays for course and student objects
Courses = Array.new
Students = Array.new

# Array of students who couldn't get into any classes
Lost = Array.new

# Initialize array for course objects
course_table.each do |row|
    Courses.push(Course.new(row[0], row[1], row[2]))
end

# Initialize array for student objects
student_table.each do |row|
    temp = Students.find {|stu| stu.student_id == row[0]} # This looks for a student object with a matching student id
    # The variable temp acts as a pointer to the student object in the array
    if !temp.nil? # If temp is not nil
        # Check to make sure that the course actually exists
        if Courses.any? {|c| c.course_id == row[1]} == true
            temp.ranked_courses.push(row[1]) # Add the course id to student object's list
        end
    else
        new_student = Student.new(row[0]) # No student object was found in the array, so make one
        if Courses.any? {|c| c.course_id == row[1]} == true
            new_student.ranked_courses.push(row[1]) # Once the new student exists add the class to its list
        end
        Students.push(new_student) # Add the new student to the array of students
    end
end

# Try and enroll student in class
def try_to_enroll(student, course)
    course_rank = student.get_ranking(course)

    if course.num_students < 18
        student.enroll_in_ranked_course(course)
    else # Replacement section
        # Check to see if this student ranked the course higher than another student
        if course.rankings.has_value?(nil) == true # If there exists a student who didn't have this course in their ranking, replace them
            rank_key = nil 
            # Lines that remove a student from the course to make room
            kicked_student = Students.find {|stu| stu.student_id == rank_key} # Get the student to be removed
            kicked_student.enrolled = false # Reset their enrollment status to false
            kicked_student.chosen_course = nil # Make sure that they don't retain the course

            course.rankings.delete(rank_key) # Delete the old student from the course hash map
        else
            lowest_rank = course.rankings.values.max # This should get the student who ranked the class lowest
            if lowest_rank > course_rank # Compare ranks FIXME is the course here an object or the id
                rank_key = course.rankings.key(lowest_rank)
    
                # Lines that remove a student from the course to make room
                kicked_student = Students.find {|stu| stu.student_id == rank_key} # Get the student to be removed
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

# This is the important main loop
while Students.any? {|stu| stu.enrolled == false}
    student = Students.find {|stu| stu.enrolled == false}

    # For every course the student has ranked try to enroll while not enrolled
    student.ranked_courses.each do |ranked_course_id|
        # This is so that the course object is being passed to the function, not the course id
        ranked_course = Courses.find {|c| c.course_id == ranked_course_id}

        try_to_enroll(student, ranked_course)

        # If the student is enrolled, break the loop
        if student.enrolled == true
            break
        end
    end

    # This runs if the student wasn't able to make it into any of their preffered classes
    if student.enrolled == false
        course_least_students = Courses.min_by {|c| c.num_students} # The course with the least amount of students # FIXME min_by
        if course_least_students.num_students < 18 # If the smallest amount of students in a class isn't 18, a student can be placed
            student.enroll_in_any_course(course_least_students) # TODO make sure this works
        end
    end

    ###### Place student in list of unenrolled students if they couldn't get into any class ######
    if student.enrolled == false
        student.enrolled = true # They are not actually enrolled; they're enrolled in the loser list
        student.chosen_course = nil # Just to make sure
        Lost.push(student)
    end
    ############

    ###### Place students in course if they run out of options ######
    # If a student has tried to get into all their ranked courses and failed
    # Put them in the class with the least amount of students
    # TODO Make sure that their chosen_rank value is nil
    # TODO Make sure that the 'Compare ranks' code knows how to handle nil
    #if student.enrolled == false
    #    # Find the lowest number of students in a course
    #    lowest = Course.min_by {|c| c.num_students} # This should be the lowest number, not the course object itself
    #
    #    unranked_course = Course.find {|c| c.num_students == lowest} # Gets a course with the lowest number of students
    #    student.enroll_in_course(unranked_course) # Enroll the student in the course
    #    # TODO Make sure that the 'Compare ranks' knows how to handle this unranked course
    #end
    ############

end

# This is old and can be deleted when I'm sure I don't need to reference it
=begin
def try_to_enroll(course)
    if chosen_course.nil? == true
        choose_course(course)
    else
        # Check to see if course is in list of preferred courses
        i = nil # This will take the ranking of the course if found in the ranking list
        @ranked_courses.each_with_index do |cid, idx|
            if course.course_id == cid
                i = idx
            end
        end

        # If the course was in the list see if it is preferred
        if !i.nil?
            j = nil # This will take the ranking of the currently chosen course
            @ranked_courses.each_with_index do |cid, idx|
                if chosen_id == cid
                    j = idx
                end
            end

            # If i < j then it is higher in the ranking
            if i < j || j 
                # The new course is preferred
                choose_course(course)
            end
        end
    end
end
=end

# testing
sFile = File.new("outs.txt", "w+")
if sFile
    i = 0
    sFile.syswrite("student_id, class")
    sFile.syswrite("\n")
    Students.each do |s|
        if s.chosen_course.nil? == false # If the chosen course is not nil, meaning they are actually enrolled in something
            sFile.syswrite("#{s.student_id}, #{s.chosen_id}")
            sFile.syswrite("\n")
            i += 1
        end
    end
    puts "number of students is #{Students.length}"
    puts "number of students in a course: #{i}"
else
   puts "Unable to open file!"
end