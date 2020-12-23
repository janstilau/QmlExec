import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Layouts 1.11
import QtQuick.Window 2.11

ItemDelegate {
    id: root
    width: parent.width
    checkable: true
    /*
      ItemDelegate 是继承自 button 的, 所以, 点击可以设置 checked 状态.
      这个状态, 直接影响到下面几个控件的可见性.
      当 Item 的高度变化的时候, 会自动拉伸 ListView 的可滚动范围, 使得 ListView 可以响应数据的变化.
      通过值绑定的方式, List 会自动调整空间的长度.
      */

    onClicked: ListView.view.currentIndex = index // index 的值, 可以在这里获取.

    contentItem: ColumnLayout {
        spacing: 0

        RowLayout {
            id: topVisibleCard
            ColumnLayout {
                id: dateColumn

                readonly property date alarmDate: new Date(
                    model.year, model.month - 1, model.day, model.hour, model.minute)

                Label {
                    id: timeLabel
                    font.pixelSize: Qt.application.font.pixelSize * 2
                    text: dateColumn.alarmDate.toLocaleTimeString(window.locale, Locale.ShortFormat)
                }

                RowLayout {
                    Label {
                        id: dateLabel
                        text: dateColumn.alarmDate.toLocaleDateString(window.locale, Locale.ShortFormat)
                    }
                    Label {
                        id: alarmAbout
                        text: "⸱ " + model.label
                        visible: model.label.length > 0 && !root.checked
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: "yellow"
                    opacity: 0.3
                    border.width: 2
                    border.color: "red"
                }
            }

            // 中间的 spacingStretch, 占据所有可以占据的控件
            Item {
                Layout.fillWidth: true
                Rectangle {
                    anchors.fill: parent
                    color: "yellow"
                    opacity: 0.3
                    border.width: 2
                    border.color: "red"
                }
            }

            Switch {
                checked: model.activated
                Layout.alignment: Qt.AlignTop
                onClicked: model.activated = checked

                Rectangle {
                    anchors.fill: parent
                    color: "yellow"
                    opacity: 0.3
                    border.width: 2
                    border.color: "red"
                }
            }
        }

        // action -> model 变化 -> view 变化.
        // 核心还是 model 的变化, view 的 bind 的机制, 使得 view 的同步, 在 Qml 里面变得很简单.
        CheckBox {
            id: alarmRepeat
            text: qsTr("Repeat")
            checked: model.repeat
            visible: root.checked
            onToggled: model.repeat = checked
        }

        // 大量的使用了 View data binding 的技术, 操作数据, 直接影响到了view.
        // 使用 Flow, 使得高度可以自变化.
        Flow {
            visible: root.checked && model.repeat
            Layout.fillWidth: true

            Repeater {
                id: dayRepeater
                model: daysToRepeat
                delegate: RoundButton {
                    text: Qt.locale().dayName(model.dayOfWeek, Locale.NarrowFormat)
                    flat: true
                    checked: model.repeat
                    checkable: true
                    Material.background: checked ? Material.accent : "transparent"
                    onToggled: model.repeat = checked
                }
            }
        }

        TextField {
            id: alarmDescriptionTextField
            placeholderText: qsTr("Enter description here")
            cursorVisible: true
            visible: root.checked
            text: model.label
            onTextEdited: model.label = text
        }
        Button {
            id: deleteAlarmButton
            text: qsTr("Delete")
            width: 40
            height: 40
            visible: root.checked
            onClicked: root.ListView.view.model.remove(root.ListView.view.currentIndex, 1)
        }
    }
}
