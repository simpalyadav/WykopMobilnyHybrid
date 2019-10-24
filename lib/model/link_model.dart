import 'package:flutter/foundation.dart';
import 'package:owmflutter/models/models.dart';
import 'package:owmflutter/model/model.dart';
import 'package:owmflutter/api/api.dart';

class LinkModel extends InputModel {
  @override
  Future<void> onInputSubmitted(InputData data) async {}
  int _id;
  String _title;
  String _description;
  String _tags;
  String _sourceUrl;
  int _relatedCount;
  String _preview;
  bool _isHot;
  bool _canVote;
  String _date;
  int _voteCount;
  Author _author;
  List<LinkComment> _comments;
  int _commentsCount;
  int _buryCount;
  List<Related> _relatedLinks;
  LinkVoteState _voteState;
  bool _isFavorite;

  int get id => _id;
  String get date => _date;
  int get voteCount => _voteCount;
  Author get author => _author;
  String get title => _title.replaceAll('&quot;', '"').replaceAll('&amp;', '&');
  String get description =>
      _description.replaceAll('&quot;', '"').replaceAll('&amp;', '&');
  String get sourceUrl => _sourceUrl;
  String get tags => _tags;
  int get relatedCount => _relatedCount;
  String get preview => _preview;
  List<Related> get relatedLinks => _relatedLinks;
  bool get isHot => _isHot;
  bool get isFavorite => _isFavorite;
  bool get canVote => _canVote;

  int get commentsCount => _commentsCount;
  LinkVoteState get voteState => _voteState;
  List<LinkComment> get comments => _comments;

  void setData(Link link) {
    _id = link.id;
    _date = link.date;
    _voteCount = link.voteCount;
    _author = link.author;
    _description = link.description;
    _title = link.title;
    _sourceUrl = link.sourceUrl;
    _tags = link.tags;
    _buryCount = link.buryCount;
    _relatedCount = link.relatedCount;
    _preview = link.preview;
    _isHot = link.isHot;
    _isFavorite = link.isFavorite;
    _canVote = link.canVote;
    _relatedLinks = [];
    _voteState = link.voteState;
    _comments = [];
    _commentsCount = link.commentsCount;
    notifyListeners();
  }

  void setId(int id) {
    _id = id;
  }

  void favoriteToggle() async {
    _isFavorite = await api.entries.markFavorite(_id);
    notifyListeners();
  }

  Future<void> loadComments() async {
    var allComents = await api.links.getLinkComments(id);
    _comments = allComents;
    /*.where((e) => e.id == e.parentId)
      ..forEach(
        (c) {
          c.children.addAll(
            allComents.where((e) => e.parentId == c.id && e.id != c.id),
          );
        },
      );*/
    _relatedLinks = await api.links.getRelatedLinks(id);
    notifyListeners();
  }

  Future<void> voteUp() async {
    if (_voteState != LinkVoteState.NONE) {
      return voteRemove();
    }

    var res = await api.links.voteUp(_id.toString());
    _buryCount = res.buries;
    _voteCount = res.digs;
    _voteState = res.state;
    notifyListeners();
  }

  Future<void> voteDown(int reason) async {
    if (_voteState != LinkVoteState.NONE) {
      return voteRemove();
    }
    var res = await api.links.voteDown(_id.toString(), reason);
    _buryCount = res.buries;
    _voteCount = res.digs;
    _voteState = res.state;
    notifyListeners();
  }

  Future<void> voteRemove() async {
    var res = await api.links.voteRemove(_id.toString());
    _buryCount = res.buries;
    _voteCount = res.digs;
    _voteState = res.state;
    notifyListeners();
  }
}
