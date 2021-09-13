#!/usr/bin/env ruby

require 'csv'

# Course object
class Course
    # Initialize object with course id, number, and title
    def initialize(course_id, course_num, course_title)
        @course_id = course_id
        @course_num = course_num
        @course_title = course_title
        @rankings = Hash.new
    end

    attr_reader :course_id
    attr_reader :course_num
    attr_reader :course_title
    attr_accessor :rankings
end

# Student object
class Student
    @student_id # The unique student id
    @ranked_courses = Array.new # Array of course ids in order of preference
    @chosen_course  # Course the student is enrolled in
    @chosen_id # The id of the course the student is enrolled in
    @chosen_rank # TODO get rank from array    

    def initialize(student_id)
        @student_id = student_id
    end

    # This function adds a stuent to a course
    def enroll_in_course(course)
        @chosen_course = course # Set chosen course object
        @chosen_id = @choose_course.course_id # Set id of chosen course
        @chosen_rank = @ranked_courses.find_index(@chosen_id) # Get rank of course from array
        @chosen_course.rankings[@student_id] = @chosen_rank
    end

    # This function will check if a course is listed in preferred courses
    # If it is listed then you get the ranking of course
    # If not then you get nil
    def check_if_listed(course)
        # Check to see if this course is in list of preferred courses
        idx = @ranked_courses.find_index(course.course_id)
        return idx
    end

    # Check to see if new course preferred
    # If it is, then return true
    # If it isn't, then return false
    def check_if_preferred(idx)
        if idx < @chosen_rank
            return true
        else
            return false
        end
    end

    # Define this outside of class
    def try_to_enroll(course)
        if chosen_course.nil? == true
            choose_course(course)
        else
            # Check to see if course is in list of preferred courses
            i = -1 # This will take the ranking of the course if found in the ranking list
            @ranked_courses.each_with_index do |cid, idx|
                if course.course_id == cid
                    i = idx
                end
            end

            # If the course was in the list see if it is preferred
            # TODO add a variable to the class for the index of the currently chosen course
            if i > -1
                j = -1 # This will take the ranking of the currently chosen course
                @ranked_courses.each_with_index do |cid, idx|
                    if chosen_id == cid
                        j = idx
                    end
                end

                # If i < j then it is higher in the ranking
                if i < j
                    # The new course is preferred
                    choose_course(course)
                end
            end
        end
    end

    attr_reader :student_id
    attr_reader :ranked_courses
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

# Initialize array for course objects
course_table.each do |row|
    Courses.push(Course.new(row[0], row[1], row[2]))
end

# Initialize array for student objects
student_table.each do |row|
    # make use of find
    # temp = Students.find {|stu| stu.student_id == row[0]}
    # temp acts as a pointer to the student object in the array
    # if temp isn't nil
    # temp.ranked_courses.push(row[1])
    # if it is then
    # new_student = Student.new(row[0])
    # new_student.ranked_courses.push(row[0])
    # Students.push(new_student)
end

# testing
Courses.each do |c|
    puts c.course_id
end