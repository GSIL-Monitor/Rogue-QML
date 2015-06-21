import QtQuick 1.1
import "../"
import "../Game"

// Main Scene
Item{
id: mainScene
width: parent.screenWidth
height: parent.screenHeight

property int sceneWidth: parent.screenWidth
property int sceneHeight: parent.screenHeight

Behavior on x {
    SpringAnimation {
        spring: 3
        damping: 0.23
    }
}
About{
    id: about
    x:-sceneWidth*2
    y:0
    //x:((parent.screenWidth/2)-(mainMenu.width/2))
    //anchors.left: instruction.right
    onItemClicked:{
        switch(name){case "quit":{mainScene.x = 0}}
    }
}
Instruction{
    id: instruction
    anchors.left: about.right
    onItemClicked:{
        switch(name){case "quit":{mainScene.x = 0}}
}
}
MainMenu{
    id:mainMenu
    anchors.left: instruction.right

    onItemClicked:{
        switch(name){
        case "new-game":{

            var component;
            var obj;

            function createobjObjects() {
                component = Qt.createComponent("../Game/GameScene.qml");
                if (component.status == Component.Ready)
                    finishCreation();
                else
                    component.statusChanged.connect(finishCreation);
            }

            function finishCreation() {
                console.log("finish creation")
                if (component.status == Component.Ready)
                {
                    obj = component.createObject(parent.parent);
                    obj.focus = true
                    if (obj == null) {
                        // Error Handling
                        console.log("Error creating object");
                    }
                }
                else if (component.status == Component.Error) {
                    // Error Handling
                    console.log("Error loading component:", component.errorString());
                }
            }

            createobjObjects();
            //mainScene.destroy();
            mainScene.enabled = false
}
        case "load-game":{mainScene.x = -game.width}
        case "options":{mainScene.x = -game.width*2}
        case "instructions":{mainScene.x = game.width}
        case "about":{mainScene.x = game.width*2}
        case "quit":{}
        default:{break;}}
    }
}

LoadGame{
    id: loadGame
    anchors.left: mainMenu.right
    onItemClicked:{
        switch(name){case "quit":{mainScene.x = 0}}
    }
}
Options{
    id: options
    anchors.left: loadGame.right
    onItemClicked:{
        switch(name){ case "quit":{mainScene.x = 0}}
    }
    }


}
