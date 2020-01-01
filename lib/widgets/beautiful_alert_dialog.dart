import 'package:flutter/material.dart';

class BeautifulAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function positiveCallback;
  final Function negativeCallback;
  final String positiveTitle;
  final String negativeTitle;
  final IconData icon;
  final Color iconColor;

  const BeautifulAlertDialog(
      {Key key,
      this.title,
      this.message,
      this.positiveCallback,
      this.negativeCallback,
      this.positiveTitle,
      this.negativeTitle,
      this.icon,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(right: 16.0),
          height: 150,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(75),
                  bottomLeft: Radius.circular(75),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Row(
            children: <Widget>[
              SizedBox(width: 20.0),
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey.shade200,
                child: Icon(
                  this.icon == null ? Icons.info_outline : this.icon,
                  color: this.iconColor == null ? Colors.blue : this.iconColor,
                  size: 48,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.title.copyWith(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                    ),
                    SizedBox(height: 10.0),
                    Flexible(
                      child: Text(message, style: TextStyle(fontFamily: "Roboto"),),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: this.positiveCallback == null ? 10 : 1,
                          child: Visibility(
                            visible: this.negativeCallback != null,
                            child: RaisedButton(
                              child: Text(this.negativeTitle != null
                                  ? this.negativeTitle
                                  : "Tidak"),
                              color: Colors.red,
                              colorBrightness: Brightness.dark,
                              onPressed: () {
                                Navigator.pop(context);
                                if (negativeCallback != null)
                                  negativeCallback();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          flex: this.negativeCallback == null ? 10 : 1,
                          child: Visibility(
                            visible: this.positiveCallback != null,
                            child: RaisedButton(
                              child: Text(this.positiveTitle != null
                                  ? this.positiveTitle
                                  : "Ya"),
                              color: Colors.green,
                              colorBrightness: Brightness.dark,
                              onPressed: () {
                                Navigator.pop(context);
                                if (positiveCallback != null)
                                  positiveCallback();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
