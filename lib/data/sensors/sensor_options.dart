class SensorOptions {
  List<bool> channels;
  final String name;
  final List<String> channelsLabels;
  bool active;
  int samplingRate;

  SensorOptions({
    this.name,
    this.channels = const [true],
    this.channelsLabels,
    this.samplingRate,
  }) {
    if (channelsLabels != null)
      assert(channels.length == channelsLabels.length);
    _updateActive();
  }

  void toggle() {
    active = !active;
    channels = List<bool>.from(channels.map((_) => active));
  }

  void toggleChannel(int index) {
    channels[index] = !channels[index];
    _updateActive();
  }

  void _updateActive() {
    active = channels.any((active) => active);
  }
}
