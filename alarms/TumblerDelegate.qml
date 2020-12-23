import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

// 从这里可以猜测一下, 这种滚动选择器的实现.
// 就和 listview 一样, 滚动这件事, 会是无限显示 item 吗. 只会显示在可见视图内的内容.
// 所以, offset 这个值, 其实无论多大, 都没有关系的.
// 这种转盘, 只要能够实现, 不是中心位置的 item, 渐隐就可以了. opacity 通过下面的计算公式的计算, 实现了这个效果.
// 所以, 这种轮盘选择器, 就是通过渐隐, 和不断地替换可见 item 的内容就可以实现了.
Text {
    text: modelData
    color: Tumbler.tumbler.Material.foreground
    font: Tumbler.tumbler.font
    opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    Rectangle {
        anchors.fill: parent
        color: "lightgreen"
        opacity: 0.3
    }
}
