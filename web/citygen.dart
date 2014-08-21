library citygen;

import 'dart:html';
import 'dart:core';
import 'dart:math';

part 'src/room.dart';

List<Room> rooms;

int maxRooms = 40;
int minRoomSize = 10;
int maxRoomSize = 25;
int mapWidth = 250;
int mapHeight = 150;
num _delta = 0;
Random random = new Random();

CanvasRenderingContext2D ctx;
num scaleR = 1;

void main() {
  window.animationFrame.then(render);
  placeRooms();
  print(rooms.length);
  CanvasElement canvas = querySelector('canvas');
  ctx = canvas.context2D;
  scaleR = canvas.width / mapWidth;
  
//  window.animationFrame.then(render);
}

void render(num delta){
  
  ctx
    ..restore()
    ..setTransform(1, 0, 0, 1, 0, 0)
    ..clearRect(0,  0, ctx.canvas.width, ctx.canvas.height)
    ..setFillColorRgb(0, 0, 0)
    ..scale(scaleR, scaleR);
  
  rooms.forEach((Room r){
    ctx
      ..fillRect(r.x1, r.y1, r.width, r.height);
  });
  
  window.animationFrame.then(render);
}

void placeRooms(){
  rooms = new List<Room>();  
  for (int r = 0; r < maxRooms; r++){
    var width = minRoomSize + random.nextInt(maxRoomSize - minRoomSize + 1);
    var height = minRoomSize + random.nextInt(maxRoomSize - minRoomSize + 1);
    var x = random.nextInt(mapWidth - width - 1) + 1;
    var y = random.nextInt(mapHeight - height - 1) + 1;
    
    var room = new Room(x, y, width, height);
    var failed = false;
    for(int i = 0; i <rooms.length; i++){
      var oRoom = rooms[i];
      if (oRoom.intersects(room)){
        failed = true;
//        mergeRooms(oRoom, room);
        break;
      }
    }
    
    if (!failed){
//    createRoom(oRoom);
      rooms.add(room);
    }
    
  }
}

///makes so that r1 = r1 + r2
void mergeRooms(Room r1, Room r2){
  
  r1.x1 = min(r1.x1, r2.x1);
  r1.y1 = min(r1.y1, r2.y2);
  r1.x2 = max(r1.x2, r2.x2);
  r1.y2 = max(r1.y2, r2.y2);
  
  r1.width = r1.x2 - r1.x1;
  r1.height = r1.y2 - r1.y1;
}

void hCorridor(int x1, int x2, int y){
  for (x in Std.int(Math.min(x1, x2))...Std.int(Math.max(x1, x2)) + 1) {
    // destory the tiles to "carve" out corridor
    map[x][y].parent.removeChild(map[x][y]);

    // place a new unblocked tile
    map[x][y] = new Tile(Tile.DARK_GROUND, false, false);

    // add tile as a new game object
    addChild(map[x][y]);

    // set the location of the tile appropriately
    map[x][y].setLoc(x, y);
  }
}

    // create vertical corridor to connect rooms
void vCorridor(int y1, int y2, int x) {
  for (y in Std.int(Math.min(y1, y2))...Std.int(Math.max(y1, y2)) + 1) {
    // destroy the tiles to "carve" out corridor
    map[x][y].parent.removeChild(map[x][y]);

    // place a new unblocked tile
    map[x][y] = new Tile(Tile.DARK_GROUND, false, false);

    // add tile as a new game object
    addChild(map[x][y]);

    // set the location of the tile appropriately
    map[x][y].setLoc(x, y);
  }
}



