import QtQuick 2.0

Rectangle {
    id: container

    property string text: "Button"

    signal clicked

    // activePalette 的直接使用, 破坏了封装性.
    width: buttonLabel.width + 20; height: buttonLabel.height + 5
    border { width: 1; color: Qt.darker(activePalette.button) }
    antialiasing: true
    radius: 8

    // color the button with a gradient
    gradient: Gradient {
        GradientStop {
            position: 0.0
            // color 这里, 想要结果是一个 color 值, 那么就可以使用表达式来进行代替. 这里, 直接是一个函数
            color: {
                if (mouseArea.pressed)
                    return activePalette.dark
                else
                    return activePalette.light
            }
        }
        GradientStop {
            position: 1.0;
            color: activePalette.button
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: container.clicked();
    }

    Text {
        id: buttonLabel
        anchors.centerIn: container
        color: activePalette.buttonText
        // 这种设计, 个人感觉打破了封装性. 凭什么子控件就能找到父控件里面的 id 代表的对象呢.
        // 最好, 还是子控件暴露一个属性, 由外界进行传递才好.
        text: labelText
    }
}
