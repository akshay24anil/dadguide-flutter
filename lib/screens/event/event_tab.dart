import 'package:dadguide2/components/enums.dart';
import 'package:dadguide2/components/icons.dart';
import 'package:dadguide2/l10n/localizations.dart';
import 'package:dadguide2/screens/event/server_select_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'event_list.dart';
import 'event_search_bloc.dart';

final _dateFormatter = DateFormat.MMMMd();

/// A header-tabbed screen displaying events.
class EventTab extends StatelessWidget {
  EventTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: ChangeNotifierProvider(
        builder: (context) => ScheduleDisplayState(),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: EventListHeader(),
          ),
          body: Column(children: [
            Expanded(child: EventListTabs()),
            DateSelectBar(),
          ]),
        ),
      ),
    );
  }
}

/// The event tab header.
class EventListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var loc = DadGuideLocalizations.of(context);

    return AppBar(
      flexibleSpace: Row(
        children: [
          InkWell(
              onTap: () => showServerSelectDialog(context),
              child: SizedBox(width: 60, height: 40, child: DadGuideIcons.currentCountryOn)),
          Flexible(
            child: TabBar(tabs: [
              Tab(text: loc.eventTabAll),
              Tab(text: loc.eventTabGuerrilla),
              Tab(text: loc.eventTabSpecial),
//              News disabled for now
//              Tab(text: 'News'),
            ]),
          ),
        ],
      ),
    );
  }
}

/// The tab contents.
class EventListTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBarView(children: [
      EventList(ScheduleTabKey.all),
      EventList(ScheduleTabKey.guerrilla),
      EventList(ScheduleTabKey.special),
//              News disabled for now
//      EventList(ScheduleTabKey.news),
    ]);
  }
}

/// Displays a list of Events, chunked into sections by type.
class EventList extends StatelessWidget {
  final ScheduleTabKey _tabKey;

  EventList(this._tabKey);

  @override
  Widget build(BuildContext context) {
    var displayState = Provider.of<ScheduleDisplayState>(context);

    return ChangeNotifierProvider(
        key: UniqueKey(),
        builder: (context) => ScheduleTabState(displayState.servers, displayState.starters, _tabKey,
            displayState.currentEventDate, displayState.hideClosed),
        child: EventListContents());
  }
}

/// Bar at the bottom of each tab; allows the user to select the current event date.
class DateSelectBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var displayState = Provider.of<ScheduleDisplayState>(context);
    var currentEventDate = displayState.currentEventDate;

    return Container(
      color: Colors.grey[400],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
              child: FlatButton(
                onPressed: () => DatePicker.showDatePicker(
                  context,
                  currentTime: currentEventDate,
                  minTime: DateTime.now().subtract(Duration(days: 1)),
                  maxTime: currentEventDate.add(Duration(days: 30)),
                  onConfirm: (d) => displayState.currentEventDate = d,
                ),
                child: Row(
                  children: [
                    Icon(Icons.event),
                    SizedBox(width: 4),
                    Text(_dateFormatter.format(currentEventDate)),
                  ],
                ),
              ),
            ),
            Spacer(),
//            Disabling schedule view and egg machine view
//            SizedBox(
//              height: 20,
//              child: FlatButton(
//                onPressed: null,
//                child: Icon(MaterialCommunityIcons.getIconData('file-document-box-outline')),
//              ),
//            ),
//            SizedBox(
//              height: 20,
//              child: FlatButton(
//                onPressed: null,
//                child: Icon(MaterialCommunityIcons.getIconData('egg')),
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}
