import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/presentation/components/uihelper.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  String selectedCountry = "India";
  final List<String> countries = ["India", "America", "Africa", "Italy", "Germany"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UiHelper.CustomText(
                text: "Enter your phone number",
                height: 20,
                color: Color(0xFF00A884),
                fontweight: FontWeight.bold,
              ),
              const SizedBox(height: 15),
              _buildInfoText(),
              const SizedBox(height: 30),
              _buildCountryDropdown(),
              const SizedBox(height: 20),
              _buildPhoneNumberField(),
            ],
          ),
        ),
      ),
      floatingActionButton: UiHelper.CustomButton(
        callback: () => login(phoneController.text.trim()),
        buttonname: "Next",
        backgroundColor: Color(0xFF00A884),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// Widget to show informational text
  Widget _buildInfoText() {
    return Column(
      children: [
        UiHelper.CustomText(text: "WhatsApp will need to verify your phone", height: 16),
        UiHelper.CustomText(text: "number. Carrier charges may apply.", height: 16),
        UiHelper.CustomText(
          text: "What’s my number?",
          height: 16,
          color: Color(0xFF00A884),
        ),
      ],
    );
  }

  /// Country Dropdown Widget
  Widget _buildCountryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: DropdownButtonFormField(
        value: selectedCountry,
        decoration: _inputDecoration(),
        items: countries.map((String country) {
          return DropdownMenuItem(value: country, child: Text(country));
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedCountry = newValue!;
          });
        },
      ),
    );
  }

  /// Phone Number Input Fields
  Widget _buildPhoneNumberField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSmallTextField(hintText: "+91"), // Country code field
        const SizedBox(width: 10),
        _buildLargeTextField(controller: phoneController), // Phone number input
      ],
    );
  }

  /// Small Text Field (Country Code)
  Widget _buildSmallTextField({required String hintText}) {
    return SizedBox(
      width: 50,
      child: TextField(
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        decoration: _inputDecoration(hintText: hintText),
      ),
    );
  }

  /// Large Text Field (Phone Number)
  Widget _buildLargeTextField({required TextEditingController controller}) {
    return Expanded(
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: controller,
        decoration: _inputDecoration(),
      ),
    );
  }

  /// Common Input Decoration
  InputDecoration _inputDecoration({String hintText = ""}) {
    return InputDecoration(
      hintText: hintText,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF00A884)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF00A884)),
      ),
    );
  }

  /// Login Logic
  void login(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Enter Phone Number"),
          backgroundColor: Color(0xFF00A884),
        ),
      );
    } else {
      // Proceed to OTP screen
      // Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(phonenumber: phoneNumber)));
    }
  }
}
