import QtQuick 1.0
import Box2D 1.0
import Qt.labs.particles 1.0
import Qt 4.7
import "Menu"

// Background

Item{
    id: container
    width:640
    height:480

Image {
    id: game
    source:"background-new.png"
    width: container.width
    height: container.height
    fillMode: Image.Tile

    property int screenWidth: width
    property int screenHeight: height

    MainScene{
        id: mainscene
    }

    Component.onCompleted: {
        console.log("start QML")
    }
}
}

