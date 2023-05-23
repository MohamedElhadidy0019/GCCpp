import subprocess
import sys
import re
import os
from PyQt5.QtWidgets import QApplication, QWidget, QTextEdit, QVBoxLayout, QHBoxLayout, QLabel, QPushButton
import PyQt5
from PyQt5.QtWidgets import (
    QApplication,
    QTextEdit,
    QPushButton,
)
class Window(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Troll Compiler")
        self.symbols_list = []

        # Create the three QTextEdit widgets for the code, quad, and error
        self.code_edit = QTextEdit()
        self.quad_edit =    QTextEdit()
        self.error_edit = QTextEdit()
        self.symbol_edit = QTextEdit()

        # Create the three QLabel widgets for the headers of the code, quad, and error
        self.code_label = QLabel("Code")
        self.quad_label = QLabel("Quadruples")
        self.error_label = QLabel("Error/Syntax")
        self.symbol_label = QLabel("Symbol Table")

        # make it read only
        self.quad_edit.setReadOnly(True)
        self.error_edit.setReadOnly(True)
        self.symbol_edit.setReadOnly(True)

        # Create the QPushButton widget for the compile button
        self.compile_button = QPushButton("Compile")
        self.compile_button.clicked.connect(self.compile)

        self.next_symbol_button = QPushButton("Next Symbol")
        self.next_symbol_button.clicked.connect(self.next_symbol)




        # Create the QVBoxLayout for the code, quad, and error
        code_layout = QVBoxLayout()
        code_layout.addWidget(self.code_label)
        code_layout.addWidget(self.code_edit)

        quad_layout = QVBoxLayout()
        quad_layout.addWidget(self.quad_label)
        quad_layout.addWidget(self.quad_edit)

        error_layout = QVBoxLayout()
        error_layout.addWidget(self.error_label)
        error_layout.addWidget(self.error_edit)

        symbol_layout = QVBoxLayout()
        symbol_layout.addWidget(self.symbol_label)
        symbol_layout.addWidget(self.symbol_edit)


        # Create the QHBoxLayout for the code, quad, and error
        edit_layout = QHBoxLayout()
        edit_layout.addLayout(code_layout)

        edit_layout.addLayout(quad_layout)
        edit_layout.addLayout(error_layout)
        edit_layout.addLayout(symbol_layout)

        # Create the QVBoxLayout for the entire window
        main_layout = QVBoxLayout()
        main_layout.addLayout(edit_layout)
        main_layout.addWidget(self.compile_button)
        main_layout.addWidget(self.next_symbol_button)

        # Set the main layout for the window
        self.setLayout(main_layout)


    def replace_html_entities(self, text):
        """
        Replaces the '<' and '>' characters in a string with their corresponding HTML entities,
        """
        text = text.replace("<", "&lt;")
        text = text.replace(">", "&gt;")
        text = text.replace(" ", "&nbsp;")
        return text


    def syntax_highlight(self, error_list):
        text = self.code_edit.toPlainText()
        txt_temp = ""
        i=0
        for line in text.split('\n'):
            # make it html
            # print(line)
            if i in error_list:
                line = "<font color='red'>" + self.replace_html_entities(line) + "</font>"
            else:
                line = "<font color='black'>" + self.replace_html_entities(line) + "</font>"
            txt_temp += line + '<br>'
            i+=1
        self.code_edit.clear()
        self.code_edit.setHtml(txt_temp)


    def symbol_table_parsing(self, symbol_txt):
        lines_clean = []
        lines = symbol_txt.split('\n')
        for line in lines:
            if not line.startswith('id'):
                lines_clean.append(line)


        string_list = []
        i=0
        while i < len(lines_clean):
            temp_string = ""
            while not lines_clean[i].startswith('=') and i < len(lines_clean):
                temp_string += lines_clean[i] + '\n'
                i+=1

                if(i >= len(lines_clean)):
                    break
            string_list.append(temp_string)
            i+=1



        self.symbols_list = string_list


    def next_symbol(self):
        if len(self.symbols_list) > 0:
            symbol = self.symbols_list.pop(0)
            self.symbol_edit.clear()

            symbol = str(symbol).replace(" ", "")
            symbol = str(symbol).replace("\t", "")
            # print(symbol)
            self.symbol_edit.setText(symbol)
        else:
            self.symbol_edit.setText("No more symbols :)")


    def extract_line_numbers(self, filename):
        """
        Extracts the numbers that follow the word "line" in each line of a text file,
        and returns them as a list of integers.
        """
        line_numbers = []
        with open(filename, "r") as file:
            for line in file:
                matches = re.findall(r"line\s+(\d+)", line)
                if matches:
                    line_numbers.append(int(matches[0])-1)
        return line_numbers



    def compile(self):
        self.symbols_list = []
        # clear
        self.quad_edit.clear()
        self.error_edit.clear()
        self.symbol_edit.clear()


        code = self.code_edit.toPlainText()
        with open("testcases.txt", "w") as f:
            f.write(code)

        # run the script
        current_dir = str(os.getcwd())
        script_dir = current_dir + "/run.sh"
        result = subprocess.run([script_dir])


        with open("error.txt", "r") as f:
            error = f.read()
        self.error_edit.append(error)

        error_list = self.extract_line_numbers("error.txt")

        self.syntax_highlight(error_list)
        if error != "":
            self.quad_edit.setText("Error in code")
            self.symbol_edit.setText("Error in code")
            return


        with open("quad_log.log", "r") as f:
            quad = f.read()
        self.quad_edit.append(quad)


        with open("symbol_table.log", "r") as f:
            symbol_txt = f.read()
        self.symbol_table_parsing(symbol_txt)
        self.next_symbol()


        # TODO take number of errors from error.txt



if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = Window()
    window.show()
    sys.exit(app.exec_())