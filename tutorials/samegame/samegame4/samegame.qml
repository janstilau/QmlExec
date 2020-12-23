import QtQuick 2.0
import "content"
import "content/samegame.js" as SameGame // 一次引入, 就执行一次里面的初始化操作.


// SameGame 里面, 可以直接使用 id 所指向的那些值.

Rectangle {
    id: screen

    width: 490; height: 720

    // SystemPalette 用来获取系统相关的配色.
    SystemPalette { id: activePalette }
    // 子控件的 Button, 居然可以直接使用到父对象里面定义的一个属性.
    property string labelText : "这是最上层的一个属性, 看一看下层能接收到不."

    Item {
        width: parent.width
        anchors { top: parent.top; bottom: toolBar.top }

        Image {
            id: background
            anchors.fill: parent
            source: "../shared/pics/background.jpg"
            fillMode: Image.PreserveAspectCrop
        }

        Item {
            id: gameCanvas
            property int score: 0
            property int blockSize: 40

            anchors.centerIn: parent
           // 这里, 是计算, 刚好能够进行显示.
            width: parent.width - (parent.width % blockSize);
            height: parent.height - (parent.height % blockSize);

            MouseArea {
                anchors.fill: parent; onClicked: SameGame.handleClick(mouse.x,mouse.y);
            }
        }
    }

    Dialog {
        id: dialog
        anchors.centerIn: parent
        z: 100
    }

    //![0]
    Dialog {
        id: nameInputDialog
        anchors.centerIn: parent
        z: 100

        onClosed: {
            if (nameInputDialog.inputText != "")
                SameGame.saveHighScore(nameInputDialog.inputText);
        }
    }
    //![0]

    // 底部的工具栏.
    Rectangle {
        id: toolBar
        width: parent.width; height: 30
        color: activePalette.window // 这里, 使用系统的调色板, 显得很自然.
        anchors.bottom: screen.bottom

        Button {
            anchors { left: parent.left; verticalCenter: parent.verticalCenter }
            text: "New Game"
            onClicked: SameGame.startNewGame()
        }

        Text {
            id: score
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            text: "Score: " + gameCanvas.score // 这里, 直接绑定了 score 的显示.
        }
    }
}
