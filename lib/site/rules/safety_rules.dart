import '../models/safety.dart';

/// The words shown for each reason, in the order they are offered. The hint says what it covers so nobody has to guess.
const List<({ReportReason reason, String label, String hint})> reportReasons = [
  (reason: ReportReason.spam, label: 'Spam', hint: 'Ads, repeated messages or fake engagement'),
  (reason: ReportReason.harassment, label: 'Harassment or bullying', hint: 'Targeting or insulting someone'),
  (reason: ReportReason.hate, label: 'Hate speech', hint: 'Attacking people for who they are'),
  (reason: ReportReason.sexual, label: 'Nudity or sexual content', hint: 'Not allowed on BottlesUp'),
  (reason: ReportReason.violence, label: 'Violence or threats', hint: 'Hurting or threatening to hurt someone'),
  (reason: ReportReason.scam, label: 'Scam or fraud', hint: 'Trying to get money or details dishonestly'),
  (reason: ReportReason.impersonation, label: 'Pretending to be someone else', hint: 'A fake or copied account'),
  (reason: ReportReason.selfHarm, label: 'Self-harm', hint: 'Someone who may hurt themselves'),
  (reason: ReportReason.other, label: 'Something else', hint: 'Tell us in your own words'),
];

String reportKindLabel(ReportKind kind) => switch (kind) {
      ReportKind.post => 'post',
      ReportKind.comment => 'comment',
      ReportKind.profile => 'profile',
      ReportKind.message => 'message',
      ReportKind.review => 'review',
      ReportKind.job => 'job',
    };

const int reportDetailsMax = 500;

/// What to say after a report, whether it was new or already sent.
String reportThanks(ReportReceipt receipt) => receipt.already ? 'You already reported this. Our team has it.' : 'Thanks for telling us. Our team will take a look.';
