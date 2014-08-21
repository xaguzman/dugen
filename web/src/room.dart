part of citygen;


class Room{
  int x1, y1, x2, y2, width, height;
  Point center;
  
  Room(this.x1, this.y1, this.width, this.height){
    x2 = x1 + width;
    y2 = y1 + height;
        
    var centerX = (x1 + x2) ~/ 2;
    var centerY = (y1 + y2) ~/ 2;
    center = new Point( centerX, centerY  );
  }
  
  bool intersects(Room room) => 
      (x1 <= room.x2 && x2 >= room.x1 && y1 <= room.y2 && room.y2 >= room.y1);
}

class Point{
  int x, y;
  Point(this.x, this.y);
}