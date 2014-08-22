part of citygen;

class MapGenerator{
  List<Room> rooms;
  List<List<num>> map;

  bool mergeOverriding = false;

  int minRooms = 5;
  int maxRooms = 8;
  int minRoomSize = 6;
  int maxRoomSize = 8;
  int mapWidth;
  int mapHeight;
  Random random = new Random();
  
  MapGenerator(this.mapWidth, this.mapHeight);
  
  /// builds the  map with the options
  void build(){
    placeRooms();
    buildCorridors();
  }
  
  ///randomly build rooms and place them into our map
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
          if (mergeOverriding) 
            mergeRooms(oRoom, room);
          break;
        }
      }
      
      if (!failed){
//    createRoom(oRoom);
        rooms.add(room);
        print('new room $room');
      }else{
        if (rooms.length < minRooms && !mergeOverriding)
          r--;
      }
      
    }
    
    //init map array and put rooms in it
    map = new List.generate(mapHeight, (_) => new List.filled(mapWidth, 0));  
    rooms.forEach((Room room){
      for ( int y = room.y1; y < room.y2; y++){
        map[y].fillRange(room.x1, room.x2, 1);
      }
    });
  }
  
  /// link rooms together with corridors
  void buildCorridors(){
    for(int r = 0; r < rooms.length; r++){
      bool sideCorridor = random.nextBool();
//    if ( r == rooms.length - 1) return;
      
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
  
  ///makes so that r1 = r1 + r2 and removes r2 from the rooms list
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
  
  /// create horizontal corridor to connect rooms
  void hCorridor(int x1, int x2, int y){
    for ( int x = min(x1, x2); x < max(x1, x2) + 1; x++ ){
      map[y][x] = 1;
    }
  }
  
  /// create vertical corridor to connect rooms
  void vCorridor(int y1, int y2, int x) {
    for ( int y = min(y1, y2); y < max(y1, y2) + 1; y++ ){
      map[y][x] = 1;
    }
  }
}