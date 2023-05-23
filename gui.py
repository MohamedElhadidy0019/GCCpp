import sys
import subprocess
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

    def syntax_highlight(self, error_list):
        text = self.code_edit.toPlainText()
        txt_temp = ""
        i=0
        for line in text.split('\n'):
            # make it html
            if i in error_list:
                line = "<font color='red'>" + line + "</font>"
            else:
                line = "<font color='black'>" + line + "</font>"
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

        # print("len of lines clean: ", len(lines_clean))

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


        # print("len of string list: ", len(string_list) )
        # for string in string_list:
        #     print(string)
            # print('yaaaaay')

        self.symbols_list = string_list


    def next_symbol(self):
        if len(self.symbols_list) > 0:
            symbol = self.symbols_list.pop(0)
            self.symbol_edit.clear()
            self.symbol_edit.setText(symbol)
        else:
            self.symbol_edit.setText("No more symbols :)")


        pass

    def compile(self):

        # clear
        self.quad_edit.clear()
        self.error_edit.clear()
        self.symbol_edit.clear()


        # Get the text from the code edit
        code = self.code_edit.toPlainText()
        # dump it to a file
        with open("code.txt", "w") as f:
            f.write(code)

        # run the script
        current_dir = str(os.getcwd())
        script_dir = current_dir + "/troll.sh"
        result = subprocess.run([script_dir])


        with open("quad.txt", "r") as f:
            quad = f.read()
        self.quad_edit.append(quad)

        with open("error.txt", "r") as f:
            error = f.read()
        self.error_edit.append(error)

        with open("symbol_table.log", "r") as f:
            symbol_txt = f.read()
        self.symbol_table_parsing(symbol_txt)
        self.next_symbol()


        # TODO take number of errors from error.txt
        error_list = [0,3,5]
        self.syntax_highlight(error_list)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = Window()
    window.show()
    sys.exit(app.exec_())