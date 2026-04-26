import 'package:audioplayers/audioplayers.dart';
import 'package:my_reading_town/infrastructure/persistence/database_helper.dart';

class AudioService {
  final DatabaseHelper _db;

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _birdsPlayer = AudioPlayer();
  final AudioPlayer _suspensePlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _wheelSpinPlayer = AudioPlayer();
  final AudioPlayer _constructionWip2Player = AudioPlayer();

  bool _initialized = false;
  int _musicLevel = 3;
  int _effectsLevel = 3;
  bool _suspenseActive = false;
  bool _bgPausedMusic = false;
  bool _bgPausedBirds = false;
  bool _bgPausedSuspense = false;

  static const int defaultMusicLevel = 3;
  static const int defaultEffectsLevel = 3;

  static const String _mainMusicAsset = 'audios/my-reading-town-main.wav';
  static const String _birdsAsset = 'audios/birds.mp3';
  static const String _suspenseAsset = 'audios/my-reading-town-suspense.wav';
  static const String _correctAsset = 'audios/correct-answer-sound.mp3';
  static const String _wrongAsset = 'audios/wrong-answer-sound.mp3';
  static const String _winnerAsset = 'audios/winner-sound.mp3';
  static const String _villagerUnlockedAsset = 'audios/villager-unlocked.wav';
  static const String _wheelSpinAsset = 'audios/wheel-spin.mp3';
  static const String _levelUpAsset = 'audios/level-up.mp3';
  static const String _missionCompletedAsset = 'audios/mission-completed.wav';
  static const String _cameraSoundAsset = 'audios/camera-sound.mp3';
  static const String _constructionCompletedAsset = 'audios/construction-completed.wav';
  static const String _constructionWip1Asset = 'audios/construction-wip-1.wav';
  static const String _constructionWip2Asset = 'audios/construction-wip-2.wav';

  static final _mixingContext = AudioContext(
    android: AudioContextAndroid(
      audioFocus: AndroidAudioFocus.none,
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.game,
    ),
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playback,
      options: {AVAudioSessionOptions.mixWithOthers},
    ),
  );

  AudioService(this._db);

  int get musicLevel => _musicLevel;
  int get effectsLevel => _effectsLevel;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    _musicLevel = await _db.getMusicVolume();
    _effectsLevel = await _db.getEffectsVolume();
    await _birdsPlayer.setAudioContext(_mixingContext);
    await _effectPlayer.setAudioContext(_mixingContext);
    await _wheelSpinPlayer.setAudioContext(_mixingContext);
    await _constructionWip2Player.setAudioContext(_mixingContext);
    await _musicPlayer.setVolume(_musicLevel > 0 ? _musicLevel / 5.0 : 0);
    await _suspensePlayer.setVolume(_musicLevel > 0 ? _musicLevel / 5.0 : 0);
    await _birdsPlayer.setVolume(_effectsLevel > 0 ? _effectsLevel / 5.0 : 0);
    await _effectPlayer.setVolume(_effectsLevel > 0 ? _effectsLevel / 5.0 : 0);
    await _wheelSpinPlayer.setVolume(_effectsLevel > 0 ? _effectsLevel / 5.0 : 0);
    await _constructionWip2Player.setVolume(_effectsLevel > 0 ? _effectsLevel / 5.0 : 0);
    _musicPlayer.onPlayerComplete.listen((_) => _onMainTrackComplete());
    _birdsPlayer.onPlayerComplete.listen((_) => _onBirdsComplete());
  }

  void _onMainTrackComplete() {
    if (_musicLevel == 0 || _suspenseActive) return;
    _playBirds();
  }

  void _onBirdsComplete() {
    if (_musicLevel == 0 || _suspenseActive) return;
    _playMainTrack();
  }

  Future<void> _playMainTrack() async {
    if (_musicLevel == 0 || _suspenseActive) return;
    await _musicPlayer.setReleaseMode(ReleaseMode.release);
    await _musicPlayer.play(AssetSource(_mainMusicAsset));
  }

  Future<void> _playBirds() async {
    if (_suspenseActive) return;
    if (_effectsLevel == 0) {
      _playMainTrack();
      return;
    }
    await _birdsPlayer.setVolume(_effectsLevel / 5.0);
    await _birdsPlayer.setReleaseMode(ReleaseMode.release);
    await _birdsPlayer.play(AssetSource(_birdsAsset));
  }

  Future<void> startMusicLoop() async {
    if (_musicLevel == 0) return;
    await _playMainTrack();
  }

  Future<void> setMusicVolume(int level) async {
    if (level < 0 || level > 5) return;
    _musicLevel = level;
    await _db.saveMusicVolume(level);
    if (level == 0) {
      await _musicPlayer.pause();
      await _suspensePlayer.pause();
    } else {
      await _musicPlayer.setVolume(level / 5.0);
      await _suspensePlayer.setVolume(level / 5.0);
      if (!_suspenseActive && _musicPlayer.state != PlayerState.playing) {
        await _playMainTrack();
      }
      if (_suspenseActive && _suspensePlayer.state != PlayerState.playing) {
        await _suspensePlayer.setReleaseMode(ReleaseMode.loop);
        await _suspensePlayer.play(AssetSource(_suspenseAsset));
      }
    }
  }

  Future<void> setEffectsVolume(int level) async {
    if (level < 0 || level > 5) return;
    _effectsLevel = level;
    await _db.saveEffectsVolume(level);
    await _birdsPlayer.setVolume(level > 0 ? level / 5.0 : 0);
    await _effectPlayer.setVolume(level > 0 ? level / 5.0 : 0);
    await _wheelSpinPlayer.setVolume(level > 0 ? level / 5.0 : 0);
    await _constructionWip2Player.setVolume(level > 0 ? level / 5.0 : 0);
    if (level == 0 && _birdsPlayer.state == PlayerState.playing) {
      await _birdsPlayer.stop();
      await _playMainTrack();
    }
  }

  Future<void> startSuspenseMusic() async {
    _suspenseActive = true;
    await _musicPlayer.pause();
    await _birdsPlayer.stop();
    if (_musicLevel > 0) {
      await _suspensePlayer.setVolume(_musicLevel / 5.0);
      await _suspensePlayer.setReleaseMode(ReleaseMode.loop);
      await _suspensePlayer.play(AssetSource(_suspenseAsset));
    }
  }

  Future<void> stopSuspenseMusic({bool resumeMusic = true}) async {
    _suspenseActive = false;
    await _suspensePlayer.stop();
    if (resumeMusic && _musicLevel > 0) {
      await _playMainTrack();
    }
  }

  Future<void> _playEffect(String asset) async {
    if (_effectsLevel == 0) return;
    await _effectPlayer.stop();
    await _effectPlayer.setVolume(_effectsLevel / 5.0);
    await _effectPlayer.setReleaseMode(ReleaseMode.release);
    await _effectPlayer.play(AssetSource(asset));
  }

  Future<void> playCorrectSound() => _playEffect(_correctAsset);
  Future<void> playWrongSound() => _playEffect(_wrongAsset);
  Future<void> playWinnerSound() => _playEffect(_winnerAsset);
  Future<void> playVillagerUnlockedSound() => _playEffect(_villagerUnlockedAsset);
  Future<void> playLevelUpSound() => _playEffect(_levelUpAsset);
  Future<void> playMissionCompletedSound() => _playEffect(_missionCompletedAsset);
  Future<void> playCameraSound() => _playEffect(_cameraSoundAsset);
  Future<void> playConstructionCompletedSound() => _playEffect(_constructionCompletedAsset);

  Future<void> playConstructionWipSound() async {
    if (_effectsLevel == 0) return;
    final vol = _effectsLevel / 5.0;
    await _effectPlayer.stop();
    await _effectPlayer.setVolume(vol);
    await _effectPlayer.setReleaseMode(ReleaseMode.release);
    await _effectPlayer.play(AssetSource(_constructionWip1Asset));
    await _constructionWip2Player.stop();
    await _constructionWip2Player.setVolume(vol);
    await _constructionWip2Player.setReleaseMode(ReleaseMode.release);
    await _constructionWip2Player.play(AssetSource(_constructionWip2Asset));
  }

  Future<void> startWheelSpinSound(Duration spinDuration) async {
    if (_effectsLevel == 0) return;
    await _wheelSpinPlayer.setVolume(_effectsLevel / 5.0);
    await _wheelSpinPlayer.setReleaseMode(ReleaseMode.release);
    await _wheelSpinPlayer.setSource(AssetSource(_wheelSpinAsset));
    final audioDuration = await _wheelSpinPlayer.getDuration();
    if (audioDuration != null && audioDuration.inMilliseconds > 0) {
      final rate = audioDuration.inMilliseconds / spinDuration.inMilliseconds;
      await _wheelSpinPlayer.setPlaybackRate(rate.clamp(0.1, 4.0));
    }
    await _wheelSpinPlayer.resume();
  }

  Future<void> stopWheelSpinSound() async {
    await _wheelSpinPlayer.stop();
    await _wheelSpinPlayer.setPlaybackRate(1.0);
  }

  Future<void> pauseForBackground() async {
    _bgPausedMusic = _musicPlayer.state == PlayerState.playing;
    _bgPausedBirds = _birdsPlayer.state == PlayerState.playing;
    _bgPausedSuspense = _suspensePlayer.state == PlayerState.playing;
    if (_bgPausedMusic) await _musicPlayer.pause();
    if (_bgPausedBirds) await _birdsPlayer.pause();
    if (_bgPausedSuspense) await _suspensePlayer.pause();
    await _wheelSpinPlayer.stop();
    await _constructionWip2Player.stop();
  }

  Future<void> resumeFromBackground() async {
    if (_bgPausedSuspense) {
      _bgPausedSuspense = false;
      if (_musicLevel > 0) await _suspensePlayer.resume();
    }
    if (_bgPausedMusic) {
      _bgPausedMusic = false;
      if (_musicLevel > 0) await _musicPlayer.resume();
    }
    if (_bgPausedBirds) {
      _bgPausedBirds = false;
      if (_effectsLevel > 0) await _birdsPlayer.resume();
    }
  }

  Future<void> dispose() async {
    await _musicPlayer.dispose();
    await _birdsPlayer.dispose();
    await _suspensePlayer.dispose();
    await _effectPlayer.dispose();
    await _wheelSpinPlayer.dispose();
    await _constructionWip2Player.dispose();
  }
}
