from PySide6.QtCore import Qt, QLineF
from PySide6.QtGui import QPen
from PySide6.QtWidgets import QGraphicsLineItem


class EdgeItem(QGraphicsLineItem):

    def __init__(self, parent_node, child_node):

        super().__init__()

        self.parent_node = parent_node
        self.child_node = child_node

        self.setPen(
            QPen(
                Qt.black,
                2
            )
        )

        self.setZValue(
            -1
        )

        self.update_position()


    def update_position(self):

        if (
            self.parent_node.scene() is None
            or
            self.child_node.scene() is None
        ):

            return

        parent_center = (
            self.parent_node.sceneBoundingRect().center()
        )

        child_center = (
            self.child_node.sceneBoundingRect().center()
        )

        self.setLine(
            QLineF(
                parent_center,
                child_center
            )
        )