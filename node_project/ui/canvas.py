from PySide6.QtCore import Qt, QPoint
from PySide6.QtGui import QBrush
from PySide6.QtWidgets import (
    QGraphicsView,
    QGraphicsScene,
    QGraphicsEllipseItem
)



class Canvas(QGraphicsView):

    def __init__(self, parent=None):

        super().__init__(parent)


        self.scene = QGraphicsScene()

        self.setScene(
            self.scene
        )


        # zoom
        self.zoom_factor = 1.15


        # pan
        self.panning = False
        self.last_mouse_position = QPoint()


        self.setTransformationAnchor(
            QGraphicsView.AnchorUnderMouse
        )


        self.setResizeAnchor(
            QGraphicsView.AnchorUnderMouse
        )


        # fundal
        self.setBackgroundBrush(
            QBrush(Qt.white)
        )


        # TEST OBJECT
        test = QGraphicsEllipseItem(
            -50,
            -50,
            100,
            100
        )


        test.setBrush(
            QBrush(Qt.red)
        )


        self.scene.addItem(
            test
        )



    def wheelEvent(self, event):

        if event.angleDelta().y() > 0:

            factor = self.zoom_factor

        else:

            factor = 1 / self.zoom_factor


        self.scale(
            factor,
            factor
        )



    def mousePressEvent(self, event):

        item = self.itemAt(
            event.position().toPoint()
        )


        if (
            event.button() == Qt.LeftButton
            and item is None
        ):

            self.panning = True


            self.last_mouse_position = (
                event.position().toPoint()
            )


            self.setCursor(
                Qt.ClosedHandCursor
            )


            event.accept()

            return


        super().mousePressEvent(event)



    def mouseMoveEvent(self, event):

        if self.panning:

            delta = (
                event.position().toPoint()
                -
                self.last_mouse_position
            )


            self.last_mouse_position = (
                event.position().toPoint()
            )


            self.horizontalScrollBar().setValue(
                self.horizontalScrollBar().value()
                -
                delta.x()
            )


            self.verticalScrollBar().setValue(
                self.verticalScrollBar().value()
                -
                delta.y()
            )


            event.accept()

            return


        super().mouseMoveEvent(event)



    def mouseReleaseEvent(self, event):

        if event.button() == Qt.LeftButton:

            self.panning = False


            self.setCursor(
                Qt.ArrowCursor
            )


        super().mouseReleaseEvent(event)