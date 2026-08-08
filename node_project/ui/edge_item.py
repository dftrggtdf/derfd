from PySide6.QtCore import Qt, QLineF, QPointF
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

        self.setZValue(-1)

        self.update_position()


    def update_position(self):

        if (
            self.parent_node.scene() is None
            or
            self.child_node.scene() is None
        ):

            return


        parent_rect = (
            self.parent_node.sceneBoundingRect()
        )

        child_rect = (
            self.child_node.sceneBoundingRect()
        )


        parent_center = parent_rect.center()
        child_center = child_rect.center()


        line = QLineF(
            parent_center,
            child_center
        )


        if line.length() == 0:

            return


        # Vector normalizat

        dx = line.dx()
        dy = line.dy()

        length = line.length()

        dx /= length
        dy /= length


        # Jumatatea dimensiunilor nodurilor

        parent_half_width = (
            parent_rect.width() / 2
        )

        parent_half_height = (
            parent_rect.height() / 2
        )

        child_half_width = (
            child_rect.width() / 2
        )

        child_half_height = (
            child_rect.height() / 2
        )


        # Distanta pana la marginea dreptunghiului

        parent_distance = min(
            parent_half_width / abs(dx)
            if dx != 0 else float("inf"),

            parent_half_height / abs(dy)
            if dy != 0 else float("inf")
        )


        child_distance = min(
            child_half_width / abs(dx)
            if dx != 0 else float("inf"),

            child_half_height / abs(dy)
            if dy != 0 else float("inf")
        )


        start = QPointF(
            parent_center.x()
            +
            dx * parent_distance,

            parent_center.y()
            +
            dy * parent_distance
        )


        end = QPointF(
            child_center.x()
            -
            dx * child_distance,

            child_center.y()
            -
            dy * child_distance
        )


        self.setLine(
            QLineF(
                start,
                end
            )
        )