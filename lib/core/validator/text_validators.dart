import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TextValidatorI)
class TextValidator implements TextValidatorI {
  @override
  ValidationResult checkEmail(String em) {
    const String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(em)) {
      return const ValidationResult(
          isSuccess: false, message: 'This is not a valid email address.');
    }
    return const ValidationResult(isSuccess: true);
  }

  @override
  ValidationResult checkPassword(String em) {
    if (em.length < 8) {
      return const ValidationResult(
          isSuccess: false, message: 'This is not a valid password.');
    } else {
      return const ValidationResult(isSuccess: true);
    }
  }

  @override
  ValidationResult checkName(String em) {
    if (em.length < 3) {
      return const ValidationResult(
          isSuccess: false, message: 'This is not a valid user name.');
    } else {
      return const ValidationResult(isSuccess: true);
    }
  }
}

abstract class TextValidatorI {
  ValidationResult checkEmail(String em);

  ValidationResult checkPassword(String em);

  ValidationResult checkName(String em);
}

@immutable
class ValidationResult {
  const ValidationResult({
    this.isSuccess,
    this.message = '',
  });

  final bool isSuccess;
  final String message;
}
