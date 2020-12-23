import QtQuick 2.0

Rectangle {
    id: root

    width: 300; height: 400

//![0]
    Component {
        id: dragDelegate

//![1]
        MouseArea {
            id: dragArea

            property bool held: false

            anchors { left: parent.left; right: parent.right }
            height: content.height

            drag.target: held ? content : undefined
            drag.axis: Drag.YAxis

            onPressAndHold: held = true
            onReleased: held = false

            Rectangle {
                id: content
//![1]
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                width: dragArea.width; height: column.implicitHeight + 4

                border.width: 1
                border.color: "lightsteelblue"
//![3]
                color: dragArea.held ? "lightsteelblue" : "white"
                Behavior on color { ColorAnimation { duration: 100 } }
//![3]
                radius: 2
//![4]
                Column {
                    id: column
                    anchors { fill: parent; margins: 2 }

                    Text { text: 'Name: ' + name }
                    Text { text: 'Type: ' + type }
                    Text { text: 'Age: ' + age }
                    Text { text: 'Size: ' + size }
                }

                states: State {
                    when: dragArea.held

                    // 当, 被按住的时候, 脱离原有的 parent, 并且不再进行对齐.
                    ParentChange { target: content; parent: root }
                    AnchorChanges {
                        target: content
                        anchors { horizontalCenter: undefined; verticalCenter: undefined }
                    }
                }
//![2]
            }
        }
//![2]
    }
//![0]

    ListView {
        id: view

        anchors { fill: parent; margins: 2 }

        model: PetsModel {}
        delegate: dragDelegate

        spacing: 4
        cacheBuffer: 50
    }
}
