#!/usr/bin/env ruby

# Course object
class Course
    # Initialize object with course id, number, and title
    def initialize(course_id, course_num, course_title)
        @course_id = course_id
        @course_num = course_num
        @course_title = course_title
        @num_students = 0
    end

    attr_reader :course_id
    attr_reader :course_num
    attr_reader :course_title
    attr_accessor :num_students
end

# Student object
class Student
    @ranked_courses = Array.new(6) # Array of course ids in order of preference
    @chosen_course  # Course the student is enrolled in
    @chosen_id = @chosen_course.course_id # The id of the course the student is enrolled in

    def initialize(student_id)
        @student_id = student_id
        # TODO put a loop here to fill the array
    end

    def choose_course(course)
        # If  there is a course set, remove the student from that course
        if chosen_course.nil? != true
            @chosen_course.num_students = @chosen_course.num_students - 1
        end

        # Add student to new course
        @chosen_course = course
        @chosen_course.num_students = @chosen_course.num_students + 1
    end

    def check_pref(course)
        # Check to see if course is in list of preffered courses
        i = -1
        @ranked_courses.each_with_index do |r, idx|
            if course.course_id == r
                i = idx
            end
        end

        # If the course was in the list see if it is preffered
        # TODO add a variable to the class for the index of the currently chosen course
    end

    attr_reader :student_id
    attr_reader :ranked_courses
    attr_accessor :chosen_course
end