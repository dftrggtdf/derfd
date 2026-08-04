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


        self.scene = QGraphicsScene(
            -50000,
            -50000,
            100000,
            100000
        )


        self.setScene(
            self.scene
        )


        self.zoom_factor = 1.15


        self.panning = False

        self.last_mouse_position = QPoint()



        self.setTransformationAnchor(
            QGraphicsView.AnchorUnderMouse
        )


        self.setBackgroundBrush(
            QBrush(Qt.white)
        )



        # obiect de test temporar
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

        if event.button() == Qt.LeftButton:


            item = self.itemAt(
                event.position().toPoint()
            )


            # pan doar pe zona libera

            if item is None:

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


            current = (
                event.position().toPoint()
            )


            delta = (
                current
                -
                self.last_mouse_position
            )


            self.last_mouse_position = current



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


            event.accept()

            return



        super().mouseReleaseEvent(event)