from PySide6.QtWidgets import QMainWindow

from ui.canvas import Canvas
from ui.node_item import NodeItem



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



        # root node

        node = NodeItem(
            "New Mind Map"
        )


        # pozitia root-ului

        node.setPos(
            -90,
            -35
        )


        self.canvas.scene.addItem(
            node
        )