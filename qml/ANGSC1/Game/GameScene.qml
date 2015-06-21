import QtQuick 1.1
import Engine 1.0

Item {
    id: gameScene

    Keys.forwardTo: [hero]
    Item{
        id: debug
        //anchors.fill: gameScene
        width: 200;
        height: 200
        z: 3;

        anchors.left: gameScene.left
        anchors.leftMargin: 10
        anchors.top: gameScene.top
        anchors.topMargin: 5




        ListModel {
            id: myModel
        }
        function log(str){
            //view.children[0].childAt(1,(16-1)*myModel.count).color = Qt.rgba(255,255,255,1.0)
            if(myModel.count<=7){
                myModel.remove(6);
                myModel.insert(0,{"type":str})

                if(view.children[0].childAt(1,16-1)){
                    view.children[0].childAt(1,16-1).color = Qt.rgba(255,255,255,1.0)
                }
                if(view.children[0].childAt(1,32-1)){
                    view.children[0].childAt(1,32-1).color = Qt.rgba(255,255,255,0.8)
                }
                if(view.children[0].childAt(1,48-1)){
                    view.children[0].childAt(1,48-1).color = Qt.rgba(255,255,255,0.75)
                }
                if(view.children[0].childAt(1,64-1)){
                    view.children[0].childAt(1,64-1).color = Qt.rgba(255,255,255,0.7)
                }
                if(view.children[0].childAt(1,80-1)){
                    view.children[0].childAt(1,80-1).color = Qt.rgba(255,255,255,0.6)
                }
                if(view.children[0].childAt(1,96-1)){
                    view.children[0].childAt(1,96-1).color = Qt.rgba(255,255,255,0.5)
                }
                if(view.children[0].childAt(1,112-1)){
                    view.children[0].childAt(1,112-1).color = Qt.rgba(255,255,255,0.4)
                }

            }else{
                myModel.insert(0,{"type":str})




            }
        }


        Component {
            id: myDelegate
            //Rectangle{
                //height: textItem.height
                Text { id:textItem; font.family: "Helvetica"; font.pointSize: 10; text: type }
            //}

        }

        ListView {
            id: view
                anchors.fill: parent
                model: myModel
                delegate: myDelegate
                enabled: false
        }




    }




    Dungeon{
        id: dungeon
        cellSize: 32; // cellSize in px
        levelWidth: 20; // dungeon level width in cells
        levelHeight: 20; // dungeon level height in cells
        z: 2

        Component.onCompleted: {   
            console.log(dungeon.map);
            console.log(levelWidth, levelHeight, dungeon.cellSize, children[0] ) // COOL FEATURE ACCES TO QML CREATED ITEM IN C++ FROM QML
        }



        // ScrollArea
        Flickable {
            id: flick
            objectName: "rect" // for find in cpp

            //flicking: true

            width: parent.screenWidth; height: parent.screenHeight

            // Layer ground,  big canvas item for flicking
            Item{
                id: ground
                objectName: "ground"
                width: dungeon.levelWidth*dungeon.cellSize
                height: dungeon.levelWidth*dungeon.cellSize
            }
            // Layer enivorment
            Item{
                id: enivorment
                objectName: "enivorment"
                width: dungeon.levelWidth*dungeon.cellSize
                height: dungeon.levelWidth*dungeon.cellSize
            }
            // Layer creatures
            Item{
                id: creatures
                objectName: "creatures"
                width: dungeon.levelWidth*dungeon.cellSize
                height: dungeon.levelWidth*dungeon.cellSize
            }

            // fill floor on ground from map indexes
            Component.onCompleted: {

                dungeon.generateMapNew(dungeon.levelWidth,dungeon.levelHeight);
                dungeon.loadMap();

            }



            // MOVE HERO AND FLICK RIGHT AT ONE TIME
            ParallelAnimation{
                id: flickRight
                // flick right
                NumberAnimation{
                    target: flick; property: "contentX";
                    to: (flick.contentX+dungeon.cellSize)
                    easing {
                        type: Easing.Linear
                        amplitude: 1.0
                        period: 0.1
                    }
                }
                // hero right
                NumberAnimation {
                    target: hero; property: "x"
                    to: (hero.x+dungeon.cellSize)
                    easing {
                        type: Easing.Linear
                        amplitude: 1.0
                        period: 0.1
                    }
                }
            }
            // MOVE HERO AND FLICK LEFT AT ONE TIME
            ParallelAnimation{
                id: flickLeft
                // flick left
                NumberAnimation{
                    target: flick; property: "contentX";
                    to: (flick.contentX-dungeon.cellSize)
                    easing {
                        type: Easing.Linear
                        amplitude: 1.0
                        period: 0.1
                    }
                }
                // hero left
                NumberAnimation {
                    target: hero; property: "x"
                    to: (hero.x-dungeon.cellSize)
                    easing {
                        type: Easing.Linear
                        amplitude: 1.0
                        period: 0.1
                    }
                }
            }
            // MOVE HERO AND FLICK DOWN AT ONE TIME
            ParallelAnimation{
                id: flickDown
                // flick down
                NumberAnimation{
                    target: flick; property: "contentY";
                    to: (flick.contentY+dungeon.cellSize)
                    easing {
                        type: Easing.Linear
                        amplitude: 1.0
                        period: 0.1
                    }
                }
                // hero down
                NumberAnimation {
                    target: hero; property: "y"
                    to: (hero.y+dungeon.cellSize)
                    easing {
                        type: Easing.Linear
                        amplitude: 1.0
                        period: 0.1
                    }
                }
            }
            // MOVE HERO AND FLICK UP AT ONE TIME
            ParallelAnimation{
                id: flickUp
                // flick up
                NumberAnimation{
                    target: flick; property: "contentY";
                    to: (flick.contentY-dungeon.cellSize)
                    easing {
                        type: Easing.Linear
                        amplitude: 1.0
                        period: 0.1
                    }
                }
                // hero up
                NumberAnimation {
                    target: hero; property: "y"
                    to: (hero.y-dungeon.cellSize)
                    easing {
                        type: Easing.Linear
                        amplitude: 1.0
                        period: 0.1
                    }
                }
            }

            // Hero
            Image {
                id: hero
                x: 10*dungeon.cellSize
                y: 10*dungeon.cellSize
                z:2
                source: "../hero.png"

                NumberAnimation {
                    id: behavior
                    easing {
                        type: Easing.Linear
                        amplitude: 1.0
                        period: 0.1
                    }
                }
                NumberAnimation {
                    id: behavior2
                    easing {
                        type: Easing.Linear
                        amplitude: 1.0
                        period: 0.1
                    }
                }
                Behavior on x  {
                    animation: behavior
                }
                Behavior on y {
                    animation: behavior2
                }

                //FIXME: проверить в MOVE BOUND там где проверка на шаг героя нет ли столкновений, совпадает ли HERO.X+32 и ground.getCHildAt() на одну и ту же клеточку и нет ли смещений HERO.X когда идет скролинг по карте
                //TODO: сделать рамки границы карты из Items с тегом непроходимости
                //FIXME: почему при зажатой клавишей движении при достижении границы карты герой смещается на пару пикслей и застряет для проверок, а по горизонтали нет, исправить проверку, убрать догон мини фикс

                // move hero
                /*function move(direction){
                    switch(direction){
                    case Qt.Key_Up:{
                        // проверка не идет ли еще предыдущая анимация передвижения героя по горизонтали и вертикали
                        if(behavior2.running){
                            behavior2.complete()
                        }
                        if(behavior.running){
                            behavior.complete()
                        }
                        // проверка не стоит ли на месте куда шагнет герой обьект с именем-тегом которым свойственна непроходимость
                        if(ground.childAt(hero.x+1,hero.y-1).objectName!="eniv"){
                        // проверка для передвижения ровно по клеточках
                        if(!(y%dungeon.cellSize)){
                           hero.y = hero.y-dungeon.cellSize
                        }
                        // ДОГОН ! СПЕЦИАЛЬНЫЙ МИНИФИКС - ЗАМЕНИТЬ ЧЕТКОЙ ПРОВЕРКОЙ ПЕРЕМЕЩЕНИЯ ПО КЛЕТОЧКАМ
                        else{
                            console.log("dogon")
                            hero.y = (Math.floor(hero.y/dungeon.cellSize)*dungeon.cellSize-dungeon.cellSize)
                        }
                        }

                        break;
                    }
                    case Qt.Key_Down:{
                        if(behavior2.running){
                            behavior2.complete()
                        }
                        if(behavior.running){
                            behavior.complete()
                        }
                        if(ground.childAt(hero.x+1,hero.y+dungeon.cellSize+1).objectName!="eniv"){
                        if(!(y%dungeon.cellSize)){
                            hero.y = hero.y+dungeon.cellSize
                        }
                        // ДОГОН
                        else{
                            hero.y = (Math.floor(hero.y/dungeon.cellSize)*dungeon.cellSize+dungeon.cellSize)
                        }
                        }

                        break;
                    }
                    case Qt.Key_Left:{
                        if(behavior2.running){
                            behavior2.complete()
                        }
                        if(behavior.running){
                            behavior.complete()
                        }
                        if(ground.childAt(hero.x-1,hero.y+1).objectName!="eniv"){
                        if(!(x%dungeon.cellSize)){
                            x = x-dungeon.cellSize
                        }
                        // ДОГОН
                        else{
                            hero.x = (Math.floor(hero.x/dungeon.cellSize)*dungeon.cellSize-dungeon.cellSize)
                        }
                        }

                        break;
                    }
                    case Qt.Key_Right:{
                        if(behavior2.running){
                            behavior2.complete()
                        }
                        if(behavior.running){
                            behavior.complete()
                        }
                        if(ground.childAt(hero.x+dungeon.cellSize+1,hero.y+1).objectName!="eniv"){
                        if(!(x%dungeon.cellSize)){
                             x = x+dungeon.cellSize
                        }
                        // ДОГОН
                        else{
                            hero.x = (Math.floor(hero.x/dungeon.cellSize)*dungeon.cellSize+dungeon.cellSize)

                        }
                        }

                        break;
                    }
                    default:{
                        break;
                    }
                    }
                }*/

                // move bounds of visible frame via flick
                function moveareaBounds(direction){
                    switch(direction){

                    case Qt.Key_Up:{                       
                        // проверка не идет ли еще предыдущая анимация передвижения героя и границ по разным сторонам
                        if(flickUp.running){
                            flickUp.complete()
                            console.log("up-run")
                        }
                        if(flickDown.running){
                            flickDown.complete()
                            console.log("down-run")
                        }
                        if(flickLeft.running){
                            flickLeft.complete()
                            console.log("left-run")
                        }
                        if(flickRight.running){
                            flickRight.complete()
                            console.log("right-run")
                        }

                        /// Проверка колизий проходимости
                        // проверка существует ли обьект
                        if (ground.childAt(hero.x+1,hero.y-1)){
                        // проверка не стоит ли на месте куда шагнет герой обьект с именем-тегом которым свойственна непроходимость на слое пола
                        if(ground.childAt(hero.x+1,hero.y-1).objectName=="grnd"){
                            break;
                        }
                        }
                        if (enivorment.childAt(hero.x+1,hero.y-1)){
                        if(enivorment.childAt(hero.x+1,hero.y-1).objectName=="eniv"){
                            break;
                        }
                        }
                        if (creatures.childAt(hero.x+1,hero.y-1)){
                        if(creatures.childAt(hero.x+1,hero.y-1).objectName=="creat"){
                            break;
                        }
                        }
                        /// Перемещение
                        // проверка для перемещения границ ровно на клеточку
                        if(!(flick.contentY%dungeon.cellSize)){
                            flickUp.start()// двигать одновременно героя и клеточку
                            console.log("moveBound ",hero.x, " ", hero.y)
                            debug.log("move bound Up")
                        }

                        //}
                        break;
                    }
                    case Qt.Key_Down:{
                        if(flickUp.running){
                            flickUp.complete()
                        }
                        if(flickDown.running){
                            flickDown.complete()
                        }
                        if(flickLeft.running){
                            flickLeft.complete()
                        }
                        if(flickRight.running){
                            flickRight.complete()
                        }

                        if (ground.childAt(hero.x+1,hero.y+dungeon.cellSize+1)){
                        if(ground.childAt(hero.x+1,hero.y+dungeon.cellSize+1).objectName=="grnd"){
                            break;
                        }
                        }
                        if (enivorment.childAt(hero.x+1,hero.y+dungeon.cellSize+1)){
                        if(enivorment.childAt(hero.x+1,hero.y+dungeon.cellSize+1).objectName=="eniv"){
                            break;
                        }
                        }
                        if (creatures.childAt(hero.x+1,hero.y+dungeon.cellSize+1)){
                        if(creatures.childAt(hero.x+1,hero.y+dungeon.cellSize+1).objectName=="creat"){
                            break;
                        }
                        }
                        if(!(flick.contentY%dungeon.cellSize)){
                            flickDown.start()
                            debug.log("moveBound Down",hero.x, " ", hero.y)
                        }

                        break;
                    }
                    case Qt.Key_Left:{
                        if(flickUp.running){
                            flickUp.complete()
                        }
                        if(flickDown.running){
                            flickDown.complete()
                        }
                        if(flickLeft.running){
                            flickLeft.complete()
                        }
                        if(flickRight.running){
                            flickRight.complete()
                        }

                        if (ground.childAt(hero.x-1,hero.y+1)){
                        if(ground.childAt(hero.x-1,hero.y+1).objectName=="grnd"){
                            break;
                        }
                        }
                        if (enivorment.childAt(hero.x-1,hero.y+1)){
                        if(enivorment.childAt(hero.x-1,hero.y+1).objectName=="eniv"){
                            break;
                        }
                        }
                        if (creatures.childAt(hero.x-1,hero.y+1)){
                        if(creatures.childAt(hero.x-1,hero.y+1).objectName=="creat"){
                            break;
                        }
                        }
                        if(!(flick.contentY%dungeon.cellSize)){
                            flickLeft.start()
                            debug.log("moveBound Left",hero.x, " ", hero.y)
                        }

                        break;
                    }
                    case Qt.Key_Right:{
                        if(flickUp.running){
                            flickUp.complete()
                        }
                        if(flickDown.running){
                            flickDown.complete()
                        }
                        if(flickLeft.running){
                            flickLeft.complete()
                        }
                        if(flickRight.running){
                            flickRight.complete()
                        }


                        if (ground.childAt(hero.x+dungeon.cellSize+1,hero.y+1)){
                        if(ground.childAt(hero.x+dungeon.cellSize+1,hero.y+1).objectName=="grnd"){
                            break;
                        }
                        }
                        if (enivorment.childAt(hero.x+dungeon.cellSize+1,hero.y+1)){
                        if(enivorment.childAt(hero.x+dungeon.cellSize+1,hero.y+1).objectName=="eniv"){
                            break;
                        }
                        }
                        if (creatures.childAt(hero.x+dungeon.cellSize+1,hero.y+1)){
                        if(creatures.childAt(hero.x+dungeon.cellSize+1,hero.y+1).objectName=="creat"){
                            break;
                        }
                        }
                        if(!(flick.contentY%dungeon.cellSize)){
                            flickRight.start()
                            debug.log("moveBound Right",hero.x, " ", hero.y)
                        }

                        break;
                    }
                    default:{
                        break;
                    }
                    }

                }

                Keys.onPressed: {
                      var frame = 32; //отступ от края границ экрана при которых юудет перемещенеи границ

                      if (event.key == Qt.Key_Up) {

                          // проверка не будет ли следующий шаг героя за границу+отступ от края экрана, если да то переместим границу влево
                          //if (hero.y-flick.contentY-frame<=0){
                              //move flick
                              moveareaBounds(Qt.Key_Up);
                          //}else{
                          //move(Qt.Key_Up);
                          //}
                      }
                      if (event.key == Qt.Key_Down) {
                          //if (hero.y+dungeon.cellSize-flick.contentY+frame>=gameScene.parent.screenHeight){
                              //move flick
                              moveareaBounds(Qt.Key_Down);
                         // }else{
                          //move(Qt.Key_Down);
                          //}
                      }
                      if (event.key == Qt.Key_Left) {
                         // if (hero.x-flick.contentX-frame<=0){
                              //move flick
                              moveareaBounds(Qt.Key_Left);
                         // }else{
                          //move(Qt.Key_Left);
                         //}
                      }
                      if (event.key == Qt.Key_Right) {
                         // if (hero.x+dungeon.cellSize-flick.contentX+frame>=gameScene.parent.screenWidth){
                              //move flick
                              moveareaBounds(Qt.Key_Right);
                         // }else{
                         // move(Qt.Key_Right);
                         // }
                      }
                      event.accepted = true;
                  }


           }

        }
    }
}
