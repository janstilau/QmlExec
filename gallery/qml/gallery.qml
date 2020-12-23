// 总的入口.

import QtQuick 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.0
import QtQuick.Window 2.1

Window {
    id: root
    objectName: "window"
    visible: true
    width: 480
    height: 800

    // 这个并不是继承自 Rectangle
    color: "#161616"
    title: "Qt Quick Extras Demo"

    function toPixels(percentage) {
        return percentage * Math.min(root.width, root.height);
    }

    // 这里, 自定义的属性, 表达式表示, 也会变为 binding.
    property bool isScreenPortrait: height > width
    property color lightFontColor: "#222"
    property color darkFontColor: "#e7e7e7"
    readonly property color lightBackgroundColor: "#cccccc"
    readonly property color darkBackgroundColor: "#161616"
    property real customizerPropertySpacing: 10
    property real colorPickerRowSpacing: 8

    Text {
        id: textSingleton
    }

    property Component circularGauge: CircularGaugeView {}

    property Component dial: ControlView {
        darkBackground: false

        control: Column {
            id: dialColumn
            width: controlBounds.width
            height: controlBounds.height - spacing
            spacing: root.toPixels(0.05)

            ColumnLayout {
                id: volumeColumn
                width: parent.width
                height: (dialColumn.height - dialColumn.spacing) / 2
                spacing: height * 0.025

                Dial {
                    id: volumeDial
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    /*!
                        Determines whether the dial animates its rotation to the new value when
                        a single click or touch is received on the dial.
                    */
                    property bool animate: customizerItem.animate

                    Behavior on value {
                        enabled: volumeDial.animate && !volumeDial.pressed
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutSine
                        }
                    }
                }

                ControlLabel {
                    id: volumeText
                    text: "Volume"
                    Layout.alignment: Qt.AlignCenter
                }
            }

            ColumnLayout {
                id: trebleColumn
                width: parent.width
                height: (dialColumn.height - dialColumn.spacing) / 2
                spacing: height * 0.025

                Dial {
                    id: dial2
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    stepSize: 1
                    maximumValue: 10

                    style: DialStyle {
                        labelInset: outerRadius * 0
                    }
                }

                ControlLabel {
                    id: trebleText
                    text: "Treble"
                    Layout.alignment: Qt.AlignCenter
                }
            }
        }

        customizer: Column {
            spacing: customizerPropertySpacing

            property alias animate: animateCheckBox.checked

            CustomizerLabel {
                text: "Animate"
            }

            CustomizerSwitch {
                id: animateCheckBox
            }
        }
    }

    property Component delayButton: ControlView {
        darkBackground: false

        control: DelayButton {
            text: "Alarm"
            anchors.centerIn: parent
        }
    }

    property Component gauge: ControlView {
        id: gaugeView
        control: Gauge {
            id: gauge
            width: orientation === Qt.Vertical ? implicitWidth : gaugeView.controlBounds.width
            height: orientation === Qt.Vertical ? gaugeView.controlBounds.height : implicitHeight
            anchors.centerIn: parent

            minimumValue: 0
            value: customizerItem.value
            maximumValue: 100
            orientation: customizerItem.orientationFlag ? Qt.Vertical : Qt.Horizontal
            tickmarkAlignment: orientation === Qt.Vertical
                ? (customizerItem.alignFlag ? Qt.AlignLeft : Qt.AlignRight)
                : (customizerItem.alignFlag ? Qt.AlignTop : Qt.AlignBottom)
        }

        customizer: Column {
            spacing: customizerPropertySpacing

            property alias value: valueSlider.value
            property alias orientationFlag: orientationCheckBox.checked
            property alias alignFlag: alignCheckBox.checked

            CustomizerLabel {
                text: "Value"
            }

            CustomizerSlider {
                id: valueSlider
                minimumValue: 0
                value: 50
                maximumValue: 100
            }

            CustomizerLabel {
                text: "Vertical orientation"
            }

            CustomizerSwitch {
                id: orientationCheckBox
                checked: true
            }

            CustomizerLabel {
                text: controlItem.orientation === Qt.Vertical ? "Left align" : "Top align"
            }

            CustomizerSwitch {
                id: alignCheckBox
                checked: true
            }
        }
    }


    property Component toggleButton: ControlView {
        darkBackground: false

        // ToggleButton 是 Qt 原生自带的.
        control: ToggleButton {
            text: checked ? "On" : "Off"
            anchors.centerIn: parent
        }
    }

    property Component pieMenu: PieMenuControlView {}

    property Component statusIndicator: ControlView {
        id: statusIndicatorView
        darkBackground: false

        Timer {
            id: recordingFlashTimer
            running: true
            repeat: true
            interval: 1000
        }

        ColumnLayout {
            id: indicatorLayout
            width: statusIndicatorView.controlBounds.width * 0.25
            height: statusIndicatorView.controlBounds.height * 0.75
            anchors.centerIn: parent

            Repeater {
                model: ListModel {
                    id: indicatorModel
                    ListElement {
                        name: "Power"
                        indicatorColor: "#35e02f"
                    }
                    ListElement {
                        name: "Recording"
                        indicatorColor: "red"
                    }
                }

                ColumnLayout {
                    Layout.preferredWidth: indicatorLayout.width
                    spacing: 0

                    StatusIndicator {
                        id: indicator
                        color: indicatorColor
                        Layout.preferredWidth: statusIndicatorView.controlBounds.width * 0.07
                        Layout.preferredHeight: Layout.preferredWidth
                        Layout.alignment: Qt.AlignHCenter
                        on: true

                        Connections {
                            target: recordingFlashTimer
                            onTriggered: if (name == "Recording") indicator.active = !indicator.active
                        }
                    }
                    ControlLabel {
                        id: indicatorLabel
                        text: name
                        Layout.alignment: Qt.AlignHCenter
                        Layout.maximumWidth: parent.width
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }

    property Component tumbler: ControlView {
        id: tumblerView
        darkBackground: false

        Tumbler {
            id: tumbler
            anchors.centerIn: parent

            // TODO: Use FontMetrics with 5.4
            Label {
                id: characterMetrics
                font.bold: true
                font.pixelSize: textSingleton.font.pixelSize * 1.25
                font.family: openSans.name
                visible: false
                text: "M"
            }

            readonly property real delegateTextMargins: characterMetrics.width * 1.5
            readonly property var days: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

            TumblerColumn {
                id: tumblerDayColumn

                function updateModel() {
                    var previousIndex = tumblerDayColumn.currentIndex;
                    var newDays = tumbler.days[monthColumn.currentIndex];

                    if (!model) {
                        var array = [];
                        for (var i = 0; i < newDays; ++i) {
                            array.push(i + 1);
                        }
                        model = array;
                    } else {
                        // If we've already got days in the model, just add or remove
                        // the minimum amount necessary to make spinning the month column fast.
                        var difference = model.length - newDays;
                        if (model.length > newDays) {
                            model.splice(model.length - 1, difference);
                        } else {
                            var lastDay = model[model.length - 1];
                            for (i = lastDay; i < lastDay + difference; ++i) {
                                model.push(i + 1);
                            }
                        }
                    }

                    tumbler.setCurrentIndexAt(0, Math.min(newDays - 1, previousIndex));
                }
            }
            TumblerColumn {
                id: monthColumn
                width: characterMetrics.width * 3 + tumbler.delegateTextMargins
                model: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
                onCurrentIndexChanged: tumblerDayColumn.updateModel()
            }
            TumblerColumn {
                width: characterMetrics.width * 4 + tumbler.delegateTextMargins
                model: ListModel {
                    Component.onCompleted: {
                        for (var i = 2000; i < 2100; ++i) {
                            append({value: i.toString()});
                        }
                    }
                }
            }
        }
    }


    FontLoader {
        id: openSans
        source: "qrc:/fonts/OpenSans-Regular.ttf"
     }

    // 这里, 根据名称, 已经创建好了各个 Item 了
    property var componentMap: {
        "CircularGauge": circularGauge,
        "DelayButton": delayButton,
        "Dial": dial,
        "Gauge": gauge,
        "PieMenu": pieMenu,
        "StatusIndicator": statusIndicator,
        "ToggleButton": toggleButton,
        "Tumbler": tumbler
    }



// 一个类似 NavigationVc 的东西. 非常类似.
    StackView {
        id: stackView
        anchors.fill: parent

        // 最顶层的是一个 TableView.
        initialItem: ListView {
            // dataSource.
            model: ListModel {
                ListElement {
                    title: "CircularGauge"
                }
                ListElement {
                    title: "DelayButton"
                }
                ListElement {
                    title: "Dial"
                }
                ListElement {
                    title: "Gauge"
                }
                ListElement {
                    title: "PieMenu"
                }
                ListElement {
                    title: "StatusIndicator"
                }
                ListElement {
                    title: "ToggleButton"
                }
                ListElement {
                    title: "Tumbler"
                }
            }

            // cell for indexpath/
            delegate: Button {
                width: stackView.width
                height: root.height * 0.125
                text: title

                style: BlackButtonStyle {
                    fontColor: root.darkFontColor
                    rightAlignedIconSource: "qrc:/images/icon-go.png"
                }

                onClicked: {
                    if (stackView.depth == 1) {
                        // Only push the control view if we haven't already pushed it...
                        stackView.push({item: componentMap[title]});
                        stackView.currentItem.forceActiveFocus();
                    }
                }
            }

        }
    }
}


