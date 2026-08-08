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

        # Root node

        node = NodeItem(
            "New Mind Map"
        )

        node.add_child_requested.connect(
            self.create_child
        )

        node.delete_requested.connect(
            self.delete_node
        )

        self.canvas.scene.addItem(
            node
        )

        node.setPos(
            -90,
            -35
        )


    def create_child(self, parent):

        child = NodeItem(
            "New Node",
            parent_node=parent
        )

        # Salvam copilul in parinte

        parent.children.append(
            child
        )

        # Conectam actiunile copilului

        child.add_child_requested.connect(
            self.create_child
        )

        child.delete_requested.connect(
            self.delete_node
        )

        # Adaugam copilul in scena

        self.canvas.scene.addItem(
            child
        )

        # Pozitie temporara

        child.setPos(
            parent.x() + 250,
            parent.y()
        )


    def delete_node(self, node):

        # Facem o copie a listei,
        # deoarece o vom modifica in timpul stergerii.

        children = list(
            node.children
        )

        # Stergem toti copiii si descendentii lor.

        for child in children:

            self.delete_node(
                child
            )

        # Scoatem nodul din lista parintelui.

        if node.parent_node is not None:

            if node in node.parent_node.children:

                node.parent_node.children.remove(
                    node
                )

        # Scoatem nodul din scena.

        if node.scene():

            node.scene().removeItem(
                node
            )

        # Curatam relatiile interne.

        node.children.clear()

        node.parent_node = None

        # Eliberam obiectul Qt.

        node.deleteLater()