/*
 * flash player Plugin for JavaScript
 *
 *
 * FlashVars expected: (AS3 property of: loaderInfo.parameters)
 *  playerInstance:  (URL Encoded: String) Sets the JavaScript player object.
 *
 */
package
{
  import flash.external.ExternalInterface;
  import flash.media.Sound;
  import flash.net.URLRequest;
  import flash.errors.IOError;
  import flash.events.IOErrorEvent;
  import flash.events.Event;
  import flash.media.SoundChannel;
  import flash.events.StatusEvent;

  import mx.collections.ArrayCollection;


  public class Player
  {
    public function Player()
    {
    }

    public function setPlayerInstance(instance:String):void {
      this.playerInstance = instance + '.';
    }

    public function addExternalInterfaceCallbacks():void {
      ExternalInterface.addCallback("inPlaying",     this.inPlaying);
      ExternalInterface.addCallback("stopPlayback",      this.stop);
      ExternalInterface.addCallback("pausePlay",      this.pause);
      ExternalInterface.addCallback("playPosition",          this.getPosition);
      ExternalInterface.addCallback("seekTo",          this.seekTo);
      ExternalInterface.addCallback("startPlay",          this.play);
      ExternalInterface.addCallback("playDuration",     this.playDuration);


      trace("Player initialized");
      triggerEvent('initialized');
    }


    protected var isPlaying:Boolean = false;
    protected var isPaused:Boolean = false;
    protected var sound:Sound;
    protected var channel:SoundChannel;
    protected var duration:int = 0;
    protected var currentPostion:int = 0;
    private var playerInstance:String;
    private var source:String;
    private var req:URLRequest;

    protected function play(url:String):void
    {
      trace('startPlaying');
      if (url && source != url) {
        source = url;
        currentPostion = 0;
        duration = 0;
        req = new URLRequest(source);
        sound = new Sound();
        sound.load(req);
        sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
        sound.addEventListener(Event.OPEN, function() {
        });
        sound.addEventListener(Event.COMPLETE, function() {
          duration = sound.length;
          triggerEvent('durationchange', sound.length);
        });
      }
      channel = sound.play(currentPostion);
      isPlaying = true;
      isPaused = false;
      channel.addEventListener(Event.SOUND_COMPLETE, function(){
        stop();
        triggerEvent('ended');
      });
    }

    protected function stop():void
    {
      if (!isPlaying) {
        return;
      }
      trace('stopPlaying');
      if(channel){
        channel.stop();
        currentPostion = 0;
        isPaused = false;
        isPlaying = false;
      }
    }

    protected function inPlaying():Boolean
    {
      return isPlaying;
    }

    private function errorHandler(event:IOErrorEvent):void {
      triggerEvent('error', 'Audio file('+source+') is not available');
    }

    protected function pause():void
    {
      trace('pausePlaying');
      if(channel){
        currentPostion = channel.position;
        channel.stop();
        isPaused = true;
        isPlaying = false;
      }
    }

    protected function playDuration():int
    {
      return duration;
    }

    protected function seekTo(position:int):void
    {
      if (position < 0 || position > duration) {
        return;
      }
      currentPostion = position;
    }

    protected function getPosition():int
    {
      if (channel && isPlaying) {
        currentPostion = this.channel.position;
      }

      return currentPostion;
    }

    protected function triggerEvent(eventName:String, arg0=null, arg1 = null):void
    {
      ExternalInterface.call(this.playerInstance+"triggerEvent", eventName, arg0, arg1);
    }

    protected function log(message:String):void
    {
      ExternalInterface.call('console.log', 'flash: '+message);
    }
  }
}
