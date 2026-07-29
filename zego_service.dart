import 'package:flutter/services.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class ZegoService {
  // Your ZegoCloud Credentials
  static const int appID = 661760503;
  static const String appSign = 'YOUR_COPIED_APP_SIGN_HERE'; // ZegoCloud থেকে কপি করা AppSign টি এখানে বসান

  /// Initialize Zego Express SDK
  static Future<void> initZegoEngine() async {
    ZegoEngineProfile profile = ZegoEngineProfile(
      appID,
      ZegoScenario.General,
      appSign: appSign,
    );

    await ZegoExpressEngine.createEngineWithProfile(profile);
  }

  /// Start Live Streaming (Host/Publisher)
  static Future<void> startPublishingStream(String streamID) async {
    await ZegoExpressEngine.instance.startPublishingStream(streamID);
  }

  /// Stop Live Streaming
  static Future<void> stopPublishingStream() async {
    await ZegoExpressEngine.instance.stopPublishingStream();
  }

  /// Join and Watch Live Stream (Audience/Player)
  static Future<void> startPlayingStream(String streamID) async {
    await ZegoExpressEngine.instance.startPlayingStream(streamID);
  }

  /// Stop Watching Stream
  static Future<void> stopPlayingStream(String streamID) async {
    await ZegoExpressEngine.instance.stopPlayingStream(streamID);
  }
}
