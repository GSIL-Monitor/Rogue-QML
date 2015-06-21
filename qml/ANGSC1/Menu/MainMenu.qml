import QtQuick 1.1
import "../"

Item{
    id: mainMenuScene
    width: parent.sceneWidth
    height: parent.sceneHeight
    signal itemClicked(string name) // show group by id

// Group List
ListView {

    id: mainMenu

    anchors.horizontalCenter: mainMenuScene.horizontalCenter

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
            name: "new-game"
            picture:"new-game.png"
        }
        ListElement {
            name: "load-game"
            picture:"load-game.png"
        }
        ListElement {
            name: "options"
            picture:"options.png"
        }
        ListElement {
            name: "instructions"
            picture:"instruction.png"
        }
        ListElement {
            name: "about"
            picture:"about.png"
        }
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
        Image{
            id: sprite

            //x:150
            width: 260; height: 68
            source: picture
            Behavior on opacity {
                         SpringAnimation {
                             spring: 2.5
                             damping: 0.5
                         }
                     }
            MouseArea {
                      id: mArea
                      anchors.fill: parent
                      hoverEnabled: true
                      onClicked: {
                          console.log("clicked  ", name)
                          mainMenuScene.itemClicked(name)
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
