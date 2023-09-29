import 'dart:collection';

//import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:partier/model/event.dart';


/// Page displaying the summary of the events to which a user is subscribed as
/// both host and guest.
class UserPage extends StatefulWidget {
	UserPage({super.key});

	@override
	State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
	//final _dateFormat = DateFormat('d/M/y');
	final DateTime _firstDay = DateTime(2006);
	final DateTime _lastDay = DateTime(2036);
	final CalendarFormat _calendarFormat = CalendarFormat.month;

	late DateTime _focusedDay;
	late DateTime _selectedDay;
	late Map<DateTime, List<Event>> _events;

	// TODO: Improve using shifts
	int getHashCode(DateTime key) {
		return key.day * 1000000 + key.month * 10000 + key.year;
	}

	// TODO: Not efficient, doesn't remove if not found, always adds
	void loadEvents() async {
		DateTime firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
		DateTime lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

		Event event;
		DateTime eventDate;

		_events = {};

		var snap = await FirebaseFirestore.instance
			.collection('events')
			.where('date', isGreaterThanOrEqualTo: firstDay)
			.where('date', isLessThanOrEqualTo: lastDay)
			.withConverter(
				fromFirestore: Event.fromFirestore,
				toFirestore: (event, options) => event.toFirestore())
			.get();

		print('[loadEvents] isEmpty: ${snap.docs.isEmpty}');

		for (var doc in snap.docs) {
			event = doc.data();
			eventDate = event.eventDate;

			if (_events[eventDate] == null)	_events[eventDate] = [];
			_events[eventDate]!.add(event);

			print('[loadEvents] _events: $_events');
		}
	}

	/*
	Widget banner = CarouselSlider(
		options: CarouselOptions(
			aspectRatio: 16/9,
			enableInfiniteScroll: false,
			enlargeCenterPage: false,
			scrollDirection: Axis.horizontal,
		),
		items: ,
	);
	 */

	/// Returns the (eventually empty) list of events of a given day.
	List<Event> _getEventsForDay(DateTime day) {
		return _events[day] ?? [];
	}

	void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
		print('[onDaySelected] $selectedDay: ${_events[selectedDay]}');

		if (!isSameDay(_selectedDay, selectedDay)) {
			setState(() {
				_focusedDay = focusedDay;
				_selectedDay = selectedDay;
			});
		}
	}

	void _onPageChanged(focusedDay) {
		setState(() {
			_focusedDay = focusedDay;
			loadEvents();
		});
	}

	@override
	void initState() {
		super.initState();

		_focusedDay = DateTime.now();
		_selectedDay = _focusedDay;

		_events = LinkedHashMap(
				equals: isSameDay,
				hashCode: getHashCode,
			);

		loadEvents();
	}

	@override
	Widget build(BuildContext context) {
		return 
			Scaffold(
				appBar: AppBar(),
			  body: SingleChildScrollView(
					padding: const EdgeInsets.all(8),
					child: TableCalendar(
						firstDay: _firstDay,
						lastDay: _lastDay,
						focusedDay: _focusedDay,
						selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
						calendarFormat: _calendarFormat,
						eventLoader: _getEventsForDay,
						onDaySelected: _onDaySelected,
						onPageChanged: _onPageChanged,
					),
			  ),
			);
	}
}