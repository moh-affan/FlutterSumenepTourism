import 'package:flutter/material.dart';

class BeautifulDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final Function positiveCallback;
  final Function negativeCallback;
  final String positiveTitle;
  final String negativeTitle;

  const BeautifulDialog(
      {Key key,
      @required this.title,
      @required this.child,
      this.positiveCallback,
      this.negativeCallback,
      this.positiveTitle,
      this.negativeTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
            padding: EdgeInsets.all(16.0),
            height: 450,
            // width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Flexible(
                      child: this.child,
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
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
                              if (negativeCallback != null) negativeCallback();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
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
                              if (positiveCallback != null) positiveCallback();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
