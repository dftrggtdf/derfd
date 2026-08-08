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

        # Toate edge-urile
        self.edges = []

        # Distantele layout-ului
        self.horizontal_spacing = 250
        self.vertical_spacing = 100

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

        self.root_node = node


    def create_child(
        self,
        parent
    ):

        child = NodeItem(
            "New Node",
            parent_node=parent
        )

        # Salvam copilul
        parent.children.append(
            child
        )

        # Conectam actiunile
        child.add_child_requested.connect(
            self.create_child
        )

        child.delete_requested.connect(
            self.delete_node
        )

        child.position_changed.connect(
            self.update_edges
        )

        # Adaugam in scena
        self.canvas.scene.addItem(
            child
        )

        # Pozitia initiala nu mai este importanta,
        # deoarece layout-ul o va calcula.
        child.setPos(
            parent.pos()
        )

        # Cream edge-ul
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

        edge.setZValue(
            -1
        )

        # Recalculam tot arborele
        self.layout_tree()

        self.update_edges()


    def layout_tree(self):

        if self.root_node is None:
            return

        # Numarul total de niveluri
        levels = {}

        self.collect_levels(
            self.root_node,
            0,
            levels
        )

        # Pozitionam fiecare nivel
        for level in sorted(levels.keys()):

            nodes = levels[level]

            count = len(nodes)

            total_height = (
                (count - 1)
                *
                self.vertical_spacing
            )

            start_y = (
                -total_height / 2
            )

            for index, node in enumerate(nodes):

                x = (
                    level
                    *
                    self.horizontal_spacing
                )

                y = (
                    start_y
                    +
                    index
                    *
                    self.vertical_spacing
                )

                # Root-ul ramane reperul.
                # Nivelurile sunt construite in jurul lui.

                node.setPos(
                    x,
                    y
                )

        # Punem root-ul aproape de centru
        self.root_node.setPos(
            0,
            0
        )

        self.update_edges()


    def collect_levels(
        self,
        node,
        level,
        levels
    ):

        if level not in levels:

            levels[level] = []

        levels[level].append(
            node
        )

        for child in node.children:

            self.collect_levels(
                child,
                level + 1,
                levels
            )


    def update_edges(self):

        for edge in self.edges:

            if (
                edge.parent_node.scene()
                is not None
                and
                edge.child_node.scene()
                is not None
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

        self._delete_node_recursive(
            node
        )

        # Rearanjam ce a ramas
        self.layout_tree()


    def _delete_node_recursive(
        self,
        node
    ):

        # Copie pentru ca lista se modifica
        children = list(
            node.children
        )

        for child in children:

            self._delete_node_recursive(
                child
            )

        # Stergem edge-urile asociate

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

        for edge in related_edges:

            if edge.scene():

                edge.scene().removeItem(
                    edge
                )

            if edge in self.edges:

                self.edges.remove(
                    edge
                )

        # Scoatem nodul din parent

        if node.parent_node is not None:

            if node in node.parent_node.children:

                node.parent_node.children.remove(
                    node
                )

        # Scoatem din scena

        if node.scene():

            node.scene().removeItem(
                node
            )

        node.children.clear()

        node.parent_node = None

        node.deleteLater()