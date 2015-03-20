package {
  import flash.display.Sprite;
  import flash.external.ExternalInterface;

  public class FlashPlayer extends Sprite {
    public function FlashPlayer() {
      var player = new Player();
      player.setPlayerInstance(root.loaderInfo.parameters.playerInstance);
      player.addExternalInterfaceCallbacks();
    }
  }
}
