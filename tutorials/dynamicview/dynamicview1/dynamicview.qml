//![0]
import QtQuick 2.0

Rectangle {
    id: root

    width: 300; height: 400

    function showProps(obj, objName) {
      var result = "";
      for (var i in obj) {
        if (obj.hasOwnProperty(i)) {
            result += objName + "." + i + " = " + obj[i] + "\n";
        }
      }
      return result;
    }

//![1]
    Component {
        id: dragDelegate

        // 这里的 Rectangle, 主要是增加了一个边框, 真正的内容显示, 还是要靠 Column 中的 Text.
        Rectangle {
            id: content

            anchors { left: parent.left; right: parent.right }
            height: column.implicitHeight + 4

            border.width: 1
            border.color: "lightsteelblue"

            radius: 2

            Column {
                id: column
                anchors { fill: parent; margins: 2 }
                // 在 Component 的内部, 可以直接拿到 ListElement 里面的数据进行访问.
                // 到底怎么实现的未知, 先这样记得吧. 难道把 model 里面的数据复制了一份到 element 里面
                // 通过下面的 JS 代码, 没有在对象的内部, 发现这些值.
                Text { text: 'Name: ' + name }
                Text { text: 'Type: ' + type }
                Text { text: 'Age: ' + age }
                Text { text: 'Size: ' + size }
            }

            Component.onCompleted: {
                console.log(root.showProps(this.parent, "Recg:"))
            }
        }
    }
//![1]


//![2]
    ListView {
        id: view

        anchors { fill: parent; margins: 2 }

        // 这里, 新创建一个 PetsModel.
        // 但是, PetsModel 里面默认生成了很多数据.
        // 从这里可以看出, 只要写到对象内的对象, 都可以看做是默认构造函数自动会生成的对象.
        model: PetsModel {}
        delegate: dragDelegate

        spacing: 4
        cacheBuffer: 50
    }
//![2]
}
//![0]
