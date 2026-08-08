from PySide6.QtCore import (
    Qt,
    QRectF,
    QPointF,
    Signal
)

from PySide6.QtGui import (
    QBrush,
    QPen,
    QFont
)

from PySide6.QtWidgets import (
    QGraphicsItem,
    QGraphicsTextItem,
    QGraphicsObject,
    QLineEdit,
    QGraphicsProxyWidget,
    QMessageBox,
    QMenu
)

from errors import get_error


class NodeItem(QGraphicsObject):

    add_child_requested = Signal(object)
    delete_requested = Signal(object)
    position_changed = Signal()
    rename_finished = Signal(object, str, str)


    def __init__(
        self,
        title="New Mind Map",
        parent_node=None
    ):

        super().__init__()

        self.width = 180
        self.height = 70

        self.dragging = False
        self.drag_offset = QPointF()

        self.editor_proxy = None

        self.parent_node = parent_node
        self.children = []

        self.text = QGraphicsTextItem(
            title,
            self
        )

        self.text.setFont(
            QFont(
                "Monospace",
                10
            )
        )

        self.text.setDefaultTextColor(
            Qt.black
        )

        self.text.setPos(
            20,
            22
        )

        self.setFlag(
            QGraphicsItem.ItemIsSelectable,
            True
        )

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


    def paint(
        self,
        painter,
        option,
        widget=None
    ):

        if self.isSelected():

            painter.setPen(
                QPen(
                    Qt.blue,
                    3
                )
            )

        else:

            painter.setPen(
                QPen(
                    Qt.black,
                    2
                )
            )

        painter.setBrush(
            QBrush(
                Qt.white
            )
        )

        painter.drawRoundedRect(
            self.boundingRect(),
            12,
            12
        )


    def mousePressEvent(
        self,
        event
    ):

        if self.editor_proxy is not None:

            QMessageBox.warning(
                None,
                "node_project",
                get_error("ERR001")
            )

            event.ignore()

            return


        if event.button() == Qt.LeftButton:

            self.dragging = True

            self.drag_offset = (
                event.scenePos()
                -
                self.scenePos()
            )

            self.setSelected(
                True
            )

            event.accept()

            return


        super().mousePressEvent(
            event
        )


    def mouseMoveEvent(
        self,
        event
    ):

        if self.editor_proxy is not None:

            event.ignore()

            return


        if self.dragging:

            old_position = self.scenePos()

            new_position = (
                event.scenePos()
                -
                self.drag_offset
            )

            delta = (
                new_position
                -
                old_position
            )

            self.setPos(
                new_position
            )

            if (
                delta.x() != 0
                or
                delta.y() != 0
            ):

                self.move_descendants(
                    delta
                )

            self.position_changed.emit()

            event.accept()

            return


        super().mouseMoveEvent(
            event
        )


    def move_descendants(
        self,
        delta
    ):

        for child in self.children:

            child.setPos(
                child.pos()
                +
                delta
            )

            child.move_descendants(
                delta
            )


    def mouseReleaseEvent(
        self,
        event
    ):

        if event.button() == Qt.LeftButton:

            was_dragging = self.dragging

            self.dragging = False

            if was_dragging:

                self.position_changed.emit()

            event.accept()

            return


        super().mouseReleaseEvent(
            event
        )


    def mouseDoubleClickEvent(
        self,
        event
    ):

        if event.button() == Qt.LeftButton:

            self.start_rename()

            event.accept()

            return


        super().mouseDoubleClickEvent(
            event
        )


    def contextMenuEvent(
        self,
        event
    ):

        menu = QMenu()

        rename_action = menu.addAction(
            "Rename"
        )

        add_child_action = menu.addAction(
            "Add Child"
        )

        delete_action = menu.addAction(
            "Delete"
        )

        action = menu.exec(
            event.screenPos()
        )

        if action == rename_action:

            self.start_rename()

        elif action == add_child_action:

            self.add_child_requested.emit(
                self
            )

        elif action == delete_action:

            self.delete_requested.emit(
                self
            )


    def start_rename(self):

        if self.editor_proxy is not None:

            return

        old_text = (
            self.text.toPlainText()
        )

        self.text.hide()

        editor = QLineEdit()

        editor.setText(
            old_text
        )

        editor.selectAll()

        editor.returnPressed.connect(
            self.finish_rename
        )

        self.editor_proxy = QGraphicsProxyWidget(
            self
        )

        self.editor_proxy.setWidget(
            editor
        )

        self.editor_proxy.setPos(
            15,
            15
        )

        editor.setFocus(
            Qt.OtherFocusReason
        )


    def finish_rename(self):

        if self.editor_proxy is None:

            return

        editor = (
            self.editor_proxy.widget()
        )

        old_text = (
            self.text.toPlainText()
        )

        new_text = (
            editor.text()
        )

        self.text.setPlainText(
            new_text
        )

        self.text.show()

        self.editor_proxy.setWidget(
            None
        )

        self.editor_proxy.deleteLater()

        self.editor_proxy = None

        if old_text != new_text:

            self.rename_finished.emit(
                self,
                old_text,
                new_text
            )