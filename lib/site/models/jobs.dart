import '../read.dart';
import 'social_profile.dart';

/// The kinds of job the website lists, by its names.
enum JobKind {
  fullTime('full_time', 'Full-time'),
  partTime('part_time', 'Part-time'),
  eventShift('event_shift', 'Event shift'),
  freelance('freelance', 'Freelance gig'),
  collaboration('collaboration', 'Paid collaboration'),
  ambassador('ambassador', 'Promoter or ambassador');

  const JobKind(this.wire, this.label);

  final String wire;
  final String label;

  static JobKind? fromWire(Object? v) {
    for (final k in values) {
      if (k.wire == v) return k;
    }
    return null;
  }
}

/// Where an application stands.
enum ApplicationState {
  sent('sent', 'Sent'),
  shortlisted('shortlisted', 'Shortlisted'),
  accepted('accepted', 'Accepted'),
  declined('declined', 'Not this time'),
  withdrawn('withdrawn', 'Taken back');

  const ApplicationState(this.wire, this.label);

  final String wire;
  final String label;

  static ApplicationState? fromWire(Object? v) {
    for (final s in values) {
      if (s.wire == v) return s;
    }
    return null;
  }
}

/// The caller's own application to a job, in short.
class AppliedRef {
  const AppliedRef({required this.id, required this.state});

  final String id;
  final ApplicationState state;
}

/// A job listing (`job_json`). [applications] and [waiting] are the business's own numbers and null for anyone else.
class Job {
  const Job({
    required this.id,
    required this.title,
    required this.kind,
    required this.description,
    required this.compensation,
    required this.deadline,
    required this.status,
    required this.open,
    required this.poster,
    this.requirements,
    this.location,
    this.remote = false,
    this.schedule,
    this.createdAt,
    this.mine = false,
    this.applications,
    this.waiting,
    this.applied,
  });

  final String id;
  final String title;
  final JobKind kind;
  final String description;
  final String? requirements;
  final String compensation;
  final String? location;
  final bool remote;
  final String? schedule;

  /// The last day to apply.
  final DateTime deadline;

  /// `open`, `closed`, `filled` or `removed`.
  final String status;

  /// Taking applications now: open and the last day has not passed.
  final bool open;
  final SocialProfile poster;
  final DateTime? createdAt;

  /// The caller manages the business that posted it.
  final bool mine;
  final int? applications;
  final int? waiting;
  final AppliedRef? applied;

  bool get isFilled => status == 'filled';
  bool get isClosed => status == 'closed' || status == 'filled';

  /// "Toronto", "Remote" or "Toronto or remote".
  String get where => location != null && remote ? '$location or remote' : (location ?? (remote ? 'Remote' : ''));
}

Job? parseJob(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final title = readText(json['title']);
  final kind = JobKind.fromWire(json['kind']);
  final description = readText(json['description']);
  final compensation = readText(json['compensation']);
  final deadline = readDay(json['deadline']);
  final status = readText(json['status']);
  final poster = parseSocialProfile(json['poster']);
  if (id == null || title == null || kind == null || description == null || compensation == null || deadline == null || status == null || poster == null) return null;
  final applied = json['applied'];
  final appliedState = applied is Map ? ApplicationState.fromWire(applied['state']) : null;
  final appliedId = applied is Map ? readText(applied['id']) : null;
  final created = readText(json['created_at']);
  return Job(
    id: id,
    title: title,
    kind: kind,
    description: description,
    requirements: readText(json['requirements']),
    compensation: compensation,
    location: readText(json['location']),
    remote: json['remote'] == true,
    schedule: readText(json['schedule']),
    deadline: deadline,
    status: status,
    open: json['open'] == true,
    poster: poster,
    createdAt: created == null ? null : DateTime.tryParse(created)?.toLocal(),
    mine: json['mine'] == true,
    applications: readInt(json['applications']),
    waiting: readInt(json['waiting']),
    applied: appliedState == null || appliedId == null ? null : AppliedRef(id: appliedId, state: appliedState),
  );
}

List<Job> parseJobs(Object? json) => json is List ? [for (final r in json) if (parseJob(r) case final j?) j] : const [];

/// The job an application is for, in short.
class JobRef {
  const JobRef({required this.id, required this.title, required this.kind, required this.status, required this.deadline, required this.open, required this.poster});

  final String id;
  final String title;
  final JobKind kind;
  final String status;
  final DateTime deadline;
  final bool open;
  final SocialProfile poster;
}

/// An application (`job_application_json`): what the applicant wrote and what the business answered.
class JobApplication {
  const JobApplication({required this.id, required this.state, required this.message, required this.applicant, required this.job, this.link, this.reply, this.createdAt, this.decidedAt});

  final String id;
  final ApplicationState state;
  final String message;
  final String? link;
  final String? reply;
  final DateTime? createdAt;
  final DateTime? decidedAt;
  final SocialProfile applicant;
  final JobRef job;

  bool get isAnswered => state == ApplicationState.accepted || state == ApplicationState.declined;
}

JobApplication? parseJobApplication(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final state = ApplicationState.fromWire(json['state']);
  final message = readText(json['message']);
  final applicant = parseSocialProfile(json['applicant']);
  final j = json['job'];
  if (id == null || state == null || message == null || applicant == null || j is! Map) return null;
  final jobId = readText(j['id']);
  final title = readText(j['title']);
  final kind = JobKind.fromWire(j['kind']);
  final status = readText(j['status']);
  final deadline = readDay(j['deadline']);
  final poster = parseSocialProfile(j['poster']);
  if (jobId == null || title == null || kind == null || status == null || deadline == null || poster == null) return null;
  final created = readText(json['created_at']);
  final decided = readText(json['decided_at']);
  return JobApplication(
    id: id,
    state: state,
    message: message,
    link: readText(json['link']),
    reply: readText(json['reply']),
    createdAt: created == null ? null : DateTime.tryParse(created)?.toLocal(),
    decidedAt: decided == null ? null : DateTime.tryParse(decided)?.toLocal(),
    applicant: applicant,
    job: JobRef(id: jobId, title: title, kind: kind, status: status, deadline: deadline, open: j['open'] == true, poster: poster),
  );
}

List<JobApplication> parseJobApplications(Object? json) => json is List ? [for (final r in json) if (parseJobApplication(r) case final a?) a] : const [];
