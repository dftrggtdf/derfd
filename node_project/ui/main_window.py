from PySide6.QtWidgets import (
    QMainWindow,
    QMessageBox
)

from ui.canvas import Canvas
from ui.node_item import NodeItem
from ui.edge_item import EdgeItem


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


        # Toate edge-urile din harta curenta

        self.edges = []


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


        node.position_changed.connect(
            self.update_edges
        )


        self.canvas.scene.addItem(
            node
        )


        node.setPos(
            -90,
            -35
        )



    def create_child(
        self,
        parent
    ):

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


        child.position_changed.connect(
            self.update_edges
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


        # Cream linia dintre parent si child

        edge = EdgeItem(
            parent,
            child
        )


        self.canvas.scene.addItem(
            edge
        )


        self.edges.append(
            edge
        )


        # Linia sta in spatele nodurilor

        edge.setZValue(
            -1
        )



    def update_edges(self):

        for edge in self.edges:

            if (
                edge.parent_node.scene() is not None
                and
                edge.child_node.scene() is not None
            ):

                edge.update_position()



    def delete_node(
        self,
        node
    ):

        # Daca nodul are copii,
        # cerem doua confirmari.

        if node.children:

            first = QMessageBox.question(
                self,
                "Confirm deletion",
                "This node has children.\n"
                "Delete this node and all descendants?",
                QMessageBox.Yes
                |
                QMessageBox.No,
                QMessageBox.No
            )


            if first != QMessageBox.Yes:

                return


            second = QMessageBox.question(
                self,
                "Confirm deletion again",
                "Are you sure?\n"
                "This action cannot be undone.",
                QMessageBox.Yes
                |
                QMessageBox.No,
                QMessageBox.No
            )


            if second != QMessageBox.Yes:

                return


        # Dupa confirmare,
        # stergem fara alte confirmari.

        self._delete_node_recursive(
            node
        )



    def _delete_node_recursive(
        self,
        node
    ):

        # Facem copie deoarece lista
        # se modifica in timpul stergerii.

        children = list(
            node.children
        )


        # Stergem copiii.

        for child in children:

            self._delete_node_recursive(
                child
            )


        # Gasim toate edge-urile
        # conectate la acest nod.

        related_edges = []


        for edge in self.edges:

            if (
                edge.parent_node is node
                or
                edge.child_node is node
            ):

                related_edges.append(
                    edge
                )


        # Stergem edge-urile.

        for edge in related_edges:

            if edge.scene():

                edge.scene().removeItem(
                    edge
                )


            if edge in self.edges:

                self.edges.remove(
                    edge
                )


        # Scoatem nodul din parinte.

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


        # Curatam relatiile.

        node.children.clear()

        node.parent_node = None


        # Eliberam obiectul.

        node.deleteLater()