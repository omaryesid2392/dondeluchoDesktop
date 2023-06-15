import 'package:dondelucho/models/service_model.dart';

class RequestModel {
  String type;
  String uid;
  bool active;
  bool isTaked;
  bool noTaked;
  String description;
  String nameCustomer;
  String city;
  List<num> idAgents;
  num distance;
  String direction;
  num offer;
  String category;
  String subcategory;
  String userUid;
  String agentId;
  ServiceModel service;
  String attached;
  String observation;
  String cel;

  RequestModel({
    this.uid,
    this.type,
    this.active,
    this.isTaked,
    this.noTaked,
    this.description,
    this.nameCustomer,
    this.city,
    this.idAgents,
    this.distance,
    this.direction,
    this.offer,
    this.category,
    this.userUid,
    this.agentId,
    this.subcategory,
    this.attached,
    this.observation,
    this.cel,
  });

  factory RequestModel.fromFirestore(dynamic doc) {
    Map data = doc.data;

    return RequestModel(
      uid: doc.documentID,
      active: data['active'] ?? '',
      isTaked: data['isTaked'] ?? null,
      noTaked: data['noTaked'] ?? null,
      type: data['type'] ?? '',
      idAgents: List<num>.from(
          data["idAgents"] != null ? data["idAgents"].map((x) => x) : []),
      // location: List<num>.from(data["location"].map((x) => x)),
      description: data['description'] ?? '',
      nameCustomer: data['nameCustomer'] ?? '',
      city: data['city'] ?? '',
      distance: data['distance'] ?? 0,
      direction: data['direction'],
      offer: data['offer'],
      subcategory: data['subcategory'],
      category: data['category'],
      userUid: data['userUid'],
      agentId: data['agentId'],
      attached: data['attached'] ?? null,
      observation: data['observation'] ?? null,
      cel: data['cel'] ?? null,
    );
  }

  factory RequestModel.fromMap(Map data) {
    return RequestModel(
      active: data['active'] ?? '',
      isTaked: data['isTaked'] ?? null,
      noTaked: data['noTaked'] ?? null,
      type: data['type'] ?? '',
      idAgents: List<num>.from(data["idAgent"].map((x) => x)),
      // location: List<num>.from(data["location"].map((x) => x)),
      description: data['description'] ?? '',
      nameCustomer: data['nameCustomer'] ?? '',
      city: data['city'] ?? '',
      distance: data['distance'] ?? 0,
      direction: data['direction'],
      offer: data['offer'],
      category: data['category'],
      subcategory: data['subcategory'],
      userUid: data['userUid'],
      agentId: data['agentId'],
      attached: data['attached'] ?? null,
      observation: data['observation'] ?? null,
      cel: data['cel'] ?? null,
    );
  }
}
