from PySide6.QtCore import QPointF
from PySide6.QtGui import QShortcut, QKeySequence
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


        self.edges = []


        self.horizontal_spacing = 280

        self.vertical_spacing = 110


        # Undo / Redo

        self.undo_stack = []

        self.redo_stack = []

        self.history_locked = False


        # Root

        node = NodeItem(
            "New Mind Map"
        )


        self.connect_node(
            node
        )


        self.canvas.scene.addItem(
            node
        )


        node.setPos(
            -90,
            -35
        )


        self.root_node = node


        self.canvas.centerOn(
            node
        )


        # Ctrl + Z

        self.undo_shortcut = QShortcut(
            QKeySequence("Ctrl+Z"),
            self
        )

        self.undo_shortcut.activated.connect(
            self.undo
        )


        # Ctrl + Y

        self.redo_shortcut = QShortcut(
            QKeySequence("Ctrl+Y"),
            self
        )

        self.redo_shortcut.activated.connect(
            self.redo
        )


    def connect_node(
        self,
        node
    ):

        node.add_child_requested.connect(
            self.create_child
        )

        node.delete_requested.connect(
            self.delete_node
        )

        node.position_changed.connect(
            self.update_edges
        )

        node.rename_started.connect(
            self.rename_started
        )


    # ----------------------------------------
    # HISTORY
    # ----------------------------------------

    def take_snapshot(self):

        nodes = self.all_nodes()

        snapshot = []


        for node in nodes:

            snapshot.append(
                {
                    "node": node,

                    "title":
                        node.text.toPlainText(),

                    "position":
                        QPointF(
                            node.pos()
                        ),

                    "parent":
                        node.parent_node
                }
            )


        return snapshot


    def all_nodes(self):

        result = []


        for item in self.canvas.scene.items():

            if isinstance(
                item,
                NodeItem
            ):

                result.append(
                    item
                )


        return result


    def save_history(self):

        if self.history_locked:

            return


        self.undo_stack.append(
            self.take_snapshot()
        )


        self.redo_stack.clear()


    # ----------------------------------------
    # RENAME
    # ----------------------------------------

    def rename_started(
        self,
        node
    ):

        # Snapshot-ul este facut
        # inainte ca numele sa fie schimbat.

        self.save_history()


    # ----------------------------------------
    # ADD CHILD
    # ----------------------------------------

    def create_child(
        self,
        parent
    ):

        self.save_history()


        child = NodeItem(
            "New Node",
            parent_node=parent
        )


        parent.children.append(
            child
        )


        self.connect_node(
            child
        )


        self.canvas.scene.addItem(
            child
        )


        child_index = (
            len(parent.children) - 1
        )


        child_count = (
            len(parent.children)
        )


        total_height = (
            (child_count - 1)
            *
            self.vertical_spacing
        )


        first_y = (
            parent.y()
            -
            total_height / 2
        )


        child.setPos(
            parent.x()
            +
            self.horizontal_spacing,

            first_y
            +
            child_index
            *
            self.vertical_spacing
        )


        self.arrange_children(
            parent
        )


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


        self.update_edges()


    # ----------------------------------------
    # ARRANGE CHILDREN
    # ----------------------------------------

    def arrange_children(
        self,
        parent
    ):

        children = list(
            parent.children
        )


        if not children:

            return


        count = len(
            children
        )


        total_height = (
            (count - 1)
            *
            self.vertical_spacing
        )


        first_y = (
            parent.y()
            -
            total_height / 2
        )


        for index, child in enumerate(
            children
        ):

            new_x = (
                parent.x()
                +
                self.horizontal_spacing
            )


            new_y = (
                first_y
                +
                index
                *
                self.vertical_spacing
            )


            old_position = (
                child.pos()
            )


            delta = QPointF(
                new_x
                -
                old_position.x(),

                new_y
                -
                old_position.y()
            )


            child.setPos(
                new_x,
                new_y
            )


            if (
                delta.x() != 0
                or
                delta.y() != 0
            ):

                child.move_descendants(
                    delta
                )


    # ----------------------------------------
    # DELETE
    # ----------------------------------------

    def delete_node(
        self,
        node
    ):

        if node is self.root_node:

            QMessageBox.warning(
                self,
                "node_project",
                "The root node cannot be deleted."
            )

            return


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


        self.save_history()


        self._delete_node_recursive(
            node
        )


        self.update_edges()


    def _delete_node_recursive(
        self,
        node
    ):

        children = list(
            node.children
        )


        for child in children:

            self._delete_node_recursive(
                child
            )


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


        if node.parent_node is not None:

            if node in node.parent_node.children:

                node.parent_node.children.remove(
                    node
                )


        if node.scene():

            node.scene().removeItem(
                node
            )


        node.children.clear()

        node.parent_node = None

        node.deleteLater()


    # ----------------------------------------
    # EDGES
    # ----------------------------------------

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


    # ----------------------------------------
    # UNDO
    # ----------------------------------------

    def undo(self):

        if not self.undo_stack:

            return


        current = (
            self.take_snapshot()
        )


        previous = (
            self.undo_stack.pop()
        )


        self.redo_stack.append(
            current
        )


        self.restore_snapshot(
            previous
        )


    # ----------------------------------------
    # REDO
    # ----------------------------------------

    def redo(self):

        if not self.redo_stack:

            return


        current = (
            self.take_snapshot()
        )


        next_state = (
            self.redo_stack.pop()
        )


        self.undo_stack.append(
            current
        )


        self.restore_snapshot(
            next_state
        )


    # ----------------------------------------
    # RESTORE
    # ----------------------------------------

    def restore_snapshot(
        self,
        snapshot
    ):

        self.history_locked = True


        # Stergem edge-urile

        for edge in list(
            self.edges
        ):

            if edge.scene():

                edge.scene().removeItem(
                    edge
                )


        self.edges.clear()


        # Stergem nodurile actuale

        current_nodes = self.all_nodes()


        for node in current_nodes:

            if node.scene():

                node.scene().removeItem(
                    node
                )


            node.deleteLater()


        # Cream nodurile noi

        old_to_new = {}


        for data in snapshot:

            old_node = data["node"]


            new_node = NodeItem(
                data["title"]
            )


            new_node.setPos(
                data["position"]
            )


            old_to_new[
                old_node
            ] = new_node


            self.canvas.scene.addItem(
                new_node
            )


        # Refacem relatiile parent / child

        for data in snapshot:

            old_node = data["node"]

            new_node = old_to_new[
                old_node
            ]


            old_parent = data["parent"]


            if old_parent is not None:

                new_parent = (
                    old_to_new.get(
                        old_parent
                    )
                )


                if new_parent is not None:

                    new_node.parent_node = (
                        new_parent
                    )


                    new_parent.children.append(
                        new_node
                    )


        # Gasim root

        for data in snapshot:

            if data["parent"] is None:

                self.root_node = (
                    old_to_new[
                        data["node"]
                    ]
                )

                break


        # Reconectam semnalele

        for node in self.all_nodes():

            self.connect_node(
                node
            )


        # Recream edge-urile

        for node in self.all_nodes():

            for child in node.children:

                edge = EdgeItem(
                    node,
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


        self.update_edges()


        self.history_locked = False