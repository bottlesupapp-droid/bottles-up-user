import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/jobs.dart';
import '../site_error.dart';

String _day(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String? _blank(String? s) => s == null || s.trim().isEmpty ? null : s.trim();

/// What a business writes for a listing.
class JobDraft {
  const JobDraft({
    required this.title,
    required this.kind,
    required this.description,
    required this.compensation,
    required this.deadline,
    this.requirements,
    this.location,
    this.remote = false,
    this.schedule,
  });

  final String title;
  final JobKind kind;
  final String description;
  final String? requirements;
  final String compensation;
  final String? location;
  final bool remote;
  final String? schedule;
  final DateTime deadline;
}

/// Jobs and applications, through the website's functions. Applying is free and private; the website decides who may see what.
class JobsService {
  JobsService(this._db);

  final SupabaseClient _db;

  Future<T> _rpc<T>(String name, Map<String, dynamic> params, T Function(Object? answer) read, String generic) async {
    final Object? answer;
    try {
      answer = await _db.rpc(name, params: params);
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: generic);
    }
    return read(answer);
  }

  Job _job(Object? a) => parseJob(a) ?? (throw const SiteException('We could not read the answer. Look at your jobs before trying again.'));

  JobApplication _application(Object? a) => parseJobApplication(a) ?? (throw const SiteException('We could not read the answer. Look at your applications before trying again.'));

  Map<String, dynamic> _fields(JobDraft d) => {
        'p_title': d.title.trim(),
        'p_kind': d.kind.wire,
        'p_description': d.description.trim(),
        'p_requirements': _blank(d.requirements),
        'p_compensation': d.compensation.trim(),
        'p_location': _blank(d.location),
        'p_remote': d.remote,
        'p_schedule': _blank(d.schedule),
        'p_deadline': _day(d.deadline),
      };

  /// Open jobs, newest first, for the profile the person is acting as. [before] and [beforeId] continue after the last one of the page before.
  Future<List<Job>> list({required String actor, JobKind? kind, String? query, bool? remote, DateTime? before, String? beforeId, int limit = 20}) => _rpc(
        'jobs_list',
        {'p_actor': actor, 'p_kind': kind?.wire, 'p_query': _blank(query), 'p_remote': remote, 'p_before': before?.toUtc().toIso8601String(), 'p_before_id': beforeId, 'p_limit': limit},
        parseJobs,
        loadFailedMessage('the jobs'),
      );

  Future<Job> job({required String actor, required String id}) => _rpc('job_get', {'p_actor': actor, 'p_job': id}, _job, loadFailedMessage('this job'));

  Future<Job> create({required String actor, required JobDraft draft}) => _rpc('job_create', {'p_actor': actor, ..._fields(draft)}, _job, 'The job was not posted. Check your connection and try again.');

  Future<Job> update({required String actor, required String id, required JobDraft draft}) =>
      _rpc('job_update', {'p_actor': actor, 'p_job': id, ..._fields(draft)}, _job, 'The change was not saved. Check your connection and try again.');

  /// Closes a listing: [filled] when somebody was found.
  Future<Job> close({required String actor, required String id, bool filled = false}) => _rpc('job_close', {'p_actor': actor, 'p_job': id, 'p_filled': filled}, _job, actionFailedMessage);

  /// The listings of a business profile the person manages.
  Future<List<Job>> mine(String actor) => _rpc('jobs_mine', {'p_actor': actor}, parseJobs, loadFailedMessage('your jobs'));

  Future<JobApplication> apply({required String actor, required String job, required String message, String? link}) =>
      _rpc('job_apply', {'p_actor': actor, 'p_job': job, 'p_message': message.trim(), 'p_link': _blank(link)}, _application, 'Your application was not sent. Check your connection and try again.');

  /// What a business has received for one listing.
  Future<List<JobApplication>> applications({required String actor, required String job}) => _rpc('job_applications', {'p_actor': actor, 'p_job': job}, parseJobApplications, loadFailedMessage('the applications'));

  /// The business answers: shortlist, accept or decline, with a reply the applicant reads.
  Future<JobApplication> answer({required String actor, required String application, required ApplicationState state, String? reply}) =>
      _rpc('job_application_set', {'p_actor': actor, 'p_application': application, 'p_state': state.wire, 'p_reply': _blank(reply)}, _application, actionFailedMessage);

  Future<JobApplication> withdraw({required String actor, required String application}) => _rpc('job_application_withdraw', {'p_actor': actor, 'p_application': application}, _application, actionFailedMessage);

  /// The applications a profile has sent.
  Future<List<JobApplication>> myApplications(String actor) => _rpc('job_applications_mine', {'p_actor': actor}, parseJobApplications, loadFailedMessage('your applications'));
}
