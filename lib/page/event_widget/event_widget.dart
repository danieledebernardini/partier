import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:partier/model/event.dart';
import './event_survey/event_survey.dart';


class EventWidget extends StatelessWidget {

  final formatter = DateFormat('d/M/y');
  final Event event;
  
  EventWidget({
    super.key,
    required this.event,
  });

  Widget _buildPoll(BuildContext context) {
    return EventSurvey(
      title: 'Drinks',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        snap: true,
        builder: (BuildContext context, ScrollController scrollController) {
          return DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              appBar: AppBar(
                title: Text(
                  event.eventName,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                bottom: const TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.cloud_outlined),
                      text: 'Summary',
                    ),
                    Tab(
                      icon: Icon(Icons.beach_access_sharp),
                      text: 'Participants',
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  ListView(
                    //shrinkWrap: true,
                    controller: scrollController,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Time left:',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(formatter.format(event.eventDate)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18.0,),
                          const Divider(
                            color: Colors.grey,
                            height: 4.0,
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(left: 20.0, right: 20.0,
                                    top: 5.0, bottom: 10.0),
                                child: const Text("Surveys"),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => _buildPoll(context),
                                  );
                                },
                                child: const Text('Drinks'),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.grey,
                            height: 5.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                  ListView(
                    children: [
                      Column(
                        children: const [
                          Text('Participants'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

