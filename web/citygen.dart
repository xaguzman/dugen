library citygen;

import 'dart:html';
import 'dart:core';
import 'dart:math';

part 'src/room.dart';

List<Room> rooms;
List<List<num>> map;

int maxRooms = 10;
int minRoomSize = 5;
int maxRoomSize = 8;
int mapWidth = 75;
int mapHeight = 45;
num _delta = 0;
Random random = new Random();

CanvasRenderingContext2D ctx;
num tileSize = 1;

void main() {
  placeRooms();
  buildCorridors();
  print('created ${rooms.length} rooms');
  CanvasElement canvas = querySelector('canvas');
  ctx = canvas.context2D;
  tileSize = canvas.width / mapWidth;
   
  ctx.scale(tileSize, tileSize);
  
  window.animationFrame.then(render);
}

void render(num delta){
  
  ctx
    ..setFillColorRgb(0, 0, 0)
    ..fillRect(0, 0, ctx.canvas.width, ctx.canvas.height)
    ..setFillColorRgb(115, 115, 115);
  
  ctx.strokeStyle = 'White';
  for(int y = 0; y < map.length; y++){
    for(int x = 0; x < map[y].length; x++){
      if(map[y][x] == 0) continue;
      
      ctx..rect(x, y , 1, 1);
    } 
  }
  ctx.stroke();
  ctx.fill();
  
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
        mergeRooms(oRoom, room);
        break;
      }
    }
    
    if (!failed){
//    createRoom(oRoom);
      rooms.add(room);
      print('new room $room');
    }
    
  }
  
  //map = new List<List<num>>.filled(mapHeight, new List.filled(mapWidth, 0));
  map = new List(mapHeight);
  for( int i = 0; i < mapHeight; i++ ){
    map[i] = new List.filled(mapWidth, 0);
  }
  
  rooms.forEach((Room room){
    for ( int y = room.y1; y < room.y2; y++){
      map[y].fillRange(room.x1, room.x2, 1);
    }
  });
}

void buildCorridors(){
  for(int r = 0; r < rooms.length; r++){
    bool sideCorridor = random.nextBool();
    Room current = rooms[r];
    Room next = r + 1 == rooms.length ? rooms[0] : rooms[r+1];
    
    if (sideCorridor){
      hCorridor(current.center.x, next.center.x, current.center.y);
      vCorridor(current.center.y, next.center.y, next.center.x);
    }else{
      vCorridor(current.center.y, next.center.y, current.center.x);
      hCorridor(current.center.x, next.center.x, next.center.y);
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
  
  rooms.remove(r2);
  
  for(int i = 0; i <rooms.length; i++){
    var oRoom = rooms[i];
    if (oRoom != r1 && oRoom != r2 && oRoom.intersects(r1)){
      mergeRooms(r1, oRoom);
      print('merged room $r1');
      break;
    }
  }
}

void hCorridor(int x1, int x2, int y){
  for ( int x = min(x1, x2); x < max(x1, x2) + 1; x++ ){
    // destory the tiles to "carve" out corridor
//    map[x][y].parent.removeChild(map[x][y]);

    // place a new unblocked tile
//    map[x][y] = new Tile(Tile.DARK_GROUND, false, false);

    // add tile as a new game object
//    addChild(map[x][y]);

    // set the location of the tile appropriately
//    map[x][y].setLoc(x, y);
    map[y][x] = 1;
  }
}

    // create vertical corridor to connect rooms
void vCorridor(int y1, int y2, int x) {
  for ( int y = min(y1, y2); y < max(y1, y2) + 1; y++ ){
    // destroy the tiles to "carve" out corridor
//    map[x][y].parent.removeChild(map[x][y]);

    // place a new unblocked tile
//    map[x][y] = new Tile(Tile.DARK_GROUND, false, false);

    // add tile as a new game object
//    addChild(map[x][y]);

    // set the location of the tile appropriately
//    map[x][y].setLoc(x, y);
    map[y][x] = 1;
  }
}



