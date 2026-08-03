import sys

from PySide6.QtCore import Qt
from PySide6.QtGui import QBrush, QPen
from PySide6.QtWidgets import (
    QApplication,
    QMainWindow,
    QWidget,
    QPushButton,
    QHBoxLayout,
    QVBoxLayout,
    QGraphicsView,
    QGraphicsScene,
    QGraphicsTextItem,
    QGraphicsItem
)



class MapView(QGraphicsView):

    def __init__(self, scene):
        super().__init__(scene)

        self.zoom_factor = 1.0

        self.panning = False
        self.last_mouse_position = None


        self.setTransformationAnchor(
            QGraphicsView.AnchorUnderMouse
        )



    def wheelEvent(self, event):

        zoom = 1.15


        if event.angleDelta().y() > 0:
            factor = zoom

        else:
            factor = 1 / zoom


        self.zoom_factor *= factor


        self.scale(
            factor,
            factor
        )



    def mousePressEvent(self, event):

        item = self.itemAt(
            event.position().toPoint()
        )


        # zona libera
        if (
            event.button() == Qt.LeftButton
            and item is None
        ):

            self.panning = True

            self.last_mouse_position = (
                event.position()
            )

            self.setCursor(
                Qt.ClosedHandCursor
            )

            event.accept()

            return


        # nod
        super().mousePressEvent(event)



    def mouseMoveEvent(self, event):

        if self.panning:

            delta = (
                event.position()
                -
                self.last_mouse_position
            )


            self.last_mouse_position = (
                event.position()
            )


            self.horizontalScrollBar().setValue(
                self.horizontalScrollBar().value()
                -
                int(delta.x())
            )


            self.verticalScrollBar().setValue(
                self.verticalScrollBar().value()
                -
                int(delta.y())
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







class NodeItem(QGraphicsItem):

    def __init__(self, title):

        super().__init__()


        self.width = 180
        self.height = 70



        self.text = QGraphicsTextItem(
            title,
            self
        )


        self.text.setPos(
            -70,
            -10
        )



        self.setFlag(
            QGraphicsItem.ItemIsMovable,
            True
        )


        self.setFlag(
            QGraphicsItem.ItemIsSelectable,
            True
        )




    def boundingRect(self):

        return (
            -self.width / 2,
            -self.height / 2,
            self.width,
            self.height
        )



    def paint(
        self,
        painter,
        option,
        widget=None
    ):

        if self.isSelected():

            painter.setPen(
                QPen(Qt.blue, 3)
            )

        else:

            painter.setPen(
                QPen(Qt.black, 1)
            )


        painter.setBrush(
            QBrush(Qt.white)
        )


        painter.drawRoundedRect(
            -self.width / 2,
            -self.height / 2,
            self.width,
            self.height,
            10,
            10
        )








class MindMapWindow(QMainWindow):

    def __init__(self):

        super().__init__()


        self.setWindowTitle(
            "node_project (INTERNAL CLIENT)"
        )


        self.resize(
            1000,
            700
        )



        main = QWidget()

        self.setCentralWidget(main)



        layout = QVBoxLayout(main)



        toolbar = QHBoxLayout()


        self.new_button = QPushButton("New")
        self.open_button = QPushButton("Open")
        self.save_button = QPushButton("Save")



        toolbar.addWidget(
            self.new_button
        )

        toolbar.addWidget(
            self.open_button
        )

        toolbar.addWidget(
            self.save_button
        )


        layout.addLayout(toolbar)



        self.scene = QGraphicsScene()



        self.canvas = MapView(
            self.scene
        )


        layout.addWidget(
            self.canvas
        )



        self.create_node(
            0,
            0,
            "New Mind Map"
        )





    def create_node(
        self,
        x,
        y,
        title
    ):

        node = NodeItem(
            title
        )


        node.setPos(
            x,
            y
        )


        self.scene.addItem(
            node
        )







app = QApplication(sys.argv)


window = MindMapWindow()

window.show()


sys.exit(
    app.exec()
)