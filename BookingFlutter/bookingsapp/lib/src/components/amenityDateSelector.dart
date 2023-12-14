import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  final String recurrence;
  final void Function(DateTime) onDateSelected;

  const DateSelector(this.recurrence, this.onDateSelected, {super.key});
  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  String recurrence = '';
  List<DateTime> dates = [];

  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    print(widget.recurrence);

    if (widget.recurrence == "D") {
      setState(() {
        dates = List.generate(30, (index) {
          return DateTime.now().add(Duration(days: index));
        });
      });
    } else if (widget.recurrence == "W") {
      setState(() {
        dates = List.generate(15, (index) {
          return DateTime.now().add(Duration(days: index * 7));
        });
      });
    } else if (widget.recurrence == "M") {
      setState(() {
        dates = List.generate(3, (index) {
          return DateTime.now().add(Duration(days: index * 30));
        });
      });
    } else if (widget.recurrence == "Y") {
      setState(() {
        dates = List.generate(1, (index) {
          return DateTime.now().add(Duration(days: index * 365));
        });
      });
    } else if (widget.recurrence == "O") {
      setState(() {
        dates = List.generate(1, (index) {
          return DateTime.now().add(Duration(days: index));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Date Selector',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white),
          ),
          centerTitle: true,
          // Custom color
        ),
        body: Center(
          child: SizedBox(
            height: 100.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dates.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      widget.onDateSelected(dates[index]);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? Theme.of(context).focusColor // Custom color
                          : Theme.of(context).disabledColor,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${dates[index].day}/${dates[index].month}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
