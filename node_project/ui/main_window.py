from PySide6.QtWidgets import QMainWindow

from ui.canvas import Canvas



class MainWindow(QMainWindow):

    def __init__(self):

        super().__init__()


        self.setWindowTitle(
            "node_project (INTERNAL CLIENT)"
        )


        self.resize(
            1200,
            800
        )


        self.canvas = Canvas()


        self.setCentralWidget(
            self.canvas
        )