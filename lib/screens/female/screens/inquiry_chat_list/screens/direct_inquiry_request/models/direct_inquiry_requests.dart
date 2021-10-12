import 'package:darkpanda_flutter/enums/inquiry_status.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;

class DirectInquiryRequests extends Equatable {
  const DirectInquiryRequests({
    this.inquiryUuid,
    this.createdAt,
    this.username,
    this.avatarUrl,
    this.inquiryStatus,
  });

  final String inquiryUuid;
  final DateTime createdAt;
  final String username;
  final String avatarUrl;
  final InquiryStatus inquiryStatus;

  factory DirectInquiryRequests.fromJson(Map<String, dynamic> data) {
    var parsedCreatedAt = DateTime.now();

    if (data['created_at'] != null) {
      parsedCreatedAt = DateTime.tryParse(data['created_at']);
    } else {
      developer.log(
        '${data['inquiry_uuid']}: ${data['created_at']} can not be parse to DateTime object',
        name: 'Failed to parse datetime string to DateTime object',
      );
    }

    // Convert the value of `inquiry_status` from enum to string.
    String iqStatus = data['inquiry_status'] as String;

    return DirectInquiryRequests(
      inquiryUuid: data['inquiry_uuid'],
      createdAt: parsedCreatedAt.toLocal(),
      username: data['username'],
      avatarUrl: data['avatar_url'],
      // inquiryStatus: iqStatus.toInquiryStatusEnum(),
    );
  }

  DirectInquiryRequests copyWith({
    String inquiryUuid,
    DateTime createdAt,
    String username,
    String avatarUrl,
    InquiryStatus inquiryStatus,
  }) {
    return DirectInquiryRequests(
      inquiryUuid: inquiryUuid ?? this.inquiryUuid,
      createdAt: createdAt ?? this.createdAt,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      inquiryStatus: inquiryStatus ?? this.inquiryStatus,
    );
  }

  @override
  List<Object> get props => [
        inquiryUuid,
        createdAt,
        username,
        avatarUrl,
        inquiryStatus,
      ];
}
