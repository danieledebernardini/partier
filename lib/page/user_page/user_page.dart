import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:event/event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../event_widget/container/my_fancy_container.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../event_widget/container/my_container.dart';


/// Page displaying the summary of the events to which a user is subscribed as
/// both host and guest.
class UserPage extends StatefulWidget {
	Map events = <DateTime, List<Event<EventArgs>>>{
		DateTime.now(): [Event()],
	};
	
	UserPage({super.key});

	@override
	State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
	var _calendarFormat = CalendarFormat.month;
	var _selectedDay = DateTime.now();
	var _focusedDay = DateTime.now();
	var _selectedEvents = <Event>[];

	final DateFormat formatter = DateFormat('dd/MM/yyyy');
	final carouselOpt = CarouselOptions(
		aspectRatio: 16/9,
		enableInfiniteScroll: false,
		autoPlay: false,
		autoPlayInterval: const Duration(seconds: 2),
		autoPlayAnimationDuration: const Duration(milliseconds: 800),
		autoPlayCurve: Curves.fastOutSlowIn,
		enlargeCenterPage: false,
		enlargeFactor: 0.0,
		scrollDirection: Axis.horizontal,
	);

	/// Returns the (eventually empty) list of events of a given day.
	List<Event> _getEventsForDay(UserPage widget, DateTime day) {
		return widget.events[day] ?? [];
	}

	/// Returns the list of events to be shown in 'banner' widget.
	List<Widget> _buildList(List<Event> events) {
		List<Widget> content = [];

		if(events.isEmpty) {
			content.add(
				const Text('No events for today', textAlign: TextAlign.center,)
			);
		} else {
			for(int i = 0; i < events.length; i++) {
				content.add(
					MyContainer(
						title: 'Will of the People!',
						subtitle: "L'evento di Rock Alternativo dell'anno!",
						space_for_button: '',
						image_path: 'assets/images/muse.png',
					)
				);
			}
		}

		return content;
	}

	/// Returns the list of events for the specified day and renders it.
	void _onDaySelected(UserPage widget, DateTime selectedDay, DateTime focusedDay) {
		//_focusedDay = focusedDay;
		_selectedDay = selectedDay;
		_selectedEvents = _getEventsForDay(widget, selectedDay);

		setState(() {
			//_buildList(_selectedEvents);
		});
	}

	@override
	Widget build(BuildContext context) {
		Widget banner = CarouselSlider(
			options: carouselOpt,
			items: _buildList(_selectedEvents).map((i) => Builder(
				builder: (BuildContext context) {
					return Container(
						// width: MediaQuery.of(context).size.width,
						margin: const EdgeInsets.symmetric(horizontal: 5.0),
						decoration: const BoxDecoration(
								color: Colors.white24
						),
						child: i,
					);
				},
			)).toList(),
		);

		return ListView(
			padding: const EdgeInsets.all(8),
			children: <Widget>[
				TableCalendar(
					firstDay: DateTime(2006),
					lastDay: DateTime(2036),
					focusedDay: _focusedDay,
					calendarFormat: _calendarFormat,
					onFormatChanged: (format) {
						setState(() {
							_calendarFormat = format;
						});
					},
					selectedDayPredicate: (day) {
						return isSameDay(_selectedDay, day);
					},
					onDaySelected: (selectedDay, focusedDay) {
						_onDaySelected(widget, selectedDay, focusedDay);
					},
					onPageChanged: (focusedDay) {
						_focusedDay = focusedDay;
					},
					eventLoader: (day) {
						return _getEventsForDay(widget, day);
					},
				),
				Container(
					height: 15,
				),
				Text(
					'Upcoming events - ${formatter.format(_selectedDay)}',
					style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
				),
				Container(
					height: 15,
				),
				banner,
			],
		);
	}
}