import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import '../../../config/contract_linking/doctor_contract_linking.dart';

class DateTimePickerPage extends StatefulWidget {
  final EthereumAddress docAddress;
  const DateTimePickerPage({super.key, required this.docAddress});

  @override
  State<DateTimePickerPage> createState() => _DateTimePickerPageState();
}

class _DateTimePickerPageState extends State<DateTimePickerPage> {
  String dateTime = '';
  getCustomFormattedDateTime(String givenDateTime) {
    final DateTime docDateTime = DateTime.parse(givenDateTime);
    return docDateTime.millisecondsSinceEpoch;
  }

  DoctorContractLinking contractLinking = DoctorContractLinking();
  void setAppointment() {
    int dateTimeInMilliSeconds = 0;
    setState(() {
      dateTimeInMilliSeconds = getCustomFormattedDateTime(dateTime);
    });
    contractLinking.bookAppointmentFunction(
        BigInt.from(dateTimeInMilliSeconds), widget.docAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: Text(
                "schedule a meeting",
                style: TextStyle(
                    height: 1,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 10),
              )),
          const SizedBox(
            height: 20,
          ),
          DateTimePicker(
            type: DateTimePickerType.dateTime,
            initialTime: TimeOfDay.now(),
            dateMask: 'd MMMM, yyyy - hh:mm a',
            initialValue: DateTime.now().toString(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            icon: const Icon(Icons.event),
            dateLabelText: 'Date Time',
            timeLabelText: "Hour",
            selectableDayPredicate: (date) {
              if (date.weekday == 6 || date.weekday == 7) {
                return false;
              }
              return true;
            },
            onChanged: (val) {
              setState(() {
                dateTime = val;
              });
            },
            onSaved: (val) {
              setState(() {
                dateTime = val!;
              });
            },
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 20),
              ),
            ),
          ),
          GestureDetector(
            onTap: setAppointment,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xff1D3092).withOpacity(.49),
                  borderRadius: BorderRadius.circular(30)),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(
                child: Text(
                  "Confirm",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width / 20),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}