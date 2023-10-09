import 'package:json_annotation/json_annotation.dart';
part 'notification_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationDTO {
  @JsonKey(name: "id")
  final int id;
  @JsonKey()
  final String title;
  @JsonKey()
  final String description;
  @JsonKey()
  final bool isInvite;
  @JsonKey()
  final int projectID;
  @JsonKey()
  final String projectName;
  @JsonKey()
  final int classID;
  @JsonKey()
  final String className;
  @JsonKey()
  final int fromID;
  @JsonKey()
  final String fromName;
  @JsonKey()
  final int toID;
  @JsonKey()
  final String toName;
  @JsonKey()
  final DateTime sentAt;
  @JsonKey()
  final bool read;

  NotificationDTO({
    required this.id,
    required this.title,
    required this.description,
    required this.isInvite,
    required this.projectID,
    required this.projectName,
    required this.classID,
    required this.className,
    required this.fromID,
    required this.fromName,
    required this.toID,
    required this.toName,
    required this.sentAt,
    required this.read,
  });

  factory NotificationDTO.fromJson(Map<String, dynamic> json) =>
      _$NotificationDTOFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDTOToJson(this);
}
