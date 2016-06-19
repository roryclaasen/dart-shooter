part of shooter;

class Level {
   final CanvasElement canvas;
   Entity player;

   TextUtil _textUtil;

   Level(this.canvas, Keyboard _keyboard) {
      _textUtil = new TextUtil();
      player = new Player(_keyboard);
      player.setPosition(new Point((canvas.width / 2) - (player.getWidth() / 2), (canvas.height - player.getHeight()) - 50.0));
   }

   void render(CanvasRenderingContext2D context) {
      player.render(context);
      int playerHealth = player.getHealth();
      _textUtil.drawString(context, "$playerHealth hp", 10, 30);
      _textUtil.drawStringFloatRight(context, "00000", 400 /*canvas.width*/ - 10, 30);
   }

   void update(final double elapsed) {
      player.update(canvas, elapsed);
   }
}
