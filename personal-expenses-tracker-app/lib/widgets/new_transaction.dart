import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';

import 'package:personal_budget/widgets/text.dart';

class NewTransaction extends StatefulWidget {
  final Function addActionHandler;

  NewTransaction(this.addActionHandler);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime _selectedDate;

  List<CameraDescription> cameras; //list out the camera available
  CameraController controller; //controller for camera
  XFile image; //for captured image

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras[0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  void _submitDataNewTransaction() {
    String title = titleController.text;
    double amount = double.parse(amountController.text);
    if (title.isEmpty || amount <= 0) {
      return;
    }

    widget.addActionHandler(title, amount, descriptionController.text,
        _selectedDate != null ? _selectedDate : DateTime.now());
    _dismiss();
  }

  void _presentDatePIcker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      if (selectedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = selectedDate;
      });
    });
  }

  void _dismiss() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        width: constraint.maxWidth,
        height: constraint.maxHeight,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _dismiss,
                    child: IconButton(
                        icon: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 32,
                    )),
                  ),
                  MyText(
                      text: 'Add an expence',
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  TextButton(
                    onPressed: _submitDataNewTransaction,
                    child: MyText(
                        text: 'Save',
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: titleController,
                  onSubmitted: (_) => _submitDataNewTransaction(),
                  decoration: InputDecoration(
                      labelText: 'Title',
                      contentPadding: EdgeInsets.all(8),
                      errorText: titleController.text.isEmpty
                          ? 'Title shouldn\'t be Empty'
                          : null),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                      labelText: 'Amount',
                      contentPadding: EdgeInsets.all(8),
                      errorText: amountController.text.isEmpty
                          ? 'Title shouldn\'t be Empty'
                          : null),
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitDataNewTransaction(),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  minLines: 1,
                  maxLines: 2,
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                ),
              ),
              Container(
                color: Color.fromRGBO(245, 245, 245, 1),
                height: 50,
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      // <-- TextButton
                      onPressed: _presentDatePIcker,
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        size: 24.0,
                      ),
                      label: MyText(
                        text: _selectedDate == null
                            ? DateFormat.yMEd().format(DateTime.now())
                            : DateFormat.yMEd().format(_selectedDate),
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          if (controller != null) {
                            //check if contrller is not null
                            if (controller.value.isInitialized) {
                              //check if controller is initialized
                              image = await controller
                                  .takePicture(); //capture image
                              setState(() {
                                //update UI
                              });
                            }
                          }
                        } catch (e) {
                          print(e); //show error
                        }
                      },
                      child: IconButton(
                          icon: Icon(Icons.add_photo_alternate_outlined,
                              color: Colors.blue)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
