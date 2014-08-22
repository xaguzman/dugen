library citygen;

import 'dart:html';
import 'dart:core';
import 'dart:math';

part 'src/room.dart';
part 'src/mapgen.dart';


CanvasRenderingContext2D ctx;
num scaleX  = 1;
num scaleY = 1;
int mapWidth = 50;
int mapHeight = 30;
num _delta = 0;
MapGenerator mapGen;

void main() {  
  CanvasElement canvas = querySelector('canvas');
  ctx = canvas.context2D;
  scaleX = canvas.width / mapWidth;
  scaleY = canvas.height / mapHeight;
  
  mapGen = new MapGenerator(mapWidth, mapHeight)..build();
   
  ctx.scale(scaleX, scaleY);
  
  window.animationFrame.then(render);
}

void render(num delta){  
  ctx
    ..setFillColorRgb(0, 0, 0)
    ..fillRect(0, 0, ctx.canvas.width, ctx.canvas.height)
    ..setFillColorRgb(115, 115, 115);
  
  ctx.strokeStyle = 'White';
  for(int y = 0; y < mapGen.map.length; y++){
    for(int x = 0; x < mapGen.map[y].length; x++){
      if(mapGen.map[y][x] == 0) continue;
      
      ctx..rect(x, mapGen.map.length - 1 - y, 1, 1);
    } 
  }
  ctx.stroke();
  ctx.fill();
//  window.animationFrame.then(render);
}




