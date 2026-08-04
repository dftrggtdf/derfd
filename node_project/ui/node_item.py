from PySide6.QtCore import Qt, QRectF, QPointF
from PySide6.QtGui import QBrush, QPen, QFont
from PySide6.QtWidgets import (
    QGraphicsItem,
    QGraphicsTextItem,
    QGraphicsObject
)


class NodeItem(QGraphicsObject):

    def __init__(self, title="New Mind Map"):

        super().__init__()


        self.width = 180
        self.height = 70


        self.dragging = False
        self.drag_offset = QPointF()



        self.text = QGraphicsTextItem(
            title,
            self
        )


        self.text.setFont(
            QFont("Arial", 12)
        )


        self.text.setDefaultTextColor(
            Qt.black
        )


        self.text.setPos(
            20,
            22
        )


        # selectare doar
        self.setFlag(
            QGraphicsItem.ItemIsSelectable,
            True
        )


        # important:
        # textul nu mai fura mouse-ul

        self.text.setAcceptedMouseButtons(
            Qt.NoButton
        )




    def boundingRect(self):

        return QRectF(
            0,
            0,
            self.width,
            self.height
        )




    def paint(self, painter, option, widget=None):

        if self.isSelected():

            painter.setPen(
                QPen(Qt.blue, 3)
            )

        else:

            painter.setPen(
                QPen(Qt.black, 2)
            )


        painter.setBrush(
            QBrush(Qt.white)
        )


        painter.drawRoundedRect(
            self.boundingRect(),
            12,
            12
        )





    def mousePressEvent(self, event):

        if event.button() == Qt.LeftButton:

            self.dragging = True


            self.drag_offset = (
                event.scenePos()
                -
                self.scenePos()
            )


            self.setSelected(True)


            event.accept()

            return



        super().mousePressEvent(event)






    def mouseMoveEvent(self, event):

        if self.dragging:

            self.setPos(
                event.scenePos()
                -
                self.drag_offset
            )


            event.accept()

            return



        super().mouseMoveEvent(event)






    def mouseReleaseEvent(self, event):

        if event.button() == Qt.LeftButton:

            self.dragging = False


            event.accept()

            return



        super().mouseReleaseEvent(event)