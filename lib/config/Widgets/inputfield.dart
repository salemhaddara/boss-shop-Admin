import 'package:bossshopadmin/core/localisation/translation.dart';
import 'package:bossshopadmin/core/theme/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class InputField extends StatefulWidget {
  final bool isPassword;
  final String hint;
  bool initialState = false;
  final String? Function(String?) validator;
  Color? color;
  final Function(String?) onChanged;
  double? height;
  InputField(
      {Key? key,
      required this.isPassword,
      required this.hint,
      required this.initialState,
      required this.validator,
      required this.onChanged,
      this.height,
      this.color})
      : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState(initialState);
}

class _InputFieldState extends State<InputField> {
  bool isVisible = false;
  _InputFieldState(bool istrue) {
    isVisible = istrue;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: widget.height ?? 45,
            decoration: BoxDecoration(
                color: homebackgrey,
                borderRadius: const BorderRadius.all(Radius.circular(13)))),
        Container(
          constraints: const BoxConstraints(minHeight: 54),
          child: TextFormField(
            onChanged: (text) {
              widget.onChanged(text);
            },
            obscureText: isVisible,
            cursorColor: orange,
            maxLines: widget.height != null ? 4 : 1,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.always,
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
            decoration: InputDecoration(
              errorStyle: defaultLang == 'ar'
                  ? GoogleFonts.tajawal(color: Colors.red)
                  : GoogleFonts.nunitoSans(color: Colors.red),
              hintText: widget.hint,
              filled: true,
              fillColor: widget.color ?? homebackgrey,
              errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  borderSide: BorderSide(color: Colors.red)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(13))),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(13))),
              focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  borderSide: BorderSide(color: Colors.red)),
              suffixIcon: widget.isPassword
                  ? Container(
                      height: 44,
                      width: 24,
                      alignment: Alignment.center,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: SvgPicture.asset(
                          isVisible
                              ? 'assets/images/hiddenpass.svg'
                              : 'assets/images/visiblepass.svg',
                        ),
                        onTap: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      ),
                    )
                  : const SizedBox(
                      height: 1,
                      width: 1,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
