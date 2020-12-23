import QtQuick 2.11 // 最基本的模块
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Layouts 1.11
import QtQuick.Window 2.11
import Qt.labs.calendar 1.0

ApplicationWindow {
    id: window
    width: 375
    height: 667
    visible: true

    // 主题内容.
    ListView {
        id: alarmListView
        anchors.fill: parent
        model: AlarmModel {}
        delegate: AlarmDelegate {}
    }

    // 下方按钮.
    RoundButton {
        id: addAlarmButton
        text: "+"
        anchors.bottom: alarmListView.bottom
        anchors.bottomMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: alarmDialog.open()
    }

    // 这里, 直接把 alarmListView.model 传入到 AlamDialog 里去了.
    // 在 AlarmDialog 里面, 直接修改了 model 里面的数据, 而数据的改变, 直接影响到了 ListView 的改变
    // 可以说, AlarmDialog 是一个完全独立的模块.
    AlarmDialog {
        id: alarmDialog
        // x, y 的值, 使用了表达式绑定, 在 Qml 中大量使用了值的绑定的格式, 要熟悉这种写法.
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        alarmModel: alarmListView.model
    }
}
