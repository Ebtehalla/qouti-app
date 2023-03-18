import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:no_name_ecommerce/model/ticket_list_model.dart';
import 'package:no_name_ecommerce/services/common_service.dart';
import 'package:no_name_ecommerce/view/utils/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RefundTicketService with ChangeNotifier {
  var ticketList = [];

  late int totalPages;
  int currentPage = 1;

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  setDefault() {
    currentPage = 1;
    ticketList = [];
    notifyListeners();
  }

  addNewDataToTicketList(id, title, subject, priority, description, status) {
    ticketList.add({
      'id': id,
      'title': title,
      'subject': subject,
      'priority': priority,
      'description': description,
      'status': status
    });
    notifyListeners();
  }

  Future<bool> fetchTicketList(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      ticketList = [];

      notifyListeners();

      setCurrentPage(currentPage);
    } else {}

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var connection = await checkConnection();
    if (!connection) return false;
    //if connection is ok

    var response = await http.get(
        Uri.parse("${ApiUrl.refundTicketListUri}=$currentPage"),
        headers: header);

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['data'].isNotEmpty) {
      var data = TicketListModel.fromJson(jsonDecode(response.body));

      setTotalPage(data.lastPage);

      if (isrefresh) {
        print('refresh true');
        //if refreshed, then remove all service from list and insert new data
        //make the list empty first so that existing data doesn't stay
        setServiceList(data.data, false);
      } else {
        print('add new data');

        //else add new data
        setServiceList(data.data, true);
      }

      currentPage++;
      setCurrentPage(currentPage);
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  setServiceList(dataList, bool addnewData) {
    if (addnewData == false) {
      //make the list empty first so that existing data doesn't stay
      ticketList = [];
      notifyListeners();
    }

    for (int i = 0; i < dataList.length; i++) {
      ticketList.add({
        'id': dataList[i].id,
        'title': dataList[i].title,
        'subject': dataList[i].subject,
        'priority': dataList[i].priority,
        'description': dataList[i].description,
        'status': dataList[i].status
      });
    }
    notifyListeners();
  }

  goToMessagePage(
      BuildContext context, title, id, departmentId, description, priority) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(
    //     builder: (BuildContext context) => TicketChatPage(
    //       title: title,
    //       ticketId: id,
    //       departmentId: departmentId,
    //       description: description,
    //       priority: priority,
    //     ),
    //   ),
    // );

    //fetch message
    // Provider.of<SupportMessagesService>(context, listen: false)
    //     .fetchMessages(id);
  }
}
