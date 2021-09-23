# CSC-415 Assignment1

How to run the program:
- Navigate to the directory containing the `assignment1.rb` file and input files
- In the terminal run `ruby assignment1.rb`
- When prompted intput
    - Number of FYS courses being offered, e.g., `80`
    - Number of students in the incoming class, e.g., `1600`
    - Name of csv input file containing list of FYS courses being offered, e.g., `courses.csv`
    - Name of csv input file containing list of students and their FYS selections, e.g., `selections.csv`

Known bugs, issues, limitations, etc.:
- The first two user inputs are not actually used in the code.
- An additonal output file `input-nums.txt` tells user if their numerical input matched the file
- When entering file names, if the file does not exist in the directory the program will ask the user for another input
- When entering file names, if the file does not end with `.csv` the program will ask the user for another input
- All students should be placed in courses, except for when the number of students exceeds the number of courses times 18
- All courses should be able to run, except for when the number of students is less than number of courses times 10
- When the program is run the output files `output-1.txt`, `output-2.txt`, `output-3.txt` and `input-nums.txt` will be overwriten with new information