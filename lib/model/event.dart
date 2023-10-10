import 'package:cloud_firestore/cloud_firestore.dart';


// TODO: add participants
class Event {
  static const String columnId = "_id";
  static const String columnNameEvent = "name_event";
  static const String columnCreationDate = "creation_date";
  static const String columnDescription = "description";
  static const String columnDressCode = "dress_code";
  static const String columnEventDate = "event_date";
  static const String columnOwner = "owner";
  static const String columnPlace = "place";
  static const String columnPublic = "public";

  Event({
    required this.id,
    required this.eventName,
    required this.eventDate,
    this.description,
    this.dressCode,
    this.creationDate,
    this.place,
    this.owner,
    this.public
  });

  final String id;
  final String eventName;
  final DateTime eventDate;
  final String? description;
  final String? dressCode;
  final DateTime? creationDate;
  final GeoPoint? place;
  final String? owner;
  final bool? public;

  @override
  String toString() {
    late String event;

    event = 'Event $id: \n'
            '- Name: $eventName; \n'
            '- Date: $eventDate; \n';

    return event;
  }

  /// Function which associates a snapshot from the database to a event.

  factory Event.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return Event(
      id: snapshot.id,
      eventName: data?['name_event'],
      creationDate: data?['creation_date'].toDate(),
      description: data?['description'],
      dressCode: data?['dress_code'],
      owner: data?['owner'],
      place: data?['place'],
      public: data?['public'],
      eventDate: data?['event_date'].toDate(),
      //guests: data?['guests'] is Iterable ? List.from(data?['guests']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name_event": eventName,
      "event_date": Timestamp.fromDate(eventDate),

      if(dressCode != null) "dress_code": dressCode,
      if(description != null) "description": description,
      if(owner != null) "owner": owner,
      if(creationDate != null) "creation_date": creationDate,
      if(place != null) "place": place,
      if(public != null) "public": true
    };
  }

  Map toMap() {
    Map<String, dynamic> map = {
      columnNameEvent: eventName,
      columnCreationDate: creationDate,
      columnDescription: description,
      columnDressCode: dressCode,
      columnEventDate: eventDate,
      columnPlace: place,
      columnOwner: owner,
      columnPublic: public
    };

    return map;
  }

  /*
  // TODO: consider to implement these
  factory City.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return City(
      name: data?['name'],
      state: data?['state'],
      country: data?['country'],
      capital: data?['capital'],
      population: data?['population'],
      regions:
      data?['regions'] is Iterable ? List.from(data?['regions']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (state != null) "state": state,
      if (country != null) "country": country,
      if (capital != null) "capital": capital,
      if (population != null) "population": population,
      if (regions != null) "regions": regions,
    };
  }
   */

  /*
  static AustinFeedsMeEvent fromMap(Map map) {
    return new AustinFeedsMeEvent(
        name: map[columnName],
        time: map[columnTime],
        description: map[columnDescription],
        url: map[columnUrl],
        photoUrl: map[columnPhotoUrl],
        latLng: new LatLng(map[columnLat], map[columnLng]));
  }
   */
}