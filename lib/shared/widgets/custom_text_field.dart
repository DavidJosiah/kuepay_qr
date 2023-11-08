import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:kuepay_qr/config/config.dart';

import 'widgets.dart';

class CustomTextField extends StatelessWidget {
  const  CustomTextField({
    Key? key,
    this.height,
    this.controller,
    this.decoration,
    this.hintText,
    this.labelText,
    this.errorText,
    this.counterText,
    this.prefix,
    this.suffix,
    this.style,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.obscureText,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.showLabel = true,
    this.showError = true,
    this.onTap,
    this.fillColor,
    TextInputType? keyboardType,
    this.autofillHints = const <String>[],
    this.color,
    this.expands = true,
    this.onObscurityChange,
  })  : keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        assert(keyboardType != TextInputType.visiblePassword || obscureText != null),
        super(key: key);

  /// Specifies the height of the TextField
  final double? height;

  /// Optional text that describes the input field.
  ///
  /// {@macro flutter.material.inputDecoration.label}
  ///
  /// If a more elaborate label is required, consider using [label] instead.
  /// Only one of [label] and [labelText] can be specified.
  final String? labelText;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed on top of the [InputDecorator.child] (i.e., at the same location
  /// on the screen where text may be entered in the [InputDecorator.child])
  /// when the input [isEmpty] and either (a) [labelText] is null or (b) the
  /// input has the focus.
  final String? hintText;

  /// Text that appears below the [InputDecorator.child] and the border.
  ///
  /// If non-null, the border's color animates to red and the [helperText] is
  /// not shown.
  ///
  /// In a [TextFormField], this is overridden by the value returned from
  /// [TextFormField.validator], if that is not null.
  final String? errorText;

  /// Optional text to place below the line as a character count.
  ///
  /// Rendered using [counterStyle]. Uses [helperStyle] if [counterStyle] is
  /// null.
  ///
  /// The semantic label can be replaced by providing a [semanticCounterText].
  ///
  /// If null or an empty string and [counter] isn't specified, then nothing
  /// will appear in the counter's location.
  final String? counterText;

  /// Optional widget to place on the line before the input.
  ///
  /// This can be used, for example, to add some padding to text that would
  /// otherwise be specified using [prefixText], or to add a custom widget in
  /// front of the input. The widget's baseline is lined up with the input
  /// baseline.
  ///
  /// Only one of [prefix] and [prefixText] can be specified.
  ///
  /// The [prefix] appears after the [prefixIcon], if both are specified.
  ///
  /// See also:
  ///
  ///  * [suffix], the equivalent but on the trailing edge.
  final Widget? prefix;

  /// Optional widget to place on the line after the input.
  ///
  /// This can be used, for example, to add some padding to the text that would
  /// otherwise be specified using [suffixText], or to add a custom widget after
  /// the input. The widget's baseline is lined up with the input baseline.
  ///
  /// Only one of [suffix] and [suffixText] can be specified.
  ///
  /// The [suffix] appears before the [suffixIcon], if both are specified.
  ///
  /// See also:
  ///
  ///  * [prefix], the equivalent but on the leading edge.
  final Widget? suffix;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  final InputDecoration? decoration;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType keyboardType;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subtitle1` text style from the current [Theme].
  final TextStyle? style;

  /// {@macro flutter.widgets.editableText.maxLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign textAlign;

  /// {@macro flutter.widgets.editableText.obscureText}
  final bool? obscureText;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// If set, a character counter will be displayed below the
  /// field showing how many characters have been entered. If set to a number
  /// greater than 0, it will also display the maximum number allowed. If set
  /// to [TextField.noMaxLength] then only the current character count is displayed.
  ///
  /// After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforcement] is set to
  /// [MaxLengthEnforcement.none].
  ///
  /// The text field enforces the length with a [LengthLimitingTextInputFormatter],
  /// which is evaluated after the supplied [inputFormatters], if any.
  ///
  /// This value must be either null, [TextField.noMaxLength], or greater than 0.
  /// If null (the default) then there is no limit to the number of characters
  /// that can be entered. If set to [TextField.noMaxLength], then no limit will
  /// be enforced, but the number of characters entered will still be displayed.
  ///
  /// Whitespace characters (e.g. newline, space, tab) are included in the
  /// character count.
  ///
  /// If [maxLengthEnforcement] is [MaxLengthEnforcement.none], then more than
  /// [maxLength] characters may be entered, but the error counter and divider
  /// will switch to the [decoration]'s [InputDecoration.errorStyle] when the
  /// limit is exceeded.
  ///
  /// {@macro flutter.services.lengthLimitingTextInputFormatter.maxLength}
  final int? maxLength;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted]:
  ///    which are more specialized input change notifications.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [TextInputAction.next] and [TextInputAction.previous], which
  ///    automatically shift the focus to the next/previous focusable item when
  ///    the user is done editing.
  final ValueChanged<String>? onSubmitted;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// If false the text field is "disabled": it ignores taps and its
  /// [decoration] is rendered in backgroundColor.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [InputDecoration.enabled] property.
  final bool? enabled;

  /// If false the label is hidden
  final bool showLabel;

  /// If false the errors are hidden
  final bool showError;

  /// {@template flutter.material.textfield.onTap}
  /// Called for each distinct tap except for every second tap of a double tap.
  ///
  /// The text field builds a [GestureDetector] to handle input events like tap,
  /// to trigger focus requests, to move the caret, adjust the selection, etc.
  /// Handling some of those events by wrapping the text field with a competing
  /// GestureDetector is problematic.
  ///
  /// To unconditionally handle taps, without interfering with the text field's
  /// internal gesture detector, provide this callback.
  ///
  /// If the text field is created with [enabled] false, taps will not be
  /// recognized.
  ///
  /// To be notified when the text field gains or loses the focus, provide a
  /// [focusNode] and add a listener to that.
  ///
  /// To listen to arbitrary pointer events without competing with the
  /// text field's internal gesture detector, use a [Listener].
  /// {@endtemplate}
  final GestureTapCallback? onTap;

  /// {@macro flutter.widgets.editableText.autofillHints}
  /// {@macro flutter.services.AutofillConfiguration.autofillHints}
  final Iterable<String>? autofillHints;


  /// The base fill color of the decoration's container color.
  ///
  /// When [InputDecorator.isHovering] is true, the
  /// [hoverColor] is also blended into the final fill color.
  ///
  /// By default the fillColor is based on the current [Theme].
  ///
  /// The decoration's container is the area which is filled if [filled] is true
  /// and bordered per the [border]. It's the area adjacent to [icon] and above
  /// the widgets that contain [helperText], [errorText], and [counterText].
  final Color? fillColor;

  ///This color will be used to replace the primary color if it is set
  final Color? color;

  /// {@macro flutter.widgets.editableText.expands}
  final bool expands;

  ///Is triggered when the obscurity of a password TextField is changed
  final void Function(bool value)? onObscurityChange;

  @override
  Widget build(BuildContext context) {
    double height = this.height ?? 46;
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(showLabel)
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                labelText ?? hintText ?? "No Label",
                style: TextStyles(
                  color: CustomColors.primary,
                  letterSpacing: 0.1,
                ).textBodyExtraLarge
              ),
            ),

          if(showLabel)
            SizedBox(height: height * 0.1),

          SizedBox(
            height: height,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: controller,
                  expands: obscureText == null,
                  decoration: decoration ??
                      InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.dynamicColor(
                            colorScheme: ColorThemeScheme.greyAccentOne,
                          )),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: errorText != null ? CustomColors.error : CustomColors.dynamicColor(
                            colorScheme: ColorThemeScheme.greyAccentTwo,
                          )),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: errorText != null ? CustomColors.error : CustomColors.primary),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.error),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.error),
                        ),
                        isDense: false,
                        isCollapsed: false,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5
                        ),
                        labelText: null,
                        labelStyle: null,
                        hintText: hintText,
                        hintStyle: TextStyles(color: CustomColors.dynamicColor(
                          colorScheme: ColorThemeScheme.greyAccentOne,
                        )).textBodyExtraLarge,
                        errorText: null,
                        errorStyle: null,
                        counterText: '',
                        counterStyle: null,
                        prefix: prefix,
                        suffix: suffix,
                        alignLabelWithHint: true,
                        fillColor: fillColor ?? CustomColors.dynamicColor(
                          colorScheme: ColorThemeScheme.greyAccentThree,
                        ),
                      ),
                  autofillHints: autofillHints,
                  maxLines: obscureText != null ? 1 : null,// maxLines,
                  style: style ?? TextStyles(color: CustomColors.dynamicColor(
                    colorScheme: ColorThemeScheme.accent,
                  )).textBodyExtraLarge,
                  maxLength: maxLength,
                  onChanged: onChanged,
                  enabled: enabled,
                  onTap: onTap,
                  obscureText: obscureText ?? false,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                ),

                if(obscureText != null)
                  Container(
                    height: height - 2,
                    width: height - 2,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle
                    ),
                    margin: const EdgeInsets.all(1),
                    child: Center(
                      child: MaterialButton(
                          height: height - 2,
                          minWidth: height - 2,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          color: Colors.transparent,
                          padding: EdgeInsets.zero,
                          elevation: 0,
                          onPressed: () {
                            if (onObscurityChange != null) {
                              onObscurityChange!(obscureText!);
                            }
                          },
                        child: SvgPicture.asset(
                            obscureText ?? false
                                ? 'assets/icons/show_password.svg'
                                : 'assets/icons/hide_password.svg',
                            height: 20,
                            width: 20,
                            color: CustomColors.dynamicColor(
                              colorScheme: ColorThemeScheme.accent,
                            ),
                            semanticsLabel: "Toggle Pin Visibility"
                        )
                      ),
                    ),
                  )

              ],
            ),
          ),

          if(errorText != null && showError)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimen.width * 0.02,
                vertical: height * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                      errorText ?? "",
                      style: errorText!.length > 56
                          ? TextStyles(
                          color: CustomColors.error
                      ).textBodySmall
                          : TextStyles(
                          color: CustomColors.error
                      ).textBodyMedium
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class CustomFormatter {
  static final validDouble = TextInputFormatter.withFunction(
          (oldValue, newValue) {
        try {
          final text = newValue.text;

          if (text.isNotEmpty && text[0] == "0") {
            return oldValue;
          }

          if (text.isNotEmpty) double.parse(text);

          return newValue;
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
        return oldValue;
      });

  static final validAmount = [
    FilteringTextInputFormatter.allow(RegExp(r"[\d.]")),

    TextInputFormatter.withFunction((oldValue, newValue) {
      try {
        final text = newValue.text;

        if (text.length > 4) {
          final lastDigits =
          text.substring(text.length - 4);
          if (lastDigits.substring(0, 1) == ".") {
            return oldValue;
          }
        }

        if (text.isNotEmpty) double.parse(text);

        return newValue;
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
      return oldValue;
    })
  ];

  static final validDate = [
    FilteringTextInputFormatter.allow(RegExp(r"[\d/]")),

    TextInputFormatter.withFunction((oldValue, newValue) {
      try {
        final text = newValue.text;
        final oldText = oldValue.text;

        List<String> fields = text.split('/');
        if (text.isEmpty) return newValue;

        if (text.length == 2 && text.length < oldText.length &&
            !text.contains('/')) {
          return newValue.copyWith(
            text: text[0],
            selection: TextSelection.fromPosition(
                const TextPosition(offset: 1)),
          );
        }

        if (text.length == 2 && text.length > oldText.length &&
            !text.contains('/')) {
          return newValue.copyWith(
            text: '$text/',
            selection: TextSelection.fromPosition(
                const TextPosition(offset: 3)),
          );
        }

        if (fields.isNotEmpty) {
          if (fields[0].isNotEmpty && fields[0].length > 2) {
            return oldValue;
          }
          if (fields.length == 2) {
            if (fields[1].isNotEmpty && fields[1].length > 2) {
              return oldValue;
            }
          }
        }

        return newValue;
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
      return oldValue;
    })
  ];

  static final validDateWithDay = [
    FilteringTextInputFormatter.allow(RegExp(r"[\d/]")),

    TextInputFormatter.withFunction((oldValue, newValue) {
    try {
      final text = newValue.text;
      final oldText = oldValue.text;

      List<String> fields = text.split('/');
      if(text.isEmpty) return newValue;

      if(text.length == 2 && text.length < oldText.length && !text.contains('/')){
        return newValue.copyWith(
          text: text[0],
          selection: TextSelection.fromPosition(const TextPosition(offset: 1)),
        );
      }

      if(text.length == 5 && text.length < oldText.length && text.split('/').length == 2){
        return newValue.copyWith(
          text: text.substring(0, 4),
          selection: TextSelection.fromPosition(const TextPosition(offset: 4)),
        );
      }

      if(text.length == 2 && text.length > oldText.length && !text.contains('/')){
        return newValue.copyWith(
          text: '$text/',
          selection: TextSelection.fromPosition(const TextPosition(offset: 3)),
        );
      }

      if(text.length == 5 && text.length > oldText.length && text.split('/').length == 2){
        return newValue.copyWith(
          text: '$text/',
          selection: TextSelection.fromPosition(const TextPosition(offset: 6)),
        );
      }

      if(fields.isNotEmpty){
        if(fields[0].isNotEmpty && fields[0].length > 2){
          return oldValue;
        }

        if(fields.length >= 2) {
          if (fields[1].isNotEmpty && fields[1].length > 2) {
            return oldValue;
          }
        }

        if(fields.length == 3) {
          if (fields[2].isNotEmpty && fields[2].length > 2) {
            return oldValue;
          }
        }
      }

      return newValue;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return oldValue;
  })
  ];
}