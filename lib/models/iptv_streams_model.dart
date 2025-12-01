import 'package:objectbox/objectbox.dart';

@Entity()
class IptvStreamModel {
  @Id()
  int id;
  final String channel;
  final String feed;
  final String title;
  final String url;
  final String referrer;
  final String userAgent;
  final String quality;

  IptvStreamModel({
    this.id = 0,
    required this.channel,
    required this.feed,
    required this.title,
    required this.url,
    required this.referrer,
    required this.userAgent,
    required this.quality,
  });

  factory IptvStreamModel.fromJson(Map<String, dynamic> json) {
    return IptvStreamModel(
      channel: json['channel'] as String? ?? '',
      feed: json['feed'] as String? ?? '',
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      referrer: json['referrer'] as String? ?? '',
      userAgent: json['user_agent'] as String? ?? '',
      quality: json['quality'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'feed': feed,
      'title': title,
      'url': url,
      'referrer': referrer,
      'user_agent': userAgent,
      'quality': quality,
    };
  }

  IptvStreamModel copyWith({
    String? channel,
    String? feed,
    String? title,
    String? url,
    String? referrer,
    String? userAgent,
    String? quality,
  }) {
    return IptvStreamModel(
      channel: channel ?? this.channel,
      feed: feed ?? this.feed,
      title: title ?? this.title,
      url: url ?? this.url,
      referrer: referrer ?? this.referrer,
      userAgent: userAgent ?? this.userAgent,
      quality: quality ?? this.quality,
    );
  }

  @override
  String toString() {
    return 'IptvStreamModel(channel: $channel, feed: $feed, title: $title, url: $url, referrer: $referrer, userAgent: $userAgent, quality: $quality)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IptvStreamModel &&
        other.channel == channel &&
        other.feed == feed &&
        other.title == title &&
        other.url == url &&
        other.referrer == referrer &&
        other.userAgent == userAgent &&
        other.quality == quality;
  }

  @override
  int get hashCode =>
      channel.hashCode ^
      feed.hashCode ^
      title.hashCode ^
      url.hashCode ^
      referrer.hashCode ^
      userAgent.hashCode ^
      quality.hashCode;
}