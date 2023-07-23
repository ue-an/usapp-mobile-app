import 'package:usapp_mobile/providers/studnumber_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class StudnumregScreen extends StatefulWidget {
  const StudnumregScreen({Key? key}) : super(key: key);

  @override
  _StudnumregScreenState createState() => _StudnumregScreenState();
}

class _StudnumregScreenState extends State<StudnumregScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool _isObscure = true;
  final TextEditingController _idNumCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController get idNumCtrl => _idNumCtrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue[400],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  // Colors.cyan,
                  Colors.lightBlue[300]!,
                  Colors.blue[200]!,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 3),
                      // color: Colors.white70,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          // Colors.cyan,
                          Colors.white70,
                          Colors.white60,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "STUDENT VALIDATION",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[400]!,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Student number';
                                }
                                return null;
                              },
                              style: const TextStyle(color: Colors.blue),
                              controller: _idNumCtrl,
                              decoration: InputDecoration(
                                labelText: 'Student Number',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Colors.blue,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Colors.red,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Colors.blue,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                ),
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: IconButton(
                                  icon: _isObscure
                                      ? const Icon(
                                          Icons.visibility,
                                          color: Colors.blue,
                                        )
                                      : const Icon(
                                          Icons.visibility_off,
                                          color: Colors.blue,
                                        ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _isObscure,
                              onChanged: (value) => context
                                  .read<StudentnumberProvider>()
                                  .changeStudnum = value,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        GFButton(
                          elevation: 5,
                          color: Colors.white,
                          borderSide: const BorderSide(
                              color: Colors.lightBlue, width: 2),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await context
                                  .read<StudentnumberProvider>()
                                  .validateIdnumber(context, _idNumCtrl.text);
                            }
                          },
                          child: const Text(
                            "Validate",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlue,
                            ),
                          ),
                          shape: GFButtonShape.pills,
                          fullWidthButton: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
