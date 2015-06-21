import QtQuick 1.1

import "../"

Item{
    id: loadGameScene
    width: parent.sceneWidth
    height: parent.sceneHeight
    signal itemClicked(string name) // show group by id

// Group List
ListView {

    id: mainMenu

    anchors.horizontalCenter: loadGameScene.horizontalCenter
    width: 260
    height: parent.height
    //anchors.fill: parent
    //anchors.rightMargin: 10
    //anchors.leftMargin: 10

    focus: true
    clip: true // CONTENT OUT OF WINDOW DONT RENDERING !!!

    //property alias groupModel



    model:  ListModel {
        id: menuModel

        ListElement {
            name: "quit"
            picture:"quit.png"
        }
    }

    delegate: menuDelegate
    //highlight: highlight
    highlightFollowsCurrentItem: false

    Component {
        id: menuDelegate
        Sprite{
            id: sprite
            //x:150
            width: 260; height: 68
            source: picture
            running: false
            frameCount: 2
            MouseArea {
                      id: mArea
                      anchors.fill: parent
                      hoverEnabled: true
                      onClicked: {
                          console.log("clicked  ", name)
                          loadGameScene.itemClicked(name)
                          //mainMenu.parent.parent.showWall( currentItem.link);

                      }
                      onEntered: {
                          mainMenu.currentIndex = index
                          sprite.opacity = 0.5
                      }
                      onExited: {
                          sprite.opacity = 1
                      }
                 }
        }
    }
}
}
