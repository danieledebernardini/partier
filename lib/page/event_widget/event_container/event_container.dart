import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../event_widget.dart';
import 'package:partier/model/event.dart';
import 'package:partier/routing/app_router.dart';


class EventContainer extends StatelessWidget {

  final formatter = DateFormat('d/M/y');
  final Event event;

  EventContainer({
    super.key,
    required this.event,
  });

  Widget _buildEventDialog() {
    return EventWidget(event: event);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildEventDialog(),
        );
        //context.goNamed("event", extra: event);
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width*0.95,
        height: MediaQuery.of(context).size.height*0.2,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: [
              Colors.lightGreenAccent,
              Colors.lightBlue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width*0.9,
          height: MediaQuery.of(context).size.height*0.17,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20)
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/images/sanremo.jpg'),
                      opacity: 0.5,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20)
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                event.eventName,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              formatter.format(event.eventDate),
                              style: const TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
