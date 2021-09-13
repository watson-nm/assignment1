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
    @chosen_id # The id of the course the student is enrolled in
    @chosen_rank # TODO get rank from array

    def initialize(student_id)
        @student_id = student_id
        # TODO put a loop here to fill the array of ranked courses
    end

    # This function adds a stuent to a course
    def choose_course(course)
        # If there is a course set, remove the student from that course
        if chosen_course.nil? != true
            @chosen_course.num_students = @chosen_course.num_students - 1
        end

        # Add student to new course
        @chosen_course = course
        @chosen_id = @choose_course.course_id
        @choose_rank # TODO get rank from array
        @chosen_course.num_students = @chosen_course.num_students + 1
    end

    # This function will check if a course is listed in preffered courses
    # If it is listed then you get the ranking of course
    # If not then you get -1
    def check_if_listed(course)
        # Check to see if this course is in list of preffered courses
        idx = -1 # This will take the ranking of the course if found in the ranking list
        @ranked_courses.each_with_index do |ranked_course_id, ranked_course_idx|
            if course.course_id == ranked_course_id
                idx = ranked_course_idx
                break
            end
        end

        return idx
    end

    # Check to see if new course preffered
    # If it is, then return true
    # If it isn't, then return false
    def check_if_preffered(idx)
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
            # Check to see if course is in list of preffered courses
            i = -1 # This will take the ranking of the course if found in the ranking list
            @ranked_courses.each_with_index do |cid, idx|
                if course.course_id == cid
                    i = idx
                end
            end

            # If the course was in the list see if it is preffered
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
                    # The new course is preffered
                    choose_course(course)
                end
            end
        end
    end

    attr_reader :student_id
    attr_reader :ranked_courses
    attr_accessor :chosen_course
end